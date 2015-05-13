Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53206 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbEMLPu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 07:15:50 -0400
Date: Wed, 13 May 2015 12:10:17 +0100
From: Sean Young <sean@mess.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 06/11] cec: add HDMI CEC framework
Message-ID: <20150513111017.GA2191@gofer.mess.org>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
 <1430760785-1169-7-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 04, 2015 at 07:32:59PM +0200, Kamil Debski wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> The added HDMI CEC framework provides a generic kernel interface for
> HDMI CEC devices.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>

-snip-

> +int cec_create_adapter(struct cec_adapter *adap, const char *name, u32 caps)
> +{
> +	int res = 0;
> +
> +	adap->state = CEC_ADAP_STATE_DISABLED;
> +	adap->name = name;
> +	adap->phys_addr = 0xffff;
> +	adap->capabilities = caps;
> +	adap->version = CEC_VERSION_1_4;
> +	adap->sequence = 0;
> +	mutex_init(&adap->lock);
> +	adap->kthread = kthread_run(cec_thread_func, adap, name);
> +	init_waitqueue_head(&adap->kthread_waitq);
> +	init_waitqueue_head(&adap->waitq);
> +	if (IS_ERR(adap->kthread)) {
> +		pr_err("cec-%s: kernel_thread() failed\n", name);
> +		return PTR_ERR(adap->kthread);
> +	}
> +	if (caps) {
> +		res = cec_devnode_register(&adap->devnode, adap->owner);
> +		if (res)
> +			kthread_stop(adap->kthread);
> +	}
> +	adap->recv_notifier = cec_receive_notify;
> +
> +	/* Prepare the RC input device */
> +	adap->rc = rc_allocate_device();
> +	if (!adap->rc) {
> +		pr_err("cec-%s: failed to allocate memory for rc_dev\n", name);
> +		cec_devnode_unregister(&adap->devnode);
> +		kthread_stop(adap->kthread);
> +		return -ENOMEM;
> +	}
> +
> +	snprintf(adap->input_name, sizeof(adap->input_name), "RC for %s", name);
> +	snprintf(adap->input_phys, sizeof(adap->input_phys), "%s/input0", name);
> +	strncpy(adap->input_drv, name, sizeof(adap->input_drv));
> +
> +	adap->rc->input_name = adap->input_name;
> +	adap->rc->input_phys = adap->input_phys;
> +	adap->rc->dev.parent = &adap->devnode.dev;
> +	adap->rc->driver_name = adap->input_drv;
> +	adap->rc->driver_type = RC_DRIVER_CEC;
> +	adap->rc->allowed_protocols = RC_BIT_CEC;
> +	adap->rc->priv = adap;
> +	adap->rc->map_name = RC_MAP_CEC;
> +	adap->rc->timeout = MS_TO_NS(100);
> +

rc->input_id is not populated. It would be nice if input_phys has some 
resemblance to a physical path (like the output of usb_make_path() if it
is a usb device).

> +	res = rc_register_device(adap->rc);
> +
> +	if (res) {
> +		pr_err("cec-%s: failed to prepare input device\n", name);
> +		cec_devnode_unregister(&adap->devnode);
> +		rc_free_device(adap->rc);
> +		kthread_stop(adap->kthread);
> +	}
> +
> +	return res;
> +}
> +EXPORT_SYMBOL_GPL(cec_create_adapter);
> +
> +void cec_delete_adapter(struct cec_adapter *adap)
> +{
> +	if (adap->kthread == NULL)
> +		return;
> +	kthread_stop(adap->kthread);
> +	if (adap->kthread_config)
> +		kthread_stop(adap->kthread_config);
> +	adap->state = CEC_ADAP_STATE_DISABLED;
> +	if (cec_devnode_is_registered(&adap->devnode))
> +		cec_devnode_unregister(&adap->devnode);

I think you're missing a rc_unregister_device() here.

> +}
> +EXPORT_SYMBOL_GPL(cec_delete_adapter);


Sean
