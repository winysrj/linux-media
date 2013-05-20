Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50365 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3ETPfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 11:35:13 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so539747bkc.29
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 08:35:12 -0700 (PDT)
Message-ID: <519A430E.4080006@googlemail.com>
Date: Mon, 20 May 2013 17:36:46 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com> <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com> <519A1939.6030907@googlemail.com> <1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com> <519A287C.9010804@googlemail.com> <1369061513.11886.YahooMailNeo@web120305.mail.ne1.yahoo.com>
In-Reply-To: <1369061513.11886.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2013 16:51, schrieb Chris Rankin:
> ----- Original Message -----
>
>> If I had to guess, I would say you should check your rc_maps.cfg / keytable. ;)
> This is unchanged between 3.8.x and 3.9.x, and so is correct by definition.

No, just because it didn't change it isn't automatically correct. ;)
Which protocol type does you keytable specify/select ?
It should be RC5. If it's none or unknown, it's just dump luck that
things are working (because the driver fortunately configures the device
for RC5 in case of  RC_BIT_UNKNOWN).

> Kernel Upgrades Do Not Break Userspace.

Right.
That's why I would say the third (scancode) change is problematic.
Let's see what Mauro thinks about this.

Regards,
Frank

> Cheers,
> Chris
>

