Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47754 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2GJPvS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:51:18 -0400
Received: by bkwj10 with SMTP id j10so150975bkw.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 08:51:16 -0700 (PDT)
Message-ID: <4FFC4F71.4000809@gmail.com>
Date: Tue, 10 Jul 2012 17:51:13 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>, linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl> <4FFA996D.9010206@iki.fi> <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl> <4FFB2129.2070301@gmail.com> <hhvsc9-pte.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <hhvsc9-pte.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2012 08:43 AM, Marx wrote:
> I've attached stream analysis via ffmpeg in another post. I can upload
> saved stream if needed. I simply don't know how to check if weak signal
> is problem. Szap (or extended version szap-s2) gives me some numbers but
> I don't know how to properly read them.

…ffprobe
Play with a femon, dvbsnoop, …
http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps
http://www.linuxtv.org/wiki/index.php/Dvbsnoop
Read a bit
http://www.linuxtv.org/wiki/index.php/Testing_reception_quality

> Is this pctv452e device known to have poor reception?

modinfo stb6100 | grep author ;)
