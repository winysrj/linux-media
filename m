Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60131 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0JXOmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 10:42:12 -0400
Received: by bwz11 with SMTP id 11so1723153bwz.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 07:42:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik_idAA9gmKSEvCXfQ=MP2Oe0gSi=PrUKqyoOMZ@mail.gmail.com>
References: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
	<AANLkTik_idAA9gmKSEvCXfQ=MP2Oe0gSi=PrUKqyoOMZ@mail.gmail.com>
Date: Sun, 24 Oct 2010 10:42:10 -0400
Message-ID: <AANLkTimGJguc96H+wF0+z-6uCAh67WEGyT3aGad2gZrp@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings.
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: mats.randgaard@tandberg.com
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org,
	hans.verkuil@tandberg.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for the patch!

On Sun, Oct 24, 2010 at 9:38 AM, Muralidharan Karicheri
<mkaricheri@gmail.com> wrote:
>
> On Fri, Oct 22, 2010 at 3:00 AM, <mats.randgaard@tandberg.com> wrote:
>>
>> From: Mats Randgaard <mats.randgaard@tandberg.com>
>>
>> Support for DV preset and timings added to vpif_capture and vpif_display drivers.
>> Functions for debugging are added and the code is improved as well.
>>
>> Mats Randgaard (5):
>>  vpif_cap/disp: Add debug functionality
>>  vpif: Move and extend ch_params[]
>>  vpif_cap/disp: Added support for DV presets
>>  vpif_cap/disp: Added support for DV timings
>>  vpif_cap/disp: Cleanup, improved comments
>>
>>  drivers/media/video/davinci/vpif.c         |  178 +++++++++++++
>>  drivers/media/video/davinci/vpif.h         |   18 +-
>>  drivers/media/video/davinci/vpif_capture.c |  380 ++++++++++++++++++++++++++--
>>  drivers/media/video/davinci/vpif_capture.h |    2 +
>>  drivers/media/video/davinci/vpif_display.c |  370 +++++++++++++++++++++++++--
>>  drivers/media/video/davinci/vpif_display.h |    2 +
>>  6 files changed, 893 insertions(+), 57 deletions(-)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Thanks for the patch!
>
> --
> Murali Karicheri
> mkaricheri@gmail.com



--
Murali Karicheri
mkaricheri@gmail.com
