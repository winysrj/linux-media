Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:36545 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZHSLgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 07:36:42 -0400
Received: by qyk34 with SMTP id 34so3224345qyk.33
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2009 04:36:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908171040310.4449@axis700.grange>
References: <Pine.LNX.4.64.0908171040310.4449@axis700.grange>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Wed, 19 Aug 2009 20:36:23 +0900
Message-ID: <5e9665e10908190436y41dc2fecl203e09114a429f1d@mail.gmail.com>
Subject: Re: [Q] sensors, corrupting the top line
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 17, 2009 at 7:09 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> Hi Hans, all
>
> In soc-camera since its first version we have a parameter "y_skip_top",
> which the sensor uses to tell the host (bridge) driver "I am sending you
> that many lines more than what is requested, and you should drop those
> lines from the top of the image." I never investigated this in detail,
> originally this was a "strong tip" that the top line is always corrupted.
> Now I did investigate it a bit by setting this parameter to 0 and looking
> what the sensors actually produce. I am working with four sensor: mt9m001,
> mt9v022, mt9t031 and ov7725, of which only the first two had that
> parameter set to 1 from the beginning, the others didn't have it and also
> showed no signs of a problem. mt9m001 (monochrome) doesn't have the
> problem either, but mt9v022 does. It does indeed deliver the first line
> with "randomly" coloured pixels. Notice - this is not the top line of the
> sensor, this is the first read-out line, independent of the cropping
> position. So, it seems we do indeed need a way to handle such sensors. Do
> you have a suggestion for a meaningful v4l2-subdev API for this?
>

Yep I also went through similar cases and I just skipped corrupted
lines. That happens in various sensor devices isn't it? Moreover, we
sometimes have whole corrupted image frames which are due to
stabilization issue when we initialize the sensor device. In this case
I decide to drop corresponding image frames with enough number.(3
frames enough in my experience).

So, how about making an API which can cover all over these phonomenum?
which can drop or skip line and frames. Host (bridge) queries through
the API and get how many lines should skip or how many frames should
drop or something like that.. Sounds fair to make an API which can
cover general H/W defects or characteristics (even though that is not
a defect)
Cheers,

Nate


-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
