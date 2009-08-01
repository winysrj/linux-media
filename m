Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:36375 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZHAWso (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 18:48:44 -0400
Received: from [192.168.1.21] (151.59.218.5) by cp-out10.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A5DDB5B01C6158A for linux-media@vger.kernel.org; Sun, 2 Aug 2009 00:48:43 +0200
Message-ID: <4A74C64D.80708@iol.it>
Date: Sun, 02 Aug 2009 00:48:45 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it>	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>	 <4A7140DD.7040405@iol.it>	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>	 <4A729117.6010001@iol.it> <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com> <4A739DD6.8030504@iol.it>
In-Reply-To: <4A739DD6.8030504@iol.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Valerio Messina ha scritto:
> Devin Heitmueller ha scritto:
>> Ah, good news:  the patch I wrote that adds support for the remote
>> control is still around:
>>
>> http://linuxtv.org/hg/~dheitmueller/v4l-dvb-terratec-xs/rev/92885f66ac68
>>
>> I will prep this into a new tree and issue a pull request when I get
>> back in town on Sunday.
> 
> hi,
> I tried to apply the patch, recompile, install and reboot.
> Same results, IR does not send digit to text editor or Kaffeine.
> 
> What other can I do for further help/testing?

I tried another thing.
I unzipped a 2009-01-29 version of
http://mcentral.de/hg/~mrec/v4l-dvb-kernel
the last I used on Ubuntu 8.10, not really updated but worked,
recompiled for the new Ubuntu kernel
2.6.28-14-generic
install and reboot.
This one work, IR send digit to text editor and Kaffeine.
Now I remember, with past Ubuntu version I used mcentral modules, and 
not linuxtv ones. This is why IR worked for me.

I uploaded this shot of the disappeared mercurial repositories here:
http://sharebee.com/fed68f5f
all in all is all GPL code.

I looked at the code, and see that 'v4l-dvb-kernel' consist of less 
files, in particular are 296 files, while 'v4l-dvb' are 7916, probably 
because there are only em28xx related files.
The source tree have some different organization.
I see that:
v4l-dvb/linux/include/media/ir-common.h
and
v4l-dvb/linux/drivers/media/common/ir-keymaps.c
does not exist

v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c
is located here:
v4l-dvb-kernel/em28xx-cards.c
and diff report lot lot of differencies.

hope this helps integrating IR support,
Valerio

