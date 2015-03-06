Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14863 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbCFQPN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 11:15:13 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKS00MYQTBXX450@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 06 Mar 2015 16:19:09 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sean Young' <sean@mess.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de,
	'Hans Verkuil' <hansverk@cisco.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
 <1421942679-23609-4-git-send-email-k.debski@samsung.com>
 <20150123110747.GA3084@gofer.mess.org>
In-reply-to: <20150123110747.GA3084@gofer.mess.org>
Subject: RE: [RFC v2 3/7] cec: add new framework for cec support.
Date: Fri, 06 Mar 2015 17:14:50 +0100
Message-id: <086501d05828$b88bf320$29a3d960$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean, Hans,

I am sorry to reply so late, I was busy with other work. I am preparing the
next version
of the CEC framework and I would like to discuss your comment.

From: Sean Young [mailto:sean@mess.org]
Sent: Friday, January 23, 2015 12:08 PM
> 
> On Thu, Jan 22, 2015 at 05:04:35PM +0100, Kamil Debski wrote:
> > Add the CEC framework.
> -snip-
> > +Remote control handling
> > +-----------------------
> > +
> > +The CEC framework provides two ways of handling the key messages of
> > +remote control. In the first case, the CEC framework will handle
> > +these messages and provide the keypressed via the RC framework. In
> > +the second case the messages related to the key down/up events are
> > +not parsed by the framework and are passed to the userspace as raw
> messages.
> > +
> > +Switching between these modes is done with a special ioctl.
> > +
> > +#define CEC_G_KEY_PASSTHROUGH	_IOR('a', 10, __u8)
> > +#define CEC_S_KEY_PASSTHROUGH	_IOW('a', 11, __u8)
> > +#define CEC_KEY_PASSTHROUGH_DISABLE	0
> > +#define CEC_KEY_PASSTHROUGH_ENABLE	1
> 
> This is ugly. This ioctl stops keypresses from going to rc-core. The
> cec device is still registered with rc-core but no keys will be passed
> to it.
> This could also be handled by loading an empty keymap; this way the
> input layer will still receive scancodes but no keypresses.

I see here a few options that can be done:

1) Remove the past through option altogether
I think I would opt for leaving it. There should be some mode that would
enable
raw access to the CEC bus. Maybe it should be something more like a
promiscuous mode
in Wi-Fi networks. What do you think? Sean, Hans?

2) Leave the pass through mode, but without disabling passing the keyup/down
events to
the RC framework. This way an application could capture all messages, but
the input device
would not be crippled in any way. The problem with this solution is that key
presses could
be accounted twice.

3) As you suggested - load an empty keymap whenever the pass through mode is
enabled.
I am not that familiar with the RC core. Is there a simple way to switch to
an empty map
from the kernel? There is the ir_setkeytable function, but it is static in
rc-main.c, so it
cannot be used in other kernel modules. Any hints, Sean?

4) Remove the input device whenever a pass through mode is enabled. This is
an alternative to
the solution number 3. I think it would not be great, because a
/dev/input/event* that appears
and disappears could be confusing.

> 
> > +static ssize_t cec_read(struct file *filp, char __user *buf,
> > +		size_t sz, loff_t *off)
> > +{
> > +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> > +
> > +	if (!cec_devnode_is_registered(cecdev))
> > +		return -EIO;
> > +	return 0;
> > +}
> > +
> > +static ssize_t cec_write(struct file *filp, const char __user *buf,
> > +		size_t sz, loff_t *off)
> > +{
> > +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> > +
> > +	if (!cec_devnode_is_registered(cecdev))
> > +		return -EIO;
> > +	return 0;
> > +}
> 
> Both read and write do nothing; they should either -ENOSYS or the
> fuctions should be removed.
> 

I agree, I removed this for the next version.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


