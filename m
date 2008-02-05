Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JMMNH-0006mW-0r
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 12:54:03 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: "Eduard Huguet" <eduardhc@gmail.com>,
 linux-dvb@linuxtv.org
Date: Tue, 5 Feb 2008 12:19:52 +0100
References: <617be8890801290207t77149e2fh73c753501c39e835@mail.gmail.com>
	<200802042213.38495.zzam@gentoo.org>
	<617be8890802050108q5abf2c44la66a813143da205@mail.gmail.com>
In-Reply-To: <617be8890802050108q5abf2c44la66a813143da205@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802051219.54633.zzam@gentoo.org>
Subject: Re: [linux-dvb] Patch for analog part for Avermedia A700 fails to
	apply
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tuesday 05 February 2008, you wrote:
> Hi,

Hi!

>     Bad news: I've been unsuccesfully trying to apply the new patches (as
> mentioned in the wiki), with the following results:
>
> 1.- analog part applies just fine:
>
> mediacenter v4l-dvb # patch -p1 < ../1_avertv_A700_analog_part.diff
> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> patching file linux/drivers/media/video/saa7134/saa7134.h
> patching file linux/Documentation/video4linux/CARDLIST.saa7134
>
It is just listed extra as this patch is the only one I think is correct and I 
hope it gets applied to v4l-dvb in near future. (Maybe after some others have 
verified it.)

>
> 2.- Your patch (ZZam's) gives some warnings:
>

>
> Apparently the A700 section is duplicated. I assume that the second section
> is the good one, as the first gives only option for analog input. This is
> probably related to the patch no aplying cleanly. I've removed the 1st
> section and now it seems to compile fine.
>
So you found out the hard way, that patch 1 (analog-only) is already part of 
my patch and you should only apply one of these.

>
> 3.- Tino's patch gets worse. It even doesn't apply:
>

I guess this patch is also influenced by some new added cards.

Regards
  Matthias

-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
