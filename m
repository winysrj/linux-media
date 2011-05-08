Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:48103 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1EHQpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 12:45:25 -0400
Message-ID: <4DC6C87C.1090100@usa.net>
Date: Sun, 08 May 2011 18:44:44 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>, Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>	<4DC5622A.9040403@usa.net> <19909.47855.351946.831380@morden.metzler>
In-Reply-To: <19909.47855.351946.831380@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 07/05/11 23:34, Ralph Metzler wrote:
> Before blaming packet loss on the CI data path also please make
> certain that you have no buffer overflows in the input part of 
> the sec device.
> In the ngene driver you can e.g. add a printk in tsin_exchange():
>
> if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
> ...
> } else
>     printk ("buffer overflow !!!!\n");

Ralph,

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
        } else
            printk (KERN_WARNING "ngene transport interface:
tsin_exchange: buffer overflow !!!!\n");

        return 0;
    }
    if (chan->users > 0) {
        dvb_dmx_swfilter(&chan->demux, buf, len);
    }
    return NULL;
}



just prints the buffer overflow warning just after the module is loaded,
no other action made.
