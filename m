Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62958 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETMqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 08:46:14 -0400
Received: by mail-ee0-f45.google.com with SMTP id l10so4077818eei.32
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 05:46:13 -0700 (PDT)
Message-ID: <519A1B73.6050602@googlemail.com>
Date: Mon, 20 May 2013 14:47:47 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com> <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com> <519A1939.6030907@googlemail.com>
In-Reply-To: <519A1939.6030907@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2013 14:38, schrieb Frank Schäfer:
> ...
> But there was a third change:
> 3.) the scancode passed to the RC core with rc_keypress() in case of
> RC_BIT_UNKNOWN changed from a 16 bit value to 32 bit value (e.g.: old:
> 00 00 ab cd => new: ab cd xx xx).

See

commit 105e3687ada4ebe6dfbda7abc3b16106f86a787d
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Dec 15 08:29:11 2012 -0300

    [media] em28xx: add support for NEC proto variants on em2874 and upper


default_polling_getkey() (em2860/em2880) still returns the 16 bit scancode.
Whatever scancode is correct, it should be the same in both cases...

Mauro, can you take a look at this ?

Regards,
Frank
