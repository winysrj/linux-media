Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1299 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZC0HYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 03:24:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Kim, Heung Jun" <riverful@gmail.com>
Subject: Re: how about adding FOCUS mode?
Date: Fri, 27 Mar 2009 08:24:27 +0100
Cc: bill@thedirks.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@skynet.be>
References: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com>
In-Reply-To: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903270824.28092.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 March 2009 07:20:51 Kim, Heung Jun wrote:
> Hello, Hans & everyone.
>
> I'm trying to adapt the various FOCUS MODE int the NEC ISP driver.
> NEC ISP supports 4 focus mode, AUTO/MACRO/MANUAL/FULL or NORMAL.
> but, i think that it's a little insufficient to use V4L2 FOCUS Feature.
>
> so, suggest that,
>
> - change V4L2_CID_FOCUS_AUTO's type from boolean to interger, and add
> the following enumerations for CID values.
>
> enum v4l2_focus_mode {
>     V4L2_FOCUS_AUTO            = 0,
>     V4L2_FOCUS_MACRO        = 1,
>     V4L2_FOCUS_MANUAL        = 2,
>     V4L2_FOCUS_NORMAL        = 3,
>     V4L2_FOCUS_LASTP        = 3,
> };
>
> how about this usage? i wanna get some advice about FOCUS MODE.

This seems more logical to me:

enum v4l2_focus_mode {
    V4L2_FOCUS_MANUAL = 0,
    V4L2_FOCUS_AUTO_NORMAL = 1,
    V4L2_FOCUS_AUTO_MACRO = 2,
};

At least this maps the current boolean values correctly. I'm not sure from 
your decription what the fourth auto focus mode is supposed to be.

But I think it might be better to have a separate control that allows you to 
set the auto-focus mode. I can imagine that different devices might have 
different auto-focus modes.

I've CC-ed Laurent since this is more his field than mine.

Regards,

	Hans

>
> Thanks,
> Riverful



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
