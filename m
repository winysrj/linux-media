Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:57499 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab2I1QOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 12:14:00 -0400
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 13:13:59 -0300
Message-ID: <CAH0vN5LH2HJ6c9tGUtV7E7SH4BTWs+OQFL=7q5vLAEBji-43Eg@mail.gmail.com>
Subject: Build
From: Marcos Souza <marcos.souza.org@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi media guys,

After try to build the media drivers with some radios enabled, I got this error:

marcos@tux:/mnt/dados/gitroot/linux$ make M=drivers/media
  Building modules, stage 2.
  MODPOST 21 modules
WARNING: "snd_tea575x_init" [drivers/media/radio/radio-shark.ko] undefined!
WARNING: "snd_tea575x_exit" [drivers/media/radio/radio-shark.ko] undefined!
WARNING: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko] undefined!
WARNING: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko] undefined!

I saw that there is a EXPORT_SYMBOL of these functions in the file
sound/i2c/other/tea575x-tuner.c

But, I don't know how to find this...

Can someone show me how can I fix this?

Thanks since now!

-- 
Att,

Marcos Paulo de Souza
Acad�mico de Ciencia da Computa��o - FURB - SC
Github: https://github.com/marcosps/
"Uma vida sem desafios � uma vida sem raz�o"
"A life without challenges, is a non reason life"
