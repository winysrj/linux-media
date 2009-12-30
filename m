Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:34020 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZL3VfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 16:35:21 -0500
Received: by iwn1 with SMTP id 1so8714746iwn.33
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 13:35:20 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 30 Dec 2009 16:35:18 -0500
Message-ID: <39648cc20912301335n292a9460y9eb0e7d73efd781@mail.gmail.com>
Subject: i915 graphics driver
From: Neil Sikka <neilsikka@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello. I am trying to get the different display modes working with my
portege M400 laptop. Im running 2.6.32 with the toshiba_acpi module.
the problem is that when i do:

echo "lcd_out:0;crt_out:1" > /proc/acpi/toshiba/video
cat /proc/acpi/toshiba/video

i get:
lcd_out: 1
crt_out: 0
tv_out: 0

I am following the guide at
http://memebeam.org/toys/ToshibaAcpiDriver. Why does the state of the
crt_out variable not change? the kernel file where this is handled is:
kernel/drivers/portability/
x86/toshiba_acpi.c. I have the same problem as these guys here:

http://osdir.com/ml/linux.hardware.toshiba/2003-04/msg00216.html

I tried doing what was suggested at that link, but that did not work
either. Is there a known bug where the state of the driver (as seen by
cat /proc/acpi/toshiba/video) is not updated by writing to it(echo
"lcd_out:0;crt_out:1" > /proc/acpi/toshiba/video)? It seems that the
state written to this file is not persistant. I have posted my problem
in full detail here
(http://www.linuxquestions.org/questions/linux-laptop-and-netbook-25/tvout-from-toshiba-portege-m400-777822/).
thanks.

--
Neil Sikka
