Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21460 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbbDTNKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 09:10:04 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	'Hans Verkuil' <hansverk@cisco.com>
References: <1426870363-18839-1-git-send-email-k.debski@samsung.com>
 <1426870363-18839-6-git-send-email-k.debski@samsung.com>
 <550C6208.6080504@xs4all.nl>
 <049901d075ec$7caabbc0$76003340$%debski@samsung.com>
 <5530F9BB.5010208@xs4all.nl>
In-reply-to: <5530F9BB.5010208@xs4all.nl>
Subject: RE: [RFC v3 5/9] cec: add new driver for cec support.
Date: Mon, 20 Apr 2015 15:10:00 +0200
Message-id: <"074101d07b6b$4fc3e620$ef4bb260$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

From: linux-media-owner@vger.kernel.org [mailto:linux-media-
owner@vger.kernel.org] On Behalf Of Hans Verkuil
Sent: Friday, April 17, 2015 2:17 PM
> 
> On 04/13/2015 03:19 PM, Kamil Debski wrote:
> > Hi Hans,
> >
> > Thank you so much for the review.
> >
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Hans Verkuil
> > Sent: Friday, March 20, 2015 7:08 PM
> >>
> 
> <snip>
> 
> >>> +In order for a CEC adapter to be configured it needs a physical
> >> address.
> >>> +This is normally assigned by the driver. It is either 0.0.0.0 for
> a
> >> TV (aka
> >>> +video receiver) or it is derived from the EDID that the source
> >> received
> >>> +from the sink. This is normally set by the driver before enabling
> >> the CEC
> >>> +adapter, or it is set from userspace in the case of CEC USB
> dongles
> >> (although
> >>> +embedded systems might also want to set this manually).
> >>
> >> I would actually expect that USB dongles read out the EDID from the
> >> source.
> >> I might be wrong, though.
> >
> > EDID is communicated to the device by the TV on a different bus than
> > CEC, it is DDC. It is possible that the dongle also reads DDC
> messages.
> > My initial understanding was that a CEC USB dongle handles only CEC
> > messages and is passing through all other signals, such as DDC.
> 
> I checked against the libcec code (see link here: http://libcec.pulse-
> eight.com/) for my usb-cec dongle and it turns out the library reads
> out the edid from the monitor using xrandr (I think, see
> src/libcec/platform/X11/randr-edid.cpp) in order to get the physical
> address. So it is not using the dongle itself for that. Makes sense.
> 
> >
> >>> +
> >>> +After enabling the CEC adapter it has to be configured. The CEC
> >> adapter has
> >>> +to be informed for which CEC device types a logical address has to
> >> be found.
> >>
> >> I would say: 'a free (unused) logical address'.
> >>
> >>> +The CEC framework will attempt to find such logical addresses. If
> >> none are
> >>
> >> And here: 'find and claim'
> >>
> >>> +found, then it will fall back to logical address Unregistered (15).
> >>
> >> You probably need to add some documentation regarding
> >> cec_claim_log_addrs()
> >> and how drivers can use it. Also, while logical addresses are being
> >> claimed, are drivers or userspace allowed to transmit/receive other
> >> messages? Or just stall until this is finished?
> >
> > When sending a message the user space is free to set any source and
> > destination address. Hence, I see no need to wait until the logical
> > address is claimed.
> >
> > If the user space is not waiting until the address and is sending
> > messages, then I guess it is done with full responsibility on the
> user
> > space.
> >
> > Regarding receiving, I guess it should be possible to receive
> > broadcast messages.
> >
> > What do you think?
> 
> Fair enough, it just needs to be documented.

Ok, will do.

> 
> <snip>
> 
> >>> +Promiscuous mode
> >>> +----------------
> >>> +
> >>> +The promiscuous mode enables the userspace applications to read
> all
> >>> +messages on the CEC bus. This is similar to the promiscuous mode
> in
> >>> +network devices. In the normal mode messages not directed to the
> >> device
> >>> +(differentiated by the logical address of the CEC device) are not
> >>> +forwarded to the userspace. Same rule applies to the messages
> >> contailning
> >>> +remote control key codes. When promiscuous mode is enabled all
> >> messages
> >>> +can be read by userspace. Processing of the messages is still done,
> >> thus
> >>> +key codes will be both interpreted by the framework and available
> >>> +as
> >> an
> >>> +input device, but also raw messages containing these codes are
> sent
> >> to
> >>> +the userspace.
> >>
> >> Will messages that are processed by the driver or cec framework also
> >> be relayed to userspace in promiscuous mode? Will userspace be able
> >> to tell that it has been processed already?
> >
> > All messages will be relayed to the user space and no there is no
> > possibility to check whether the message was processed by the kernel
> > already.
> 
> Should we add that? To be honest, I'm not sure about that myself.

The promiscuous mode is useful mainly for debug reasons. I would leave it,
however it is not a deal breaker for me. It could be added at a later time.

> Once thing I notice is that there are no reserved fields at the end of
> struct cec_msg. We should add that. Same with the other structs. It
> served us well with v4l2, and we should do the same with the cec API.

This is indeed a good idea. Thanks :)

> 
> Another upcoming problem is the use of struct timespec: this will have
> to change in the near future to one that is year 2038-safe.
> Unfortunately, there is no public 'struct timespec64' type yet. This
> mailinglist might provide answers w.r.t. the precise plans with
> timespec:
> http://lwn.net/Articles/640284/
> 
> Also, we don't have 32-bit compat code for CEC. I wonder if it is a
> good idea to improve the layout of the structs to minimize 64/32-bit
> layout differences. I never paid attention to that when I made these
> structs as I always planned to do that at the end.

It's good that you mentioned this, will do.

> 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

