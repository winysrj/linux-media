Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2HAYYQT010205
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 06:34:34 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2HAY2AE007509
	for <video4linux-list@redhat.com>; Mon, 17 Mar 2008 06:34:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frej Drejhammar <frej.drejhammar@gmail.com>
Date: Mon, 17 Mar 2008 11:33:58 +0100
References: <patchbomb.1205671781@liva.fdsoft.se>
	<Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
	<k1w6a2xdk.fsf@liva.fdsoft.se>
In-Reply-To: <k1w6a2xdk.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171133.58855.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features.
	Version 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sunday 16 March 2008 22:05, Frej Drejhammar wrote:
> Trent,
>
> > One of the things you should do it make the control inactive when
> > in SECAM mode.  V4L2 has a flag to indicate controls that don't
> > apply to the device's current mode.
>
> I guess it is the V4L2_CTRL_FLAG_INACTIVE flag (in the flag field of
> struct v4l2_queryctrl) you are referring to, correct?
>
> > CAGC makes a difference for me too.  Some of my channels are over
> > saturated and some are under saturated and CAGC fixes them.  I
> > don't recall if I posted pictures last time CAGC came up, but it
> > really does make a difference.
>
> Good that I'm not the only one who wants/needs it :)
>z
> > I haven't ever been able to notice an effect from color killer.
> > Maybe if you had poor reception from a B&W source?  Not much black
> > and white on broadcast TV these days.
>
> So maybe I should just skip the color killer then...
>
> >> A quick grep shows that the bttv-driver also exposes chroma AGC as
> >> a private control. Cx2584x has chroma AGC enabled by default.
> >> Maybe the right thing to do is to enable chroma AGC by default for
> >> PAL and NTSC?  Chroma AGC is something you'll find on most VCRs
> >> and TVs, and then it is on by default.
> >
> > That's what I would do.  Have a standard control for CAGC and turn
> > it on by default.
>
> Then that's what I'll do. Expect a revised version of the patch which
> enables CAGC by default for PAL+NTSC and implements the
> V4L2_CTRL_FLAG_INACTIVE by the end of the week.
>
> > If I wanted to be told I wasn't worthy to use my hardware, I'd run
> > windows!
>
> Hear, hear! :)

That's not quite what I meant. I'm responsible of all the MPEG controls, 
so I'm definitely all for exposing hardware features to the user :-)

What I want to prevent is adding controls as a workaround for what might 
be a driver bug. So in this case I wonder whether chroma AGC shouldn't 
be enabled in the cx88 driver as it is for cx2584x.

Looking at the cx25840 datasheet it basically says that it should always 
be enabled except for component input (YPrPb) or SECAM. So I would 
suggest doing the same in cx88 rather than adding a control. Only if 
there are cases where Chroma AGC harms the picture quality rather than 
improves it, then the addition of a control might become important.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
