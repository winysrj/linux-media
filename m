Return-path: <mchehab@pedra>
Received: from psmtp09.wxs.nl ([195.121.247.23]:55056 "EHLO psmtp09.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0I2Vta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 17:49:30 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp09.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9J007J13AH7P@psmtp09.wxs.nl> for linux-media@vger.kernel.org;
 Wed, 29 Sep 2010 23:49:30 +0200 (MEST)
Date: Wed, 29 Sep 2010 23:49:28 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: patches for the Realtek rtl2831
In-reply-to: <4CA2321C.1020909@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Message-id: <4CA3B468.2050201@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
 <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com>
 <4CA0E554.40406@hoogenraad.net> <4CA0ECA9.30208@gmail.com>
 <4CA10262.6060206@hoogenraad.net> <4CA11E25.5030206@gmail.com>
 <4CA22A79.9020309@hoogenraad.net> <4CA2321C.1020909@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab wrote:

>
> A side question: when do you intend to send us the patches for the Realtek
> rtl2831?
>

Basically, I'm waiting for somebody to take up the task to include IR 
support in Antti's branches. I don't have the knowledge to do so.
In the mean time, I just maintain the code from Realtek on a sync with 
mainline only base in hg, as the code is really sub-standard.

http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U

I have seen that Realtek keeps updating their Windows code, and the v4l 
port, at least for the RTL2832.
I see the "recipes" to use that on many forums.

> Cheers,
> Mauro.
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
