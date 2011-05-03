Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:34892 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1ECNUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 09:20:09 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: vipul kumar samar <vipulkumar.samar@st.com>
Subject: Re: Query: Implementation of overlay on linux
Date: Tue, 3 May 2011 15:20:10 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com
References: <4DBE8FDB.5010506@st.com> <201105021520.22842.hansverk@cisco.com> <4DBFEEBA.4010005@st.com>
In-Reply-To: <4DBFEEBA.4010005@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031520.10841.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, May 03, 2011 14:02:02 vipul kumar samar wrote:
> Hello,
> On 05/02/2011 06:50 PM, Hans Verkuil wrote:
> > On Monday, May 02, 2011 13:04:59 vipul kumar samar wrote:
> >> Hello,
> >>
> >> I am working on LCD module and I want to implement two overlay windows
> >> on frame buffer. I have some queries related to this:
> >
> > You mean capture overlay windows? E.g. you want to capture from a video 
input
> > and have the video directly rendered in the framebuffer?
> >
> 
> Our LCD driver is developed on frame buffer interface.Now i want to 
> implement 2 overlay window support on the same driver.I saw the solution 
> of frame buffer emulator provided on mailing list. But i am little bit 
> confused.

So am I :-)

> My understanding is Frame buffer emulator provides a wrapper over V4L2 
> framework based driver and provide a single buffer solution.

Right.

> But my 
> condition is reverse i want to use V4L2 over frame buffer.
> 
> Is it fruit full to rearrange frame buffer based driver in v4l2 
> framework and then implement overlay support over it??
> Is there any simple way to use V4L2 frame work over frame buffer??

I still don't really understand what you want to do. You have a framebuffer,
and you want to display video in the framebuffer? Or do you want to mix a
framebuffer and a video output stream?

A block diagram of your hardware may help.

Regards,

          Hans

> 
> Thanks and Regards
> Vipul Samar
> 
> 
> > The "Video Overlay Interface" section in the V4L2 specification describes 
how
> > to do that, but it also depends on whether the V4L2 driver in question
> > supports that feature.
> >
> > It might be that you mean something else, though.
> >
> > Regards,
> >
> > 	Hans
> >
> >> 1. Can any body suggest me how to proceed towards it??
> >> 2. Is their any standard way to use frame buffer ioctl calls??
> >> 3. If i have to define my own ioctls then how application manage it??
> >>
> >>
> >> Thanks and Regards
> >> Vipul Samar
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> > .
> >
> 
> 
