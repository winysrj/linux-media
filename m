Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:5436 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdE3X7K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 19:59:10 -0400
Subject: Re: [RFC PATCH 6/7] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
To: Daniel Vetter <daniel@ffwll.ch>, Hans Verkuil <hverkuil@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-7-hverkuil@xs4all.nl>
 <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Clint Taylor <clinton.a.taylor@intel.com>
Message-ID: <439ee1fd-8c2b-01ab-7b70-93d827ab30e7@intel.com>
Date: Tue, 30 May 2017 16:57:01 -0700
MIME-Version: 1.0
In-Reply-To: <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/26/2017 12:18 AM, Daniel Vetter wrote:
> On Thu, May 25, 2017 at 05:06:25PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This adds support for the DisplayPort CEC-Tunneling-over-AUX
>> feature that is part of the DisplayPort 1.3 standard.
>>
>> Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
>> chip that has this capability actually hook up the CEC pin, so
>> even though a CEC device is created, it may not actually work.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/gpu/drm/Kconfig      |   3 +
>>   drivers/gpu/drm/Makefile     |   1 +
>>   drivers/gpu/drm/drm_dp_cec.c | 196 +++++++++++++++++++++++++++++++++++++++++++
>>   include/drm/drm_dp_helper.h  |  24 ++++++
>>   4 files changed, 224 insertions(+)
>>   create mode 100644 drivers/gpu/drm/drm_dp_cec.c
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index 78d7fc0ebb57..dd771ce8a3d0 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -120,6 +120,9 @@ config DRM_LOAD_EDID_FIRMWARE
>>   	  default case is N. Details and instructions how to build your own
>>   	  EDID data are given in Documentation/EDID/HOWTO.txt.
>>   
>> +config DRM_DP_CEC
>> +	bool
> We generally don't bother with a Kconfig for every little bit in drm, not
> worth the trouble (yes I know there's some exceptions, but somehow they're
> all from soc people). Just smash this into the KMS_HELPER one and live is
> much easier for drivers. Also allows you to drop the dummy inline
> functions.
All of the functions like cec_register_adapter() require 
CONFIG_MEDIA_CEC_SUPPORT.
This will add a new dependency to the DRM drivers. All instances of 
CONFIG_DRM_DP_CEC should be changed to CONFIG_MEDIA_CEC_SUPPORT so drm 
can still be used without the media CEC drivers.

-Clint


> The other nitpick: Pls kernel-doc the functions exported to drivers, and
> then pull them into Documentation/gpu/drm-kms-helpers.rst, next to the
> existing DP helper section.
>
> Thanks, Daniel
>
>> +
>>   config DRM_TTM
>>   	tristate
>>   	depends on DRM && MMU
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 59f0f9b696eb..22f1a17dfc8a 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -34,6 +34,7 @@ drm_kms_helper-y := drm_crtc_helper.o drm_dp_helper.o drm_probe_helper.o \
>>   		drm_simple_kms_helper.o drm_modeset_helper.o \
>>   		drm_scdc_helper.o
>>   
>> +drm_kms_helper-$(CONFIG_DRM_DP_CEC) += drm_dp_cec.o
>>   drm_kms_helper-$(CONFIG_DRM_LOAD_EDID_FIRMWARE) += drm_edid_load.o
>>   drm_kms_helper-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fb_helper.o
>>   drm_kms_helper-$(CONFIG_DRM_KMS_CMA_HELPER) += drm_fb_cma_helper.o
>> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
>> new file mode 100644
>> index 000000000000..44c544ba53cb
>> --- /dev/null
>> +++ b/drivers/gpu/drm/drm_dp_cec.c
>> @@ -0,0 +1,196 @@
>> +/*
>> + * DisplayPort CEC-Tunneling-over-AUX support
>> + *
>> + * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <drm/drm_dp_helper.h>
>> +#include <media/cec.h>
>> +
>> +static int drm_dp_cec_adap_enable(struct cec_adapter *adap, bool enable)
>> +{
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	ssize_t err = 0;
>> +
>> +	if (enable)
>> +		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL,
>> +					 DP_CEC_TUNNELING_ENABLE);
>> +	else
>> +		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, 0);
>> +	return (enable && err < 0) ? err : 0;
>> +}
>> +
>> +static int drm_dp_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
>> +{
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	u8 mask[2] = { 0x00, 0x80 };
>> +	ssize_t err;
>> +
>> +	if (addr != CEC_LOG_ADDR_INVALID) {
>> +		u16 la_mask = adap->log_addrs.log_addr_mask;
>> +
>> +		la_mask |= 0x8000 | (1 << addr);
>> +		mask[0] = la_mask & 0xff;
>> +		mask[1] = la_mask >> 8;
>> +	}
>> +	err = drm_dp_dpcd_write(aux, DP_CEC_LOGICAL_ADDRESS_MASK, mask, 2);
>> +	return (addr != CEC_LOG_ADDR_INVALID && err < 0) ? err : 0;
>> +}
>> +
>> +static int drm_dp_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>> +				    u32 signal_free_time, struct cec_msg *msg)
>> +{
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	unsigned int retries = attempts - 1;
>> +	ssize_t err;
>> +
>> +	err = drm_dp_dpcd_write(aux, DP_CEC_TX_MESSAGE_BUFFER,
>> +				msg->msg, msg->len);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	if (retries > 5)
>> +		retries = 5;
>> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TX_MESSAGE_INFO,
>> +				 (msg->len - 1) | (retries << 4) |
>> +				 DP_CEC_TX_MESSAGE_SEND);
>> +	return err < 0 ? err : 0;
>> +}
>> +
>> +static int drm_dp_cec_adap_monitor_all_enable(struct cec_adapter *adap,
>> +					      bool enable)
>> +{
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	ssize_t err;
>> +	u8 val;
>> +
>> +	if (!(adap->capabilities & CEC_CAP_MONITOR_ALL))
>> +		return 0;
>> +
>> +	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CONTROL, &val);
>> +	if (err >= 0) {
>> +		if (enable)
>> +			val |= DP_CEC_SNOOPING_ENABLE;
>> +		else
>> +			val &= ~DP_CEC_SNOOPING_ENABLE;
>> +		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
>> +	}
>> +	return (enable && err < 0) ? err : 0;
>> +}
>> +
>> +static const struct cec_adap_ops drm_dp_cec_adap_ops = {
>> +	.adap_enable = drm_dp_cec_adap_enable,
>> +	.adap_log_addr = drm_dp_cec_adap_log_addr,
>> +	.adap_transmit = drm_dp_cec_adap_transmit,
>> +	.adap_monitor_all_enable = drm_dp_cec_adap_monitor_all_enable,
>> +};
>> +
>> +static int drm_dp_cec_received(struct drm_dp_aux *aux)
>> +{
>> +	struct cec_adapter *adap = aux->cec_adap;
>> +	struct cec_msg msg;
>> +	u8 rx_msg_info;
>> +	ssize_t err;
>> +
>> +	err = drm_dp_dpcd_readb(aux, DP_CEC_RX_MESSAGE_INFO, &rx_msg_info);
>> +	if (err < 0)
>> +		return err;
>> +	if (!(rx_msg_info & DP_CEC_RX_MESSAGE_ENDED))
>> +		return 0;
>> +	msg.len = (rx_msg_info & DP_CEC_RX_MESSAGE_LEN_MASK) + 1;
>> +	err = drm_dp_dpcd_read(aux, DP_CEC_RX_MESSAGE_BUFFER, msg.msg, msg.len);
>> +	if (err < 0)
>> +		return err;
>> +	cec_received_msg(adap, &msg);
>> +	return 0;
>> +}
>> +
>> +int drm_dp_cec_irq(struct drm_dp_aux *aux)
>> +{
>> +	struct cec_adapter *adap = aux->cec_adap;
>> +	u8 flags;
>> +	ssize_t err;
>> +
>> +	if (!aux->cec_adap)
>> +		return 0;
>> +
>> +	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, &flags);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	if (flags & DP_CEC_RX_MESSAGE_INFO_VALID)
>> +		drm_dp_cec_received(aux);
>> +
>> +	if (flags & DP_CEC_TX_MESSAGE_SENT)
>> +		cec_transmit_done(adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
>> +	else if (flags & DP_CEC_TX_LINE_ERROR)
>> +		cec_transmit_done(adap, CEC_TX_STATUS_ERROR |
>> +				  CEC_TX_STATUS_MAX_RETRIES, 0, 0, 0, 1);
>> +	else if (flags &
>> +		 (DP_CEC_TX_ADDRESS_NACK_ERROR | DP_CEC_TX_DATA_NACK_ERROR))
>> +		cec_transmit_done(adap, CEC_TX_STATUS_NACK |
>> +				  CEC_TX_STATUS_MAX_RETRIES, 0, 1, 0, 0);
>> +	drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, flags);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(drm_dp_cec_irq);
>> +
>> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
>> +				 struct device *parent)
>> +{
>> +	u32 cec_caps = CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
>> +		       CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_NEEDS_HPD;
>> +	unsigned int num_las = 1;
>> +	int err;
>> +	u8 cap;
>> +
>> +	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CAPABILITY, &cap) != 1 ||
>> +	    !(cap & DP_CEC_TUNNELING_CAPABLE)) {
>> +		cec_unregister_adapter(aux->cec_adap);
>> +		aux->cec_adap = NULL;
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (cap & DP_CEC_SNOOPING_CAPABLE)
>> +		cec_caps |= CEC_CAP_MONITOR_ALL;
>> +	if (cap & DP_CEC_MULTIPLE_LA_CAPABLE)
>> +		num_las = CEC_MAX_LOG_ADDRS;
>> +
>> +	if (!IS_ERR_OR_NULL(aux->cec_adap)) {
>> +		if (aux->cec_adap->capabilities == cec_caps &&
>> +		    aux->cec_adap->available_log_addrs == num_las)
>> +			return 0;
>> +		cec_unregister_adapter(aux->cec_adap);
>> +	}
>> +
>> +	aux->cec_adap = cec_allocate_adapter(&drm_dp_cec_adap_ops,
>> +			 aux, name, cec_caps, num_las);
>> +	if (IS_ERR(aux->cec_adap)) {
>> +		err = PTR_ERR(aux->cec_adap);
>> +		aux->cec_adap = NULL;
>> +		return err;
>> +	}
>> +	err = cec_register_adapter(aux->cec_adap, parent);
>> +	if (err) {
>> +		cec_delete_adapter(aux->cec_adap);
>> +		aux->cec_adap = NULL;
>> +	}
>> +	return err;
>> +}
>> +EXPORT_SYMBOL(drm_dp_cec_configure_adapter);
>> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
>> index 3f4ad709534e..1e373df48108 100644
>> --- a/include/drm/drm_dp_helper.h
>> +++ b/include/drm/drm_dp_helper.h
>> @@ -843,6 +843,8 @@ struct drm_dp_aux_msg {
>>   	size_t size;
>>   };
>>   
>> +struct cec_adapter;
>> +
>>   /**
>>    * struct drm_dp_aux - DisplayPort AUX channel
>>    * @name: user-visible name of this AUX channel and the I2C-over-AUX adapter
>> @@ -901,6 +903,10 @@ struct drm_dp_aux {
>>   	 * @i2c_defer_count: Counts I2C DEFERs, used for DP validation.
>>   	 */
>>   	unsigned i2c_defer_count;
>> +	/**
>> +	 * @cec_adap: the CEC adapter for CEC-Tunneling-over-AUX support.
>> +	 */
>> +	struct cec_adapter *cec_adap;
>>   };
>>   
>>   ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
>> @@ -972,4 +978,22 @@ void drm_dp_aux_unregister(struct drm_dp_aux *aux);
>>   int drm_dp_start_crc(struct drm_dp_aux *aux, struct drm_crtc *crtc);
>>   int drm_dp_stop_crc(struct drm_dp_aux *aux);
>>   
>> +#ifdef CONFIG_DRM_DP_CEC
>> +int drm_dp_cec_irq(struct drm_dp_aux *aux);
>> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
>> +				 struct device *parent);
>> +#else
>> +static inline int drm_dp_cec_irq(struct drm_dp_aux *aux)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux,
>> +					       const char *name,
>> +					       struct device *parent)
>> +{
>> +	return -ENODEV;
>> +}
>> +#endif
>> +
>>   #endif /* _DRM_DP_HELPER_H_ */
>> -- 
>> 2.11.0
>>
