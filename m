Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1557 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2DMFDa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 01:03:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Fri, 13 Apr 2012 07:03:18 +0200
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	linux-media@vger.kernel.org, marbugge@cisco.com
References: <4F86F3A6.9040305@gmail.com> <4F873CE7.4040401@schinagl.nl>
In-Reply-To: <4F873CE7.4040401@schinagl.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204130703.19005.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You both hit the main problem of the CEC support: how to implement the API.

Cisco's work on CEC has been stalled as we first want to get HDMI support in
V4L. Hopefully that will happen in the next few months. After that we will
resume working on the CEC API.

Regards,

	Hans

On Thursday, April 12, 2012 22:36:55 Oliver Schinagl wrote:
> Since a lot of video cards dont' support CEC at all (not even 
> connected), don't have hdmi, but work perfectly fine with dvi->hdmi 
> adapters, CEC can be implemented in many other ways (think media centers)
> 
> One such exammple is using USB/Arduino
> 
> http://code.google.com/p/cec-arduino/wiki/ElectricalInterface
> 
> Having an AVR with v-usb code and cec code doesn't look all that hard 
> nor impossible, so one could simply have a USB plug on one end, and an 
> HDMI plug on the other end, utilizing only the CEC pins.
> 
> This would make it more something like LIRC if anything.
> 
> On 04/12/12 17:24, Florian Fainelli wrote:
> > Hi Hans, Martin,
> >
> > Sorry to jump in so late in the HDMI-CEC discussion, here are some
> > comments from my perspective on your proposal:
> >
> > - the HDMI-CEC implementation deserves its own bus and class of devices
> > because by definition it is a physical bus, which is even electrically
> > independant from the rest of the HDMI bus (A/V path)
> >
> > - I don't think it is a good idea to tight it so closely to v4l, because
> > one can perfectly have CEC-capable hardware without video, or at least
> > not use v4l and have HDMI-CEC hardware
> >
> > - it was suggested to use sockets at some point, I think it is
> > over-engineered and should only lead
> >
> > - processing messages in user-space is definitively the way to go, even
> > input can be either re-injected using an uinput driver, or be handled in
> > user-space entirely, eventually we might want to install "filters" based
> > on opcodes to divert some opcodes to a kernel consumer, and the others
> > to an user-space one
> >
> > Right now, I have a very simple implementation that I developed for the
> > company I work for which can be found here:
> > https://github.com/ffainelli/linux-hdmi-cec
> >
> > It is designed like this:
> >
> > 1) A core module, which registers a cec bus, and provides an abstraction
> > for a CEC adapter (both device & driver):
> > - basic CEC adapter operations: logical address setting, queueing
> > management
> > - counters, rx filtering
> > - host attaching/detaching in case the hardware is capable of
> > self-processing CEC messages (for wakeup in particular)
> >
> > 2) A character device module, which exposes a character device per CEC
> > adapter and only allows one consumer at a time and exposes the following
> > ioctl's:
> >
> > - SET_LOGICAL_ADDRESS
> > - RESET_DEVICE
> > - GET_COUNTERS
> > - SET_RX_MODE (my adapter can be set in a promiscuous mode)
> >
> > the character device supports read/write/poll, which are the prefered
> > ways for transfering/receiving data
> >
> > 3) A CEC adapter implementation which registers and calls into the core
> > module when receiving a CEC message, and which the core module calls in
> > response to the IOCTLs described below.
> >
> > At first I thought about defining a generic netlink family in order to
> > allow multiple user-space listeners receive CEC messages, but in the end
> > having only one consumer per adapter device is fine by me and a more
> > traditionnal approach for programmers.
> >
> > I am relying on external components for knowing my HDMI physical address.
> >
> > Hope this is not too late to (re)start the discussion on HDMI-CEC.
> >
> > Thank you very much.
> > --
> > Florian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
