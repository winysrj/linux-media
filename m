Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53693 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab2FUM7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 08:59:46 -0400
Received: by gglu4 with SMTP id u4so404410ggl.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 05:59:45 -0700 (PDT)
Message-ID: <4FE31AB1.7020706@gmail.com>
Date: Thu, 21 Jun 2012 09:59:29 -0300
From: Zhu Sha Zang <zhushazang@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Olivier GRENIE <olivier.grenie@parrot.com>
Subject: Re: DiBcom adapter problems
References: <4FDDE29B.9040500@gmail.com> <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>
In-Reply-To: <C73E570AC040D442A4DD326F39F0F00E138E9533E7@SAPHIR.xi-lite.lan>
Content-Type: multipart/mixed;
 boundary="------------090104030706000005080508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090104030706000005080508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Ok, my kernel versions are 3.4.2 and 3.4.3.

The apps used to tune are

media-tv/w_scan - http://wirbel.htpc-forum.de/w_scan/index2.html
media-tv/linuxtv-dvb-apps (dvbscan) - http://www.linuxtv.org/
media-video/vlc - http://www.videolan.org/vlc/
media-video/kaffeine - http://kaffeine.kde.org/

A six month later i've already created a channels.conf and still working 
with vlc.

A question: How to set debug parameter using modprobe?

Something like, "modrobe dib8000 debug=1; modprobe dvb-core debug=1"?


Thanks for now.

Em 19-06-2012 12:43, Olivier GRENIE escreveu:
> Hello,
> can you provide more information:
>      - kernel version
>      - more log information (not only the error message but also the log from the beginning, when you plug the device) with:
>            * the debug parameter of the dib8000 module set to 1
>            * the frontend_debug parameter of the dvb-core module set to 1
>      - which application do you use to tune the board
>
> regards,
> Olivier
> ________________________________________
> From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Rodolfo Timoteo da Silva [zhushazang@gmail.com]
> Sent: Sunday, June 17, 2012 3:58 PM
> To: linux-media@vger.kernel.org
> Subject: DiBcom adapter problems
>
> Hi, every time that i try to syntonize DVB-T channels i receive a
> message in kernel like in log1.txt arch.
>
> There are in log2.txt some usefull information about the device.
>
> My kernel/system is:
>
>
> Linux version 3.4.2-gentoo-r1-asgard (root@asgard) (gcc version 4.6.3
> (Gentoo 4.6.3 p1.3, pie-0.5.2) ) #1 SMP PREEMPT Thu Jun 14 07:45:19 BRT 2012
>
> Best Regards
>


-- 

---
Rodolfo Timóteo da Silva
Linux Counter: 359362
msn: zhushazang@gmail.com
skype: zhushazang

Ribeirão Preto - SP



--------------090104030706000005080508
Content-Type: text/plain; charset=UTF-8;
 name="channel.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="channel.conf"

TV CLUBE HD:485142857:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:0:59776
TV CLUBE MOVEL:485142857:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:0:59800
EP HD:641142857:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:273:274:59520
EPTV1Seg:641142857:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:529:530:59544


--------------090104030706000005080508--
