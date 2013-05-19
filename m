Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40791 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3ESNlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 09:41:00 -0400
Received: by mail-ee0-f50.google.com with SMTP id c41so3492617eek.23
        for <linux-media@vger.kernel.org>; Sun, 19 May 2013 06:40:59 -0700 (PDT)
Message-ID: <5198D669.6030007@googlemail.com>
Date: Sun, 19 May 2013 15:40:57 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com>
In-Reply-To: <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.05.2013 23:02, schrieb Chris Rankin:
> ----- Original Message -----
>
>> For the em28xx driver: em28xx-input.c:
>> em28xx_ir_work() is called every 100ms
>>      calls em28xx_ir_handle_key()
>>          - calls ir->get_key() which is em2874_polling_getkey() in case of your device
>>          - reports the detected key via rc_keydown() through the RC core
> By the looks of things, it's not recognising the protocol: em2874_ir_change_protocol() is setting ir->rc_type to RC_BIT_UNKNOWN. Shouldn't it be using RC5 instead?
em28xx_ir_change_protocol() should be called at least twice:
First from em28xx_ir_init() with RC_BIT_UNKNOWN (initial configuration) 
and later from the RC core with RC_BIT_RC5.
Can you confirm that ?

Regards,
Frank
