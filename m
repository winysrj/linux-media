Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58784 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQGoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 02:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141017060248.GA7166@verge.net.au>
References: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
	<Pine.LNX.4.64.1410162222550.16927@axis700.grange>
	<20141017060248.GA7166@verge.net.au>
Date: Fri, 17 Oct 2014 15:44:34 +0900
Message-ID: <CAH1o70+s4xTfQKbBRCRdgHibAWG5NTBP-PnhVqotB_HLpSBbGQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] media: soc_camera: rcar_vin: Add r8a7794, r8a7793
 device support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-10-17 15:02 GMT+09:00 Simon Horman <horms@verge.net.au>:
> Hi Guennadi,
>
> On Thu, Oct 16, 2014 at 10:27:13PM +0200, Guennadi Liakhovetski wrote:
>> Hello,
>>
>> Thanks for the patches. Could you please fold these two into one - they
>> really don't deserve to be separated.
>
> Thanks. Kaneko-san could you squash these patches and repost?

Sure, will do.

>
>> As for your other series - patches
>> there look mostly good - from just a formal review. If you don't mind,
>> I'll adjust a couple of cosmetic issues like missing curly braces in
>>
>>       if (a)
>>               x();
>>       else {
>>               y();
>>               z();
>>       }
>>
>> or multiline comments or similar minor things.
>
> Feel free to make any minor updates.
>
>> Thanks
>> Guennadi
>>
>> On Tue, 14 Oct 2014, Yoshihiro Kaneko wrote:
>>
>> > This series is against master branch of linuxtv.org/media_tree.git.
>> >
>> > Koji Matsuoka (2):
>> >   media: soc_camera: rcar_vin: Add r8a7794 device support
>> >   media: soc_camera: rcar_vin: Add r8a7793 device support
>> >
>> >  drivers/media/platform/soc_camera/rcar_vin.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > --
>> > 1.9.1
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
