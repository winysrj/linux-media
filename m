Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1B0Sax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 13:30:53 -0500
Received: by bwz15 with SMTP id 15so3166049bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 10:30:52 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: =?utf-8?q?T=C3=B6r=C3=B6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: dw2102.c: quadratic increment intended?
Date: Sun, 27 Feb 2011 20:30:54 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, gohman@apple.com,
	linux-media@vger.kernel.org
References: <4D6A6253.8020201@gmail.com>
In-Reply-To: <4D6A6253.8020201@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102272030.54781.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 27 февраля 2011 16:40:19 автор Török Edwin написал:
> Hi,
Hi

> 
> Please see http://llvm.org/bugs/show_bug.cgi?id=9259#c5, is the code
> intended to do a quadratic increment there?
> 
> While looking at this, I wonder if this isn't also a bug in the original
> code:
> 
>         /* read stv0299 register */
>         request = 0xb5;
>         value = msg[0].buf[0];/* register */
>         for (i = 0; i < msg[1].len; i++) {
>             value = value + i;
>             ret = dw2102_op_rw(d->udev, 0xb5,
>                 value, buf6, 2, DW2102_READ_MSG);
>             msg[1].buf[i] = buf6[0];
> 
>         }
> 
> I don't know anything about the hardware this driver is written for, but is
> 'value' really intended to increment quadratically? That seems
> suspicious. One
> wonders if the following is what was intended:
> 
>         [...]
>         for (i = 0; i < msg[1].len; i++) {
>             ret = dw2102_op_rw(d->udev, 0xb5,
>                 value + i, buf6, 2, DW2102_READ_MSG);
>             msg[1].buf[i] = buf6[0];
> 
>         }
> 
Accidentally, this didn't affect driver, as it reads registers by one register at one time.
But it should be corrected.

> Best regards,
> --Edwin

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
