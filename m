Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35642 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2HFP2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 11:28:35 -0400
Received: by lagy9 with SMTP id y9so806277lag.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 08:28:32 -0700 (PDT)
Message-ID: <501FE29D.7040303@gmail.com>
Date: Mon, 06 Aug 2012 17:28:29 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] Some additional az6007 cleanup patches
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab skrev 2012-08-05 19:44:
> Those are mostly cleanup patches. With regards to suspend/resume,
> this is not working properly yet. I suspect that it is due to the lack
> of dvb-usb-v2 support for reset_resume. So, document it.
>
> Mauro Carvalho Chehab (3):
>    [media] az6007: rename "st" to "state" at az6007_power_ctrl()
>    [media] az6007: make all functions static
>    [media] az6007: handle CI during suspend/resume
>
>   drivers/media/dvb/dvb-usb-v2/az6007.c | 37 +++++++++++++++++++++++++++--------
>   1 file changed, 29 insertions(+), 8 deletions(-)
>

Will all the latest patches also fix the problem with not being able to 
tune to a new encrypted channel? (Terratec H7, DVB-C. Can watch an 
encrypted channel i Kaffeine but not tune to another. Have to restart 
Kaffeine. Can tune to an unencrypted channel.)
