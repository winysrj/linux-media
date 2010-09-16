Return-path: <mchehab@pedra>
Received: from psmtp04.wxs.nl ([195.121.247.13]:42906 "EHLO psmtp04.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab0IPRHM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 13:07:12 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp04.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L8U00HEZNJUQ9@psmtp04.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 16 Sep 2010 19:07:06 +0200 (MEST)
Date: Thu, 16 Sep 2010 19:07:04 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: Trouble building v4l-dvb
In-reply-to: <1284493110.1801.57.camel@sofia>
To: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4C924EB8.9070500@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Douglas;

Could you please check your last putback ?

the build is broken.

see:
http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

and the mail
[cron job] v4l-dvb daily build 2.6.26 and up: ERRORS

Yours,
		Jan

Ole W. Saastad wrote:
> Trouble building v4l-dvb
> Asus eee netbook, running EasyPeasy.
> 
> ole@ole-eee:~$ cat /etc/issue
> Ubuntu 9.04 \n \l
> ole@ole-eee:~$ uname -a
> Linux ole-eee 2.6.30.5-ep0 #10 SMP PREEMPT Thu Aug 27 19:45:06 CEST 2009
> i686 GNU/Linux
> 
> Rationale for building from source: 
> I have bought a USB TV with mpg4 support from Sandberg, Mini DVB-T
> dongle. I also received an archive with driver routines for this from
> Sandberg. These should be copied into the v4l-dvd three and just rebuild
> with make. 
> 
> I have installed the kernel headers:
> apt-get install mercurial linux-headers-$(uname -r) build-essential
> 
> Then I have downloaded the v4l-dvb source (assuming this is a stable
> release): hg clone http://linuxtv.org/hg/v4l-dvb
> 
> 
> I wanted to try to build before applying the patch from Sandberg. 
> Issuing make yield the following :
> 
> LIRC: Requires at least kernel 2.6.36
> IR_LIRC_CODEC: Requires at least kernel 2.6.36
> IR_IMON: Requires at least kernel 2.6.36
> IR_MCEUSB: Requires at least kernel 2.6.36
> VIDEOBUF_DMA_CONTIG: Requires at least kernel 2.6.31
> V4L2_MEM2MEM_DEV: Requires at least kernel 2.6.33
> and a few more lines....
> 
> Ignoring these and just continuing :
> 
>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-dvb.o
>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-fe.o
>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-1394.o
> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:22:17: error: dma.h: No such
> file or directory
> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:23:21: error: csr1212.h: No
> such file or directory
> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:24:23: error: highlevel.h: No
> such file or directory
> and many many more similar errors.
> 
> After some time the make bails out.
> 
> 
> I assume this have some connection with the 9.04 being too old. 
> 
> 
> Hints ?
> 
> 
> 
> Regards,
> Ole W. Saastad
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
