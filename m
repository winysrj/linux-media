Return-path: <linux-media-owner@vger.kernel.org>
Received: from sqdf3.vserver.nimag.net ([62.220.136.226]:57590 "EHLO
	mail.avocats-ch.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3BBNiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 08:38:07 -0500
Received: from [192.168.1.101] (84-74-24-62.dclient.hispeed.ch [84.74.24.62])
	by mail.avocats-ch.ch (Postfix) with ESMTPSA id B5C4E29B89EF
	for <linux-media@vger.kernel.org>; Sat,  2 Feb 2013 14:38:04 +0100 (CET)
Message-ID: <510D16B7.9000304@romandie.com>
Date: Sat, 02 Feb 2013 14:37:59 +0100
From: Futilite <futilite@romandie.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Bug report - em28xx NEW
References: <CD2D9525.98B4%philschweizer@bluewin.ch> <5107DA24.5050303@romandie.com> <201301291559.26481.hverkuil@xs4all.nl> <5107EB1D.9060702@romandie.com> <5107EDD3.5060505@gmail.com> <5107F01B.60400@romandie.com> <510BB68E.6070009@romandie.com>
In-Reply-To: <510BB68E.6070009@romandie.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried again with the same machine, but this time with a 
3.2.0-29-generik-pae 64bits, instead of previous 32 bits kernel. Same 
errors when inserting the device.

Olivier

Le 01. 02. 13 13:35, Futilite a écrit :
> Well. Compilation is done since last time. But module produced is 
> unusable.
>
> I cloned last version of git repository.
>
> run ./build once -> no compilation of em28xx
> make menuconfig ->select emxx ->make
> result: compilation of em28xx*.ko
> I attached the result of stderr and stdout.
>
> But when I try to modprobe the new modules (or unplug/replug my pctv 
> quatrostick nano (520e), I obtain the following errors:
>
> root@mediacenter:~# modprobe em28xx
> WARNING: Error inserting media 
> (/lib/modules/3.2.0-36-generic-pae/kernel/drivers/media/media.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting videodev 
> (/lib/modules/3.2.0-36-generic-pae/kernel/drivers/media/v4l2-core/videodev.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting v4l2_common 
> (/lib/modules/3.2.0-36-generic-pae/kernel/drivers/media/v4l2-core/v4l2-common.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting videobuf2_core 
> (/lib/modules/3.2.0-36-generic-pae/kernel/drivers/media/v4l2-core/videobuf2-core.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting em28xx 
> (/lib/modules/3.2.0-36-generic-pae/kernel/drivers/media/usb/em28xx/em28xx.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
>
>
> Some hardware precision: I'm (obviously) trying to make a nice 
> mediacenter with two usb tv decoders. These compiled fine with another 
> computer with kernel 3.2.0-xx-generic-pae. But I need them with my 
> mediacenter, not with my desktop computer...
>
> Hardware configuration of my mediacenter: Intel(R) Atom(TM) CPU D525   
> @ 1.80GHz
>
> output of uname -r: 3.2.0-36-generic-pae
>
> Any help would be appreciated.
>
> Best regards
>
> Olivier

