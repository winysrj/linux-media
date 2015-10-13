Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33323 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbJMXKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 19:10:14 -0400
Date: Wed, 14 Oct 2015 00:09:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 06/15] rc: Add HDMI CEC protocol handling
Message-ID: <20151013230957.GN32532@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com>
 <20151006180540.GR21513@n2100.arm.linux.org.uk>
 <561B9E97.4050909@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561B9E97.4050909@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2015 at 01:50:47PM +0200, Hans Verkuil wrote:
> On 10/06/2015 08:05 PM, Russell King - ARM Linux wrote:
> > On Mon, Sep 07, 2015 at 03:44:35PM +0200, Hans Verkuil wrote:
> >> From: Kamil Debski <kamil@wypas.org>
> >>
> >> Add handling of remote control events coming from the HDMI CEC bus.
> >> This patch includes a new keymap that maps values found in the CEC
> >> messages to the keys pressed and released. Also, a new protocol has
> >> been added to the core.
> >>
> >> Signed-off-by: Kamil Debski <kamil@wypas.org>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > (Added Mauro)
> > 
> > Hmm, how is rc-cec supposed to be loaded?
> 
> Is CONFIG_RC_MAP enabled in your config? Ran 'depmod -a'? (Sorry, I'm sure you've done
> that, just checking...)

CONFIG_RC_MAP=m

and yes, if depmod hadn't have been run, modprobing rc-cec would not
have worked - modprobe always looks up in the depmod information to
find out where the module is located, and also to determine any
dependencies.

> It's optional as I understand it, since you could configure the keytable from
> userspace instead of using this module.
> 
> For the record (just tried it), it does load fine on my setup.

Immediately after boot, I have:

# lsmod
Module                  Size  Used by
...
coda                   54685  0
v4l2_mem2mem           14517  1 coda
videobuf2_dma_contig     9478  1 coda
videobuf2_vmalloc       5529  1 coda
videobuf2_memops        1888  2 videobuf2_dma_contig,videobuf2_vmalloc
cecd_dw_hdmi            3129  0
# modprobe rc-cec
# lsmod
Module                  Size  Used by
rc_cec                  1785  0
...
coda                   54685  0
v4l2_mem2mem           14517  1 coda
videobuf2_dma_contig     9478  1 coda
videobuf2_vmalloc       5529  1 coda
videobuf2_memops        1888  2 videobuf2_dma_contig,videobuf2_vmalloc
cecd_dw_hdmi            3129  0

So, rc-cec is perfectly loadable, it just doesn't get loaded at boot.
Manually loading it like this is useless though - I have to unload
cecd_dw_hdmi and then re-load it after rc-cec is loaded for rc-cec to
be seen.  At that point, (and with the help of a userspace program)
things start working as expected.

> BTW, I am still on the fence whether using the kernel RC subsystem is
> the right thing to do. There are a number of CEC RC commands that use
> extra parameters that cannot be mapped to the RC API, so you still
> need to handle those manually.

Even though it is a remote control which is being forwarded for the
most part, but there are operation codes which aren't related to
key presses specified by the standard.  I don't think there's anything
wrong with having a RC interface present, but allowing other interfaces
as a possibility is a good thing too - it allows a certain amount of
flexibility.

For example, with rc-cec loaded and properly bound, I can control at
least rhythmbox within gnome using the TVs remote control with no
modifications - and that happens because the X server passes on the
events it receives via the event device.

Given the range of media applications, I think that's key - it needs
to at least have the capability to plug into the existing ways of doing
things, even if those ways are not perfect.

> Perhaps I should split it off into a separate patch and keep it out
> from the initial pull request once we're ready for that.

I'm biased because it is an enablement feature - it allows CEC to work
out of the box with at least some existing media apps. :)

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
