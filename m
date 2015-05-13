Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42264 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbbEMJnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 05:43:45 -0400
Message-ID: <55531CC6.5020907@xs4all.nl>
Date: Wed, 13 May 2015 11:43:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 06/11] cec: add HDMI CEC framework
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Typo and question:

On 05/04/15 19:32, Kamil Debski wrote:
> +static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> +	struct cec_adapter *adap = to_cec_adapter(cecdev);
> +	void __user *parg = (void __user *)arg;
> +	int err;
> +
> +	if (!cec_devnode_is_registered(cecdev))
> +		return -EIO;
> +
> +	switch (cmd) {

snip

> +	case CEC_G_ADAP_STATE: {
> +		u32 state = adap->state != CEC_ADAP_STATE_DISABLED;
> +
> +		if (copy_to_user(parg, &state, sizeof(state)))
> +			return -EFAULT;
> +		break;
> +	}
> +
> +	case CEC_S_ADAP_STATE: {
> +		u32 state;
> +
> +		if (!(adap->capabilities & CEC_CAP_STATE))
> +			return -ENOTTY;
> +		if (copy_from_user(&state, parg, sizeof(state)))
> +			return -EFAULT;
> +		if (!state && adap->state == CEC_ADAP_STATE_DISABLED)
> +			return 0;
> +		if (state && adap->state != CEC_ADAP_STATE_DISABLED)
> +			return 0;
> +		cec_enable(adap, !!state);
> +		break;
> +	}
> +
> +	case CEC_G_ADAP_PHYS_ADDR:
> +		if (copy_to_user(parg, &adap->phys_addr,
> +						sizeof(adap->phys_addr)))
> +			return -EFAULT;

If the adapter requires that userspace sets up the phys addr, then what
should this return if no such address has been set up?

I see two options: either 0xffff (which should be used if the HDMI cable
is disconnected), or return an error (perhaps ENODATA).

I think 0xffff might be best. This will still allow the unregistered
logical address.

Note that the comment in uapi/linux/cec.h for G_ADAP_LOG_ADDRS says that it
will return an error if the physical address is not set. That's not true
as far as I can tell, and if we go for 0xffff as the default in a case like
that, then it isn't necessary either to return an error.

cec_create_adapter already initialized the physical address to 0xffff, so
that looks good. But it should be documented in cec-ioc-g-adap-phys-addr.xml.

> +		break;
> +
> +	case CEC_S_ADAP_PHYS_ADDR: {
> +		u16 phys_addr;
> +
> +		if (!(adap->capabilities & CEC_CAP_PHYS_ADDR))
> +			return -ENOTTY;
> +		if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
> +			return -EFAULT;
> +		adap->phys_addr = phys_addr;
> +		break;
> +	}
> +
> +	case CEC_G_ADAP_LOG_ADDRS: {
> +		struct cec_log_addrs log_addrs;
> +
> +		log_addrs.cec_version = adap->version;
> +		log_addrs.num_log_addrs = adap->num_log_addrs;
> +		memcpy(log_addrs.primary_device_type, adap->prim_device,
> +							CEC_MAX_LOG_ADDRS);
> +		memcpy(log_addrs.log_addr_type, adap->log_addr_type,
> +							CEC_MAX_LOG_ADDRS);
> +		memcpy(log_addrs.log_addr, adap->log_addr,
> +							CEC_MAX_LOG_ADDRS);
> +
> +		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
> +			return -EFAULT;
> +		break;
> +	}
> +
> +	case CEC_S_ADAP_LOG_ADDRS: {
> +		struct cec_log_addrs log_addrs;
> +
> +		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
> +			return -ENOTTY;
> +		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
> +			return -EFAULT;
> +		err = cec_claim_log_addrs(adap, &log_addrs,
> +					!(filp->f_flags & O_NONBLOCK));
> +		if (err)
> +			return err;
> +
> +		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
> +			return -EFAULT;
> +		break;
> +	}
> +
> +	case CEC_G_VENDOR_ID:
> +		if (copy_to_user(parg, &adap->vendor_id,
> +						sizeof(adap->vendor_id)))
> +			return -EFAULT;

I've been reading up on this. If I understand it correctly, then this is
optional (only if a device supports vendor commands does it have to implement
this).

So if the VENDOR capability is set, then userspace *may* change it. If it is
left undefined, then no vendor commands are allowed.

I think this should be redesigned:

One CEC_CAP_VENDOR_CMDS: if set, then vendor commands are allowed.
One CEC_CAP_VENDOR_ID: userspace may set the Vendor ID. No vendor commands are
allowed as long as no vendor ID was set.

So if VENDOR_CMDS is set and VENDOR_ID isn't, then that means that the driver
will have set the vendor ID and the application can retrieve it with G_VENDOR_ID.
If both are set, then userspace has to provide a vendor ID before vendor commands
will be allowed.

That leaves the problem of determining that no vendor ID was set. Unfortunately
the whole range of 0x000000-0xffffff is valid (and 0x000000 maps in fact to a
company (Xerox) according to the IEEE Registration Authority Committee website.

We can define a CEC_VENDOR_ID_INVALID 0xffffffff, that might be the easiest way
of doing this.

A related question: should userspace be allowed to change a valid physical
address or a valid vendor ID to something else once the logical addresses have
been claimed? Or should that result in -EBUSY? I'm leaning towards that.

Actually, the same question is true for S_LOG_ADDRS: that should be done only
once as well as long as the adapter is enabled.

BTW, the documentation does not mention the order in which S_PHYS_ADDR and
S_VENDOR_ID should be issued: should this be done before the adapter is
enabled or before the logical addresses are claimed?

> +		break;
> +
> +	case CEC_S_VENDOR_ID: {
> +		u32 vendor_id;
> +
> +		if (!(adap->capabilities & CEC_CAP_VENDOR_ID))
> +			return -ENOTTY;
> +		if (copy_from_user(&vendor_id, parg, sizeof(vendor_id)))
> +			return -EFAULT;
> +		/* Vendori ID is a 24 bit number, so check if the value is

Typo: Vendori -> Vendor


> +		 * within the correct range. */
> +		if ((vendor_id & 0xff000000) != 0)
> +			return -EINVAL;
> +		adap->vendor_id = vendor_id;
> +		break;
> +	}

Working on a compliance test is always a great way of finding all these
corner cases...

Regards,

	Hans
