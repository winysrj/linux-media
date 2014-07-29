Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54179 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbaG2Fim (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 01:38:42 -0400
Message-ID: <53D7335E.2010806@gentoo.org>
Date: Tue, 29 Jul 2014 07:38:38 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] si2135: Declare the structs even if frontend is not enabled
References: <1406554705-10296-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406554705-10296-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.07.2014 15:38, Mauro Carvalho Chehab wrote:
> As reported by Kbuildtest:
> 
>    In file included from drivers/media/usb/cx231xx/cx231xx-dvb.c:35:0:
>    drivers/media/dvb-frontends/si2165.h:57:9: warning: 'struct si2165_config' declared inside parameter list [enabled by default]
>      struct i2c_adapter *i2c)
>             ^
>    drivers/media/dvb-frontends/si2165.h:57:9: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>    drivers/media/usb/cx231xx/cx231xx-dvb.c:157:21: error: variable 'hauppauge_930C_HD_1113xx_si2165_config' has initializer but incomplete type
>     static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
>                         ^
>    drivers/media/usb/cx231xx/cx231xx-dvb.c:158:2: error: unknown field 'i2c_addr' specified in initializer
>      .i2c_addr = 0x64,
>      ^

Good catch.

Matthias
