Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:48803 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0IIH65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 03:58:57 -0400
Subject: Re: [PATCH v9 1/4] V4L2: Add seek spacing and FM RX class.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <4C87D782.4030604@redhat.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1283168302-19111-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <4C87D782.4030604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 10:57:28 +0300
Message-ID: <1284019048.26985.297.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello.

And thanks for the comments.

On Wed, 2010-09-08 at 20:35 +0200, ext Mauro Carvalho 
> >  	}
> > @@ -386,6 +394,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-emphasis settings";
> >  	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
> >  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
> > +	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Tuner Controls";
> 
> > +	case V4L2_CID_FM_BAND:			return "FM Band";
> 
> 
> There's no need for a FM control, as there's already an ioctl pair that allows get/set the frequency
> bandwidth: VIDIOC_S_TUNER and VIDIOC_G_TUNER. So, the entire patch here seems uneeded/unwanted.

Sometime ago Hans said the following in his comment to v5 patches:

> Based on this article: 
> http://en.wikipedia.org/wiki/FM_broadcasting, there
> seem to be only three bands for FM radio in
> practice: 87.5-108, 76-90 (Japan)
> and 65-74 (former Soviet republics, some former
> eastern bloc countries).
>
> So this should be a standard control. Since the
> latter band is being phased
> out I think a menu control with just the two other
> bands is sufficient.
>
> And I also think this should be a control of a new
> FM_RX class.
>
> I know, that's not what I said last time. So sue 
> me :-)

But if we now have a consensus when we are at v9 that's good news...

Thanks,
Matti

