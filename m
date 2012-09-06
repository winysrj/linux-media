Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2IFEJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 00:09:45 -0400
Received: by dady13 with SMTP id y13so816498dad.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 21:09:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201209051028.30258.hverkuil@xs4all.nl>
References: <20120713173708.GB17109@thunk.org>
	<201208061535.59616.hverkuil@xs4all.nl>
	<CAGA24MKVVfT7BDGus+spj9CZWctS1YLdvOM5eWOGBdgeGqmnHw@mail.gmail.com>
	<201209051028.30258.hverkuil@xs4all.nl>
Date: Thu, 6 Sep 2012 12:09:44 +0800
Message-ID: <CAGA24MKyr_N2Upns9FaZ9Q+Yegs0DDeHVfm_EWZQQN=Auky8Ow@mail.gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
From: Jun Nie <niej0001@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: workshop-2011@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/9/5 Hans Verkuil <hverkuil@xs4all.nl>:
> On Wed 5 September 2012 10:04:41 Jun Nie wrote:
>> Is there any summary for this summit or presentation material? I am
>> looking forward for some idea on CEC. It is really complex in
>> functionality.
>> Maybe other guys is expecting simiar fruite from summit too.
>
> Yes, there will be a summit report. It's not quite finished yet, I think.
>
> With respect to CEC we had some useful discussions. It will have to be a
> new class of device (/dev/cecX), so the userspace API will be separate from
> drm or v4l.
>
> And the kernel will have to take care of the core CEC protocol w.r.t. control
> and discovery due to the HDMI 1.4a requirements.
>
> I plan on starting work on this within 1-2 weeks.
>
> My CEC presentation can be found here:
>
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-cec.odp
>
> Regards,
>
>         Hans

Thanks for quick response! It's good to know that CEC is independent
with DRM/V4L for my HDMI implementation is FB/lcd-device based. CEC is
also deserved to have independent management in both hardware signal
and functionality. Someone also expressed similar thoughts before.
Will remote control protocal parsing are done in userspace reference
library? Or not decided yet?

B.R.
Jun
