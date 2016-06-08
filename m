Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:46211 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbcFHDeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 23:34:03 -0400
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com [209.85.213.51])
	by imap.netup.ru (Postfix) with ESMTPA id 562E07C7E76
	for <linux-media@vger.kernel.org>; Wed,  8 Jun 2016 06:33:59 +0300 (MSK)
Received: by mail-vk0-f51.google.com with SMTP id e4so133785291vkb.1
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2016 20:33:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <003401d1c0d4$5c6ad500$15407f00$@astim.si>
References: <CAK3bHNUPOORumndTHSQyLa0OAnE1Ob4SLR=CoLZMbi5C-P4e4w@mail.gmail.com>
 <20160607122140.25a5c1c0@recife.lan> <001b01d1c0d1$97e32a40$c7a97ec0$@astim.si>
 <CAK3bHNXWgAB1oRweFVoJb=-aosCtV9uNgW35E-ZV-_o8WZbhjA@mail.gmail.com> <003401d1c0d4$5c6ad500$15407f00$@astim.si>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 7 Jun 2016 23:33:38 -0400
Message-ID: <CAK3bHNUn6t74jGYKbVGAya3Ds_dS9=FsocrV9LN7VCtCvbXP2w@mail.gmail.com>
Subject: Re: [GIT PULL] NetUP Universal DVB (revision 1.4)
To: Saso Slavicic <saso.linux@astim.si>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

yes, strange, not applied to media_tree ... just re-sent this patch to ML.

thanks !

2016-06-07 11:50 GMT-04:00 Saso Slavicic <saso.linux@astim.si>:
> Hi,
>
> I don't see this commit in media_tree.git yet, that's why I wrote...
> As long as it gets fixed... :)
>
> Thanks,
> Saso
>
> From: Abylay Ospan [mailto:aospan@netup.ru]
> Sent: Tuesday, June 07, 2016 5:41 PM
> To: Saso Slavicic
> Cc: Mauro Carvalho Chehab; linux-media
> Subject: Re: [GIT PULL] NetUP Universal DVB (revision 1.4)
>
> Hi Saso,
>
> sorry, this path for ascot2e:
> https://github.com/aospan/linux-netup-1.4/commit/862c0314778e27de4cd4c47f12fe7e4232a7181d
>
> 2016-06-07 11:30 GMT-04:00 Saso Slavicic <saso.linux@astim.si>:
> Hi,
>
> Please check the ASCOT2E issue for the NetUP card as well.
>
> https://patchwork.linuxtv.org/patch/34451
>
> Regards,
> Saso
>
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho
> Chehab
> Sent: Tuesday, June 07, 2016 5:22 PM
> To: Abylay Ospan
> Cc: linux-media
> Subject: Re: [GIT PULL] NetUP Universal DVB (revision 1.4)
>
> Em Mon, 16 May 2016 11:58:15 -0400
> Abylay Ospan <aospan@netup.ru> escreveu:
>
>> Hi Mauro,
>>
>> Please pull code from my repository (details below). Repository is
>> based on linux-next. If it's better to send patch-by-patch basis
>> please let me know - i will prepare emails.
>>
>> This patches adding support for our NetUP Universal DVB card revision
>> 1.4 (ISDB-T added to this revision). This achieved by using new Sony
>> tuner HELENE (CXD2858ER) and new Sony demodulator ARTEMIS (CXD2854ER).
>> And other fixes for our cards in this repository too.
>
> Patches applied.
>
> Please send a patch adding an entry for the new HELENE tuner driver at
> MAINTAINERS.
>
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
>
>
>
>
> --
> Abylay Ospan,
> NetUP Inc.
> http://www.netup.tv
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
