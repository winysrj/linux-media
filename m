Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1HOTDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 15:03:15 -0400
Received: by fxh19 with SMTP id 19so3760535fxh.19
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 12:03:14 -0700 (PDT)
Subject: Re: New Hauppauge HVR-2200 Revision?
From: Adrien Dorsaz <a.dorsaz@gmail.com>
To: linux-media@vger.kernel.org
Cc: Saint-bernard <christophe@micheldorsaz.ch>
Date: Mon, 15 Aug 2011 21:03:14 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1313434995.7350.26.camel@adrien-nb>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've recently bought two cards HVR-2200 rev 0700:8940 and installed them
into one PC. Kernel module saa7164 was launched by linux (under Ubuntu
11.04, with kernel 2.6.38-10-generic-pae), but it didn't recognize my
cards (so, it selected card 0 : unknown).

I've seen a new patch on your mailing list (see archive [1] and the
patch [2]), but it was apparently only applied on kernellabs.org and not
in the linuxtv.org archive.

So I've downloaded the Ubuntu linux source (with apt-get install
linux-source), I've patched it following the diff [2] and I've compiled
this new kernel.

Now when I reboot it, it works really well : I don't need any more to
say which cards I've in /etc/modprobe.d/saa-7164.conf and both were well
recognized (I've seen my four adapters in /dev/dvb/adapter[0,1,2,3]).

So, could you apply this patch also on your source please (and try it to
confirm my tests)?

Thank you very much,
Adrien Dorsaz
a.dorsaz@gmail.com

[1] :
http://www.mail-archive.com/linux-media@vger.kernel.org/msg14612.html ,
and the message which give a patch :
http://www.mail-archive.com/linux-media@vger.kernel.org/msg14626.html

[2] : the patch on kernellabs.org :
http://www.kernellabs.com/hg/saa7164-stable/rev/cf2d7530d676

