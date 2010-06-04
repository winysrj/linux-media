Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34587 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0FDN15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 09:27:57 -0400
Received: by iwn37 with SMTP id 37so989776iwn.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jun 2010 06:27:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinh0rXgar5Q0cDqLuBkXtK7b7JPUxyKZI_E9xe3@mail.gmail.com>
References: <AANLkTinh0rXgar5Q0cDqLuBkXtK7b7JPUxyKZI_E9xe3@mail.gmail.com>
Date: Fri, 4 Jun 2010 15:27:56 +0200
Message-ID: <AANLkTil4vj-6yx4uywsCZi7vQxDs_0fc6PmlN_VKd1ly@mail.gmail.com>
Subject: Terratec Cinergy C DVB-C card problems
From: Rune Evjen <rune.evjen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> I've got a terratec cinergy c dvb-c card, fresh install of ubuntu
> 10.04 lucid i386. Card is here:
>
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
>
> I followed the install instructions under "Driver", installing the one from
>
> http://mercurial.intuxication.org/hg/s2-liplianin
>
> dmesg output afterwards:
>
> http://dpaste.com/202745/
>
> and lsmod/lspci:
>
> http://dpaste.com/202150/
>
> The previous install that worked nicely was hardy, using
> mantis-a9ecd19a37c9 that refused to compile with lucid's more recent
> kernel. Any ideas?
>
> Billy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

The Mantis drivers are available in the Ubuntu kernel 2.6.33.

I installed this kernel on top of lucid using this PPA:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.33/

Unfortunately, this kernel is built without the mantis module, after
installing the kernel I also compiled the kernel source and copied the
mantis modules into the /lib/modules/2.6.33-020633-
generic/misc/ directory and ran 'depmod -a'

I compiled the following modules to make it work:
-rw-r--r-- 1 root root 10412 2010-05-27 18:15 hopper.ko
-rw-r--r-- 1 root root 45620 2010-05-27 18:15 mantis_core.ko
-rw-r--r-- 1 root root 25624 2010-05-27 18:15 mantis.ko
-rw-r--r-- 1 root root 25244 2010-05-27 18:21 mb86a16.ko

This is probably not the best approach, but it works.

For some reason this module is not automatically loaded during boot
with ubuntu, but I added 'modprobe mantis' to /etc/rc.local so that it
loads during bootup.

Best regards,

Rune
