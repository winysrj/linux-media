Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36104 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1E0GTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 02:19:17 -0400
Received: by gyd10 with SMTP id 10so577573gyd.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 23:19:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105180817420.21439@axis700.grange>
References: <BANLkTiko27NWjPx6sT0o7NEYSY2RLsX=_Q@mail.gmail.com>
	<Pine.LNX.4.64.1105180817420.21439@axis700.grange>
Date: Fri, 27 May 2011 14:19:16 +0800
Message-ID: <BANLkTi=arAUPN=G+shcBEZ+N6+ZyaYTh-A@mail.gmail.com>
Subject: Re: pxa ccic driver based on soc_camera and videobuf
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, qingx@marvell.com,
	ygli@marvell.com, leiwen@marvell.com, hzhuang1@marvell.com,
	jwan@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi, Guennadi:

       thanks for your comments.
       I converted it to videobuf2 and send it out in another thread.
       [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC

       would you please review ? thanks



2011/5/18 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi Kassey
>
> On Wed, 18 May 2011, Kassey Lee wrote:
>
>> hi, Guennadi, Hans:
>>
>>       I just converted  Marvell CCIC driver from ccic_cafe to
>> soc_camera + videobuf, and make it stable and robust.
>
> Nice!
>
>>       do you accept the soc_camera + videobuf to the latest kernel ?
>
> My understanding is, that since videobuf2 is really an improved videobuf,
> the latter shall be deprecated and removed in some time, after all
> existing drivers are converted, so, there is no point in developing new
> drivers with videobuf. That said, the conversion is not very difficult,
> so, please, either do it yourself (preferred;)), or post your driver as is
> and we'll help you convert it.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
