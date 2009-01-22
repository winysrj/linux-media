Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:37415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZAVXCA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 18:02:00 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2318879fgg.17
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 15:01:57 -0800 (PST)
Message-ID: <4978FAE1.3070103@googlemail.com>
Date: Fri, 23 Jan 2009 00:01:53 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] device file ordering w/multiple cards
References: <alpine.LFD.2.00.0901221641300.8219@tupari.net>
In-Reply-To: <alpine.LFD.2.00.0901221641300.8219@tupari.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Joseph Shraibman schrieb:
> I have two dvb cards in my system.  Is there any way to change the order 
> of the device files?

Usually, the device files (/dev/dvb/adapter?/..) are create by a udev-rule. If you modify
the rule, you can assign every dvb card to a specific number. In my case, I'm using Suse,
which comes withe following udev rule in /etc/udev/rules.d/50-udev-default.rules:
# DVB video
SUBSYSTEM=="dvb", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter%%i/%%s
$${K%%%%.*} $${K#*.}'", NAME="%c"

I've two DVB cards, one FF and one budget. The FF should be always the adapter #0. I've
disabled the default DVB rule and add my one rule, which assigns the numbers depend on the
 pci vendor/device numbers:
# DVB video
#SUBSYSTEM=="dvb", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter%%i/%%s
$${K%%%%.*} $${K#*.}'", NAME="%c"
SUBSYSTEM=="dvb", SYSFS{subsystem_device}=="0x1156", SYSFS{subsystem_vendor}=="0x153b",
PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter%%i/%%s 1 $${K#*.}'", NAME="%c
SUBSYSTEM=="dvb", SYSFS{subsystem_device}=="0x000a", SYSFS{subsystem_vendor}=="0x13c2",
PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter%%i/%%s 0 $${K#*.}'", NAME="%c

If you use two identical cards, you can use the pci slot number:
# DVB video
#SUBSYSTEM=="dvb", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter%%i/%%s
$${K%%%%.*} $${K#*.}'", NAME="%c"
SUBSYSTEM=="dvb", SUBSYSTEMS=="pci", KERNELS=="0000:04:07.0", PROGRAM="/bin/sh -c 'K=%k;
K=$${K#dvb}; printf dvb/adapter%%i/%%s 1 $${K#*.}'", NAME="%c"
SUBSYSTEM=="dvb", SUBSYSTEMS=="pci", KERNELS=="0000:04:06.0", PROGRAM="/bin/sh -c 'K=%k;
K=$${K#dvb}; printf dvb/adapter%%i/%%s 0 $${K#*.}'", NAME="%c"

Regards,
Hartmut
