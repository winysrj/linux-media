Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2H1fFBw005863
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:41:15 -0400
Received: from mail7.sea5.speakeasy.net (mail7.sea5.speakeasy.net
	[69.17.117.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2H1ehnC032424
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:40:44 -0400
Date: Sun, 16 Mar 2008 18:40:38 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jelle Foks <jelle@foks.us>
In-Reply-To: <47DDB7A7.6000400@foks.us>
Message-ID: <Pine.LNX.4.58.0803161831110.20723@shell4.speakeasy.net>
References: <patchbomb.1205671781@liva.fdsoft.se>
	<200803161442.37610.hverkuil@xs4all.nl>
	<kod9eemd4.fsf@liva.fdsoft.se>
	<Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
	<47DDB7A7.6000400@foks.us>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Frej Drejhammar <frej.drejhammar@gmail.com>, video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features. Version
 2
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

On Sun, 16 Mar 2008, Jelle Foks wrote:

> Trent Piepho wrote:
>
> >> color killer does not make a very large impact for black and white
> >> material (the only time it is needed), frankly I'm not sure if its not
> >> just the placebo effect. I can live without color killer but
> >> definitely not without chroma AGC.
> >
> > I haven't ever been able to notice an effect from color killer.  Maybe if
> > you had poor reception from a B&W source?  Not much black and white on
> > broadcast TV these days.
>
> I would think that a chip configuration called 'color killer' will make
> the full channel bandwidth (~5MHz) available for the luma, while without
> it, the upper 1.5MHz or so is used for the chroma signal.

That's not what it does:
    If a color-burst of 25 (NTSC) or 35 (PAL/SECAM) percent or less of the
    nominal amplitude is detected for 127 consecutive scan lines, the
    color-difference signals U and V are set to 0.  When the low color
    detection is active, the reduced chrominance signal is still separated
    from the composite signal to generate the luminance portion of the
    signal.  The resulting Cr and Cb values are 128.  Output of the
    chrominance signal is re-enabled when a color-burst of 43 (NTSC) or 60
    (PAL/SECAM) percent or greater of nominal amplitude is detected for 127
    consecutive scan lines.  Low color detection and removal may be
    disabled.

I think it's when you have poor reception and can't decode the color
signal, which is in the upper part of the band.  Rather than decode garbage
color, it just turns color off.  Or maybe it's for avoiding adding spurious
color when you have a B&W signal?  I've never been able to get it to do
anything I could notice.

> When using a higher-quality B&W camera on a composite input, you will
> probably be able to see an improved sharpness in the picture with such a
> 'color killer' switched on.

Getting the full luma bandwidth would be achieved by turning off the luma
notch filter, which should be done already for s-video sources.  It might
not be a bad idea to have a control to allow this for composite signals,
like B&W surveillance cams.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
