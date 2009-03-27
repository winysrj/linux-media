Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:51816 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758939AbZC0QRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:17:53 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: how about adding FOCUS mode?
Date: Fri, 27 Mar 2009 17:19:00 +0100
Cc: "Kim, Heung Jun" <riverful@gmail.com>, bill@thedirks.org,
	linux-media@vger.kernel.org
References: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com> <200903270824.28092.hverkuil@xs4all.nl>
In-Reply-To: <200903270824.28092.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271719.00404.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 27 March 2009 08:24:27 Hans Verkuil wrote:
> On Friday 27 March 2009 07:20:51 Kim, Heung Jun wrote:
> > Hello, Hans & everyone.
> >
> > I'm trying to adapt the various FOCUS MODE int the NEC ISP driver.
> > NEC ISP supports 4 focus mode, AUTO/MACRO/MANUAL/FULL or NORMAL.
> > but, i think that it's a little insufficient to use V4L2 FOCUS Feature.
> >
> > so, suggest that,
> >
> > - change V4L2_CID_FOCUS_AUTO's type from boolean to interger, and add
> > the following enumerations for CID values.
> >
> > enum v4l2_focus_mode {
> >     V4L2_FOCUS_AUTO            = 0,
> >     V4L2_FOCUS_MACRO        = 1,
> >     V4L2_FOCUS_MANUAL        = 2,
> >     V4L2_FOCUS_NORMAL        = 3,
> >     V4L2_FOCUS_LASTP        = 3,
> > };
> >
> > how about this usage? i wanna get some advice about FOCUS MODE.

V4L2_CID_FOCUS_AUTO is meant to change the auto-focus mode. Can you describe 
FOCUS_MACRO and FOCUS_NORMAL in more details ? Are they auto-focus modes or 
just focus presets ?

> This seems more logical to me:
>
> enum v4l2_focus_mode {
>     V4L2_FOCUS_MANUAL = 0,
>     V4L2_FOCUS_AUTO_NORMAL = 1,
>     V4L2_FOCUS_AUTO_MACRO = 2,
> };
>
> At least this maps the current boolean values correctly. I'm not sure from
> your decription what the fourth auto focus mode is supposed to be.

Does an auto-macro focus mode really exists ?

> But I think it might be better to have a separate control that allows you
> to set the auto-focus mode. I can imagine that different devices might have
> different auto-focus modes.
>
> I've CC-ed Laurent since this is more his field than mine.

Regards,

Laurent Pinchart

