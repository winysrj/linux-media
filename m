Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4702 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZEBORe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 10:17:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Julia Lawall <julia@diku.dk>
Subject: Re: tvaudio.c: possible problem with V4L2_TUNER_MODE_MONO
Date: Sat, 2 May 2009 16:17:16 +0200
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0905021518250.9563@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0905021518250.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905021617.16995.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 02 May 2009 15:19:03 Julia Lawall wrote:
> The file drivers/media/video/tvaudio.c contains the following code:
>
> (starting at line 1257 in a recent linux-next)
>
> 		if (mode & V4L2_TUNER_MODE_MONO)
> 			s1 |= TDA8425_S1_STEREO_MONO;
> 		if (mode & V4L2_TUNER_MODE_STEREO)
> 			s1 |= TDA8425_S1_STEREO_SPATIAL;
>
> (starting at line 1856 in a recent linux-next)
>
> 	if (mode & V4L2_TUNER_MODE_MONO)
> 		vt->rxsubchans |= V4L2_TUNER_SUB_MONO;
> 	if (mode & V4L2_TUNER_MODE_STEREO)
> 		vt->rxsubchans |= V4L2_TUNER_SUB_STEREO;
>
> The only possible value of V4L2_TUNER_MODE_MONO, however, seems to be 0,
> as defined in include/linux/videodev2.h, and thus the first test in each
> case is never true.  Is this what is intended, or should the tests be
> expressed in another way?

Hi Julia,

Nope, this isn't intended. A grep over the v4l sources shows that it is 
handled incorrectly in several other drivers as well. I'll prepare patches 
to fix all these drivers.

Thanks,

	Hans

>
> julia
>
> This problem was found using the following semantic match:
> (http://www.emn.fr/x-info/coccinelle/)
>
> @r expression@
> identifier C;
> expression E;
> position p;
> @@
>
> (
>  E & C@p && ...
>
>  E & C@p || ...
> )
>
> @s@
> identifier r.C;
> position p1;
> @@
>
> #define C 0
>
> @t@
> identifier r.C;
> expression E != 0;
> @@
>
> #define C E
>
> @script:python depends on s && !t@
> p << r.p;
> C << r.C;
> @@
>
> cocci.print_main("and with 0", p)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
