Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37695 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab1HQQKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 12:10:43 -0400
Received: by pzk37 with SMTP id 37so1312816pzk.1
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 09:10:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108161953.40596.laurent.pinchart@ideasonboard.com>
References: <alpine.DEB.2.02.1108161255100.16286@ipanema>
	<201108161953.40596.laurent.pinchart@ideasonboard.com>
Date: Wed, 17 Aug 2011 16:10:42 +0000
Message-ID: <CABYn4swqs=L+OR8x8MGndPmfaDNMp+HT+Y7Wt_CYsymBbCEHJA@mail.gmail.com>
Subject: Re: [PATCH] media: Added extensive feature set to the OV5642 camera driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/16 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Tuesday 16 August 2011 14:58:58 Bastian Hecht wrote:
>> The driver now supports arbitray resolutions (width up to 2592, height
>> up to 720), automatic/manual gain, automatic/manual white balance,
>> automatic/manual exposure control, vertical flip, brightness control,
>> contrast control and saturation control. Additionally the following
>> effects are available now: rotating the hue in the colorspace, gray
>> scale image and solarize effect.
>
> That's a big patch, thus quite hard to review. What about splitting it in one
> patch per feature (or group of features, at least separating format
> configuration and controls) ? :-)

Hello Laurent,

I have reposted the my code split into 2 patches. The first with
changes related to
the image sizes and the other with all the controls. I hope that this
separation makes
it easy enough to review it. If not, tell me and I can split it up further.
Thanks for reviewing,

 Bastian Hecht


> --
> Regards,
>
> Laurent Pinchart
>
