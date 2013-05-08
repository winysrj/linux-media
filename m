Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46877 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3EHCSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 22:18:14 -0400
Received: by mail-ee0-f47.google.com with SMTP id b47so647703eek.6
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 19:18:12 -0700 (PDT)
Message-ID: <5189B5E1.3050201@gmail.com>
Date: Wed, 08 May 2013 04:18:09 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: debian@dct.mine.nu
CC: linux-media@vger.kernel.org
Subject: Re: Support of RTL2832U+R820T
References: <51898A55.8050005@dct.mine.nu>
In-Reply-To: <51898A55.8050005@dct.mine.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.05.2013 01:12, Karsten Malcher wrote:
> Hello,
> 
> i want to ask how i can get the DVB-T RTL2832U with the new R820T Tuner
> supported?
> 
> First i found this GitHub that i could compile, but it does not support
> the new Tuner.
> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> 
> 
> Here i found the tuner supported, but i don't know how to integrate this
> stuff into the driver?
> http://sdr.osmocom.org/trac/wiki/rtl-sdr
> 
> Can you help?

Oh dear. :)

http://git.linuxtv.org/media_build.git

Typical usage is:
…


poma



