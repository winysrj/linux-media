Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2469 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbZKEOFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 09:05:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sigmund Augdal <sigmund@snap.tv>
Subject: Re: [PATCH] output human readable form of the .status field from  VIDIOC_ENUMINPUT
Date: Thu, 5 Nov 2009 15:05:29 +0100
Cc: linux-media@vger.kernel.org
References: <aaaa95950910210632p74179cv91aa9825eff8d6bd@mail.gmail.com> <aaaa95950910230035o4c07c955jbbe74a80f79d6d69@mail.gmail.com> <aaaa95950910230638p28399b5dld4cbbb44e3c19c32@mail.gmail.com>
In-Reply-To: <aaaa95950910230638p28399b5dld4cbbb44e3c19c32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911051505.29959.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 October 2009 15:38:03 Sigmund Augdal wrote:
> On Fri, Oct 23, 2009 at 9:35 AM, Sigmund Augdal <sigmund@snap.tv> wrote:
> > On Fri, Oct 23, 2009 at 12:10 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >>> The attach patch modifies v4l2-ctl -I to also output signal status as
> >>> detected by the driver/hardware. This info is available in the status
> >>> field of the data returned by VIDIOC_ENUMINPUT which v4l2-ctl -I
> >>> already calls. The strings are copied from the v4l2 api specification
> >>> and could perhaps be modified a bit to fit the application.
> >>>
> >>> Best regards
> >>>
> >>> Sigmund Augdal
> >>>
> >>
> >> Hi Sigmund,
> >>
> >> This doesn't work right: the status field is a bitmask, so multiple bits
> >> can be set at the same time. So a switch is not the right choice for that.
> >> Look at some of the other functions to print bitmasks in v4l2-ctl.cpp for
> >> ideas on how to implement this properly.
> >>
> >> But it will be nice to have this in v4l2-ctl!
> > Right, I realized this shortly after sending. I'll take a look at this
> > today. However, I'm unsure how to handle the value 0. It seems this is
> > used both for "signal detected and everything is ok" and "driver has
> > no clue if there is a signal or not". Any feedback welcome.
> 
> And again, this time with the attachment.

Hi Sigmund,

Thanks for these patches. I've added them to my v4l-dvb tree and will post a
pull request for them soon.

I did some cleanup of the enuminput code as it was a bit inconsistent with
other parts of the v4l2-ctl code and I took the opportunity to improve the
printing of the std field in enum_input/output.

Regards,

	Hans

> 
> Best regards
> 
> Sigmund Augdal
> >
> > Best regards
> >
> > Sigmund Augdal
> >>
> >> Regards,
> >>
> >>      Hans
> >>
> >> --
> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> >>
> >>
> >
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
