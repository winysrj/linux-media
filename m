Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40020 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0BAMmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 07:42:47 -0500
Subject: Re: Videotext application crashes the kernel due to DVB-demux patch
From: Andy Walls <awalls@radix.net>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <1265018173.2449.19.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 07:41:50 -0500
Message-Id: <1265028110.3098.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-01 at 10:56 +0100, Chicken Shack wrote:
> Hi,
> 
> here is a link to a patch which breaks backwards compatibility for a
> teletext software called alevt-dvb.
> 
> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> 
> The kernel patch was introduced with kernel 2.6.32-rc1.
> It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> author, Andreas Oberritter.
> 
> Previous help calls, not only on this list, have been ignored for
> reasons that I do not know.
> Even distro maintainers have given up and removed the DVB implementation
> of alevt from their distro list.
> 
> Is that really what things are up to?
> To pull through an API update by kernel patch, but simply dive off with
> the usual "Sorry, but I don't have no time" when objections or problems
> arise?

I have close to 0 time for this (I'm a volunteer who doesn't get paid
for linux work *at all*), but I will look into the problem for you.


> What the hell is going on in those peoples' minds?
> 
> It seems to me that the following disclaimer is worth nothing:
> 
> "If anyone has any objections, please let us know by sending a message
> to: Linux Media Mailing List <linux-me...@vger.kernel.org>"
> 
> Volunteers welcome! Who please consacres some time and DVB competence to
> give the appropriate hints please?
> 
> Regards
> 
> CS
> 
> P. S.: This is how the kernel crash looks like:

The information below can get me started.  Could you please provide
whole Ooops from the output dmesg or from your /var/log/messages file?

I'll try to look at this tonight.

Regards,
Andy

> brian:~# alevt
> alevt: SDT: service_id 0xcf24 not in PAT
> 
> sid:pmtpid:ttpid:type:provider:name:language:texttype:magazine:page
> 
> 28006:100:130:1:ZDFvision:ZDF:lang=deu:type=1:magazine=1:page=  0
> 28011:600:630:1:ZDFvision:ZDFinfokanal:lang=deu:type=1:magazine=1:page=
> 0
> 28014:650:630:1:ZDFvision:zdf_neo:lang=deu:type=1:magazine=1:page=  0
> 28016:1100:630:1:ZDFvision:ZDFtheaterkanal:lang=deu:type=1:magazine=1:page=  0
> 28007:200:230:1:ZDFvision:3sat:lang=deu:type=1:magazine=1:page=  0
> 28008:300:330:1:ZDFvision:KiKa:lang=deu:type=1:magazine=1:page=  0
> 28017:411:8191:2:ZDFvision:DRadio Wissen:lang=:type=0:magazine=0:page=
> 0
> 28012:700:8191:2:ZDFvision:DKULTUR:lang=:type=0:magazine=0:page=  0
> 28013:800:8191:2:ZDFvision:DLF:lang=:type=0:magazine=0:page=  0
> 
> Using: Service ID = 28006 ; PMT PID = 100 ; TXT PID = 130 ;
> Service type = 1 ; Provider Name = ZDFvision ; Service name = ZDF ;
> language = deu ; Text type = 1 ; Text Magazine = 1 ; Text page =   0
> alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> Getötet
> brian:~# 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563487] Oops: 0000 [#1] PREEMPT SMP 
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563492] last sysfs
> file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-0:1.0/uevent
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563589] Process alevt (pid: 1780, ti=e7934000
> task=e7915be0 task.ti=e7934000)
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563592] Stack:
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563622] Call Trace:
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563650] Code: f2 da 4c c8 8d 56 78 89 54 24 04 89 d0 e8
> e4 da 4c c8 89 f0 e8 31 ff ff ff 83 7e 4c 01 76 73 83 7e 48 02 75 49 8b
> 46 04 8d 48 f8 <8b> 41 08 8d 58 f8 8d 7e 04 eb 28 8b 41 08 8b 51 0c 89
> 50 04 89 
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563697] EIP: [<f8cec1b2>] dvb_demux_release+0x43/0x183
> [dvb_core] SS:ESP 0068:e7935f58
> 
> Message from syslogd@brian at Jan 31 19:52:33 ...
>  kernel:[  116.563706] CR2: 0000000000000000
> 
> PLEASE DO NOT IGNORE THIS MAIL!
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

