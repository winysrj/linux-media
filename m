Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33175 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbcCBR0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 12:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <56D4475A.1070203@xs4all.nl>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
	<56D4475A.1070203@xs4all.nl>
Date: Thu, 3 Mar 2016 02:26:41 +0900
Message-ID: <CAH1o70KLcLAK4GCN-PYmrggHoXFB-9bRiCF73M-0YL5griaweg@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] media: soc_camera: rcar_vin: Add UDS and NV16
 scaling support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2016-02-29 22:27 GMT+09:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Huh, you must have missed Niklas's work the rcar-vin driver:
>
> http://www.spinics.net/lists/linux-media/msg97816.html
>
> I expect that the old soc-camera driver will be retired soon in favor of
> the new driver, so I don't want to accept patches for that one.
>
> I recommend that you check the new driver and see what (if anything) is needed
> to get this functionality in there and work with Niklas on this.
>
> This is all quite recent work, so it is not surprising that you missed it.

Thank you for informing me!
I will check it.

>
> Regards,
>
>         Hans

Regards,
kaneko

>
> On 02/29/2016 02:12 PM, Yoshihiro Kaneko wrote:
>> This series adds UDS support, NV16 scaling support and callback functions
>> to be required by a clipping process.
>>
>> This series is against the master branch of linuxtv.org/media_tree.git.
>>
>> Koji Matsuoka (3):
>>   media: soc_camera: rcar_vin: Add get_selection callback function
>>   media: soc_camera: rcar_vin: Add cropcap callback function
>>   media: soc_camera: rcar_vin: Add NV16 scaling support
>>
>> Yoshihiko Mori (1):
>>   media: soc_camera: rcar_vin: Add UDS support
>>
>>  drivers/media/platform/soc_camera/rcar_vin.c | 220 ++++++++++++++++++++++-----
>>  1 file changed, 184 insertions(+), 36 deletions(-)
>>
>
