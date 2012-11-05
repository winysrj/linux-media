Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62151 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2KELLp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 06:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <50979998.8090809@gmail.com>
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com>
	<5096C561.5000108@gmail.com>
	<CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
	<5096E8D7.4070304@gmail.com>
	<CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
	<50979998.8090809@gmail.com>
Date: Mon, 5 Nov 2012 14:11:45 +0300
Message-ID: <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
From: Andrey Gusakov <dron0gus@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Thanks all!
I make it work! Have to comment out write { REG_GRCOM, 0x3f },	/*
Analog BLC & regulator */ and have to enable gate clock for fimc at
probe.

> Hmm, in my case VER was 0x50. PID, VER = 0x96, 0x50. And this a default
> value
> after reset according to the datasheet, ver. 1.3. For ver. 1.91 it is
> PID, VER = 0x96, 0x52. Perhaps it just indicates ov9652 sensor ov9652.
> Obviously I didn't test the driver with this one. Possibly the differences
> can be resolved by comparing the documentation. Not sure if those are
> significant and how much it makes sense to have single driver for both
> sensor versions. I'll try to have a look at that.
Ok. I also try to compate init sequenses from different sources on web.

Next step is to make ov2460 work.

Best regards.
Andrey.
