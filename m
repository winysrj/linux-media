Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43522 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbbAWLHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 06:07:50 -0500
Date: Fri, 23 Jan 2015 11:07:47 +0000
From: Sean Young <sean@mess.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC v2 3/7] cec: add new framework for cec support.
Message-ID: <20150123110747.GA3084@gofer.mess.org>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
 <1421942679-23609-4-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421942679-23609-4-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2015 at 05:04:35PM +0100, Kamil Debski wrote:
> Add the CEC framework.
-snip-
> +Remote control handling
> +-----------------------
> +
> +The CEC framework provides two ways of handling the key messages of remote
> +control. In the first case, the CEC framework will handle these messages and
> +provide the keypressed via the RC framework. In the second case the messages
> +related to the key down/up events are not parsed by the framework and are
> +passed to the userspace as raw messages.
> +
> +Switching between these modes is done with a special ioctl.
> +
> +#define CEC_G_KEY_PASSTHROUGH	_IOR('a', 10, __u8)
> +#define CEC_S_KEY_PASSTHROUGH	_IOW('a', 11, __u8)
> +#define CEC_KEY_PASSTHROUGH_DISABLE	0
> +#define CEC_KEY_PASSTHROUGH_ENABLE	1

This is ugly. This ioctl stops keypresses from going to rc-core. The cec 
device is still registered with rc-core but no keys will be passed to it. 
This could also be handled by loading an empty keymap; this way the input 
layer will still receive scancodes but no keypresses.

> +static ssize_t cec_read(struct file *filp, char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> +
> +	if (!cec_devnode_is_registered(cecdev))
> +		return -EIO;
> +	return 0;
> +}
> +
> +static ssize_t cec_write(struct file *filp, const char __user *buf,
> +		size_t sz, loff_t *off)
> +{
> +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> +
> +	if (!cec_devnode_is_registered(cecdev))
> +		return -EIO;
> +	return 0;
> +}

Both read and write do nothing; they should either -ENOSYS or the fuctions
should be removed.


Sean
