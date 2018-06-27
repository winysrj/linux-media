Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:21955 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934377AbeF0R5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 13:57:17 -0400
Date: Wed, 27 Jun 2018 20:57:12 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sean Paul <seanpaul@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Carlos Santa <carlos.santa@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv6 1/3] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
Message-ID: <20180627175712.GH20518@intel.com>
References: <20180612111831.58210-1-hverkuil@xs4all.nl>
 <20180612111831.58210-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180612111831.58210-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 12, 2018 at 01:18:29PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This adds support for the DisplayPort CEC-Tunneling-over-AUX
> feature that is part of the DisplayPort 1.3 standard.
> 
> Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
> chip that has this capability actually hook up the CEC pin, so
> even though a CEC device is created, it may not actually work.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/Kconfig         |  10 +
>  drivers/gpu/drm/Makefile        |   1 +
>  drivers/gpu/drm/drm_dp_cec.c    | 423 ++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/drm_dp_helper.c |   1 +
>  include/drm/drm_dp_helper.h     |  56 +++++
>  5 files changed, 491 insertions(+)
>  create mode 100644 drivers/gpu/drm/drm_dp_cec.c
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index deeefa7a1773..d63876425cdc 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -121,6 +121,16 @@ config DRM_LOAD_EDID_FIRMWARE
>  	  default case is N. Details and instructions how to build your own
>  	  EDID data are given in Documentation/EDID/HOWTO.txt.
>  
> +config DRM_DP_CEC
> +	bool "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
> +	select CEC_CORE
> +	help
> +	  Choose this option if you want to enable HDMI CEC support for
> +	  DisplayPort/USB-C to HDMI adapters.
> +
> +	  Note: not all adapters support this feature, and even for those
> +	  that do support this they often do not hook up the CEC pin.
> +
>  config DRM_TTM
>  	tristate
>  	depends on DRM && MMU
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 50093ff4479b..c787481c2502 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -41,6 +41,7 @@ drm_kms_helper-$(CONFIG_DRM_PANEL_BRIDGE) += bridge/panel.o
>  drm_kms_helper-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fb_helper.o
>  drm_kms_helper-$(CONFIG_DRM_KMS_CMA_HELPER) += drm_fb_cma_helper.o
>  drm_kms_helper-$(CONFIG_DRM_DP_AUX_CHARDEV) += drm_dp_aux_dev.o
> +drm_kms_helper-$(CONFIG_DRM_DP_CEC) += drm_dp_cec.o
>  
>  obj-$(CONFIG_DRM_KMS_HELPER) += drm_kms_helper.o
>  obj-$(CONFIG_DRM_DEBUG_MM_SELFTEST) += selftests/
> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> new file mode 100644
> index 000000000000..555a9fca3fef
> --- /dev/null
> +++ b/drivers/gpu/drm/drm_dp_cec.c
> @@ -0,0 +1,423 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * DisplayPort CEC-Tunneling-over-AUX support
> + *
> + * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <drm/drm_dp_helper.h>
> +#include <media/cec.h>
> +
> +/*
> + * Unfortunately it turns out that we have a chicken-and-egg situation
> + * here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> + * have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> + * Parade PS176), but they do not wire up the CEC pin, thus making CEC
> + * useless.
> + *
> + * Sadly there is no way for this driver to know this. What happens is
> + * that a /dev/cecX device is created that is isolated and unable to see
> + * any of the other CEC devices. Quite literally the CEC wire is cut
> + * (or in this case, never connected in the first place).
> + *
> + * The reason so few adapters support this is that this tunneling protocol
> + * was never supported by any OS. So there was no easy way of testing it,
> + * and no incentive to correctly wire up the CEC pin.
> + *
> + * Hopefully by creating this driver it will be easier for vendors to
> + * finally fix their adapters and test the CEC functionality.
> + *
> + * I keep a list of known working adapters here:
> + *
> + * https://hverkuil.home.xs4all.nl/cec-status.txt
> + *
> + * Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> + * and is not yet listed there.
> + *
> + * Note that the current implementation does not support CEC over an MST hub.
> + * As far as I can see there is no mechanism defined in the DisplayPort
> + * standard to transport CEC interrupts over an MST device. It might be
> + * possible to do this through polling, but I have not been able to get that
> + * to work.
> + */
> +
> +/**
> + * DOC: dp cec helpers
> + *
> + * These functions take care of supporting the CEC-Tunneling-over-AUX
> + * feature of DisplayPort-to-HDMI adapters.
> + */
> +
> +/*
> + * When the EDID is unset because the HPD went low, then the CEC DPCD registers
> + * typically can no longer be read (true for a DP-to-HDMI adapter since it is
> + * powered by the HPD). However, some displays toggle the HPD off and on for a
> + * short period for one reason or another, and that would cause the CEC adapter
> + * to be removed and added again, even though nothing else changed.
> + *
> + * This module parameter sets a delay in seconds before the CEC adapter is
> + * actually unregistered. Only if the HPD does not return within that time will
> + * the CEC adapter be unregistered.

And whatever is trying to do cec is happy with the dpcd accesses
failing during that time?

> + *
> + * If it is set to 0, then the CEC adapter will never be unregistered for as
> + * long as the connector remains registered.
> + *
> + * Note that for integrated HDMI branch devices that support CEC the DPCD
> + * registers remain available even if the HPD goes low since it is not powered
> + * by the HPD. In that case the CEC adapter will never be unregistered during
> + * the life time of the connector. At least, this is the theory since I do not
> + * have hardware with an integrated HDMI branch device that supports CEC.
> + */
> +static unsigned int drm_dp_cec_unregister_delay = 1;
> +module_param(drm_dp_cec_unregister_delay, uint, 0600);
> +MODULE_PARM_DESC(drm_dp_cec_unregister_delay, "CEC unregister delay in seconds, 0 == never unregister");
> +
> +static int drm_dp_cec_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	u32 val = enable ? DP_CEC_TUNNELING_ENABLE : 0;
> +	ssize_t err = 0;
> +
> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
> +	return (enable && err < 0) ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
> +I think I looked at the dpcd detais last time around. {
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	/* Bit 15 (logical address 15) should always be set */
> +	u16 la_mask = 1 << CEC_LOG_ADDR_BROADCAST;
> +	u8 mask[2];
> +	ssize_t err;
> +
> +	if (addr != CEC_LOG_ADDR_INVALID)
> +		la_mask |= adap->log_addrs.log_addr_mask | (1 << addr);
> +	mask[0] = la_mask & 0xff;
> +	mask[1] = la_mask >> 8;
> +	err = drm_dp_dpcd_write(aux, DP_CEC_LOGICAL_ADDRESS_MASK, mask, 2);
> +	return (addr != CEC_LOG_ADDR_INVALID && err < 0) ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> +				    u32 signal_free_time, struct cec_msg *msg)

'msg' could be const perhaps?

> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	unsigned int retries = min(5, attempts - 1);
> +	ssize_t err;
> +
> +	err = drm_dp_dpcd_write(aux, DP_CEC_TX_MESSAGE_BUFFER,
> +				msg->msg, msg->len);
> +	if (err < 0)
> +		return err;
> +
> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TX_MESSAGE_INFO,
> +				 (msg->len - 1) | (retries << 4) |
> +				 DP_CEC_TX_MESSAGE_SEND);
> +	return err < 0 ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_monitor_all_enable(struct cec_adapter *adap,
> +					      bool enable)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	ssize_t err;
> +	u8 val;
> +
> +	if (!(adap->capabilities & CEC_CAP_MONITOR_ALL))
> +		return 0;
> +
> +	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CONTROL, &val);
> +	if (err >= 0) {
> +		if (enable)
> +			val |= DP_CEC_SNOOPING_ENABLE;
> +		else
> +			val &= ~DP_CEC_SNOOPING_ENABLE;
> +		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
> +	}
> +	return (enable && err < 0) ? err : 0;
> +}
> +
> +static void drm_dp_cec_adap_status(struct cec_adapter *adap,
> +				   struct seq_file *file)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	struct drm_dp_desc desc;
> +	struct drm_dp_dpcd_ident *id = &desc.ident;
> +
> +	if (drm_dp_read_desc(aux, &desc, true))
> +		return;
> +	seq_printf(file, "OUI: %*pdH\n",
> +		   (int)sizeof(id->oui), id->oui);
> +	seq_printf(file, "ID: %*pE\n",
> +		   (int)strnlen(id->device_id, sizeof(id->device_id)),
> +		   id->device_id);
> +	seq_printf(file, "HW Rev: %d.%d\n", id->hw_rev >> 4, id->hw_rev & 0xf);
> +	/*
> +	 * Show this both in decimal and hex: at least one vendor
> +	 * always reports this in hex.
> +	 */
> +	seq_printf(file, "FW/SW Rev: %d.%d (0x%02x.0x%02x)\n",
> +		   id->sw_major_rev, id->sw_minor_rev,
> +		   id->sw_major_rev, id->sw_minor_rev);
> +}
> +
> +static const struct cec_adap_ops drm_dp_cec_adap_ops = {
> +	.adap_enable = drm_dp_cec_adap_enable,
> +	.adap_log_addr = drm_dp_cec_adap_log_addr,
> +	.adap_transmit = drm_dp_cec_adap_transmit,
> +	.adap_monitor_all_enable = drm_dp_cec_adap_monitor_all_enable,
> +	.adap_status = drm_dp_cec_adap_status,
> +};
> +
> +static int drm_dp_cec_received(struct drm_dp_aux *aux)
> +{
> +	struct cec_adapter *adap = aux->cec_adap;
> +	struct cec_msg msg;
> +	u8 rx_msg_info;
> +	ssize_t err;
> +
> +	err = drm_dp_dpcd_readb(aux, DP_CEC_RX_MESSAGE_INFO, &rx_msg_info);
> +	if (err < 0)
> +		return err;
> +
> +	if (!(rx_msg_info & DP_CEC_RX_MESSAGE_ENDED))
> +		return 0;
> +
> +	msg.len = (rx_msg_info & DP_CEC_RX_MESSAGE_LEN_MASK) + 1;
> +	err = drm_dp_dpcd_read(aux, DP_CEC_RX_MESSAGE_BUFFER, msg.msg, msg.len);
> +	if (err < 0)
> +		return err;
> +
> +	cec_received_msg(adap, &msg);
> +	return 0;
> +}
> +
> +static void drm_dp_cec_handle_irq(struct drm_dp_aux *aux)
> +{
> +	struct cec_adapter *adap = aux->cec_adap;
> +	u8 flags;
> +
> +	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, &flags) < 0)
> +		return;
> +
> +	if (flags & DP_CEC_RX_MESSAGE_INFO_VALID)
> +		drm_dp_cec_received(aux);
> +
> +	if (flags & DP_CEC_TX_MESSAGE_SENT)
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_OK);
> +	else if (flags & DP_CEC_TX_LINE_ERROR)
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_ERROR |
> +						CEC_TX_STATUS_MAX_RETRIES);
> +	else if (flags &
> +		 (DP_CEC_TX_ADDRESS_NACK_ERROR | DP_CEC_TX_DATA_NACK_ERROR))
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK |
> +						CEC_TX_STATUS_MAX_RETRIES);
> +	drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, flags);
> +}
> +
> +/**
> + * drm_dp_cec_irq() - handle CEC interrupt, if any
> + * @aux: DisplayPort AUX channel
> + *
> + * Should be called when handling an IRQ_HPD request. If CEC-tunneling-over-AUX
> + * is present, then it will check for a CEC_IRQ and handle it accordingly.
> + */
> +void drm_dp_cec_irq(struct drm_dp_aux *aux)
> +{
> +	u8 cec_irq;
> +	int ret;
> +
> +	mutex_lock(&aux->cec_mutex);
> +	if (!aux->cec_adap)
> +		goto unlock;
> +
> +	ret = drm_dp_dpcd_readb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
> +				&cec_irq);
> +	if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
> +		goto unlock;
> +
> +	drm_dp_cec_handle_irq(aux);
> +	drm_dp_dpcd_writeb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1, DP_CEC_IRQ);
> +unlock:
> +	mutex_unlock(&aux->cec_mutex);
> +}
> +EXPORT_SYMBOL(drm_dp_cec_irq);
> +
> +static bool drm_dp_cec_cap(struct drm_dp_aux *aux, u8 *cec_cap)
> +{
> +	u8 cap = 0;
> +
> +	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CAPABILITY, &cap) != 1 ||
> +	    !(cap & DP_CEC_TUNNELING_CAPABLE))
> +		return false;
> +	if (cec_cap)
> +		*cec_cap = cap;
> +	return true;
> +}
> +
> +/*
> + * Called if the HPD was low for more than drm_dp_cec_unregister_delay
> + * seconds. This unregisters the CEC adapter.
> + */
> +static void drm_dp_cec_unregister_work(struct work_struct *work)
> +{
> +	struct drm_dp_aux *aux = container_of(work, struct drm_dp_aux,
> +					      cec_unregister_work.work);
> +
> +	if (!aux->cec_adap)
> +		return;
> +	mutex_lock(&aux->cec_mutex);
> +	cec_unregister_adapter(aux->cec_adap);
> +	aux->cec_adap = NULL;
> +	mutex_unlock(&aux->cec_mutex);
> +}
> +
> +/*
> + * A new EDID is set. If there is no CEC adapter, then create one. If
> + * there was a CEC adapter, then check if the CEC adapter properties
> + * were unchanged and just update the CEC physical address. Otherwise
> + * unregister the old CEC adapter and create a new one.
> + */
> +void drm_dp_cec_set_edid(struct drm_dp_aux *aux, struct edid *edid)

'edid' can be const.

> +{
> +	u32 cec_caps = CEC_CAP_DEFAULTS | CEC_CAP_NEEDS_HPD;
> +	unsigned int num_las = 1;
> +	u8 cap;
> +
> +#ifndef CONFIG_MEDIA_CEC_RC
> +	/*
> +	 * CEC_CAP_RC is part of CEC_CAP_DEFAULTS, but it is stripped by
> +	 * cec_allocate_adapter() if CONFIG_MEDIA_CEC_RC is undefined.
> +	 *
> +	 * Do this here as well to ensure the tests against cec_caps are
> +	 * correct.
> +	 */
> +	cec_caps &= ~CEC_CAP_RC;
> +#endif
> +	cancel_delayed_work_sync(&aux->cec_unregister_work);
> +
> +	mutex_lock(&aux->cec_mutex);
> +	if (!drm_dp_cec_cap(aux, &cap)) {
> +		/* CEC is not supported, unregister any existing adapter */
> +		cec_unregister_adapter(aux->cec_adap);
> +		aux->cec_adap = NULL;
> +		goto unlock;
> +	}
> +
> +	if (cap & DP_CEC_SNOOPING_CAPABLE)
> +		cec_caps |= CEC_CAP_MONITOR_ALL;
> +	if (cap & DP_CEC_MULTIPLE_LA_CAPABLE)
> +		num_las = CEC_MAX_LOG_ADDRS;
> +
> +	if (aux->cec_adap) {
> +		if (aux->cec_adap->capabilities == cec_caps &&
> +		    aux->cec_adap->available_log_addrs == num_las) {
> +			/* Unchanged, so just set the phys addr */
> +			cec_s_phys_addr_from_edid(aux->cec_adap, edid);
> +			goto unlock;
> +		}
> +		/*
> +		 * The capabilities changed, so unregister the old
> +		 * adapter first.
> +		 */
> +		cec_unregister_adapter(aux->cec_adap);
> +	}
> +
> +	/* Create a new adapter */
> +	aux->cec_adap = cec_allocate_adapter(&drm_dp_cec_adap_ops,
> +					     aux, aux->cec_name, cec_caps,
> +					     num_las);
> +	if (IS_ERR(aux->cec_adap)) {
> +		aux->cec_adap = NULL;
> +		goto unlock;
> +	}
> +	if (cec_register_adapter(aux->cec_adap, aux->cec_parent)) {
> +		cec_delete_adapter(aux->cec_adap);
> +		aux->cec_adap = NULL;
> +	} else {
> +		/*
> +		 * Update the phys addr for the new CEC adapter. When called
> +		 * from drm_dp_cec_register_connector() edid == NULL, so in
> +		 * that case the phys addr is just invalidated.
> +		 */
> +		cec_s_phys_addr_from_edid(aux->cec_adap, edid);
> +	}
> +unlock:
> +	mutex_unlock(&aux->cec_mutex);
> +}
> +EXPORT_SYMBOL(drm_dp_cec_set_edid);
> +
> +/*
> + * The EDID disappeared (likely because of the HPD going down).
> + */
> +void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
> +{
> +	mutex_lock(&aux->cec_mutex);
> +	if (!aux->cec_adap)
> +		goto unlock;
> +	cec_phys_addr_invalidate(aux->cec_adap);
> +	/*
> +	 * We're done if we want to keep the CEC device
> +	 * (drm_dp_cec_unregister_delay is 0) or if the DPCD still indicates
> +	 * the CEC capability (expected for an integrated HDMI branch device).
> +	 */
> +	if (!drm_dp_cec_unregister_delay || drm_dp_cec_cap(aux, NULL))
> +		goto unlock;

The drm_dp_cec_unregister_delay semantics seem a bit unnatural to me.
I think ==0 -> no delay, <0 -> infinite delay would make more sense.
Although we already have the exact opposite with the vblank_offdelay for
some historical reason :(

> +
> +	cancel_delayed_work_sync(&aux->cec_unregister_work);

This looks like a potential deadlock to me.

> +	if (aux->cec_adap) {
> +		/* sanity check */
> +		if (drm_dp_cec_unregister_delay > 600)
> +			drm_dp_cec_unregister_delay = 600;
> +		/*
> +		 * Unregister the CEC adapter after drm_dp_cec_unregister_delay
> +		 * seconds. This to debounce short HPD off-and-on cycles from
> +		 * displays.
> +		 */
> +		schedule_delayed_work(&aux->cec_unregister_work,
> +				      drm_dp_cec_unregister_delay * HZ);
> +	}
> +unlock:
> +	mutex_unlock(&aux->cec_mutex);
> +}
> +EXPORT_SYMBOL(drm_dp_cec_unset_edid);
> +
> +/**
> + * drm_dp_cec_register_connector() - register a new connector
> + * @aux: DisplayPort AUX channel
> + * @name: name of the CEC device
> + * @parent: parent device
> + *
> + * A new connector was registered with associated CEC adapter name and
> + * CEC adapter parent device. After registering the name and parent
> + * drm_dp_cec_set_edid() is called to check if the connector supports
> + * CEC and to register a CEC adapter if that is the case.
> + */
> +void drm_dp_cec_register_connector(struct drm_dp_aux *aux, const char *name,
> +				struct device *parent)
> +{
> +	WARN_ON(aux->cec_adap);
> +	aux->cec_name = name;
> +	aux->cec_parent = parent;
> +	INIT_DELAYED_WORK(&aux->cec_unregister_work, drm_dp_cec_unregister_work);
> +
> +	drm_dp_cec_set_edid(aux, NULL);
> +}
> +EXPORT_SYMBOL(drm_dp_cec_register_connector);
> +
> +/**
> + * drm_dp_cec_unregister_connector() - unregister the CEC adapter, if any
> + * @aux: DisplayPort AUX channel
> + */
> +void drm_dp_cec_unregister_connector(struct drm_dp_aux *aux)
> +{
> +	if (!aux->cec_adap)
> +		return;
> +	cancel_delayed_work_sync(&aux->cec_unregister_work);
> +	cec_unregister_adapter(aux->cec_adap);
> +	aux->cec_adap = NULL;
> +}
> +EXPORT_SYMBOL(drm_dp_cec_unregister_connector);
> diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
> index ffe14ec3e7f2..e6b0e08ee0aa 100644
> --- a/drivers/gpu/drm/drm_dp_helper.c
> +++ b/drivers/gpu/drm/drm_dp_helper.c
> @@ -1073,6 +1073,7 @@ static void drm_dp_aux_crc_work(struct work_struct *work)
>  void drm_dp_aux_init(struct drm_dp_aux *aux)
>  {
>  	mutex_init(&aux->hw_mutex);
> +	mutex_init(&aux->cec_mutex);
>  	INIT_WORK(&aux->crc_work, drm_dp_aux_crc_work);
>  
>  	aux->ddc.algo = &drm_dp_i2c_algo;
> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
> index 62903bae0221..415ac52e8599 100644
> --- a/include/drm/drm_dp_helper.h
> +++ b/include/drm/drm_dp_helper.h
> @@ -1062,6 +1062,9 @@ struct drm_dp_aux_msg {
>  	size_t size;
>  };
>  
> +struct cec_adapter;
> +struct edid;
> +
>  /**
>   * struct drm_dp_aux - DisplayPort AUX channel
>   * @name: user-visible name of this AUX channel and the I2C-over-AUX adapter
> @@ -1120,6 +1123,26 @@ struct drm_dp_aux {
>  	 * @i2c_defer_count: Counts I2C DEFERs, used for DP validation.
>  	 */
>  	unsigned i2c_defer_count;
> +	/**
> +	 * @cec_mutex: mutex protecting the cec_ fields
> +	 */
> +	struct mutex cec_mutex;
> +	/**
> +	 * @cec_adap: the CEC adapter for CEC-Tunneling-over-AUX support.
> +	 */
> +	struct cec_adapter *cec_adap;
> +	/**
> +	 * @cec_name: name of the CEC adapter
> +	 */
> +	const char *cec_name;
> +	/**
> +	 * @cec_parent: parent device of the CEC adapter
> +	 */
> +	struct device *cec_parent;
> +	/**
> +	 * @cec_unregister_work: unregister the CEC adapter
> +	 */
> +	struct delayed_work cec_unregister_work;

'struct { ... } cec;' could be a decent idea here.

I think I looked at the dpcd detais last time around so I'll not bother
this time around with that. Apart from the possible deadlock I think
this is looking pretty good.

>  };
>  
>  ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
> @@ -1242,4 +1265,37 @@ drm_dp_has_quirk(const struct drm_dp_desc *desc, enum drm_dp_quirk quirk)
>  	return desc->quirks & BIT(quirk);
>  }
>  
> +#ifdef CONFIG_DRM_DP_CEC
> +void drm_dp_cec_irq(struct drm_dp_aux *aux);
> +void drm_dp_cec_register_connector(struct drm_dp_aux *aux, const char *name,
> +				 struct device *parent);
> +void drm_dp_cec_unregister_connector(struct drm_dp_aux *aux);
> +void drm_dp_cec_set_edid(struct drm_dp_aux *aux, struct edid *edid);
> +void drm_dp_cec_unset_edid(struct drm_dp_aux *aux);
> +#else
> +static inline void drm_dp_cec_irq(struct drm_dp_aux *aux)
> +{
> +}
> +
> +static inline void drm_dp_cec_register_connector(struct drm_dp_aux *aux,
> +					      const char *name,
> +					      struct device *parent)
> +{
> +}
> +
> +static inline void drm_dp_cec_unregister_connector(struct drm_dp_aux *aux)
> +{
> +}
> +
> +static inline void drm_dp_cec_set_edid(struct drm_dp_aux *aux,
> +				       struct edid *edid)
> +{
> +}
> +
> +static inline void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
> +{
> +}
> +
> +#endif
> +
>  #endif /* _DRM_DP_HELPER_H_ */
> -- 
> 2.17.0

-- 
Ville Syrjälä
Intel
