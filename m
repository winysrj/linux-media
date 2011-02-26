Return-path: <mchehab@pedra>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:39268 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1BZOOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 09:14:55 -0500
Received: by gwb15 with SMTP id 15so1608766gwb.10
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 06:14:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	<AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	<201102100847.15212.hverkuil@xs4all.nl>
	<201102171448.09063.laurent.pinchart@ideasonboard.com>
	<AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
	<1298578789.821.54.camel@deumeu>
	<AANLkTi=Twg-hzngyrpU_=o1yxQ3qVtiJf-Qhj--OubPu@mail.gmail.com>
Date: Sat, 26 Feb 2011 23:14:54 +0900
Message-ID: <AANLkTini7xuQ2kcrWbfGSUomdoPkLLJiik2soer8SL+X@mail.gmail.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Kyungmin Park <kmpark@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Edward Hervey <bilboed@gmail.com>, johan.mossberg.lml@gmail.com,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Feb 26, 2011 at 2:22 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/2/24 Edward Hervey <bilboed@gmail.com>:
>
>>  What *needs* to be solved is an API for data allocation/passing at the
>> kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
>> userspace (like GStreamer) can pass around, monitor and know about.
>
> I think the patches sent out from ST-Ericsson's Johan Mossberg to
> linux-mm for "HWMEM" (hardware memory) deals exactly with buffer
> passing, pinning of buffers and so on. The CMA (Contigous Memory
> Allocator) has been slightly modified to fit hand-in-glove with HWMEM,
> so CMA provides buffers, HWMEM pass them around.
>
> Johan, when you re-spin the HWMEM patchset, can you include
> linaro-dev and linux-media in the CC? I think there is *much* interest
> in this mechanism, people just don't know from the name what it
> really does. Maybe it should be called mediamem or something
> instead...

To Marek,

Can you also update the CMA status and plan?

The important thing is still Russell don't agree the CMA since it's
not solve the ARM different memory attribute mapping issue. Of course
there's no way to solve the ARM issue.

We really need the memory solution for multimedia.

Thank you,
Kyungmin Park


>
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
