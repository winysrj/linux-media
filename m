Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:4780 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbZDQH3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:29:33 -0400
Received: by wf-out-1314.google.com with SMTP id 29so790506wff.4
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 00:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Date: Fri, 17 Apr 2009 16:29:30 +0900
Message-ID: <5e9665e10904170029g56c0be23i9116c28b4a723314@mail.gmail.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've got one more thing to ask.
Is SoC camera framework supporting for selecting video standards
between camera interface and external camera module? I mean ITU-R BT
601 and 656 things.
Or any different way that I'm not aware is supported?

On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> This patch series is a preparation for the v4l2-subdev conversion. Please,
> review and test. My current patch-stack in the form of a
> (manually-created) quilt-series is at
> http://www.open-technology.de/download/20090415/ based on linux-next
> history branch, commit ID in 0000-base file. Don't be surprised, that
> patch-set also contains a few not directly related patches.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
