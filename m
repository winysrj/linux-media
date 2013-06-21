Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48344 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161254Ab3FUM1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 08:27:50 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so550158wiv.9
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 05:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8uUEcoh2bbpUP=Oo8Pj-1yX8VWS7z9m_kOgyzxfMwQ-Ow@mail.gmail.com>
References: <1371306876-8596-1-git-send-email-lars@metafoo.de> <CA+V-a8uUEcoh2bbpUP=Oo8Pj-1yX8VWS7z9m_kOgyzxfMwQ-Ow@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 21 Jun 2013 17:57:29 +0530
Message-ID: <CA+V-a8tgrLgeuQ83eRQkW6OeyBvCYzRD5k4xjnPwdne7hbCuWQ@mail.gmail.com>
Subject: Re: [PATCH] [media] tvp514x: Fix init seqeunce
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

On Sun, Jun 16, 2013 at 3:41 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Lars-Peter,
>
> Thanks for the patch.
>
> On Sat, Jun 15, 2013 at 8:04 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> client->driver->id_table will always point to the first entry in the device id
>> table. So all devices will use the same init sequence. Use the id table entry
>> that gets passed to the driver's probe() function to get the right init
>> sequence.
>>
> The patch looks OK, but it causes following two warnings,
>
> drivers/media/i2c/tvp514x.c: In function 'tvp514x_s_stream':
> drivers/media/i2c/tvp514x.c:868: warning: unused variable 'client'
> drivers/media/i2c/tvp514x.c: In function 'tvp514x_probe':
> drivers/media/i2c/tvp514x.c:1092: warning: assignment makes pointer
> from integer without a cast
>
Do you plan to post a v2 ? or shall I take care of it ?

Regards,
--Prabhakar Lad
