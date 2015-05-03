Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37881 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbbECIpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 04:45:47 -0400
Message-ID: <5545E031.4050604@xs4all.nl>
Date: Sun, 03 May 2015 10:45:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: issue with videobuf2-dma-sg.ko
References: <20150503071410.GA57577@shambles.windy>
In-Reply-To: <20150503071410.GA57577@shambles.windy>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vince,

On 05/03/2015 09:14 AM, Vincent McIntyre wrote:
> Hi
> 
> I am trying to load the cx23885 module. It fails to load and I get this in dmesg;
> 
>   [  433.506983] videobuf2_dma_sg: Unknown symbol dma_buf_export (err 0)
> 
> I wrote a small script to load each of the dependencies one at a time,
> which shows pretty clearly the problem is videobuf2-dma-sg.ko.
> 
> I am up to date with the media_tree:
>   $ git log |head
>   commit 59366d3bbae4f67ae3b3a32696faa0798cef1b67
>   Author: Hans Verkuil <hans.verkuil@cisco.com>
>   Date:   Sat May 2 10:41:49 2015 +0200
> 
>       v4l/compat.h: fix compiler warning
> 
>       In file included from <command-line>:0:0:
>       v4l/compat.h:1605:11: warning: 'struct device_node' declared inside parameter list
>                  u64 *out_values, size_t sz)
>        	              ^
> 
> Can anyone point out how to fix this?
> What other information would be useful?

Try again, I've hopefully fixed this problem. You need to do a git pull from the
media_build.git repo and that should solve it.

Let me know if you run into problems.

Regards,

	Hans

> Cheers
> Vince
> 
> System details
> 
>   $ uname -a
>   Linux ubuntu 3.13.0-51-generic #84-Ubuntu SMP Wed Apr 15 12:11:46 UTC 2015 i686 i686 i686 GNU/Linux
>   
>   $ sudo sh load.sh
>   videobuf2_core 3
>   videodev 2
>   rc_core 1
>   altera_ci 0
>   modprobe -v altera_ci
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/pci/cx23885/altera-ci.ko
>   v4l2_common 2
>   snd_pcm 4
>   snd 17
>   tveeprom 0
>   modprobe -v tveeprom
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/common/tveeprom.ko
>   cx2341x 0
>   modprobe -v cx2341x
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/common/cx2341x.ko
>   videobuf2_dma_sg 0
>   modprobe -v videobuf2_dma_sg
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/v4l2-core/videobuf2-dma-sg.ko
>   modprobe: ERROR: could not insert 'videobuf2_dma_sg': Unknown symbol in module, or unknown parameter (see dmesg)
>   videobuf2_dvb 0
>   modprobe -v videobuf2_dvb
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/v4l2-core/videobuf2-dvb.ko
>   dvb_core 2
>   tda18271 0
>   modprobe -v tda18271
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/tuners/tda18271.ko
>   altera_stapl 0
>   modprobe -v altera_stapl
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/misc/altera-stapl/altera-stapl.ko
>   cx23885 0
>   modprobe -v cx23885
>   insmod /lib/modules/3.13.0-51-generic/kernel/drivers/media/v4l2-core/videobuf2-dma-sg.ko
>   modprobe: ERROR: could not insert 'cx23885': Unknown symbol in module, or unknown parameter (see dmesg)
>   
>   $ dmesg|tail
>   [   38.177893] nvidia 0000:01:00.0: irq 43 for MSI/MSI-X
>   [   39.350957] init: plymouth-upstart-bridge main process ended, respawning
>   [   39.390535] init: plymouth-upstart-bridge main process (1381) terminated with status 1
>   [   39.390563] init: plymouth-upstart-bridge main process ended, respawning
>   [   56.994291] audit_printk_skb: 123 callbacks suppressed
>   [   56.994298] type=1400 audit(1430633192.185:74): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/lib/cups/backend/cups-pdf" pid=2295 comm="apparmor_parser"
>   [   56.994310] type=1400 audit(1430633192.185:75): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" pid=2295 comm="apparmor_parser"
>   [   56.994991] type=1400 audit(1430633192.185:76): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" pid=2295 comm="apparmor_parser"
>   [  122.119702] videobuf2_dma_sg: Unknown symbol dma_buf_export (err 0)
>   [  122.243021] videobuf2_dma_sg: Unknown symbol dma_buf_export (err 0)
>   
>   
>   
>   $ cat load.sh
>   #!/bin/sh
>   for m in videobuf2_core videodev rc_core altera_ci v4l2_common snd_pcm snd tveeprom cx2341x videobuf2_dma_sg videobuf2_dvb dvb_core tda18271 altera_stapl cx23885
>   do
>       n=`lsmod|grep -F $m -c`
>       echo $m $n
>       [ $n -eq 0 ] || continue
>       echo modprobe -v $m
>       modprobe -v $m
>   done
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

