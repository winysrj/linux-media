Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51935 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3ESRZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 13:25:27 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so3449833eae.30
        for <linux-media@vger.kernel.org>; Sun, 19 May 2013 10:25:26 -0700 (PDT)
Message-ID: <51990B63.5090402@googlemail.com>
Date: Sun, 19 May 2013 19:26:59 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com>
In-Reply-To: <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.05.2013 16:11, schrieb Chris Rankin:
> ----- Original Message -----
>
>> em28xx_ir_change_protocol() should be called at least twice:
>> First from em28xx_ir_init() with RC_BIT_UNKNOWN (initial configuration) 
>> and later from the RC core with RC_BIT_RC5.
>> Can you confirm that ?
> Yes, it does appear to be called twice: first with *rc_type=1 and then later with *rc_type=8.

Good, that's how it should be.

>  But that still doesn't seem to stop ir->rc_type being RC_BIT_UNKNOWN in em2874_polling_getkey().

Hmm... that's weird. Are you sure about that ? Is this really a 3.9.2
vanilla kernel ?
The code looks good, ir->rc_type is updated by
em2874_ir_change_protocol() when the protocol is changed.
I also tried to reproduce your problem with a em2884 device with a RC5
remote control a few minutes ago, but everything works as expected...

One thing I noticed is that in em28xx_ir_handle_key() ir->last_readcount
is reset to 0 for the em2874 and em2884.
I assume the same should be done for em28174, too...
Anyway, that's a separate issue and older kernels did the same.

Regards,
Frank
