Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217]:52690 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZKJMt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 07:49:56 -0500
Received: by ewy17 with SMTP id 17so444736ewy.17
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 04:50:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
References: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
	 <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
	 <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
Date: Tue, 10 Nov 2009 13:50:00 +0100
Message-ID: <b40acdb70911100450i4902900eu92c3529de9b5b9a0@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_tw68=2Dv2=2Ftw68=2Di2c=2Ec=3A145=3A_error=3A_unknown_field_=91?=
	=?windows-1252?Q?client=5Fregister=92_specified_in_initializer?=
From: Domenico Andreoli <cavokz@gmail.com>
To: Roman Gaufman <hackeron@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Tue, Nov 10, 2009 at 1:40 PM, Roman Gaufman <hackeron@gmail.com> wrote:
> Thanks, managed to compile but getting -1 Unknown symbol in module now
> - any ideas?
>
> # make
> make -C /lib/modules/2.6.31-14-generic/build M=/root/tw68-v2 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
>  CC [M]  /root/tw68-v2/tw68-core.o
>  CC [M]  /root/tw68-v2/tw68-cards.o
>  CC [M]  /root/tw68-v2/tw68-video.o
>  CC [M]  /root/tw68-v2/tw68-controls.o
>  CC [M]  /root/tw68-v2/tw68-fileops.o
>  CC [M]  /root/tw68-v2/tw68-ioctls.o
>  CC [M]  /root/tw68-v2/tw68-vbi.o
>  CC [M]  /root/tw68-v2/tw68-ts.o
>  CC [M]  /root/tw68-v2/tw68-risc.o
>  CC [M]  /root/tw68-v2/tw68-input.o
>  CC [M]  /root/tw68-v2/tw68-tvaudio.o
>  LD [M]  /root/tw68-v2/tw68.o
>  Building modules, stage 2.
>  MODPOST 1 modules
>  CC      /root/tw68-v2/tw68.mod.o
>  LD [M]  /root/tw68-v2/tw68.ko
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
> # insmod tw68.ko
> insmod: error inserting 'tw68.ko': -1 Unknown symbol in module

dmesg would show which symbol is missing. the quick hack i suggest is
to load the bttv driver with "modprobe bttv", which brings in all the usual
v4l2 modules, unload it and the reload the tw68.ko

ciao,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
