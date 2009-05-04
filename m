Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:64795 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbZEDQ37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 12:29:59 -0400
Received: by ewy24 with SMTP id 24so4091951ewy.37
        for <linux-media@vger.kernel.org>; Mon, 04 May 2009 09:29:58 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 May 2009 18:29:58 +0200
Message-ID: <ecc945da0905040929g828133ha7b1542dad9a1ca8@mail.gmail.com>
Subject: TT-3200: locks init. and timeout
From: pierre gronlier <ticapix@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a TT-3200 card and the b40d628f830d revision of v4l-dvb (april 24th)
I have this two szap config files:
$ cat channels_astra_fta.conf
LCP:11479:v:0:22000:161:84:6402

$ cat channels_hotbird_fta.conf
4FunTv:10719:v:1:27500:163:92:4404

My problem is that to lock on hotbird I have to lock first on astra
and them quickly launch szap on hotbird.
If I'm waiting few seconds after the lock of astra then the lock on
hotbird doesn't work.

To lock on astra, I use this command
$ szap -a 0 -f 0 -d 0 -c channels_astra_fta.conf -xr -n 1
To lock on hotbird, I use this command
$ szap -a 0 -f 0 -d 0 -c channels_hotbird_fta.conf -xr -n 1


I enclose to the mail three logs:
- when astra locks
- when hotbird failed to lock
- when hotbird locks

The logs are big but the diffs are really small so I hope that someone
who is familiar with the hardware could answer me.

http://pierre.gronlier.fr/tmp/astra_ok_small.log
http://pierre.gronlier.fr/tmp/hotbird_failed_small.log
http://pierre.gronlier.fr/tmp/hotbird_ok_small.log


--
Pierre
