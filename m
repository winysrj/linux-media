Return-path: <mchehab@gaivota>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:60511 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1EMLyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 07:54:45 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19917.7169.579857.44894@morden.metzler>
Date: Fri, 13 May 2011 13:54:41 +0200
To: Issa Gorissen <flop.m@usa.net>
Cc: Ralph Metzler <rjkm@metzlerbros.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	S-bastien RAILLARD <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
In-Reply-To: <4DCC45D7.8090405@usa.net>
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
	<4DCC45D7.8090405@usa.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Issa Gorissen writes:
 > On 11/05/11 15:12, Issa Gorissen wrote:
 > > From: Ralph Metzler <rjkm@metzlerbros.de>
 > >> Issa Gorissen writes:
 > >>  > Could you please take a look at the cxd2099 issues ?
 > >>  > 
 > >>  > I have attached a version with my changes. I have tested a lot of
 > >>  > different settings with the help of the chip datasheet.
 > >>  > 
 > >>  > Scrambled programs are not handled correctly. I don't know if it is the
 > >>  > TICLK/MCLKI which is too high or something, or the sync detector ? Also,
 > >>  > as we have to set the TOCLK to max of 72MHz, there are way too much null
 > >>  > packets added. Is there a way to solve this ?
 > >>
 > >> I do not have any cxd2099 issues.
 > >> I have a simple test program which includes a 32bit counter as payload 
 > >> and can pump data through the CI with full speed and have no packet
 > >> loss. I only tested decoding with an ORF stream and an Alphacrypt CAM
 > >> but also had no problems with this.
 > >>
 > >> Please take care not to write data faster than it is read. Starting two
 > >> dds will not guarantee this. To be certain you could write a small
 > >> program which never writes more packets than input buffer size minus
 > >> the number of read packets (and minus the stuffing null packets on ngene).
 > >>
 > >> Before blaming packet loss on the CI data path also please make
 > >> certain that you have no buffer overflows in the input part of 
 > >> the sec device.
 > >> In the ngene driver you can e.g. add a printk in tsin_exchange():
 > >>
 > >> if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
 > >> ...
 > >> } else
 > >>     printk ("buffer overflow !!!!\n");
 > >>
 > >>
 > >> Regards,
 > >> Ralph
 > Ralph,
 > 
OB > Done some more tests, from by test tool, I found out that I have to skip
 > (rather often) bytes to find the sync one when reading from sec0. I
 > thought I only needed to do that at the start of the stream, not in the
 > middle; because I always read/write 188 bytes from it.

This should not happen. 
Is there any difference regarding this alignment problem if the CI is inserted or not?

 
 > Could you share your test code ? I'm finding it difficult to interact
 > with this sec0 implementation.


Below my test code. You just need to adjust the device name.

I had it running for an hour and had no discontinuities (except at
restarts, might have to look into buffer flushing).
I tested it with nGene and Octopus boards on an Asus ION2 board and on a
Marvell Kirkwood based ARM board.

Btw., what hardware exactly are you using? 
Which DVB card version, CI type, motherboard chipset?


Regards,
Ralph



#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <pthread.h>

uint8_t fill[188]={0x47, 0x1f, 0xff, 0x10,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
		   0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff };

uint8_t ts[188]={0x47, 0x0a, 0xaa, 0x00 };


void proc_buf(uint8_t *buf, uint32_t *d)
{
	uint32_t c;

	if (buf[1]==0x1f && buf[2]==0xff) {
		//printf("fill\n");
		return;
	}
	if (buf[1]==0x9f && buf[2]==0xff) {
		//printf("fill\n");
		return;
	}
	if (buf[1]!=0x0a || buf[2]!=0xaa)
		return;
	c=(buf[4]<<24)|(buf[5]<<16)|(buf[6]<<8)|buf[7];
	if (c!=*d) {
		printf("CONT ERROR %08x %08x\n", c, *d);
		*d=c;
	} else {
		if (memcmp(ts+8, buf+8, 180))
			printf("error\n");
		if (!(c&0xffff))
			printf("R %d\n", c);
	}
	(*d)++;
}

void *get_ts(void *a)
{
	uint8_t buf[188*1024];
	int len, off;

	int fdi=open("/dev/dvb/adapter4/sec0", O_RDONLY);
	uint32_t d=0;

	while (1) {
		len=read(fdi, buf, 188*1024);
		if (len<0)
			continue;
		if (buf[0]!=0x47) { //should not happen
			read(fdi, buf, 1);
			continue;
		}
		for (off=0; off<len; off+=188) {
			proc_buf(buf+off, &d);
		}
	}	
}

#define SNUM 671
void send(void)
{
	uint8_t buf[188*SNUM], *cts;
	int i;
	uint32_t c=0;
	int fdo;

	fdo=open("/dev/dvb/adapter4/sec0", O_WRONLY);


	while (1) {
		for (i=0; i<SNUM; i++) {
			cts=buf+i*188;
			memcpy(cts, ts, 188);
			cts[4]=(c>>24);
			cts[5]=(c>>16);
			cts[6]=(c>>8);
			cts[7]=c;
			//write(fdo, fill, 188);
			//printf("S %d\n", c); 
			c++;
			//usleep(100000+0xffff&rand());
			//usleep(1000);
		}
		write(fdo, buf, 188*SNUM);
	}
}


int main()
{
	pthread_t th;

	memset(ts+8, 180, 0x5a);
	pthread_create(&th, NULL, get_ts, NULL);
	send();
}

 
