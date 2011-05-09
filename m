Return-path: <mchehab@gaivota>
Received: from cmsout02.mbox.net ([165.212.64.32]:48365 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1EIAmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 20:42:38 -0400
Message-ID: <4DC73854.7090104@usa.net>
Date: Mon, 09 May 2011 02:41:56 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>, Oliver Endriss <o.endriss@gmx.de>,
	Martin Vidovic <xtronom@gmail.com>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>	<4DC5622A.9040403@usa.net> <19909.47855.351946.831380@morden.metzler>
In-Reply-To: <19909.47855.351946.831380@morden.metzler>
Content-Type: multipart/mixed;
 boundary="------------000104010406020002080907"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------000104010406020002080907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/05/11 23:34, Ralph Metzler wrote:
> I do not have any cxd2099 issues.
> I have a simple test program which includes a 32bit counter as payload 
> and can pump data through the CI with full speed and have no packet
> loss. I only tested decoding with an ORF stream and an Alphacrypt CAM
> but also had no problems with this.
>
> Please take care not to write data faster than it is read. Starting two
> dds will not guarantee this. To be certain you could write a small
> program which never writes more packets than input buffer size minus
> the number of read packets (and minus the stuffing null packets on ngene).
>
> Before blaming packet loss on the CI data path also please make
> certain that you have no buffer overflows in the input part of 
> the sec device.
> In the ngene driver you can e.g. add a printk in tsin_exchange():
>
> if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
> ...
> } else
>     printk ("buffer overflow !!!!\n");
>
>
> Regards,
> Ralph

Ralph,

As mentioned earlier, the warning message in tsin_exchange() is somewhat
useless because it is printed endlessly at module start.

However, I've written the small test (attached) and took care to not
write more than read (not taking account of null packets).

I still cannot descrambled channels. I'm using the source from 2.6.39 rc
5 with the fix from Oliver
[http://linuxtv.org/hg/~endriss/v4l-dvb/rev/3d3e6ec2d0a7].  I launched
gnutv with output to dvr, and launched my tool to read from dvr,
write/read from sec0, write to a file.

The end result is a file which is clean of null packets, but cannot be
played by mplayer (no audio, or no video, or both...)

I don't know if CAT needs to be in the stream passed through sec0 as
Sebastien mentioned, so I modified gnutv to add it to dvr.

Sebastien, Martin, could you try Ralph suggestion and post results as
well. Thx.


Please also find an update of ngene-dvb.c, the sec device now handles
blocking/non blocking access.

--
Issa

--------------000104010406020002080907
Content-Type: text/x-csrc;
 name="dvbloop.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dvbloop.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>

static void signal_handler(int _signal);
static int quit_app = 0;

int main(int argc, char *argv[])
{
	signal(SIGINT, signal_handler);

	if (argc <= 3)
		exit(1);	

	int in_fd = open(argv[1], O_RDONLY);
	int out_fd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
	int tsi_fd = open(argv[3], O_RDWR);

	int rlen = 0;
	int wlen = 0;
	int rtsilen = 0;
	int wtsilen = 0;

	int BUFFY = 188 * 20;
	unsigned char buf[BUFFY];
	struct timespec sl[1];
	sl[0].tv_nsec = 250000;
	
	while (!quit_app)
	{
		// read from input (DVR or other)
		rlen = read(in_fd, buf, BUFFY);
		if (rlen > 0)
		{
			// write data to caio device
			wlen = write(tsi_fd, buf, rlen);
			if (wlen != rlen)
			{
				perror("Did not write same amount of data from input to caio!!!");
				exit(1);
			}/* else
				printf("written %d bytes in tsi\n", wlen);
	*/	}

		if (rlen < BUFFY)
		{
			nanosleep(sl, NULL);
		}

		if (rlen < 188)
			continue;


		// read data from caio device - should be decrypted
		// finding sync byte
		do {
			rtsilen = read(tsi_fd, buf, 1);
		//	printf("reading one byte: %02x from tsi\n", buf[0]);
			if (rtsilen && (buf[0] == 0x47)) {
				do {
					int i = read(tsi_fd, buf + rtsilen, 188 - rtsilen);
					rtsilen += i;
		//			printf("reading %d bytes from tsi\n", i);
				} while (rtsilen < 188);

				break;
			}
		} while (1);

//printf("sync byte found: %02x \n", buf[0]);

		wtsilen = 0;
		do {
//			printf("from tsi out: %x %x %x \n", buf[0], buf[1], buf[2]);
			if (buf[0] == 0x47 && buf[1] == 0x1F && buf[2] == 0xFF) {
				// DVB null packet, discard
			} else {
				// write packet to output
				wtsilen += write(out_fd, buf, 188);
			}

			if (rlen == wtsilen)
				break;

			rtsilen = 0;
			do {
				rtsilen += read(tsi_fd, buf + rtsilen, 188 - rtsilen);
			} while (rtsilen < 188);
		} while (1);
	}

	close(in_fd);
	close(out_fd);
	close(tsi_fd);

	exit(0);
}


static void signal_handler(int _signal)
{
	if (!quit_app)
	{
		quit_app = 1;
	}
}

--------------000104010406020002080907
Content-Type: text/x-csrc;
 name="ngene-dvb.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ngene-dvb.c"

/*
 * ngene-dvb.c: nGene PCIe bridge driver - DVB functions
 *
 * Copyright (C) 2005-2007 Micronas
 *
 * Copyright (C) 2008-2009 Ralph Metzler <rjkm@metzlerbros.de>
 *                         Modifications for new nGene firmware,
 *                         support for EEPROM-copying,
 *                         support for new dual DVB-S2 card prototype
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 only, as published by the Free Software Foundation.
 *
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/io.h>
#include <asm/div64.h>
#include <linux/pci.h>
#include <linux/timer.h>
#include <linux/byteorder/generic.h>
#include <linux/firmware.h>
#include <linux/vmalloc.h>

#include "ngene.h"


/****************************************************************************/
/* COMMAND API interface ****************************************************/
/****************************************************************************/

static ssize_t ts_write(struct file *file, const char *buf,
			size_t count, loff_t *ppos)
{
	struct dvb_device *dvbdev = file->private_data;
	struct ngene_channel *chan = dvbdev->priv;
	struct ngene *dev = chan->dev;

/*
	if (wait_event_interruptible(dev->tsout_rbuf.queue,
				     dvb_ringbuffer_free
				     (&dev->tsout_rbuf) >= count) < 0)
		return 0;

	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, count);

	return count;
*/
	int avail;
	char nonblock;

	nonblock = file->f_flags & O_NONBLOCK;

	if (!count)
		return 0;

	if (nonblock) {
		avail = dvb_ringbuffer_avail(&dev->tsout_rbuf);
		if (!avail)
			return -EAGAIN;
	} else {
		while (1) {
			if (wait_event_interruptible(dev->tsout_rbuf.queue,
						     dvb_ringbuffer_free
						     (&dev->tsout_rbuf) >= count) >= 0)
				break;
		}
		avail = count;
	}

	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, avail);
	return avail;

}

static ssize_t ts_read(struct file *file, char *buf,
		       size_t count, loff_t *ppos)
{
	struct dvb_device *dvbdev = file->private_data;
	struct ngene_channel *chan = dvbdev->priv;
	struct ngene *dev = chan->dev;
/*	int left, avail;

	left = count;
	while (left) {
		if (wait_event_interruptible(
			    dev->tsin_rbuf.queue,
			    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
			return -EAGAIN;
		avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
		if (avail > left)
			avail = left;
		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
		left -= avail;
		buf += avail;
	}
	return count;
*/
	int avail = 0;
	char nonblock;

	nonblock = file->f_flags & O_NONBLOCK;

	if (!count)
		return 0;

	if (nonblock) {
		avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
	} else {
		while (!avail) {
			if (wait_event_interruptible(
				    dev->tsin_rbuf.queue,
				    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
				continue;

			avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
		}
	}

	if (avail > count)
		avail = count;
	if (avail > 0)
		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);

	if (!avail)
		return -EAGAIN;
	else
		return avail;

}

static const struct file_operations ci_fops = {
	.owner   = THIS_MODULE,
	.read    = ts_read,
	.write   = ts_write,
	.open    = dvb_generic_open,
	.release = dvb_generic_release,
};

struct dvb_device ngene_dvbdev_ci = {
	.priv    = 0,
	.readers = 1,
	.writers = 1,
	.users   = 2,
	.fops    = &ci_fops,
};


/****************************************************************************/
/* DVB functions and API interface ******************************************/
/****************************************************************************/

static void swap_buffer(u32 *p, u32 len)
{
	while (len) {
		*p = swab32(*p);
		p++;
		len -= 4;
	}
}

void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
{
	struct ngene_channel *chan = priv;
	struct ngene *dev = chan->dev;


	if (flags & DF_SWAP32)
		swap_buffer(buf, len);
	if (dev->ci.en && chan->number == 2) {
		if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
			dvb_ringbuffer_write(&dev->tsin_rbuf, buf, len);
			wake_up_interruptible(&dev->tsin_rbuf.queue);
		}

		return 0;
	}
	if (chan->users > 0) {
		dvb_dmx_swfilter(&chan->demux, buf, len);
	}
	return NULL;
}

u8 fill_ts[188] = { 0x47, 0x1f, 0xff, 0x10 };

void *tsout_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
{
	struct ngene_channel *chan = priv;
	struct ngene *dev = chan->dev;
	u32 alen;

	alen = dvb_ringbuffer_avail(&dev->tsout_rbuf);
	alen -= alen % 188;

	if (alen < len)
		FillTSBuffer(buf + alen, len - alen, flags);
	else
		alen = len;
	dvb_ringbuffer_read(&dev->tsout_rbuf, buf, alen);
	if (flags & DF_SWAP32)
		swap_buffer((u32 *)buf, alen);
	wake_up_interruptible(&dev->tsout_rbuf.queue);
	return buf;
}



int ngene_start_feed(struct dvb_demux_feed *dvbdmxfeed)
{
	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
	struct ngene_channel *chan = dvbdmx->priv;

	if (chan->users == 0) {
		if (!chan->dev->cmd_timeout_workaround || !chan->running)
			set_transfer(chan, 1);
	}

	return ++chan->users;
}

int ngene_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
{
	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
	struct ngene_channel *chan = dvbdmx->priv;

	if (--chan->users)
		return chan->users;

	if (!chan->dev->cmd_timeout_workaround)
		set_transfer(chan, 0);

	return 0;
}

int my_dvb_dmx_ts_card_init(struct dvb_demux *dvbdemux, char *id,
			    int (*start_feed)(struct dvb_demux_feed *),
			    int (*stop_feed)(struct dvb_demux_feed *),
			    void *priv)
{
	dvbdemux->priv = priv;

	dvbdemux->filternum = 256;
	dvbdemux->feednum = 256;
	dvbdemux->start_feed = start_feed;
	dvbdemux->stop_feed = stop_feed;
	dvbdemux->write_to_decoder = NULL;
	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
				      DMX_SECTION_FILTERING |
				      DMX_MEMORY_BASED_FILTERING);
	return dvb_dmx_init(dvbdemux);
}

int my_dvb_dmxdev_ts_card_init(struct dmxdev *dmxdev,
			       struct dvb_demux *dvbdemux,
			       struct dmx_frontend *hw_frontend,
			       struct dmx_frontend *mem_frontend,
			       struct dvb_adapter *dvb_adapter)
{
	int ret;

	dmxdev->filternum = 256;
	dmxdev->demux = &dvbdemux->dmx;
	dmxdev->capabilities = 0;
	ret = dvb_dmxdev_init(dmxdev, dvb_adapter);
	if (ret < 0)
		return ret;

	hw_frontend->source = DMX_FRONTEND_0;
	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, hw_frontend);
	mem_frontend->source = DMX_MEMORY_FE;
	dvbdemux->dmx.add_frontend(&dvbdemux->dmx, mem_frontend);
	return dvbdemux->dmx.connect_frontend(&dvbdemux->dmx, hw_frontend);
}

--------------000104010406020002080907--
