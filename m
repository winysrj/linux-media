Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32902 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbbBDPCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 10:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+Yk1sDT+KfxRfR3ue74KtKxDB3Aj0BS2=sfYwzMcQtDw@mail.gmail.com>
References: <1421365163-29394-1-git-send-email-prabhakar.csengg@gmail.com> <CAL_Jsq+Yk1sDT+KfxRfR3ue74KtKxDB3Aj0BS2=sfYwzMcQtDw@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 4 Feb 2015 15:01:43 +0000
Message-ID: <CA+V-a8u4Zp8Ab4xkrG=+=fQkV8_RtGMiTuYbizyEAL8qbmafgQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: add support for omnivision's ov2659 sensor
To: Rob Herring <robherring2@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Grant Likely <grant.likely@linaro.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thanks for the review.

On Wed, Feb 4, 2015 at 2:55 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Thu, Jan 15, 2015 at 5:39 PM, Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> this patch adds support for omnivision's ov2659
>> sensor.
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>
> [...]
>
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index b1df0ad..153cd92 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -118,6 +118,7 @@ nvidia      NVIDIA
>>  nxp    NXP Semiconductors
>>  onnn   ON Semiconductor Corp.
>>  opencores      OpenCores.org
>> +ovt    OmniVision Technologies
>
> I'm surprised there are not already compatible strings with
> OmniVision. There are some examples using "omnivision", but no dts
> files and examples don't count.
>
> The stock ticker is ovti, so please use that.
>
OK will update in the v2 version, I went with website which was ovt [1].

[1] http://www.ovt.com/

Regards,
--Prabhakar Lad
