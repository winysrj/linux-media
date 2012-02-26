Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw-out2.cc.tut.fi ([130.230.160.33]:53845 "EHLO
	mail-gw-out2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2BZR0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 12:26:11 -0500
Message-ID: <4F4A67AB.1070103@iki.fi>
Date: Sun, 26 Feb 2012 19:11:07 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Issa Gorissen <flop.m@usa.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	S-bastien RAILLARD <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net> <4DCC45D7.8090405@usa.net> <19917.7169.579857.44894@morden.metzler>
In-Reply-To: <19917.7169.579857.44894@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

13.05.2011 14:54, Ralph Metzler kirjoitti:
> Below my test code. You just need to adjust the device name.
> 
> I had it running for an hour and had no discontinuities (except at
> restarts, might have to look into buffer flushing).
> I tested it with nGene and Octopus boards on an Asus ION2 board and on a
> Marvell Kirkwood based ARM board.

Should your test code (quoted below) work with e.g. Octopus DDBridge on
vanilla 3.2.6 kernel, without any additional initialization needed
through ca0 or so?

When I try it here like that, the reader thread simply blocks
indefinitely on the first read, while the writer thread continues to
write packets into the device.
Am I missing something, or is this a bug?

> Btw., what hardware exactly are you using? 
> Which DVB card version, CI type, motherboard chipset?

I'm not sure what do you need, exactly, but here's the relevant section
of the kernel log. Motherboard chipset is Intel X58. Feel free to ask
for anything else.

[ 1333.801243] Digital Devices PCIE bridge driver, Copyright (C) 2010-11
Digital Devices GmbH
[ 1333.801302] DDBridge 0000:08:00.0: PCI INT A -> GSI 32 (level, low)
-> IRQ 32
[ 1333.801314] DDBridge driver detected: Digital Devices Octopus DVB adapter
[ 1333.801357] HW 00010004 FW 00010001
[ 1333.802371] Port 0 (TAB 1): DUAL DVB-C/T
[ 1333.802819] Port 1 (TAB 2): CI
[ 1333.803785] Port 2 (TAB 3): DUAL DVB-C/T
[ 1333.804369] Port 3 (TAB 4): NO MODULE
[ 1333.805176] DVB: registering new adapter (DDBridge)
[ 1333.824506] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
[ 1334.313799] DRXK driver version 0.9.4300
[ 1337.120786] DVB: registering adapter 0 frontend 0 (DRXK DVB-C)...
[ 1337.120996] DVB: registering adapter 0 frontend 0 (DRXK DVB-T)...
[ 1337.121165] DVB: registering new adapter (DDBridge)
[ 1337.151565] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
[ 1337.653400] DRXK driver version 0.9.4300
[ 1340.467888] DVB: registering adapter 1 frontend 0 (DRXK DVB-C)...
[ 1340.468097] DVB: registering adapter 1 frontend 0 (DRXK DVB-T)...
[ 1340.468203] DVB: registering new adapter (DDBridge)
[ 1340.477045] Attached CXD2099AR at 40
[ 1340.477502] DVB: registering new adapter (DDBridge)
[ 1340.498717] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
[ 1340.978018] DRXK driver version 0.9.4300
[ 1343.784964] DVB: registering adapter 3 frontend 0 (DRXK DVB-C)...
[ 1343.785168] DVB: registering adapter 3 frontend 0 (DRXK DVB-T)...
[ 1343.785322] DVB: registering new adapter (DDBridge)
[ 1343.805712] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
[ 1344.295293] DRXK driver version 0.9.4300
[ 1347.062278] DVB: registering adapter 4 frontend 0 (DRXK DVB-C)...
[ 1347.062490] DVB: registering adapter 4 frontend 0 (DRXK DVB-T)...
[ 1347.816555] dvb_ca adapter 2: DVB CAM detected and initialised
successfully


> Regards,
> Ralph
> 
> 
> 
> #include <stdio.h>
> #include <ctype.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <pthread.h>
> 
> uint8_t fill[188]={0x47, 0x1f, 0xff, 0x10,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
>    0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
> 		   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff };
> 
> uint8_t ts[188]={0x47, 0x0a, 0xaa, 0x00 };
> 
> 
> void proc_buf(uint8_t *buf, uint32_t *d)
> {
> 	uint32_t c;
> 
> 	if (buf[1]==0x1f && buf[2]==0xff) {
> 		//printf("fill\n");
> 		return;
> 	}
> 	if (buf[1]==0x9f && buf[2]==0xff) {
> 		//printf("fill\n");
> 		return;
> 	}
> 	if (buf[1]!=0x0a || buf[2]!=0xaa)
> 		return;
> 	c=(buf[4]<<24)|(buf[5]<<16)|(buf[6]<<8)|buf[7];
> 	if (c!=*d) {
> 		printf("CONT ERROR %08x %08x\n", c, *d);
> 		*d=c;
> 	} else {
> 		if (memcmp(ts+8, buf+8, 180))
> 			printf("error\n");
> 		if (!(c&0xffff))
> 			printf("R %d\n", c);
> 	}
> 	(*d)++;
> }
> 
> void *get_ts(void *a)
> {
> 	uint8_t buf[188*1024];
> 	int len, off;
> 
> 	int fdi=open("/dev/dvb/adapter4/sec0", O_RDONLY);
> 	uint32_t d=0;
> 
> 	while (1) {
> 		len=read(fdi, buf, 188*1024);
> 		if (len<0)
> 			continue;
> 		if (buf[0]!=0x47) { //should not happen
> 			read(fdi, buf, 1);
> 			continue;
> 		}
> 		for (off=0; off<len; off+=188) {
> 			proc_buf(buf+off, &d);
> 		}
> 	}	
> }
> 
> #define SNUM 671
> void send(void)
> {
> 	uint8_t buf[188*SNUM], *cts;
> 	int i;
> 	uint32_t c=0;
> 	int fdo;
> 
> 	fdo=open("/dev/dvb/adapter4/sec0", O_WRONLY);
> 
> 
> 	while (1) {
> 		for (i=0; i<SNUM; i++) {
> 			cts=buf+i*188;
> 			memcpy(cts, ts, 188);
> 			cts[4]=(c>>24);
> 			cts[5]=(c>>16);
> 			cts[6]=(c>>8);
> 			cts[7]=c;
> 			//write(fdo, fill, 188);
> 			//printf("S %d\n", c); 
> 			c++;
> 			//usleep(100000+0xffff&rand());
> 			//usleep(1000);
> 		}
> 		write(fdo, buf, 188*SNUM);
> 	}
> }
> 
> 
> int main()
> {
> 	pthread_t th;
> 
> 	memset(ts+8, 180, 0x5a);
> 	pthread_create(&th, NULL, get_ts, NULL);
> 	send();
> }
> 
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Anssi Hannula
