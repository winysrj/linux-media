Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I7e12i007518
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:40:01 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6I7dnUu025373
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:39:49 -0400
Date: Fri, 18 Jul 2008 09:39:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20080714120249.4806.66136.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0807180918160.13569@axis700.grange>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
	<20080714120249.4806.66136.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, paulius.zaleckas@teltonika.lt,
	linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 05/06] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver
 V3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Magnus,

the whole this patch-series has been pulled into the v4l tree now, which 
means there hasn't been any critical issues left, at least none are 
known:-)

A couple of general notes, that would be nice to address in an incremental 
patch:

1. the driver could benefit from a bit more comments:-) At least for 
register configuration.

2. code like

> +	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
> +	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
> +
> +	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~0x10000);
> +
> +	ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);

specifically the 0x0317f313 constants in it might better be coded with 
macros, or at least should be commented.

3. you don't seem to check the interrupt reason nor to handle any error 
conditions like overflow. I guess, there is something like a status 
register on the interface, that you can check on an interrupt to see what 
really was the cause for it.

4. you really managed it to keep the driver platform-neutral!:-) Still, do 
we need an ack from the SH-maintainer? If you think we do, please, try to 
obtain one asap - the patches should be ready to go upstream by Sunday.

5. the memory you are binding with dma_declare_coherent_memory - is it 
some SoC-local SRAM? Is it usably only by the camera interface or also by 
other devices? You might want to request it first like in 
drivers/scsi/NCR_Q720.c to make sure noone else is using it.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
