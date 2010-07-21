Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns2.embit.ro ([77.81.44.3]:43779 "EHLO pa-mx-2.embit.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803Ab0GUMyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 08:54:24 -0400
Received: from [77.81.44.130] (snake.embit.ro [77.81.44.130])
	by pa-mx-2.embit.ro (Postfix) with ESMTPSA id 7093D1080B9
	for <linux-media@vger.kernel.org>; Wed, 21 Jul 2010 15:54:21 +0300 (EEST)
Message-ID: <4C46EDF5.6060102@embit.ro>
Date: Wed, 21 Jul 2010 15:54:13 +0300
From: Timofte Bogdan <bogdan@embit.ro>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] CAM Support for Terratec Cinergy S2 HD or Technisat
 SkyStar HD2
References: <AANLkTim3sbg90SKwNEP3COINRD5Z26Hj60_exb7_DEXd@mail.gmail.com>
In-Reply-To: <AANLkTim3sbg90SKwNEP3COINRD5Z26Hj60_exb7_DEXd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
  Try: http://mercurial.intuxication.org/hg/s2-liplianin/summary
CI works for me with SkyStar HD 2.
On 20.07.2010 12:17, code unknown wrote:
> Hi,
>
> I am using a Terratec Cinergy S2 HD with Mantis driver and so far the
> card runs without problems.
>
> The only thing is that CAM seems not to be supported - it is defined
> out from the source code:
>
> #if 0
>     err = mantis_ca_init(mantis);
>     if (err<  0) {
>              dprintk(MANTIS_ERROR, 1, "ERROR: Mantis CA initialization
> failed<%d>", err);
>     }
> #endif
>
>
> My questions are:
>
> 1. Is anybody currently working on CAM support? Will it be supported soon?
>
> 2. Is there another DVB-S2 HD card which has CAM supported?
>
>
> Thanks,
>
> rinf
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>    

