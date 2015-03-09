Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18445 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbbCIQWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 12:22:09 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKY008O9DNMQ620@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Mar 2015 16:26:10 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>
Cc: 'Sean Young' <sean@mess.org>, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, 'Hans Verkuil' <hansverk@cisco.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
 <1421942679-23609-4-git-send-email-k.debski@samsung.com>
 <20150123110747.GA3084@gofer.mess.org>
 <086501d05828$b88bf320$29a3d960$%debski@samsung.com>
 <20150308124141.0bce2846@recife.lan>
In-reply-to: <20150308124141.0bce2846@recife.lan>
Subject: RE: [RFC v2 3/7] cec: add new framework for cec support.
Date: Mon, 09 Mar 2015 17:22:05 +0100
Message-id: <000901d05a85$2f484500$8dd8cf00$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for your comments.

From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
Sent: Sunday, March 08, 2015 4:42 PM

> 
> Em Fri, 06 Mar 2015 17:14:50 +0100
> Kamil Debski <k.debski@samsung.com> escreveu:
> 
> > Hi Sean, Hans,
> >
> > I am sorry to reply so late, I was busy with other work. I am
> > preparing the next version of the CEC framework and I would like to
> > discuss your comment.
> 
> I'll do a deeper review of this patch when I have some time. For now,
> let me add my comments about the pass-trough mode. See below.

I think I might have confused you with the pass-through mode. I think it
would be good if I explained it in detail.

I guess my initial name choice wasn't fortunate. I prefer the name "raw"
over "pass through" as it is closer to what I meant by adding this feature. 
Maybe even "promiscuous" could be better.

The CEC framework does filtering on the messages it receives. It will
filter messages not directed to the device (different logical address)
and will do parsing of the keystrokes. The keystrokes are then reported by
the input framework to the userspace and won't be read by the CEC_RECEIVE
ioctl.

In the "raw"/"promiscuous" the messages on the CEC bus would not be
filtered and all of them should be passed to the userspace. This will
include messages not intended for the particular device and keystroke
messages. I think that this mode could be useful, e.g. for debugging and
maybe for devices that act as switches.

My original idea was that in the "raw" mode the CEC framework would stop
passing the keycodes from the CEC bus to the input device. I see that
this can be problematic, hence I think that suspending from passing the
keycodes to the input framework is not necessary. 

I think that this solution would be acceptable for you guys. Mauro, Sean,
Hans, tell me if I am wrong? To recap - the "raw"/"promiscuous" mode would
only disable filtering of messages and had no effect on passing keycodes
to the input device.

> >
> > From: Sean Young [mailto:sean@mess.org]
> > Sent: Friday, January 23, 2015 12:08 PM
> > >
> > > On Thu, Jan 22, 2015 at 05:04:35PM +0100, Kamil Debski wrote:
> > > > Add the CEC framework.
> > > -snip-
> > > > +Remote control handling
> > > > +-----------------------
> > > > +
> > > > +The CEC framework provides two ways of handling the key messages
> > > > +of remote control. In the first case, the CEC framework will
> > > > +handle these messages and provide the keypressed via the RC
> > > > +framework. In the second case the messages related to the key
> > > > +down/up events are not parsed by the framework and are passed to
> > > > +the userspace as raw
> > > messages.
> > > > +
> > > > +Switching between these modes is done with a special ioctl.
> > > > +
> > > > +#define CEC_G_KEY_PASSTHROUGH	_IOR('a', 10, __u8)
> > > > +#define CEC_S_KEY_PASSTHROUGH	_IOW('a', 11, __u8)
> > > > +#define CEC_KEY_PASSTHROUGH_DISABLE	0
> > > > +#define CEC_KEY_PASSTHROUGH_ENABLE	1
> > >
> > > This is ugly. This ioctl stops keypresses from going to rc-core.
> The
> > > cec device is still registered with rc-core but no keys will be
> > > passed to it.
> > > This could also be handled by loading an empty keymap; this way the
> > > input layer will still receive scancodes but no keypresses.
> >
> > I see here a few options that can be done:
> >
> > 1) Remove the past through option altogether I think I would opt for
> > leaving it. There should be some mode that would enable raw access to
> > the CEC bus. Maybe it should be something more like a promiscuous
> mode
> > in Wi-Fi networks. What do you think? Sean, Hans?
> >
> > 2) Leave the pass through mode, but without disabling passing the
> > keyup/down events to the RC framework. This way an application could
> > capture all messages, but the input device would not be crippled in
> > any way. The problem with this solution is that key presses could be
> > accounted twice.
> >
> > 3) As you suggested - load an empty keymap whenever the pass through
> > mode is enabled.
> > I am not that familiar with the RC core. Is there a simple way to
> > switch to an empty map from the kernel? There is the ir_setkeytable
> > function, but it is static in rc-main.c, so it cannot be used in
> other
> > kernel modules. Any hints, Sean?
> >
> > 4) Remove the input device whenever a pass through mode is enabled.
> > This is an alternative to the solution number 3. I think it would not
> > be great, because a
> > /dev/input/event* that appears
> > and disappears could be confusing.
> 
> (4) doesn't seem nice.
> 
> I don't think that the driver itself should cleanup the keymap. This is
> something that the userspace app(s) should explicitly request.

I agree.

> With regards to the "raw" mode, the RC core currently has two ways to
> send/receive raw data:
> 
> 1) Via LIRC. This needs to be extended to pass scancodes, as, currently,
> it sends/receive pulses. We need such extension for other usages,
> anyway, so adding it makes sense.

That is another thing I need to implement - send keycodes to other
devices.

> 
> 2) The input layer actually provide several types of events on a key
> press. One of such events carry on the scancode:
> 
> 1425828993.018962: event type EV_KEY(0x01) key_down:
> KEY_VOLUMEDOWN(0x0001)
> 1425828993.018962: event type EV_SYN(0x00).
> 1425828993.131823: event type EV_KEY(0x01) key_up:
> KEY_VOLUMEDOWN(0x0001)
> 1425828993.131823: event type EV_MSC(0x04): scancode = 0x1e
> 1425828993.131823: event type EV_SYN(0x00).
> 
> The EV_KEY events has the Linux Keycode, plus the info if the key was
> pressed or released, while the EV_MSC has the scancode.
> 
> So, I'm not seeing much usage of a pass-through mode, as, even without
> LIRC, the userspace could simply cleanup the key map, and listen to
> EV_MSC:

Maybe I made this confusing - the pass-through (raw/promiscuous) mode
would be useful for debugging and I think for switches that forward CEC
messages. 

> 
> $ sudo ir-keytable -c -t
> Old keytable cleared
> Testing events. Please, press CTRL-C to abort.
> 1425829137.721737: event type EV_MSC(0x04): scancode = 0x1b
> 1425829137.721737: event type EV_SYN(0x00).
> 1425829139.318249: event type EV_MSC(0x04): scancode = 0x18
> 1425829139.318249: event type EV_SYN(0x00).
> ...
> 
> Yet, the best would be for the application is to setup the key map it
> needs, and just use the standard Linux way: wait for EV_KEY events.
> 
> Regards,
> Mauro
> 
> >
> > >
> > > > +static ssize_t cec_read(struct file *filp, char __user *buf,
> > > > +		size_t sz, loff_t *off)
> > > > +{
> > > > +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> > > > +
> > > > +	if (!cec_devnode_is_registered(cecdev))
> > > > +		return -EIO;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static ssize_t cec_write(struct file *filp, const char __user
> *buf,
> > > > +		size_t sz, loff_t *off)
> > > > +{
> > > > +	struct cec_devnode *cecdev = cec_devnode_data(filp);
> > > > +
> > > > +	if (!cec_devnode_is_registered(cecdev))
> > > > +		return -EIO;
> > > > +	return 0;
> > > > +}
> > >
> > > Both read and write do nothing; they should either -ENOSYS or the
> > > fuctions should be removed.
> > >
> >
> > I agree, I removed this for the next version.
> >
> > Best wishes,

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

