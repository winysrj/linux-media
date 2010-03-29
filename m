Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:61063 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0C2SlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 14:41:11 -0400
Received: by fxm23 with SMTP id 23so1112615fxm.21
        for <linux-media@vger.kernel.org>; Mon, 29 Mar 2010 11:41:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b8a3b1ca1003290841h68e4b109nd7e095393518ba63@mail.gmail.com>
References: <b8a3b1ca1003290841h68e4b109nd7e095393518ba63@mail.gmail.com>
Date: Mon, 29 Mar 2010 20:41:08 +0200
Message-ID: <b8a3b1ca1003291141t2cbc05c4o6be1574da798a084@mail.gmail.com>
Subject: Re: Module option adapter_nr
From: =?UTF-8?B?VG9tw6HFoSBTa2/EjWRvcG9sZQ==?=
	<tomas.skocdopole@ippolna.cz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am using the Archlinux distribution and i have four Skystar HD2
cards and one Airstar DVB card in my system.
I want to specify adapter numbers for this cards. Order of DVB-S2
cards is not important.

So I add this lines into /etc/modprobe.d/modprobe.conf
options b2c2-flexcop adapter_nr=0
options mantis-core adapter_nr=11,12,13,14

But with no results.

If I specify option directly, I got same result: modprobe mantis-core
adapter_nr=11,12,13,14; modprobe mantis

Or it is better do this with udev?

Regards, Tomas Skocdopole
