Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:46997 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311Ab2EJMLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 08:11:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Thu, 10 May 2012 14:11:15 +0200
Cc: muralidhar dixit <muralidhar.dixit@gmail.com>,
	linux-media@vger.kernel.org
References: <CAH-Z1=WtUrS0HYMsOb9CarAcXhR72cO8QWAnUJdP+zDuj92Rxg@mail.gmail.com> <1622612.qhoKdLnT7W@flexo>
In-Reply-To: <1622612.qhoKdLnT7W@flexo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205101411.15982.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 10 May 2012 13:43:16 Florian Fainelli wrote:
> Hello Murali,
> 
> On Thursday 10 May 2012 12:40:05 muralidhar dixit wrote:
> > Hello Florian,
> > 
> > I do have similar implementation for my CEC driver.
> > And I prefer most of the CEC messaged to be handled in the user space and
> > have the kernel driver bare minimum with interfaces to
> > 1) REGISTER CEC device( I have support for multiple logical devices)
> > 2) SEND CEC MESSAGE
> > 3) RECV CEC MESSAGE
> > 
> > But one issue with this was the response time to the TV remote actions.
> 
> Well, I think this is specific to your platform, because I don't have any such 
> issue here with my implementation. The specification says that the desired 
> response time is of 200 ms and the maximum 1s, even with multiple context 
> switches you should be able to achieve that. Not knowing exactly how your 
> hardware works, maybe there is a bottleneck somewhere.
> 
> > Initially I was sending the UI control messages also to user space but
> > response time was too bad. Hence I wrote a CEC Keyboard driver which will
> > process the CEC UI control messages. From the CEC driver if I recv any CEC
> > UI control messages I will route it to CEC Keyboard driver in the kernel
> > and all other messages have to be handled by user space application.
> 
> This is the kind of thing that I want to avoid, on my platform, all the input 
> is processed in user-land and exposed as a HID device (thus self-describing), 
> forwarding CEC UI key codes to the kernel does not seem like a good solution 
> to me because it means we have to know about the CEC protocol itself.
> 
> I fear that if we start doing this with the CEC UI codes, we end-up doing the 
> same for the system-related messages (Power, standby etc ...) and this is also 
> to be avoided.

We are also doing parsing in userspace. The CEC API just gets the hardware up
and running so that we can send and receive CEC packets, but the kernel doesn't
parse. The only exception to that *might* be the remote control part of the
CEC specification (that's where button presses of a remote control are passed
over CEC). It might make sense to pass them on to the V4L2 framework for remote
controls.

Then again, it might not. Or only if you set a flag or something.

My personal view (but not everyone agreed at the time) is that we just need a
simple API to send/receive CEC packets and do everything else in userspace.
It would be nice if we have a standard library for that that everyone can use,
though.

Regards,

	Hans

> 
> > 
> > Best Regards,
> > Murali
> > From: Florian Fainelli <f.fainelli <at> gmail.com>
> > Subject: Re: [RFC] HDMI-CEC
> > proposal<http://news.gmane.org/find-
> root.php?message_id=%3c4F87F195.5080504%40gmail.com%3e>
> > Newsgroups: gmane.linux.drivers.video-input-
> infrastructure<http://news.gmane.org/gmane.linux.drivers.video-input-
> infrastructure>
> > Date: 2012-04-13 09:27:49 GMT (3 weeks, 5 days, 21 hours and 33 minutes ago)
> > 
> > Hi Hans,
> > 
> > Le 04/13/12 07:03, Hans Verkuil a écrit :
> > > You both hit the main problem of the *CEC* support: how to implement the 
> API.
> > 
> > Well, the API that I propose here [1] is quite simple:
> > 
> > - a kernel-side API for defining *CEC* adapters drivers
> > - a character device with an ioctl() control path and read/write/poll
> > data-path
> > 
> > [1]: https://github.com/ffainelli/linux-*hdmi*-*cec*
> > <https://github.com/ffainelli/linux-hdmi-cec>
> > 
> > >
> > > Cisco's work on *CEC* has been stalled as we first want to get *HDMI* 
> support in
> > > V4L. Hopefully that will happen in the next few months. After that we will
> > > resume working on the *CEC* API.
> > 
> > Well, I don't think that tighting *HDMI* into V4L is such a good idea
> > either. *HDMI* is also a separate bus and deserves its own subsystem and
> > even subsystems (audio, video, HDCP, *CEC*). For instance, the STB I am
> > working with does not use the V4L API at all, however, I would like to
> > be able to integrate within the Linux *HDMI* stack once there, think about
> > nvidia's driver too.
> > 
> > I can understand that you want to hold on your efforts on *CEC* while you
> > want to get *HDMI* in, but don't make it entirely driven by Cisco and
> > accept the community feedback.
> > 
> > >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > On Thursday, April 12, 2012 22:36:55 Oliver Schinagl wrote:
> > >> Since a lot of video cards dont' support *CEC* at all (not even
> > >> connected), don't have *hdmi*, but work perfectly fine with dvi->*hdmi*
> > >> adapters, *CEC* can be implemented in many other ways (think media 
> centers)
> > >>
> > >> One such exammple is using USB/Arduino
> > >>
> > >> http://code.google.com/p/*cec*-arduino/wiki/ElectricalInterface 
> <http://code.google.com/p/cec-arduino/wiki/ElectricalInterface>
> > >>
> > >> Having an AVR with v-usb code and *cec* code doesn't look all that hard
> > >> nor impossible, so one could simply have a USB plug on one end, and an
> > >> *HDMI* plug on the other end, utilizing only the *CEC* pins.
> > >>
> > >> This would make it more something like LIRC if anything.
> > >>
> > >> On 04/12/12 17:24, Florian Fainelli wrote:
> > >>> Hi Hans, Martin,
> > >>>
> > >>> Sorry to jump in so late in the *HDMI*-*CEC* discussion, here are some
> > >>> comments from my perspective on your *proposal*:
> > >>>
> > >>> - the *HDMI*-*CEC* implementation deserves its own bus and class of 
> devices
> > >>> because by definition it is a physical bus, which is even electrically
> > >>> independant from the rest of the *HDMI* bus (A/V path)
> > >>>
> > >>> - I don't think it is a good idea to tight it so closely to v4l, because
> > >>> one can perfectly have *CEC*-capable hardware without video, or at least
> > >>> not use v4l and have *HDMI*-*CEC* hardware
> > >>>
> > >>> - it was suggested to use sockets at some point, I think it is
> > >>> over-engineered and should only lead
> > >>>
> > >>> - processing messages in user-space is definitively the way to go, even
> > >>> input can be either re-injected using an uinput driver, or be handled in
> > >>> user-space entirely, eventually we might want to install "filters" based
> > >>> on opcodes to divert some opcodes to a kernel consumer, and the others
> > >>> to an user-space one
> > >>>
> > >>> Right now, I have a very simple implementation that I developed for the
> > >>> company I work for which can be found here:
> > >>> https://github.com/ffainelli/linux-*hdmi*-*cec* 
> <https://github.com/ffainelli/linux-hdmi-cec>
> > >>>
> > >>> It is designed like this:
> > >>>
> > >>> 1) A core module, which registers a *cec* bus, and provides an 
> abstraction
> > >>> for a *CEC* adapter (both device&  driver):
> > >>> - basic *CEC* adapter operations: logical address setting, queueing
> > >>> management
> > >>> - counters, rx filtering
> > >>> - host attaching/detaching in case the hardware is capable of
> > >>> self-processing *CEC* messages (for wakeup in particular)
> > >>>
> > >>> 2) A character device module, which exposes a character device per *CEC*
> > >>> adapter and only allows one consumer at a time and exposes the following
> > >>> ioctl's:
> > >>>
> > >>> - SET_LOGICAL_ADDRESS
> > >>> - RESET_DEVICE
> > >>> - GET_COUNTERS
> > >>> - SET_RX_MODE (my adapter can be set in a promiscuous mode)
> > >>>
> > >>> the character device supports read/write/poll, which are the prefered
> > >>> ways for transfering/receiving data
> > >>>
> > >>> 3) A *CEC* adapter implementation which registers and calls into the 
> core
> > >>> module when receiving a *CEC* message, and which the core module calls 
> in
> > >>> response to the IOCTLs described below.
> > >>>
> > >>> At first I thought about defining a generic netlink family in order to
> > >>> allow multiple user-space listeners receive *CEC* messages, but in the 
> end
> > >>> having only one consumer per adapter device is fine by me and a more
> > >>> traditionnal approach for programmers.
> > >>>
> > >>> I am relying on external components for knowing my *HDMI* physical 
> address.
> > >>>
> > >>> Hope this is not too late to (re)start the discussion on *HDMI*-*CEC*.
> > >>>
> > >>> Thank you very much.
> > >>> --
> > >>> Florian
> > >>> --
> > >>> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in
> > >>> the body of a message to majordomo <at> vger.kernel.org
> > >>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> > >>
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > >> the body of a message to majordomo <at> vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
