Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4358 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3DWGp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 02:45:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFCv3 08/10] [media] tuner-core: store tuner ranges at tuner struct
Date: Tue, 23 Apr 2013 08:45:45 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <201304220922.18022.hverkuil@xs4all.nl> <51752949.8000901@redhat.com>
In-Reply-To: <51752949.8000901@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304230845.45209.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, April 22, 2013 14:12:57 Mauro Carvalho Chehab wrote:
> Em 22-04-2013 04:22, Hans Verkuil escreveu:
> > On Sun April 21 2013 21:00:37 Mauro Carvalho Chehab wrote:
> >> Instead of using global values for tuner ranges, store them
> >> internally. That fixes the need of using a different range
> >> for SDR radio, and will help to latter add a tuner ops to
> >> retrieve the tuner range for SDR mode.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> ---
> >>   drivers/media/v4l2-core/tuner-core.c | 59 ++++++++++++++++++++++--------------
> >>   1 file changed, 37 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> >> index e54b5ae..abdcda4 100644
> >> --- a/drivers/media/v4l2-core/tuner-core.c
> >> +++ b/drivers/media/v4l2-core/tuner-core.c
> >> @@ -67,8 +67,8 @@ static char secam[] = "--";
> >>   static char ntsc[] = "-";
> >>
> >>   module_param_named(debug, tuner_debug, int, 0644);
> >> -module_param_array(tv_range, int, NULL, 0644);
> >> -module_param_array(radio_range, int, NULL, 0644);
> >> +module_param_array(tv_range, int, NULL, 0444);
> >> +module_param_array(radio_range, int, NULL, 0444);
> >
> > Shouldn't we add a sdr_range here as well?
> 
> I don't think it is needed to have a modprobe parameter for that.
> If user wants to change the range, VIDIOC_S_TUNER can be used.

You can't change the range using S_TUNER, it's not a settable field.

> 
> Btw, I was tempted to even remove those ;)

I'd either remove them or add an sdr_range rather than leaving it in
an inconsistent state.

Regards,

	Hans
