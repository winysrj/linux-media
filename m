Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:57706 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab1JMQbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 12:31:20 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9DGVIgG006433
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 12:31:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 3FA1C1E00BE
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 12:31:17 -0400 (EDT)
Message-ID: <4E971255.8080203@lockie.ca>
Date: Thu, 13 Oct 2011 12:31:17 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: recent cx23385?
References: <4E967E5B.3050504@lockie.ca> <CAGoCfiyViRDt690TWtiWdnfP5C-az2aeOK=TGhgP4kwT1QJfqQ@mail.gmail.com>
In-Reply-To: <CAGoCfiyViRDt690TWtiWdnfP5C-az2aeOK=TGhgP4kwT1QJfqQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/11 08:48, Devin Heitmueller wrote:
> On Thu, Oct 13, 2011 at 1:59 AM, James<bjlockie@lockie.ca>  wrote:
>> Is there a newer cx23385 driver than the one in kernel-3.0.4?
>> I bought ahttp://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250  and it
>> shows video for about 5 seconds and then locks up the system.
> You cannot install individual drivers (Linux doesn't work like Windows
> in this regards).  You have to either install the latest kernel or you
> can swap out the whole media subsystem with a later version.
>
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>
> Devin
Where do I see the date/version of the media subsystem?

It is not video related, w_scan works sometimes but freezes the kernel 
sometimes.
This is booting right to a console.
Is there a program to do a stress test on the hardware and print lots of 
messages as it's working?


$ modinfo cx23885
filename:       
/lib/modules/3.0.4/kernel/drivers/media/video/cx23885/cx23885.ko
license:        GPL
author:         Steven Toth <stoth@linuxtv.org>
description:    v4l2 driver module for cx23885 based TV cards
license:        GPL
author:         Steven Toth <stoth@linuxtv.org>
description:    Driver for cx23885 based TV cards
alias:          pci:v000014F1d00008880sv*sd*bc*sc*i*
alias:          pci:v000014F1d00008852sv*sd*bc*sc*i*
depends:        
videobuf-core,videobuf-dma-sg,stv0367,lnbp21,cx2341x,tveeprom,lgdt330x,videobuf-dvb,stv0900,zl10353,mt2131,ds3000,dib7000p,btcx-risc,tda10048,cx24116,s5h1411,s5h1409,stv6110
vermagic:       3.0.4 SMP mod_unload
parm:           ci_dbg:Enable CI debugging (int)
parm:           ci_irq_enable:Enable IRQ from CAM (int)
parm:           ir_888_debug:enable debug messages [CX23888 IR 
controller] (int)
parm:           mpegbufs:number of mpeg buffers, range 2-32 (int)
parm:           mpeglines:number of lines in an MPEG buffer, range 2-32 
(int)
parm:           mpeglinesize:number of bytes in each line of an MPEG 
buffer, range 512-1024 (int)
parm:           v4l_debug:enable V4L debug messages (int)
parm:           alt_tuner:Enable alternate tuner configuration (int)
parm:           adapter_nr:DVB adapter numbers (array of short)
parm:           i2c_debug:enable debug messages [i2c] (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           debug:enable debug messages (int)
parm:           card:card type (array of int)
parm:           vbibufs:number of vbi buffers, range 2-32 (int)
parm:           vbi_debug:enable debug messages [vbi] (int)
parm:           video_nr:video device numbers (array of int)
parm:           vbi_nr:vbi device numbers (array of int)
parm:           radio_nr:radio device numbers (array of int)
parm:           video_debug:enable debug messages [video] (int)
parm:           irq_debug:enable debug messages [IRQ handler] (int)
parm:           vid_limit:capture memory limit in megabytes (int)
parm:           enable_885_ir:Enable integrated IR controller for supported
                     CX2388[57] boards that are wired for it:
                         HVR-1250 (reported safe)
                         TeVii S470 (reported unsafe)
                     This can cause an interrupt storm with some cards.
                     Default: 0 [Disabled] (int)

I did:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
/bin/sh: /sbin/lsmod: No such file or directory
Lot's of pr_fmt redefined errors.

I put the build log at: lockie.ca/test/v4l_build.txt.bz2

Something is not right though. :-(
$ modprobe cx23885
WARNING: Deprecated config file /etc/modprobe.conf, all config files 
belong into /etc/modprobe.d/.
WARNING: Error inserting altera_ci 
(/lib/modules/3.0.4/kernel/drivers/media/video/cx23885/altera-ci.ko): 
Invalid module format
WARNING: Error inserting media 
(/lib/modules/3.0.4/kernel/drivers/media/media.ko): Invalid module format
WARNING: Error inserting videodev 
(/lib/modules/3.0.4/kernel/drivers/media/video/videodev.ko): Invalid 
module format
WARNING: Error inserting v4l2_common 
(/lib/modules/3.0.4/kernel/drivers/media/video/v4l2-common.ko): Invalid 
module format
WARNING: Error inserting videobuf_core 
(/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-core.ko): 
Invalid module format
WARNING: Error inserting videobuf_dvb 
(/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-dvb.ko): Invalid 
module format
WARNING: Error inserting videobuf_dma_sg 
(/lib/modules/3.0.4/kernel/drivers/media/video/videobuf-dma-sg.ko): 
Invalid module format
WARNING: Error inserting cx2341x 
(/lib/modules/3.0.4/kernel/drivers/media/video/cx2341x.ko): Invalid 
module format
WARNING: Error inserting altera_stapl 
(/lib/modules/3.0.4/kernel/drivers/linux/drivers/misc/altera-stapl/altera-stapl.ko): 
Invalid module format
WARNING: Error inserting rc_core 
(/lib/modules/3.0.4/kernel/drivers/media/rc/rc-core.ko): Invalid module 
format
FATAL: Error inserting cx23885 
(/lib/modules/3.0.4/kernel/drivers/media/video/cx23885/cx23885.ko): 
Invalid module format

