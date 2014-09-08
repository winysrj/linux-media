Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48095 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaIHMky (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 08:40:54 -0400
Date: Mon, 8 Sep 2014 14:40:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] firewire: firedtv-avc: potential buffer
 overflow
Message-ID: <20140908144033.42a0762d@kant>
In-Reply-To: <20140908140502.20d6f864@kant>
References: <20140908111843.GC6947@mwanda>
	<20140908140502.20d6f864@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 08 Stefan Richter wrote:
> On Sep 08 Dan Carpenter wrote:
> > "program_info_length" is user controlled and can go up to 4095.  The
> > operand[] array has 509 bytes so we need to add a limit here to prevent
> > buffer overflows.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Thank you.

Oops, that was a bit too quick.  After the memcpy() accesses which you
protect, there are another four bytes written, still without checking
the bounds.

> > 
> > diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
> > index d1a1a13..ac17567 100644
> > --- a/drivers/media/firewire/firedtv-avc.c
> > +++ b/drivers/media/firewire/firedtv-avc.c
> > @@ -1157,6 +1157,10 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
> >  		if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
> >  			dev_err(fdtv->device,
> >  				"invalid pmt_cmd_id %d\n", pmt_cmd_id);
> > +		if (program_info_length > sizeof(c->operand) - write_pos) {

So I suggest something like this instead:

+		if (program_info_length > sizeof(c->operand) - 4 - write_pos) {

> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> >  
> >  		memcpy(&c->operand[write_pos], &msg[read_pos],
> >  		       program_info_length);
> > @@ -1180,6 +1184,11 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
> >  				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
> >  					"at stream level\n", pmt_cmd_id);
> >  
> > +			if (es_info_length > sizeof(c->operand) - write_pos) {

And likewise:

+			if (es_info_length > sizeof(c->operand) - 4 - write_pos) {

> > +				ret = -EINVAL;
> > +				goto out;
> > +			}
> > +
> >  			memcpy(&c->operand[write_pos], &msg[read_pos],
> >  			       es_info_length);
> >  			read_pos += es_info_length;

FYI, after this follows:

			write_pos += es_info_length;
		}
	}
	write_pos += 4; /* CRC */

	c->operand[7] = 0x82;
	c->operand[8] = (write_pos - 10) >> 8;
	c->operand[9] = (write_pos - 10) & 0xff;
	c->operand[14] = write_pos - 15;

	crc32_csum = crc32_be(0, &c->operand[10], c->operand[12] - 1);
	c->operand[write_pos - 4] = (crc32_csum >> 24) & 0xff;
	c->operand[write_pos - 3] = (crc32_csum >> 16) & 0xff;
	c->operand[write_pos - 2] = (crc32_csum >>  8) & 0xff;
	c->operand[write_pos - 1] = (crc32_csum >>  0) & 0xff;
	pad_operands(c, write_pos);

	fdtv->avc_data_length = ALIGN(3 + write_pos, 4);
	ret = avc_write(fdtv);


And pad_operands() is defined in the same source file as:

#define LAST_OPERAND (509 - 1)

static inline void clear_operands(struct avc_command_frame *c, int from, int to)
{
	memset(&c->operand[from], 0, to - from + 1);
}

static void pad_operands(struct avc_command_frame *c, int from)
{
	int to = ALIGN(from, 4);

	if (from <= to && to <= LAST_OPERAND)
		clear_operands(c, from, to);
}

BTW, the calculation of "to" in pad_operands appears to be wrong, but this does
not affect Dan's patch.  I will send an extra patch for that.

Regards,
-- 
Stefan Richter
-=====-====- =--= -=---
http://arcgraph.de/sr/
