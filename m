Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59383 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZKMIq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 03:46:59 -0500
Received: by fxm21 with SMTP id 21so183906fxm.21
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 00:47:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <28911112.17998.1258101443429.JavaMail.root@mail>
References: <5247569.9431255416845783.JavaMail.root@mail>
	 <28911112.17998.1258101443429.JavaMail.root@mail>
Date: Fri, 13 Nov 2009 16:47:03 +0800
Message-ID: <d9def9db0911130047i2cc2eccyc9807f63fb5e9647@mail.gmail.com>
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U
From: Markus Rechberger <mrechberger@gmail.com>
To: Lauri Laanmets <lauri.laanmets@proekspert.ee>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 13, 2009 at 4:37 PM, Lauri Laanmets
<lauri.laanmets@proekspert.ee> wrote:
> Hello
>
> I have managed to attach the device without any error messages now but the tuning and playback of DVB still doesn't work. I get a lot of these error messages:
>
> [  247.268152] em28xx #0: reading i2c device failed (error=-110)
> [  247.268161] xc2028 1-0061: i2c input error: rc = -110 (should be 2)
>
> and
>
> [  433.232124] xc2028 1-0061: Loading SCODE for type=DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0000000000000000.
> [  433.256017] xc2028 1-0061: Incorrect readback of firmware version.
> [  433.372019] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
> [  437.940029] xc2028 1-0061: Loading firmware for type=D2620 DTV78 (108), id 0000000000000000.
>
> Do anybody have an idea what to do next? Or maybe somebody is willing to help me understanding the mcentral code because that one works fine.
>

Due some fundamental problems we do not recommend to use the
em28xx-new code, it can damage your device(!)

We are now working together with several manufacturers since we
accepted their restrictions we got indepth details about how to handle
those devices correctly in order to prevent damaged devices. Even if
it works fine for you it might break the device the next day. The only
way to get it right is to cooperate with the chip design companies.

Markus
