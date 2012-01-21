Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43411 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2AUNjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 08:39:20 -0500
Received: by iacb35 with SMTP id b35so1067255iac.19
        for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 05:39:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F193B96.9020008@redhat.com>
References: <CACGt9y=8FzimyQPx7gJQ=gVqDp7cRUojT53gJq2+TNKhH37Wpg@mail.gmail.com>
 <4F182BCF.60303@redhat.com> <CACGt9ymVoDWyG8rt3psCT-PmZ7zeB_8YTjv5ZZQ-2Mx2-pteag@mail.gmail.com>
 <4F193B96.9020008@redhat.com>
From: =?UTF-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
Date: Sat, 21 Jan 2012 11:38:58 -0200
Message-ID: <CACGt9ynN=Abu1BsrGZ1Gotif-WnPu6CkEYL02+DeRoBJ5tYe_w@mail.gmail.com>
Subject: Re: Siano DVB USB device called "Smart Plus"
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 20, 2012 at 08:01, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>> Then I added a few lines, as shown below, but it seems
>> the driver still tries to load "dvb_nova_12mhz_b0.inp" instead of
>> "isdbt_nova_12mhz_b0.inp".
>
> No. there's a parameter for the smsmdtv module to select the right
> standard:
>
> drivers/media/dvb/siano/smscoreapi.c:module_param(default_mode, int, 0644);
>
> You need to pass "default_mode=6" for ISDB-T to work. Just renaming
> the firmware won't work. Of course, the firmware name entry needs to be
> filled.

Okay, I did:
modprobe smsmdtv default_mode=6
Now it loads the correct firmware. But, still, neither vlc nor w_scan
can find any channels.

I bet it requires deeper debugging and more knowledge than what I have now.

-- 
Denilson Figueiredo de Sá
Belo Horizonte - Brasil
