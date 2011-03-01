Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1628 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1CARbx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 12:31:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Martin Bugge (marbugge)" <marbugge@cisco.com>
Subject: Re: [RFC] HDMI-CEC proposal
Date: Tue, 1 Mar 2011 18:31:41 +0100
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
References: <4D6CC36B.50009@cisco.com> <1298987251.3311.32.camel@morgan.silverblock.net> <4D6D09C9.5040608@cisco.com>
In-Reply-To: <4D6D09C9.5040608@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011831.42023.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, March 01, 2011 15:59:21 Martin Bugge (marbugge) wrote:
> On 03/01/2011 02:47 PM, Andy Walls wrote:
> > On Tue, 2011-03-01 at 10:59 +0100, Martin Bugge (marbugge) wrote:
> >    
> >> Author: Martin Bugge<marbugge@cisco.com>
> >> Date:  Tue, 1 March 2010
> >> ======================
> >>
> >> This is a proposal for adding a Consumer Electronic Control (CEC) API to
> >> V4L2.
> >> This document describes the changes and new ioctls needed.
> >>
> >> Version 1.0 (This is first version)
> >>
> >> Background
> >> ==========
> >> CEC is a protocol that provides high-level control functions between
> >> various audiovisual products.
> >> It is an optional supplement to the High-Definition Multimedia Interface
> >> Specification (HDMI).
> >> Physical layer is a one-wire bidirectional serial bus that uses the
> >> industry-standard AV.link protocol.
> >>
> >> In short: CEC uses pin 13 on the HDMI connector to transmit and receive
> >> small data-packets
> >>             (maximum 16 bytes including a 1 byte header) at low data
> >> rates (~400 bits/s).
> >>
> >> A CEC device may have any of 15 logical addresses (0 - 14).
> >> (address 15 is broadcast and some addresses are reserved)
> >>
> >>
> >> References
> >> ==========
> >> [1] High-Definition Multimedia Interface Specification version 1.3a,
> >>       Supplement 1 Consumer Electronic Control (CEC).
> >>       http://www.hdmi.org/manufacturer/specification.aspx
> >>
> >> [2]
> >> http://www.hdmi.org/pdf/whitepaper/DesigningCECintoYourNextHDMIProduct.pdf
> >>      
> >
> > Hi Martin,
> >
> > After reading the whitepaper, and the the general purpose nature of your
> > proposed API calls, I'm wondering if a socket interface wouldn't be
> > appropriate.
> >
> > The CEC bus seems to be designed as a network.  A broadcast medium, with
> > multiport devices (switches), physical (MAC) addresses in dotted decimal
> > notation (1.0.0.0), dynamic logical address assignment, arbitration
> > (Media Access Control), etc.  The whitepaper even suggests OSI layers,
> > using the term PHY in a few places.
> >
> >
> > A network interface could be implemented something like what is done for
> > SLIP in figure 2 here (compare with figure 1):
> >
> > 	http://www.linux.it/~rubini/docs/serial/serial.html
> >
> >
> > Using that diagram as a guide, a socket interface would need a CEC tty
> > line discipline, CEC network device, and code to hook the CEC serial
> > device to the tty layer.  Multiple CEC serial devices would show up as
> > multiple network interfaces.
> >
> > Once a network device is available, user-space could then use AF_PACKET
> > sockets.  If CEC's layers are standardized enough, a new address family
> > could be added to the kernel, I guess.
> >
> > Of course, all that is a lot of work.  Since Cisco should have some
> > networking experts hanging around, maybe it wouldn't be too hard. ;)
> >
> >
> > Regards,
> > Andy
> >    
> 
> Hi Andy and thank you.
> 
> I agree its always nice to strive for a generic solution, but I don't 
> think I'm able to
> get hold of the resources required.
> 
> In CEC the physical address is determined by the edid information from 
> the HDMI sink,
> or for the HDMI sink its HDMI port number.
> 
> While the logical address describes the type of device, TV, Recorder, 
> Tuner, etc.
> 
>  From that point of view I do think that the CEC protocol is closly 
> connected to the HDMI connector,
> such that it belongs together with a video device.
> 
> But I will ask my "mentor" for advice.

Yes, CEC has a physical address which obtained from the EDID. It is generated
via the EDID. It has nothing to do with network addresses. Instead it is a
generated unique identifier. CEC also has logical addresses which is a really
a 'Device Type Identifier' for want of a better name. See CEC Table 5 in the
1.3a HDMI spec.

When I read through it I couldn't help wondering what to do if I have more than
three playback devices or recording devices. Or more than one TV, for that matter.

It also seems that the tree of connected devices can't be more than 4 or 5 levels,
if I understand section 8.7.2 (Physical Address Discovery) correctly.

As I mentioned in my reply to Mauro, CEC most closely resembles RDS in that the
hardware/kernel part is trivial, but parsing and correctly handling it is a lot
more complicated and ideal for a userspace library.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
