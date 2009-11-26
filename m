Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:48223 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954AbZKZHof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 02:44:35 -0500
Received: by ywh12 with SMTP id 12so538555ywh.21
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 23:44:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <uljhunm76.wl%morimoto.kuninori@renesas.com>
References: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
	 <aec7e5c30911250310m46442ff7r5bd0c745a0ad9f42@mail.gmail.com>
	 <uljhunm76.wl%morimoto.kuninori@renesas.com>
Date: Thu, 26 Nov 2009 16:44:41 +0900
Message-ID: <aec7e5c30911252344y11001bb4nad17914749bd7904@mail.gmail.com>
Subject: Re: [PATCH] soc-camera: Add mt9t112 camera support
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Guennadi <g.liakhovetski@gmx.de>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Morimoto-san,

On Thu, Nov 26, 2009 at 9:50 AM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
>> Do you have any mt9t112 platform data for the ecovec board? I'd like
>> to try out this patch but I don't know which board specific parts that
>> are missing!
>
> Yes I have.
> I attached it.
> This platform patch is based on Guennadi's latest patches.
>
> I also attached tw9910 platform patch.
> Please apply in order of tw9910 -> mt9t112.

Thanks for the patches.

So now I've done some testing of the mt9t112 sensor hooked up to CEU0
on the ecovec board. I tried 16-bit RGB and NV12 in various
resolutions with mplayer. My only comment is that it seems to take a
bit of time to setup the sensor initially, but that may be something
related to the camera sensor itself.

Cheers,

/ magnus
