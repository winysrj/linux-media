Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39333 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FXFrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 01:47:31 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so2117787wiv.5
        for <linux-media@vger.kernel.org>; Sun, 23 Jun 2013 22:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19880516.7ZPIjvT6Bx@avalon>
References: <CACySJQX-GUYax5MPounyFCUczgncPx=SV=8O6ORd_zwfn31jkQ@mail.gmail.com>
	<19880516.7ZPIjvT6Bx@avalon>
Date: Mon, 24 Jun 2013 14:47:30 +0900
Message-ID: <CACySJQUvkv4+x5UborCRHs=V20bzx5r7A2zgvecEkvcb8kQhUA@mail.gmail.com>
Subject: Re: Mistake on the colorspace page in the API doc
From: Wouter Thielen <wouter@morannon.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry for the late reply. I'll post a patch of your revised version,
but I don't see the documentation anywhere in your git repositories. I
guess I'll download the file (preserving directory structure), update
it, and send you a diff -run. If this is not how it is done, please
let me know.

Regards,

Wouter


On Wed, Jun 19, 2013 at 5:58 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Wouter,
>
> On Sunday 26 May 2013 15:34:26 Wouter Thielen wrote:
>> Hi all,
>>
>> I have been trying to get the colors right in the images grabbed from my
>> webcam, and I tried the color conversion code on
>> http://linuxtv.org/downloads/v4l-dvb-apis/colorspaces.html.
>>
>> It turned out to be very white, so I checked out the intermediate steps,
>> and thought the part:
>>
>> ER = clamp (r * 255); /* [ok? one should prob. limit y1,pb,pr] */
>> EG = clamp (g * 255);
>> EB = clamp (b * 255);
>>
>>
>> should be without the * 255. I tried removing *255 and that worked.
>
> Good catch. I would instead do
>
> y1 = (Y1 - 16) / 219.0;
> pb = (Cb - 128) / 224.0;
> pr = (Cr - 128) / 224.0;
>
> and keep the E[RGB] lines unmodified to keep lower-case variables in the [0.0
> 1.0] or [-0.5 0.5] range.
>
> Would you like to post a patch for the documentation ? If not I can take care
> of it.
>
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Wouter Thielen
