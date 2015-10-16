Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:36114 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbJPV7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 17:59:44 -0400
Received: by ykdz2 with SMTP id z2so12799328ykd.3
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2015 14:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4801142.TL3UEFHxhL@wuerfel>
References: <10110482.QkOJ1nlAsE@wuerfel>
	<CABxcv=n_N-176+iOsBaroJoGy0kj35YELyfLnaXJGmsi9xkDOg@mail.gmail.com>
	<4801142.TL3UEFHxhL@wuerfel>
Date: Fri, 16 Oct 2015 23:59:43 +0200
Message-ID: <CABxcv=kMgPkaA8ZHZhiQOGtX-3CWAs=rEQP98o-Zw4Cv6unhkA@mail.gmail.com>
Subject: Re: [PATCH] [media] lnbh25: fix lnbh25_attach inline wrapper
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergey Kozlov <serjk@netup.ru>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Arnd,

On Fri, Oct 16, 2015 at 11:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 16 October 2015 23:45:46 Javier Martinez Canillas wrote:
>>
>> On Fri, Oct 16, 2015 at 10:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > The 'static inline' version of lnbh25_attach() has an incorrect
>> > prototype which results in a build error when
>> > CONFIG_DVB_LNBH25 is disabled:
>> >
>> > In file included from /git/arm-soc/drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
>> > /git/arm-soc/drivers/media/dvb-frontends/lnbh25.h:46:86: error: unknown type name 'dvb_frontend'
>> >
>> > This changes the code to have the correct prototype.
>> >
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> > Fixes: e025273b86fb ("[media] lnbh25: LNBH25 SEC controller driver")
>> > ---
>>
>> Same for this patch, the same change is already in the media fixes branch [0].
>>
>> [0]: http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=b36a55cf298127a285806c52d8777c49548f3785
>
> Ah, I see. The patches must have crossed then, it was still broken in linux-next
> this morning.
>

Well, I don't see that branch listed in
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees

>         Arnd

Best regards,
Javier
