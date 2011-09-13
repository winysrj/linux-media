Return-path: <linux-media-owner@vger.kernel.org>
Received: from flosoft.biz ([91.121.71.91]:45463 "EHLO flosoft.biz"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932092Ab1IMS44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 14:56:56 -0400
Received: by wwf22 with SMTP id 22so1154678wwf.1
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 11:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH5-0B4q+9aA=3fdxo1KJ6yoLhObmzVfbUnHJOCE7C9bjsosEw@mail.gmail.com>
References: <CAH5-0B4q+9aA=3fdxo1KJ6yoLhObmzVfbUnHJOCE7C9bjsosEw@mail.gmail.com>
From: Sander Devrieze <sander@sanderdevrieze.net>
Date: Tue, 13 Sep 2011 20:56:28 +0200
Message-ID: <CAH5-0B7jjtH4C+Av5z9aBx6WhJtQPoB-1H3EY1Aq1h8Ve7qPBQ@mail.gmail.com>
Subject: Re: Cinergy T USB XXS (HD): wrong keymap loaded
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Watching television works out of the box, but the remote control does
not work by default. The remote uses the NEC protocol as is also noted
on http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_XXS#Cinergy_T_USB_XXS_.28HD.29_.280ccd:00ab.29
However the RC5 protocol is loaded with a wrong keymap. This is the
command that made the remote work:

ir-keytab --sysdev rc1 -w /lib/udev/rc_keymaps/dib0700_nec

lsusb output:
Bus 001 Device 006: ID 0ccd:00ab TerraTec Electronic GmbH

Related discussion:
http://linuxtv.org/irc/v4l/index.php?date=2011-09-08 (user: fgfhdfh)


Note to Terratec support: last month I bought hardware from LiteOn,
Logitech, Spire, Epson, Lexmark, Intel, AMD (ATI), Crucial, MSI,
Seagate and Terratec. All hardware works flawlessly out of the box or
after installation of software from the vendor, except for Terratec.
Inexperienced people will think their Terratec hardware is broken in a
case like this. Can you guys regularly test your hardware and send
reports like this to the linux-media mailing list (if something is
broken)? With the expected growth of Linux-based Android tablets, the
number of inexperienced people that will think Terratec hardware is
broken could only increase (if they want to use a Terratec USB device
to watch television on their tablet).

--
Mvg, Sander Devrieze.
