Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab1AJM1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:27:25 -0500
Message-ID: <4D2AFB1D.5080708@redhat.com>
Date: Mon, 10 Jan 2011 10:27:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl> <201101080056.40803@orion.escape-edv.de> <4D2AF5E6.1070007@redhat.com>
In-Reply-To: <4D2AF5E6.1070007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-01-2011 10:04, Mauro Carvalho Chehab escreveu:
> Em 07-01-2011 21:56, Oliver Endriss escreveu:
>> On Friday 07 January 2011 22:06:30 Hans Verkuil wrote:
>>> On Friday, January 07, 2011 21:13:31 Devin Heitmueller wrote:
>>>> On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>>>>> Hi guys,
>>>>>
>>>>> are you aware that there is a lot of '#if 0' code in the HG repositories
>>>>> which is not in GIT?

> As a reference and further discussions, I'm enclosing the diff.

It is now easier to comment on what we have inside the #if 0 code. Let me add
my comments about that.

A general comment after my review is that most of the commented code should
be just discarded, but I agree with Oliver that there are some things there
that we want to preserve.

> 
> ---
> 
> diff -upr /tmp/stripped/drivers/media/common/tuners/tea5767.c /tmp/not_stripped/drivers/media/common/tuners/tea5767.c
> --- /tmp/stripped/drivers/media/common/tuners/tea5767.c	2011-01-10 10:01:50.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/common/tuners/tea5767.c	2011-01-10 10:02:06.000000000 -0200
> @@ -371,6 +371,9 @@ int tea5767_autodetection(struct i2c_ada
>  	struct tuner_i2c_props i2c = { .adap = i2c_adap, .addr = i2c_addr };
>  	unsigned char buffer[7] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>  	int rc;
> +#if 0 /* Needed if uncomment I2C send code below */
> +	int div;
> +#endif
>  
>  	if ((rc = tuner_i2c_xfer_recv(&i2c, buffer, 7))< 5) {
>  		printk(KERN_WARNING "It is not a TEA5767. Received %i bytes.\n", rc);
> @@ -394,7 +397,42 @@ int tea5767_autodetection(struct i2c_ada
>  		return -EINVAL;
>  	}
>  
> +#if 0	/* Not working for TEA5767 in Beholder Columbus card */
> +	/* It seems that tea5767 returns 0xff after the 5th byte */
> +	if ((buffer[5] != 0xff) || (buffer[6] != 0xff)) {
> +		printk(KERN_WARNING "Returned more than 5 bytes. It is not a TEA5767\n");
> +		return -EINVAL;
> +	}
> +#endif
> +
> +#if 0 /*Sometimes, this code doesn't work */
> +	/* Sets tuner at some freq (87.5 MHz) and see if it is ok */
> +	div = ((87500 * 4000 + 700000 + 225000) + 16768) >> 15;
> +	buffer[0] = ((div >> 8) & 0x3f) | TEA5767_MUTE;
> +	buffer[1] = div & 0xff;
> +	buffer[2] = TEA5767_PORT1_HIGH;
> +	buffer[3] = TEA5767_PORT2_HIGH | TEA5767_HIGH_CUT_CTRL |
> +		    TEA5767_ST_NOISE_CTL;
> +	buffer[4] = 0;
> +
> +	if (5 != (rc = tuner_i2c_xfer_send(&i2c, buffer, 5)))
> +		printk(KERN_WARNING "i2c i/o error: rc == %d (should be 5)\n", rc);
> +
> +	msleep(15);
> +
> +	if (5 != (rc = tuner_i2c_xfer_recv(&i2c, buffer, 5))) {
> +		printk(KERN_WARNING "It is not a TEA5767. Received %i bytes.\n", rc);
> +		return -EINVAL;
> +	}
>  
> +	/* Initial freq for 32.768KHz clock */
> +	if ((buffer[1] != (div & 0xff) ) || ((buffer[0] & 0x3f) != ((div >> 8) & 0x3f))) {
> +		printk(KERN_WARNING "It is not a TEA5767. div=%d, Return: %02x %02x %02x %02x %02x\n",
> +				div,buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]);
> +		tea5767_status_dump(buffer);
> +		return -EINVAL;
> +	}
> +#endif
>  	return 0;
>  }
>  
> @@ -443,6 +481,10 @@ struct dvb_frontend *tea5767_attach(stru
>  {
>  	struct tea5767_priv *priv = NULL;
>  
> +#if 0 /* By removing autodetection allows forcing TEA chip */
> +	if (tea5767_autodetection(i2c_adap, i2c_addr) == -EINVAL)
> +		return -EINVAL;
> +#endif
>  	priv = kzalloc(sizeof(struct tea5767_priv), GFP_KERNEL);
>  	if (priv == NULL)
>  		return NULL;

All the #if 0 code there are obsolete. The detection tests
were moved to other place.

> diff -upr /tmp/stripped/drivers/media/common/tuners/tuner-simple.c /tmp/not_stripped/drivers/media/common/tuners/tuner-simple.c
> --- /tmp/stripped/drivers/media/common/tuners/tuner-simple.c	2011-01-10 10:01:50.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/common/tuners/tuner-simple.c	2011-01-10 10:02:06.000000000 -0200
> @@ -161,6 +161,12 @@ static inline int tuner_afcstatus(const 
>  	return (status & TUNER_AFC) - 2;
>  }
>  
> +#if 0 /* unused */
> +static inline int tuner_mode(const int status)
> +{
> +	return (status & TUNER_MODE) >> 3;
> +}
> +#endif
>  
>  static int simple_get_status(struct dvb_frontend *fe, u32 *status)
>  {

No idea about that. Too old for me to remember, but I don't think
we should backport it.

> diff -upr /tmp/stripped/drivers/media/dvb/ngene/ngene-cards.c /tmp/not_stripped/drivers/media/dvb/ngene/ngene-cards.c
> --- /tmp/stripped/drivers/media/dvb/ngene/ngene-cards.c	2011-01-10 10:01:49.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/dvb/ngene/ngene-cards.c	2011-01-10 10:02:05.000000000 -0200
> @@ -272,6 +272,32 @@ static const struct pci_device_id ngene_
>  	NGENE_ID(0x18c3, 0xdd10, ngene_info_duoFlexS2),
>  	NGENE_ID(0x18c3, 0xdd20, ngene_info_duoFlexS2),
>  	NGENE_ID(0x1461, 0x062e, ngene_info_m780),
> +#if 0 /* not (yet?) supported */
> +	NGENE_ID(0x18c3, 0x0000, ngene_info_appboard),
> +	NGENE_ID(0x18c3, 0x0004, ngene_info_appboard),
> +	NGENE_ID(0x18c3, 0x8011, ngene_info_appboard),
> +	NGENE_ID(0x18c3, 0x8015, ngene_info_appboard_ntsc),
> +	NGENE_ID(0x153b, 0x1167, ngene_info_terratec),
> +	NGENE_ID(0x18c3, 0x0030, ngene_info_python),
> +	NGENE_ID(0x18c3, 0x0052, ngene_info_sidewinder),
> +	NGENE_ID(0x18c3, 0x8f00, ngene_info_racer),
> +	NGENE_ID(0x18c3, 0x0041, ngene_info_viper_v1),
> +	NGENE_ID(0x18c3, 0x0042, ngene_info_viper_v2),
> +	NGENE_ID(0x14f3, 0x0041, ngene_info_vbox_v1),
> +	NGENE_ID(0x14f3, 0x0043, ngene_info_vbox_v2),
> +	NGENE_ID(0x18c3, 0xabcd, ngene_info_s2),
> +	NGENE_ID(0x18c3, 0xabc2, ngene_info_s2_b),
> +	NGENE_ID(0x18c3, 0xabc3, ngene_info_s2_b),
> +	NGENE_ID(0x18c3, 0x0001, ngene_info_appboard),
> +	NGENE_ID(0x18c3, 0x0005, ngene_info_appboard),
> +	NGENE_ID(0x18c3, 0x0009, ngene_info_appboard_atsc),
> +	NGENE_ID(0x18c3, 0x000b, ngene_info_appboard_atsc),
> +	NGENE_ID(0x18c3, 0x0010, ngene_info_shrek_50_fp),
> +	NGENE_ID(0x18c3, 0x0011, ngene_info_shrek_60_fp),
> +	NGENE_ID(0x18c3, 0x0012, ngene_info_shrek_50),
> +	NGENE_ID(0x18c3, 0x0013, ngene_info_shrek_60),
> +	NGENE_ID(0x18c3, 0x0000, ngene_info_hognose),
> +#endif
>  	{0}
>  };
>  MODULE_DEVICE_TABLE(pci, ngene_id_tbl);

It is probably a good idea to backport this one. I would change it to #if 1, to allow
people to test (or I would create a CONFIG_NGENE_EXPERIMENTAL to enable such support).

> diff -upr /tmp/stripped/drivers/media/video/bt8xx/bttv-cards.c /tmp/not_stripped/drivers/media/video/bt8xx/bttv-cards.c
> --- /tmp/stripped/drivers/media/video/bt8xx/bttv-cards.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/bt8xx/bttv-cards.c	2011-01-10 10:02:08.000000000 -0200
> @@ -1801,12 +1801,21 @@ struct tvcard bttv_tvcards[] = {
>  		.name           = "Osprey 540",   /* 540 */
>  		.video_inputs   = 4,
>  		/* .audio_inputs= 1, */
> +	#if 0 /* TODO ... */
> +		.svhs           = OSPREY540_SVID_ANALOG,
> +		.muxsel         = {       [OSPREY540_COMP_ANALOG] = 2,
> +					[OSPREY540_SVID_ANALOG] = 3, },
> +	#endif
>  		.pll            = PLL_28,
>  		.tuner_type     = TUNER_ABSENT,
>  		.tuner_addr	= ADDR_UNSET,
>  		.no_msp34xx     = 1,
>  		.no_tda9875     = 1,
>  		.no_tda7432     = 1,
> +	#if 0 /* TODO ... */
> +		.muxsel_hook    = osprey_540_muxsel,
> +		.picture_hook   = osprey_540_set_picture,
> +	#endif
>  	},
>  
>  		/* ---- card 0x5C ---------------------------------- */

We lack documentation about that. I remember I asked once to some contacts at Osprey but
they didn't send me any docs or further info.

> diff -upr /tmp/stripped/drivers/media/video/bt8xx/bttv-driver.c /tmp/not_stripped/drivers/media/video/bt8xx/bttv-driver.c
> --- /tmp/stripped/drivers/media/video/bt8xx/bttv-driver.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/bt8xx/bttv-driver.c	2011-01-10 10:02:08.000000000 -0200
> @@ -937,10 +937,12 @@ disclaim_video_lines(struct bttv *btv)
>  static
>  void free_btres(struct bttv *btv, struct bttv_fh *fh, int bits)
>  {
> +#if 1 /* DEBUG */
>  	if ((fh->resources & bits) != bits) {
>  		/* trying to free ressources not allocated by us ... */
>  		printk("bttv: BUG! (btres)\n");
>  	}
> +#endif
>  	mutex_lock(&btv->lock);
>  	fh->resources  &= ~bits;
>  	btv->resources &= ~bits;

No sense to backport. Yet, a patch is welcome to convert the printk into something better
(maybe BUG_ON?).

> diff -upr /tmp/stripped/drivers/media/video/bt8xx/bttv-risc.c /tmp/not_stripped/drivers/media/video/bt8xx/bttv-risc.c
> --- /tmp/stripped/drivers/media/video/bt8xx/bttv-risc.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/bt8xx/bttv-risc.c	2011-01-10 10:02:08.000000000 -0200
> @@ -349,6 +349,10 @@ bttv_calc_geo_old(struct bttv *btv, stru
>  	}
>  
>  	vdelay = tvnorm->vdelay;
> +#if 0 /* FIXME */
> +	if (vdelay < btv->vbi.lines*2)
> +		vdelay = btv->vbi.lines*2;
> +#endif
>  
>  	xsf = (width*scaledtwidth)/swidth;
>  	geo->hscale =  ((totalwidth*4096UL)/xsf-4096);

VBI works on bttv. Not sure why this code is there.

> diff -upr /tmp/stripped/drivers/media/video/cx88/cx88-core.c /tmp/not_stripped/drivers/media/video/cx88/cx88-core.c
> --- /tmp/stripped/drivers/media/video/cx88/cx88-core.c	2011-01-10 10:01:51.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/cx88/cx88-core.c	2011-01-10 10:02:07.000000000 -0200
> @@ -430,6 +430,25 @@ static int cx88_risc_decode(u32 risc)
>  	return incr[risc >> 28] ? incr[risc >> 28] : 1;
>  }
>  
> +#if 0 /* currently unused, but useful for debugging */
> +void cx88_risc_disasm(struct cx88_core *core,
> +		      struct btcx_riscmem *risc)
> +{
> +	unsigned int i,j,n;
> +
> +	printk("%s: risc disasm: %p [dma=0x%08lx]\n",
> +	       core->name, risc->cpu, (unsigned long)risc->dma);
> +	for (i = 0; i < (risc->size >> 2); i += n) {
> +		printk("%s:   %04d: ", core->name, i);
> +		n = cx88_risc_decode(risc->cpu[i]);
> +		for (j = 1; j < n; j++)
> +			printk("%s:   %04d: 0x%08x [ arg #%d ]\n",
> +			       core->name, i+j, risc->cpu[i+j], j);
> +		if (risc->cpu[i] == RISC_JUMP)
> +			break;
> +	}
> +}
> +#endif
>  
>  void cx88_sram_channel_dump(struct cx88_core *core,
>  			    struct sram_channel *ch)

This might be useful to enable, but the cx88 risc assembler code initialized
by the driver is there for a long time and nobody had to touch on it for a long
time. 

> diff -upr /tmp/stripped/drivers/media/video/cx88/cx88-reg.h /tmp/not_stripped/drivers/media/video/cx88/cx88-reg.h
> --- /tmp/stripped/drivers/media/video/cx88/cx88-reg.h	2011-01-10 10:01:51.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/cx88/cx88-reg.h	2011-01-10 10:02:07.000000000 -0200
> @@ -661,11 +661,18 @@
>  #define EN_I2SIN_STR2DAC        0x00004000
>  #define EN_I2SIN_ENABLE         0x00008000
>  
> +#if 0 /* old */
> +#define EN_DMTRX_SUMDIFF        0x00000800
> +#define EN_DMTRX_SUMR           0x00000880
> +#define EN_DMTRX_LR             0x00000900
> +#define EN_DMTRX_MONO           0x00000980
> +#else /* dscaler cvs */
>  #define EN_DMTRX_SUMDIFF        (0 << 7)
>  #define EN_DMTRX_SUMR           (1 << 7)
>  #define EN_DMTRX_LR             (2 << 7)
>  #define EN_DMTRX_MONO           (3 << 7)
>  #define EN_DMTRX_BYPASS         (1 << 11)
> +#endif
>  
>  // Video
>  #define VID_CAPTURE_CONTROL		0x310180

Seems bogus to me.

> diff -upr /tmp/stripped/drivers/media/video/cx88/cx88-video.c /tmp/not_stripped/drivers/media/video/cx88/cx88-video.c
> --- /tmp/stripped/drivers/media/video/cx88/cx88-video.c	2011-01-10 10:01:51.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/cx88/cx88-video.c	2011-01-10 10:02:07.000000000 -0200
> @@ -719,6 +719,231 @@ static struct videobuf_queue_ops cx8800_
>  
>  /* ------------------------------------------------------------------ */
>  
> +#if 0 /* overlay support not finished yet */
> +static u32* ov_risc_field(struct cx8800_dev *dev, struct cx8800_fh *fh,
> +			  u32 *rp, struct btcx_skiplist *skips,
> +			  u32 sync_line, int skip_even, int skip_odd)
> +{
> +	int line,maxy,start,end,skip,nskips;
> +	u32 ri,ra;
> +	u32 addr;
> +
> +	/* sync instruction */
> +	*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
> +
> +	addr  = (unsigned long)dev->fbuf.base;
> +	addr += dev->fbuf.fmt.bytesperline * fh->win.w.top;
> +	addr += (fh->fmt->depth >> 3)      * fh->win.w.left;
> +
> +	/* scan lines */
> +	for (maxy = -1, line = 0; line < fh->win.w.height;
> +	     line++, addr += dev->fbuf.fmt.bytesperline) {
> +		if ((line%2) == 0  &&  skip_even)
> +			continue;
> +		if ((line%2) == 1  &&  skip_odd)
> +			continue;
> +
> +		/* calculate clipping */
> +		if (line > maxy)
> +			btcx_calc_skips(line, fh->win.w.width, &maxy,
> +					skips, &nskips, fh->clips, fh->nclips);
> +
> +		/* write out risc code */
> +		for (start = 0, skip = 0; start < fh->win.w.width; start = end) {
> +			if (skip >= nskips) {
> +				ri  = RISC_WRITE;
> +				end = fh->win.w.width;
> +			} else if (start < skips[skip].start) {
> +				ri  = RISC_WRITE;
> +				end = skips[skip].start;
> +			} else {
> +				ri  = RISC_SKIP;
> +				end = skips[skip].end;
> +				skip++;
> +			}
> +			if (RISC_WRITE == ri)
> +				ra = addr + (fh->fmt->depth>>3)*start;
> +			else
> +				ra = 0;
> +
> +			if (0 == start)
> +				ri |= RISC_SOL;
> +			if (fh->win.w.width == end)
> +				ri |= RISC_EOL;
> +			ri |= (fh->fmt->depth>>3) * (end-start);
> +
> +			*(rp++)=cpu_to_le32(ri);
> +			if (0 != ra)
> +				*(rp++)=cpu_to_le32(ra);
> +		}
> +	}
> +	kfree(skips);
> +	return rp;
> +}
> +
> +static int ov_risc_frame(struct cx8800_dev *dev, struct cx8800_fh *fh,
> +			 struct cx88_buffer *buf)
> +{
> +	struct btcx_skiplist *skips;
> +	u32 instructions,fields;
> +	u32 *rp;
> +	int rc;
> +
> +	/* skip list for window clipping */
> +	if (NULL == (skips = kmalloc(sizeof(*skips) * fh->nclips,GFP_KERNEL)))
> +		return -ENOMEM;
> +
> +	fields = 0;
> +	if (V4L2_FIELD_HAS_TOP(fh->win.field))
> +		fields++;
> +	if (V4L2_FIELD_HAS_BOTTOM(fh->win.field))
> +		fields++;
> +
> +	/* estimate risc mem: worst case is (clip+1) * lines instructions
> +	   + syncs + jump (all 2 dwords) */
> +	instructions  = (fh->nclips+1) * fh->win.w.height;
> +	instructions += 3 + 4;
> +	if ((rc = btcx_riscmem_alloc(dev->pci,&buf->risc,instructions*8)) < 0) {
> +		kfree(skips);
> +		return rc;
> +	}
> +
> +	/* write risc instructions */
> +	rp = buf->risc.cpu;
> +	switch (fh->win.field) {
> +	case V4L2_FIELD_TOP:
> +		rp = ov_risc_field(dev, fh, rp, skips, 0,     0, 0);
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		rp = ov_risc_field(dev, fh, rp, skips, 0x200, 0, 0);
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		rp = ov_risc_field(dev, fh, rp, skips, 0,     0, 1);
> +		rp = ov_risc_field(dev, fh, rp, skips, 0x200, 1, 0);
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	/* save pointer to jmp instruction address */
> +	buf->risc.jmp = rp;
> +	kfree(skips);
> +	return 0;
> +}
> +
> +static int verify_window(struct cx8800_dev *dev, struct v4l2_window *win)
> +{
> +	enum v4l2_field field;
> +	int maxw, maxh;
> +
> +	if (NULL == dev->fbuf.base)
> +		return -EINVAL;
> +	if (win->w.width < 48 || win->w.height <  32)
> +		return -EINVAL;
> +	if (win->clipcount > 2048)
> +		return -EINVAL;
> +
> +	field = win->field;
> +	maxw  = norm_maxw(core->tvnorm);
> +	maxh  = norm_maxh(core->tvnorm);
> +
> +	if (V4L2_FIELD_ANY == field) {
> +		field = (win->w.height > maxh/2)
> +			? V4L2_FIELD_INTERLACED
> +			: V4L2_FIELD_TOP;
> +	}
> +	switch (field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +		maxh = maxh / 2;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	win->field = field;
> +	if (win->w.width > maxw)
> +		win->w.width = maxw;
> +	if (win->w.height > maxh)
> +		win->w.height = maxh;
> +	return 0;
> +}
> +
> +static int setup_window(struct cx8800_dev *dev, struct cx8800_fh *fh,
> +			struct v4l2_window *win)
> +{
> +	struct v4l2_clip *clips = NULL;
> +	int n,size,retval = 0;
> +
> +	if (NULL == fh->fmt)
> +		return -EINVAL;
> +	retval = verify_window(dev,win);
> +	if (0 != retval)
> +		return retval;
> +
> +	/* copy clips  --  luckily v4l1 + v4l2 are binary
> +	   compatible here ...*/
> +	n = win->clipcount;
> +	size = sizeof(*clips)*(n+4);
> +	clips = kmalloc(size,GFP_KERNEL);
> +	if (NULL == clips)
> +		return -ENOMEM;
> +	if (n > 0) {
> +		if (copy_from_user(clips,win->clips,sizeof(struct v4l2_clip)*n)) {
> +			kfree(clips);
> +			return -EFAULT;
> +		}
> +	}
> +
> +	/* clip against screen */
> +	if (NULL != dev->fbuf.base)
> +		n = btcx_screen_clips(dev->fbuf.fmt.width, dev->fbuf.fmt.height,
> +				      &win->w, clips, n);
> +	btcx_sort_clips(clips,n);
> +
> +	/* 4-byte alignments */
> +	switch (fh->fmt->depth) {
> +	case 8:
> +	case 24:
> +		btcx_align(&win->w, clips, n, 3);
> +		break;
> +	case 16:
> +		btcx_align(&win->w, clips, n, 1);
> +		break;
> +	case 32:
> +		/* no alignment fixups needed */
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	down(&fh->vidq.lock);
> +	if (fh->clips)
> +		kfree(fh->clips);
> +	fh->clips    = clips;
> +	fh->nclips   = n;
> +	fh->win      = *win;
> +/* #if 0 */
> +	fh->ov.setup_ok = 1;
> +/* #endif */
> +
> +	/* update overlay if needed */
> +	retval = 0;
> +/* #if 0 */
> +	if (check_btres(fh, RESOURCE_OVERLAY)) {
> +		struct bttv_buffer *new;
> +
> +		new = videobuf_pci_alloc(sizeof(*new));
> +		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
> +		retval = bttv_switch_overlay(btv,fh,new);
> +	}
> +/* #endif */
> +	up(&fh->vidq.lock);
> +	return retval;
> +}
> +#endif
>  
>  /* ------------------------------------------------------------------ */
>  

This is just a copy of bttv or saa7134 overlay code, that would need to be fixed, if 
someone was interested on adding overlay code to cx88. Overlay mode is dead, due to
Xorg changes. There's no sense on preserving it anymore, except if someone decides
to fix the current apps to work with newer X11 drivers.

> diff -upr /tmp/stripped/drivers/media/video/em28xx/em28xx-cards.c /tmp/not_stripped/drivers/media/video/em28xx/em28xx-cards.c
> --- /tmp/stripped/drivers/media/video/em28xx/em28xx-cards.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/em28xx/em28xx-cards.c	2011-01-10 10:02:08.000000000 -0200
> @@ -106,9 +106,21 @@ static struct em28xx_reg_seq em2880_msi_
>  };
>  
>  /* Boards - EM2880 MSI DIGIVOX AD and EM2880_BOARD_MSI_DIGIVOX_AD_II */
> +#if 0	/* Still missing the dvb setup */
> +static struct em28xx_reg_seq em2880_msi_digivox_ad_digital[] = {
> +	{EM28XX_R08_GPIO,	0x6a,	~EM_GPIO_4,	10},
> +	{	-1,		-1,	-1,		-1},
> +};
> +#endif
>  
>  /* Board  - EM2870 Kworld 355u
>     Analog - No input analog */
> +#if 0	/* Still missing the dvb setup */
> +static struct em28xx_reg_seq em2870_kworld_355u_digital[] = {
> +	{EM2880_R04_GPO,	0x01,	0xff,		10},
> +	{  -1,			-1,	-1,		-1},
> +};
> +#endif
>  
>  /* Board - EM2882 Kworld 315U digital */
>  static struct em28xx_reg_seq em2882_kworld_315u_digital[] = {
> @@ -656,6 +668,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_gpio   = default_tuner_gpio,
>  		.decoder      = EM28XX_TVP5150,
>  
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -758,6 +774,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.valid        = EM28XX_BOARD_NOT_VALIDATED,
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = default_digital,
> +#endif
>  	},
>  	[EM2870_BOARD_TERRATEC_XS_MT2060] = {
>  		.name         = "Terratec Cinergy T XS (MT2060)",
> @@ -769,10 +789,18 @@ struct em28xx_board em28xx_boards[] = {
>  		.valid        = EM28XX_BOARD_NOT_VALIDATED,
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = default_digital,
> +#endif
>  	},
>  	[EM2870_BOARD_KWORLD_355U] = {
>  		.name         = "Kworld 355 U DVB-T",
>  		.valid        = EM28XX_BOARD_NOT_VALIDATED,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = em2870_kworld_355u_digital,
> +#endif
>  	},
>  	[EM2870_BOARD_PINNACLE_PCTV_DVB] = {
>  		.name         = "Pinnacle PCTV DVB-T",
> @@ -848,6 +876,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.mts_firmware = 1,
>  		.ir_codes     = RC_MAP_HAUPPAUGE_NEW,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -1003,6 +1035,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -1245,6 +1281,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = em2880_msi_digivox_ad_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -1268,6 +1308,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = em2880_msi_digivox_ad_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -1394,6 +1438,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_type   = TUNER_XC2028,
>  		.tuner_gpio   = default_tuner_gpio,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = default_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,
> @@ -1442,6 +1490,10 @@ struct em28xx_board em28xx_boards[] = {
>  		.tuner_gpio   = default_tuner_gpio,
>  		.mts_firmware = 1,
>  		.decoder      = EM28XX_TVP5150,
> +#if 0 /* FIXME: add an entry at em28xx-dvb */
> +		.has_dvb      = 1,
> +		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
> +#endif
>  		.input        = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
>  			.vmux     = TVP5150_COMPOSITE0,

The above changes probably deserves a backport.

> diff -upr /tmp/stripped/drivers/media/video/gspca/pac7302.c /tmp/not_stripped/drivers/media/video/gspca/pac7302.c
> --- /tmp/stripped/drivers/media/video/gspca/pac7302.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/gspca/pac7302.c	2011-01-10 10:02:08.000000000 -0200
> @@ -415,6 +415,27 @@ static void reg_w_buf(struct gspca_dev *
>  	}
>  }
>  
> +#if 0 /* not used */
> +static __u8 reg_r(struct gspca_dev *gspca_dev,
> +			     __u8 index)
> +{
> +	int ret;
> +
> +	ret = usb_control_msg(gspca_dev->dev,
> +			usb_rcvctrlpipe(gspca_dev->dev, 0),
> +			0,			/* request */
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0,			/* value */
> +			index, gspca_dev->usb_buf, 1,
> +			500);
> +	if (ret < 0)
> +		PDEBUG(D_ERR, "reg_r(): "
> +		"Failed to read register from index 0x%x, error %i",
> +		index, ret);
> +
> +	return gspca_dev->usb_buf[0];
> +}
> +#endif
>  
>  static void reg_w(struct gspca_dev *gspca_dev,
>  		  __u8 index,

It may make some sense to backport this one.

> diff -upr /tmp/stripped/drivers/media/video/gspca/pac7311.c /tmp/not_stripped/drivers/media/video/gspca/pac7311.c
> --- /tmp/stripped/drivers/media/video/gspca/pac7311.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/gspca/pac7311.c	2011-01-10 10:02:09.000000000 -0200
> @@ -283,6 +283,27 @@ static void reg_w_buf(struct gspca_dev *
>  	}
>  }
>  
> +#if 0 /* not used */
> +static __u8 reg_r(struct gspca_dev *gspca_dev,
> +			     __u8 index)
> +{
> +	int ret;
> +
> +	ret = usb_control_msg(gspca_dev->dev,
> +			usb_rcvctrlpipe(gspca_dev->dev, 0),
> +			0,			/* request */
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			0,			/* value */
> +			index, gspca_dev->usb_buf, 1,
> +			500);
> +	if (ret < 0)
> +		PDEBUG(D_ERR, "reg_r(): "
> +		"Failed to read register from index 0x%x, error %i",
> +		index, ret);
> +
> +	return gspca_dev->usb_buf[0];
> +}
> +#endif
>  
>  static void reg_w(struct gspca_dev *gspca_dev,
>  		  __u8 index,

It may make some sense to backport this one.

> diff -upr /tmp/stripped/drivers/media/video/gspca/stv0680.c /tmp/not_stripped/drivers/media/video/gspca/stv0680.c
> --- /tmp/stripped/drivers/media/video/gspca/stv0680.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/gspca/stv0680.c	2011-01-10 10:02:09.000000000 -0200
> @@ -195,6 +195,19 @@ static int sd_config(struct gspca_dev *g
>  	PDEBUG(D_PROBE, "Sensor ID is %i",
>  	       (gspca_dev->usb_buf[4]*16) + (gspca_dev->usb_buf[5]>>4));
>  
> +#if 0 /* The v4l1 driver used to this but I don't think it is necessary */
> +	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
> +	if (ret < 0) {
> +		PDEBUG(D_ERR, "Set alt 1 failed (%d)", ret);
> +		return ret;
> +	}
> +
> +	if (stv_sndctrl(gspca_dev, 0, 0x85, 0, 0x10) != 0x10)
> +		return stv0680_handle_error(gspca_dev, -EIO);
> +	if (stv_sndctrl(gspca_dev, 0, 0x8d, 0, 0x08) != 0x08)
> +		return stv0680_handle_error(gspca_dev, -EIO);
> +	PDEBUG(D_PROBE, "Camera has %i pictures.", gspca_dev->usb_buf[3]);
> +#endif
>  
>  	ret = stv0680_get_video_mode(gspca_dev);
>  	if (ret < 0)
> @@ -230,6 +243,13 @@ static int sd_config(struct gspca_dev *g
>  	cam->cam_mode = &sd->mode;
>  	cam->nmodes = 1;
>  
> +#if 0 /* The v4l1 driver used to this but I don't think it is necessary */
> +	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 0);
> +	if (ret < 0) {
> +		PDEBUG(D_ERR, "Set alt 0 failed (%d)", ret);
> +		return ret;
> +	}
> +#endif
>  
>  	ret = stv0680_set_video_mode(gspca_dev, sd->orig_mode);
>  	if (ret < 0)

It may be interesting to backport, as it may help to fix some troubles with different
hardware revisions.

> diff -upr /tmp/stripped/drivers/media/video/gspca/vc032x.c /tmp/not_stripped/drivers/media/video/gspca/vc032x.c
> --- /tmp/stripped/drivers/media/video/gspca/vc032x.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/gspca/vc032x.c	2011-01-10 10:02:09.000000000 -0200
> @@ -253,16 +253,37 @@ static const struct v4l2_pix_format vc03
>  		.priv = 2},
>  };
>  static const struct v4l2_pix_format bi_mode[] = {
> +#if 0 /* JPEG vc0323 */
> +	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +		.bytesperline = 320,
> +		.sizeimage = 320 * 240 * 3 / 8 + 590,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.priv = 5},
> +#endif
>  	{320, 240, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
>  		.bytesperline = 320,
>  		.sizeimage = 320 * 240 * 2,
>  		.colorspace = V4L2_COLORSPACE_SRGB,
>  		.priv = 2},
> +#if 0 /* JPEG vc0323 */
> +	{640, 480, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +		.bytesperline = 640,
> +		.sizeimage = 640 * 480 * 3 / 8 + 590,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.priv = 4},
> +#endif
>  	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
>  		.bytesperline = 640,
>  		.sizeimage = 640 * 480 * 2,
>  		.colorspace = V4L2_COLORSPACE_SRGB,
>  		.priv = 1},
> +#if 0 /* JPEG vc0323 */
> +	{1280, 1024, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +		.bytesperline = 1280,
> +		.sizeimage = 1280 * 1024 * 1 / 4 + 590,
> +		.colorspace = V4L2_COLORSPACE_JPEG,
> +		.priv = 3},
> +#endif
>  	{1280, 1024, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
>  		.bytesperline = 1280,
>  		.sizeimage = 1280 * 1024 * 2,
> @@ -1195,6 +1216,123 @@ static const u8 mi1320_soc_InitVGA[][4] 
>  	{0xb3, 0x5c, 0x01, 0xcc},
>  	{}
>  };
> +#if 0 /* JPEG vc0323 */
> +static const u8 mi1320_soc_InitVGA_JPG[][4] = {
> +	{0xb3, 0x01, 0x01, 0xcc},
> +	{0xb0, 0x03, 0x19, 0xcc},
> +	{0xb0, 0x04, 0x02, 0xcc},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0xb3, 0x00, 0x64, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xb3, 0x05, 0x01, 0xcc},
> +	{0xb3, 0x06, 0x01, 0xcc},
> +	{0xb3, 0x08, 0x01, 0xcc},
> +	{0xb3, 0x09, 0x0c, 0xcc},
> +	{0xb3, 0x34, 0x02, 0xcc},
> +	{0xb3, 0x35, 0xc8, 0xcc},
> +	{0xb3, 0x02, 0x00, 0xcc},
> +	{0xb3, 0x03, 0x0a, 0xcc},
> +	{0xb3, 0x04, 0x05, 0xcc},
> +	{0xb3, 0x20, 0x00, 0xcc},
> +	{0xb3, 0x21, 0x00, 0xcc},
> +	{0xb3, 0x22, 0x01, 0xcc},
> +	{0xb3, 0x23, 0xe0, 0xcc},
> +	{0xb3, 0x14, 0x00, 0xcc},
> +	{0xb3, 0x15, 0x00, 0xcc},
> +	{0xb3, 0x16, 0x02, 0xcc},
> +	{0xb3, 0x17, 0x7f, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xb8, 0x00, 0x00, 0xcc},
> +	{0xbc, 0x00, 0x71, 0xcc},
> +	{0xbc, 0x01, 0x01, 0xcc},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x00, 0x00, 0x10, 0xdd},
> +	{0xc8, 0x00, 0x00, 0xbb},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x00, 0x00, 0x10, 0xdd},
> +	{0x07, 0x00, 0xe0, 0xbb},
> +	{0x08, 0x00, 0x0b, 0xbb},
> +	{0x21, 0x00, 0x0c, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0xb6, 0x00, 0x00, 0xcc},
> +	{0xb6, 0x03, 0x02, 0xcc},
> +	{0xb6, 0x02, 0x80, 0xcc},
> +	{0xb6, 0x05, 0x01, 0xcc},
> +	{0xb6, 0x04, 0xe0, 0xcc},
> +	{0xb6, 0x12, 0xf8, 0xcc},
> +	{0xb6, 0x13, 0x05, 0xcc},
> +	{0xb6, 0x18, 0x02, 0xcc},
> +	{0xb6, 0x17, 0x58, 0xcc},
> +	{0xb6, 0x16, 0x00, 0xcc},
> +	{0xb6, 0x22, 0x12, 0xcc},
> +	{0xb6, 0x23, 0x0b, 0xcc},
> +	{0xbf, 0xc0, 0x39, 0xcc},
> +	{0xbf, 0xc1, 0x04, 0xcc},
> +	{0xbf, 0xcc, 0x00, 0xcc},
> +	{0xb3, 0x01, 0x41, 0xcc},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x05, 0x01, 0x78, 0xbb},
> +	{0x06, 0x00, 0x11, 0xbb},
> +	{0x07, 0x01, 0x42, 0xbb},
> +	{0x08, 0x00, 0x11, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0x21, 0x80, 0x00, 0xbb},
> +	{0x22, 0x0d, 0x0f, 0xbb},
> +	{0x24, 0x80, 0x00, 0xbb},
> +	{0x59, 0x00, 0xff, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x39, 0x03, 0xca, 0xbb},
> +	{0x3a, 0x06, 0x80, 0xbb},
> +	{0x3b, 0x01, 0x52, 0xbb},
> +	{0x3c, 0x05, 0x40, 0xbb},
> +	{0x57, 0x01, 0x9c, 0xbb},
> +	{0x58, 0x01, 0xee, 0xbb},
> +	{0x59, 0x00, 0xf0, 0xbb},
> +	{0x5a, 0x01, 0x20, 0xbb},
> +	{0x5c, 0x1d, 0x17, 0xbb},
> +	{0x5d, 0x22, 0x1c, 0xbb},
> +	{0x64, 0x1e, 0x1c, 0xbb},
> +	{0x5b, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x22, 0xa0, 0x78, 0xbb},
> +	{0x23, 0xa0, 0x78, 0xbb},
> +	{0x24, 0x7f, 0x00, 0xbb},
> +	{0x28, 0xea, 0x02, 0xbb},
> +	{0x29, 0x86, 0x7a, 0xbb},
> +	{0x5e, 0x52, 0x4c, 0xbb},
> +	{0x5f, 0x20, 0x24, 0xbb},
> +	{0x60, 0x00, 0x02, 0xbb},
> +	{0x02, 0x00, 0xee, 0xbb},
> +	{0x03, 0x39, 0x23, 0xbb},
> +	{0x04, 0x07, 0x24, 0xbb},
> +	{0x09, 0x00, 0xc0, 0xbb},
> +	{0x0a, 0x00, 0x79, 0xbb},
> +	{0x0b, 0x00, 0x04, 0xbb},
> +	{0x0c, 0x00, 0x5c, 0xbb},
> +	{0x0d, 0x00, 0xd9, 0xbb},
> +	{0x0e, 0x00, 0x53, 0xbb},
> +	{0x0f, 0x00, 0x21, 0xbb},
> +	{0x10, 0x00, 0xa4, 0xbb},
> +	{0x11, 0x00, 0xe5, 0xbb},
> +	{0x15, 0x00, 0x00, 0xbb},
> +	{0x16, 0x00, 0x00, 0xbb},
> +	{0x17, 0x00, 0x00, 0xbb},
> +	{0x18, 0x00, 0x00, 0xbb},
> +	{0x19, 0x00, 0x00, 0xbb},
> +	{0x1a, 0x00, 0x00, 0xbb},
> +	{0x1b, 0x00, 0x00, 0xbb},
> +	{0x1c, 0x00, 0x00, 0xbb},
> +	{0x1d, 0x00, 0x00, 0xbb},
> +	{0x1e, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x01, 0xbb},
> +	{0x06, 0xe0, 0x0e, 0xbb},
> +	{0x06, 0x60, 0x0e, 0xbb},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{}
> +};
> +#endif
>  static const u8 mi1320_soc_InitQVGA[][4] = {
>  	{0xb3, 0x01, 0x01, 0xcc},
>  	{0xb0, 0x03, 0x19, 0xcc},
> @@ -1308,6 +1446,272 @@ static const u8 mi1320_soc_InitQVGA[][4]
>  	{0xb3, 0x5c, 0x01, 0xcc},
>  	{}
>  };
> +#if 0 /* JPEG vc0323 */
> +static const u8 mi1320_soc_InitQVGA_JPG[][4] = {
> +	{0xb3, 0x01, 0x01, 0xcc},
> +	{0xb0, 0x03, 0x19, 0xcc},
> +	{0xb0, 0x04, 0x02, 0xcc},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0xb3, 0x00, 0x64, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xb3, 0x05, 0x01, 0xcc},
> +	{0xb3, 0x06, 0x01, 0xcc},
> +	{0xb3, 0x08, 0x01, 0xcc},
> +	{0xb3, 0x09, 0x0c, 0xcc},
> +	{0xb3, 0x34, 0x02, 0xcc},
> +	{0xb3, 0x35, 0xc8, 0xcc},
> +	{0xb3, 0x02, 0x00, 0xcc},
> +	{0xb3, 0x03, 0x0a, 0xcc},
> +	{0xb3, 0x04, 0x05, 0xcc},
> +	{0xb3, 0x20, 0x00, 0xcc},
> +	{0xb3, 0x21, 0x00, 0xcc},
> +	{0xb3, 0x22, 0x01, 0xcc},
> +	{0xb3, 0x23, 0xe0, 0xcc},
> +	{0xb3, 0x14, 0x00, 0xcc},
> +	{0xb3, 0x15, 0x00, 0xcc},
> +	{0xb3, 0x16, 0x02, 0xcc},
> +	{0xb3, 0x17, 0x7f, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xb8, 0x00, 0x00, 0xcc},
> +	{0xbc, 0x00, 0xd1, 0xcc},
> +	{0xbc, 0x01, 0x01, 0xcc},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x00, 0x00, 0x10, 0xdd},
> +	{0xc8, 0x00, 0x00, 0xbb},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x00, 0x00, 0x10, 0xdd},
> +	{0x07, 0x00, 0xe0, 0xbb},
> +	{0x08, 0x00, 0x0b, 0xbb},
> +	{0x21, 0x00, 0x0c, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0xb6, 0x00, 0x00, 0xcc},
> +	{0xb6, 0x03, 0x01, 0xcc},
> +	{0xb6, 0x02, 0x40, 0xcc},
> +	{0xb6, 0x05, 0x00, 0xcc},
> +	{0xb6, 0x04, 0xf0, 0xcc},
> +	{0xb6, 0x12, 0xf8, 0xcc},
> +	{0xb6, 0x13, 0x05, 0xcc},
> +	{0xb6, 0x18, 0x00, 0xcc},
> +	{0xb6, 0x17, 0x96, 0xcc},
> +	{0xb6, 0x16, 0x00, 0xcc},
> +	{0xb6, 0x22, 0x12, 0xcc},
> +	{0xb6, 0x23, 0x0b, 0xcc},
> +	{0xbf, 0xc0, 0x39, 0xcc},
> +	{0xbf, 0xc1, 0x04, 0xcc},
> +	{0xbf, 0xcc, 0x00, 0xcc},
> +	{0xbc, 0x02, 0x18, 0xcc},
> +	{0xbc, 0x03, 0x50, 0xcc},
> +	{0xbc, 0x04, 0x18, 0xcc},
> +	{0xbc, 0x05, 0x00, 0xcc},
> +	{0xbc, 0x06, 0x00, 0xcc},
> +	{0xbc, 0x08, 0x30, 0xcc},
> +	{0xbc, 0x09, 0x40, 0xcc},
> +	{0xbc, 0x0a, 0x10, 0xcc},
> +	{0xbc, 0x0b, 0x00, 0xcc},
> +	{0xbc, 0x0c, 0x00, 0xcc},
> +	{0xb3, 0x01, 0x41, 0xcc},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x05, 0x01, 0x78, 0xbb},
> +	{0x06, 0x00, 0x11, 0xbb},
> +	{0x07, 0x01, 0x42, 0xbb},
> +	{0x08, 0x00, 0x11, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0x21, 0x80, 0x00, 0xbb},
> +	{0x22, 0x0d, 0x0f, 0xbb},
> +	{0x24, 0x80, 0x00, 0xbb},
> +	{0x59, 0x00, 0xff, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x39, 0x03, 0xca, 0xbb},
> +	{0x3a, 0x06, 0x80, 0xbb},
> +	{0x3b, 0x01, 0x52, 0xbb},
> +	{0x3c, 0x05, 0x40, 0xbb},
> +	{0x57, 0x01, 0x9c, 0xbb},
> +	{0x58, 0x01, 0xee, 0xbb},
> +	{0x59, 0x00, 0xf0, 0xbb},
> +	{0x5a, 0x01, 0x20, 0xbb},
> +	{0x5c, 0x1d, 0x17, 0xbb},
> +	{0x5d, 0x22, 0x1c, 0xbb},
> +	{0x64, 0x1e, 0x1c, 0xbb},
> +	{0x5b, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x22, 0xa0, 0x78, 0xbb},
> +	{0x23, 0xa0, 0x78, 0xbb},
> +	{0x24, 0x7f, 0x00, 0xbb},
> +	{0x28, 0xea, 0x02, 0xbb},
> +	{0x29, 0x86, 0x7a, 0xbb},
> +	{0x5e, 0x52, 0x4c, 0xbb},
> +	{0x5f, 0x20, 0x24, 0xbb},
> +	{0x60, 0x00, 0x02, 0xbb},
> +	{0x02, 0x00, 0xee, 0xbb},
> +	{0x03, 0x39, 0x23, 0xbb},
> +	{0x04, 0x07, 0x24, 0xbb},
> +	{0x09, 0x00, 0xc0, 0xbb},
> +	{0x0a, 0x00, 0x79, 0xbb},
> +	{0x0b, 0x00, 0x04, 0xbb},
> +	{0x0c, 0x00, 0x5c, 0xbb},
> +	{0x0d, 0x00, 0xd9, 0xbb},
> +	{0x0e, 0x00, 0x53, 0xbb},
> +	{0x0f, 0x00, 0x21, 0xbb},
> +	{0x10, 0x00, 0xa4, 0xbb},
> +	{0x11, 0x00, 0xe5, 0xbb},
> +	{0x15, 0x00, 0x00, 0xbb},
> +	{0x16, 0x00, 0x00, 0xbb},
> +	{0x17, 0x00, 0x00, 0xbb},
> +	{0x18, 0x00, 0x00, 0xbb},
> +	{0x19, 0x00, 0x00, 0xbb},
> +	{0x1a, 0x00, 0x00, 0xbb},
> +	{0x1b, 0x00, 0x00, 0xbb},
> +	{0x1c, 0x00, 0x00, 0xbb},
> +	{0x1d, 0x00, 0x00, 0xbb},
> +	{0x1e, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x01, 0xbb},
> +	{0x06, 0xe0, 0x0e, 0xbb},
> +	{0x06, 0x60, 0x0e, 0xbb},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{}
> +};
> +#endif
> +#if 0 /* JPEG vc0323 */
> +static const u8 mi1320_soc_InitSXGA_JPG[][4] = {
> +	{0xb3, 0x01, 0x01, 0xcc},
> +	{0xb0, 0x03, 0x19, 0xcc},
> +	{0xb0, 0x04, 0x02, 0xcc},
> +	{0x00, 0x00, 0x33, 0xdd},
> +	{0xb3, 0x00, 0x64, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xb3, 0x05, 0x00, 0xcc},
> +	{0xb3, 0x06, 0x00, 0xcc},
> +	{0xb3, 0x08, 0x01, 0xcc},
> +	{0xb3, 0x09, 0x0c, 0xcc},
> +	{0xb3, 0x34, 0x02, 0xcc},
> +	{0xb3, 0x35, 0xc8, 0xcc},
> +	{0xb3, 0x02, 0x00, 0xcc},
> +	{0xb3, 0x03, 0x0a, 0xcc},
> +	{0xb3, 0x04, 0x05, 0xcc},
> +	{0xb3, 0x20, 0x00, 0xcc},
> +	{0xb3, 0x21, 0x00, 0xcc},
> +	{0xb3, 0x22, 0x04, 0xcc},
> +	{0xb3, 0x23, 0x00, 0xcc},
> +	{0xb3, 0x14, 0x00, 0xcc},
> +	{0xb3, 0x15, 0x00, 0xcc},
> +	{0xb3, 0x16, 0x04, 0xcc},
> +	{0xb3, 0x17, 0xff, 0xcc},
> +	{0xb3, 0x00, 0x67, 0xcc},
> +	{0xbc, 0x00, 0x71, 0xcc},
> +	{0xbc, 0x01, 0x01, 0xcc},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0xc8, 0x9f, 0x0b, 0xbb},
> +	{0x00, 0x00, 0x20, 0xdd},
> +	{0x5b, 0x00, 0x01, 0xbb},
> +	{0x00, 0x00, 0x20, 0xdd},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x00, 0x00, 0x30, 0xdd},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0x00, 0x00, 0x20, 0xdd},
> +	{0xb6, 0x00, 0x00, 0xcc},
> +	{0xb6, 0x03, 0x05, 0xcc},
> +	{0xb6, 0x02, 0x00, 0xcc},
> +	{0xb6, 0x05, 0x04, 0xcc},
> +	{0xb6, 0x04, 0x00, 0xcc},
> +	{0xb6, 0x12, 0xf8, 0xcc},
> +	{0xb6, 0x13, 0x29, 0xcc},
> +	{0xb6, 0x18, 0x0a, 0xcc},
> +	{0xb6, 0x17, 0x00, 0xcc},
> +	{0xb6, 0x16, 0x00, 0xcc},
> +	{0xb6, 0x22, 0x12, 0xcc},
> +	{0xb6, 0x23, 0x0b, 0xcc},
> +	{0xbf, 0xc0, 0x39, 0xcc},
> +	{0xbf, 0xc1, 0x04, 0xcc},
> +	{0xbf, 0xcc, 0x00, 0xcc},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{0xb3, 0x01, 0x41, 0xcc},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x05, 0x01, 0x78, 0xbb},
> +	{0x06, 0x00, 0x11, 0xbb},
> +	{0x07, 0x01, 0x42, 0xbb},
> +	{0x08, 0x00, 0x11, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0x21, 0x80, 0x00, 0xbb},
> +	{0x22, 0x0d, 0x0f, 0xbb},
> +	{0x24, 0x80, 0x00, 0xbb},
> +	{0x59, 0x00, 0xff, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x39, 0x03, 0xca, 0xbb},
> +	{0x3a, 0x06, 0x80, 0xbb},
> +	{0x3b, 0x01, 0x52, 0xbb},
> +	{0x3c, 0x05, 0x40, 0xbb},
> +	{0x57, 0x01, 0x9c, 0xbb},
> +	{0x58, 0x01, 0xee, 0xbb},
> +	{0x59, 0x00, 0xf0, 0xbb},
> +	{0x5a, 0x01, 0x20, 0xbb},
> +	{0x5c, 0x1d, 0x17, 0xbb},
> +	{0x5d, 0x22, 0x1c, 0xbb},
> +	{0x64, 0x1e, 0x1c, 0xbb},
> +	{0x5b, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x22, 0xa0, 0x78, 0xbb},
> +	{0x23, 0xa0, 0x78, 0xbb},
> +	{0x24, 0x7f, 0x00, 0xbb},
> +	{0x28, 0xea, 0x02, 0xbb},
> +	{0x29, 0x86, 0x7a, 0xbb},
> +	{0x5e, 0x52, 0x4c, 0xbb},
> +	{0x5f, 0x20, 0x24, 0xbb},
> +	{0x60, 0x00, 0x02, 0xbb},
> +	{0x02, 0x00, 0xee, 0xbb},
> +	{0x03, 0x39, 0x23, 0xbb},
> +	{0x04, 0x07, 0x24, 0xbb},
> +	{0x09, 0x00, 0xc0, 0xbb},
> +	{0x0a, 0x00, 0x79, 0xbb},
> +	{0x0b, 0x00, 0x04, 0xbb},
> +	{0x0c, 0x00, 0x5c, 0xbb},
> +	{0x0d, 0x00, 0xd9, 0xbb},
> +	{0x0e, 0x00, 0x53, 0xbb},
> +	{0x0f, 0x00, 0x21, 0xbb},
> +	{0x10, 0x00, 0xa4, 0xbb},
> +	{0x11, 0x00, 0xe5, 0xbb},
> +	{0x15, 0x00, 0x00, 0xbb},
> +	{0x16, 0x00, 0x00, 0xbb},
> +	{0x17, 0x00, 0x00, 0xbb},
> +	{0x18, 0x00, 0x00, 0xbb},
> +	{0x19, 0x00, 0x00, 0xbb},
> +	{0x1a, 0x00, 0x00, 0xbb},
> +	{0x1b, 0x00, 0x00, 0xbb},
> +	{0x1c, 0x00, 0x00, 0xbb},
> +	{0x1d, 0x00, 0x00, 0xbb},
> +	{0x1e, 0x00, 0x00, 0xbb},
> +	{0xf0, 0x00, 0x01, 0xbb},
> +	{0x06, 0xe0, 0x0e, 0xbb},
> +	{0x06, 0x60, 0x0e, 0xbb},
> +	{0xb3, 0x5c, 0x01, 0xcc},
> +	{0xf0, 0x00, 0x00, 0xbb},
> +	{0x05, 0x01, 0x13, 0xbb},
> +	{0x06, 0x00, 0x11, 0xbb},
> +	{0x07, 0x00, 0x85, 0xbb},
> +	{0x08, 0x00, 0x27, 0xbb},
> +	{0x20, 0x01, 0x03, 0xbb},	/* h/v flip */
> +	{0x21, 0x80, 0x00, 0xbb},
> +	{0x22, 0x0d, 0x0f, 0xbb},
> +	{0x24, 0x80, 0x00, 0xbb},
> +	{0x59, 0x00, 0xff, 0xbb},
> +	{0xf0, 0x00, 0x02, 0xbb},
> +	{0x39, 0x03, 0x0d, 0xbb},
> +	{0x3a, 0x06, 0x1b, 0xbb},
> +	{0x3b, 0x00, 0x95, 0xbb},
> +	{0x3c, 0x04, 0xdb, 0xbb},
> +	{0x57, 0x02, 0x00, 0xbb},
> +	{0x58, 0x02, 0x66, 0xbb},
> +	{0x59, 0x00, 0xff, 0xbb},
> +	{0x5a, 0x01, 0x33, 0xbb},
> +	{0x5c, 0x12, 0x0d, 0xbb},
> +	{0x5d, 0x16, 0x11, 0xbb},
> +	{0x64, 0x5e, 0x1c, 0xbb},
> +	{0x2f, 0x90, 0x00, 0xbb},
> +	{}
> +};
> +#endif
>  static const u8 mi1320_soc_InitSXGA[][4] = {
>  	{0xb3, 0x01, 0x01, 0xcc},
>  	{0xb0, 0x03, 0x19, 0xcc},
> @@ -3512,6 +3916,11 @@ static int sd_start(struct gspca_dev *gs
>  		mi1320_soc_InitSXGA,
>  		mi1320_soc_InitVGA,
>  		mi1320_soc_InitQVGA,
> +#if 0 /* JPEG vc0323 */
> +		mi1320_soc_InitSXGA_JPG,
> +		mi1320_soc_InitVGA_JPG,
> +		mi1320_soc_InitQVGA_JPG
> +#endif
>  	};
>  
>  /*fixme: back sensor only*/

I've no idea if the above is useful or not. Maybe Hans or Jean could
give us some hint about that. Eventually, this can be already obsoleted
by some newer gspca patch.

> diff -upr /tmp/stripped/drivers/media/video/gspca/zc3xx.c /tmp/not_stripped/drivers/media/video/gspca/zc3xx.c
> --- /tmp/stripped/drivers/media/video/gspca/zc3xx.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/gspca/zc3xx.c	2011-01-10 10:02:08.000000000 -0200
> @@ -228,7 +228,11 @@ struct usb_action {
>  static const struct usb_action adcm2700_Initial[] = {
>  	{0xa0, 0x01, ZC3XX_R000_SYSTEMCONTROL},		/* 00,00,01,cc */
>  	{0xa0, 0x04, ZC3XX_R002_CLOCKSELECT},		/* 00,02,04,cc */
> +#if 1 /*jfm*/
>  	{0xa0, 0x00, ZC3XX_R008_CLOCKSETTING},		/* 00,08,03,cc */
> +#else
> +	{0xa0, 0x03, ZC3XX_R008_CLOCKSETTING},		/* 00,08,03,cc */
> +#endif
>  	{0xa0, 0x0a, ZC3XX_R010_CMOSSENSORSELECT},	/* 00,10,0a,cc */
>  	{0xa0, 0xd3, ZC3XX_R08B_I2CDEVICEADDR},		/* 00,8b,d3,cc */
>  	{0xa0, 0x02, ZC3XX_R003_FRAMEWIDTHHIGH},	/* 00,03,02,cc */
> @@ -248,7 +252,11 @@ static const struct usb_action adcm2700_
>  	{0xbb, 0x00, 0x0400},				/* 04,00,00,bb */
>  	{0xdd, 0x00, 0x0010},				/* 00,00,10,dd */
>  	{0xbb, 0x0f, 0x140f},				/* 14,0f,0f,bb */
> +#if 1 /*jfm-mswin*/
>  	{0xa0, 0xb7, ZC3XX_R101_SENSORCORRECTION},	/* 01,01,37,cc */
> +#else
> +	{0xa0, 0x37, ZC3XX_R101_SENSORCORRECTION},	/* 01,01,37,cc */
> +#endif
>  	{0xa0, 0x0d, ZC3XX_R100_OPERATIONMODE},		/* 01,00,0d,cc */
>  	{0xa0, 0x06, ZC3XX_R189_AWBSTATUS},		/* 01,89,06,cc */
>  	{0xa0, 0x03, ZC3XX_R1C5_SHARPNESSMODE},		/* 01,c5,03,cc */
> @@ -317,7 +325,11 @@ static const struct usb_action adcm2700_
>  static const struct usb_action adcm2700_InitialScale[] = {
>  	{0xa0, 0x01, ZC3XX_R000_SYSTEMCONTROL},		/* 00,00,01,cc */
>  	{0xa0, 0x10, ZC3XX_R002_CLOCKSELECT},		/* 00,02,10,cc */
> +#if 1 /*jfm*/
>  	{0xa0, 0x00, ZC3XX_R008_CLOCKSETTING},		/* 00,08,03,cc */
> +#else
> +	{0xa0, 0x03, ZC3XX_R008_CLOCKSETTING},		/* 00,08,03,cc */
> +#endif
>  	{0xa0, 0x0a, ZC3XX_R010_CMOSSENSORSELECT},	/* 00,10,0a,cc */
>  	{0xa0, 0xd3, ZC3XX_R08B_I2CDEVICEADDR},		/* 00,8b,d3,cc */
>  	{0xa0, 0x02, ZC3XX_R003_FRAMEWIDTHHIGH},	/* 00,03,02,cc */
> @@ -337,7 +349,11 @@ static const struct usb_action adcm2700_
>  	{0xbb, 0x00, 0x0400},				/* 04,00,00,bb */
>  	{0xdd, 0x00, 0x0010},				/* 00,00,10,dd */
>  	{0xbb, 0x0f, 0x140f},				/* 14,0f,0f,bb */
> +#if 1 /*jfm-mswin*/
>  	{0xa0, 0xb7, ZC3XX_R101_SENSORCORRECTION},	/* 01,01,37,cc */
> +#else
> +	{0xa0, 0x37, ZC3XX_R101_SENSORCORRECTION},	/* 01,01,37,cc */
> +#endif
>  	{0xa0, 0x0d, ZC3XX_R100_OPERATIONMODE},		/* 01,00,0d,cc */
>  	{0xa0, 0x06, ZC3XX_R189_AWBSTATUS},		/* 01,89,06,cc */
>  	{0xa0, 0x03, ZC3XX_R1C5_SHARPNESSMODE},		/* 01,c5,03,cc */
> @@ -365,9 +381,17 @@ static const struct usb_action adcm2700_
>  	{0xbb, 0x5f, 0x2090},				/* 20,5f,90,bb */
>  	{0xbb, 0x01, 0x8000},				/* 80,01,00,bb */
>  	{0xbb, 0x09, 0x8400},				/* 84,09,00,bb */
> +#if 1 /*jfm-mswin*/
>  	{0xbb, 0x86, 0x0002},				/* 00,88,02,bb */
> +#else
> +	{0xbb, 0x88, 0x0002},				/* 00,88,02,bb */
> +#endif
>  	{0xbb, 0xe6, 0x0401},				/* 04,e6,01,bb */
> +#if 1 /*jfm-mswin*/
>  	{0xbb, 0x86, 0x0802},				/* 08,88,02,bb */
> +#else
> +	{0xbb, 0x88, 0x0802},				/* 08,88,02,bb */
> +#endif
>  	{0xbb, 0xe6, 0x0c01},				/* 0c,e6,01,bb */
>  	{0xa0, 0x01, ZC3XX_R010_CMOSSENSORSELECT},	/* 00,10,01,cc */
>  	{0xdd, 0x00, 0x0010},				/* 00,00,10,dd */
> @@ -3159,7 +3183,12 @@ static const struct usb_action mc501cb_N
>  static const struct usb_action ov7620_Initial[] = {	/* 640x480 */
>  	{0xa0, 0x01, ZC3XX_R000_SYSTEMCONTROL}, /* 00,00,01,cc */
>  	{0xa0, 0x40, ZC3XX_R002_CLOCKSELECT}, /* 00,02,40,cc */
> +#if 1 /*jfm*/
>  	{0xa0, 0x00, ZC3XX_R008_CLOCKSETTING}, /* 00,08,00,cc */
> +#else
> +	{0xa0, 0x03, ZC3XX_R008_CLOCKSETTING}, /* 00,08,00,cc */
> +						/* mx change? */
> +#endif
>  	{0xa0, 0x01, ZC3XX_R001_SYSTEMOPERATING}, /* 00,01,01,cc */
>  	{0xa0, 0x06, ZC3XX_R010_CMOSSENSORSELECT}, /* 00,10,06,cc */
>  	{0xa0, 0x02, ZC3XX_R083_RGAINADDR}, /* 00,83,02,cc */

I've no idea if the above is useful or not. Maybe Hans or Jean could
give us some hint about that. Eventually, this can be already obsoleted
by some newer gspca patch.

> diff -upr /tmp/stripped/drivers/media/video/ov7670.c /tmp/not_stripped/drivers/media/video/ov7670.c
> --- /tmp/stripped/drivers/media/video/ov7670.c	2011-01-10 10:01:51.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/ov7670.c	2011-01-10 10:02:07.000000000 -0200
> @@ -500,6 +500,27 @@ static int ov7670_write(struct v4l2_subd
>  }
>  #endif /* CONFIG_OLPC_XO_1 */
>  
> +#if 0 /* Not currently used, but maybe should be  */
> +
> +static int ov7670_write_mask(struct v4l2_subdev *sd, unsigned char reg,
> +		unsigned char value, unsigned char mask)
> +{
> +	unsigned char v;
> +	int ret, tries = 0;
> +
> +	ret = ov7670_read(sd, reg, &v);
> +	if (ret < 0)
> +		return ret;
> +	v &= ~mask;
> +	v |= (value & mask);
> +	msleep(10); /* FIXME experiment */
> +	do {
> +		ret = ov7670_write(sd, reg, v);
> +	} while (ret < 0 && ++tries < 3);
> +	return ret;
> +}
> +
> +#endif
>  
>  /*
>   * Write a list of register settings; ff/ff stops the process.
> @@ -901,6 +922,28 @@ static int ov7670_s_parm(struct v4l2_sub
>   * Code for dealing with controls.
>   */
>  
> +#if 0  /* This seems unneeded after all, should probably come out */
> +/*
> + * Fetch and store the color matrix.
> + */
> +static int ov7670_get_cmatrix(struct v4l2_subdev *sd,
> +	int matrix[CMATRIX_LEN])
> +{
> +	int i, ret;
> +	unsigned char signbits;
> +
> +	ret = ov7670_read(sd, REG_CMATRIX_SIGN, &signbits);
> +	for (i = 0; i < CMATRIX_LEN; i++) {
> +		unsigned char raw;
> +
> +		ret += ov7670_read(sd, REG_CMATRIX_BASE + i, &raw);
> +		matrix[i] = (int) raw;
> +		if (signbits & (1 << i))
> +			matrix[i] *= -1;
> +	}
> +	return ret;
> +}
> +#endif
>  
>  

I've no idea if the above is useful or not.

>  
> diff -upr /tmp/stripped/drivers/media/video/saa7134/saa7134-core.c /tmp/not_stripped/drivers/media/video/saa7134/saa7134-core.c
> --- /tmp/stripped/drivers/media/video/saa7134/saa7134-core.c	2011-01-10 10:01:52.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/saa7134/saa7134-core.c	2011-01-10 10:02:08.000000000 -0200
> @@ -1140,6 +1140,9 @@ static void __devexit saa7134_finidev(st
>  	release_mem_region(pci_resource_start(pci_dev,0),
>  			   pci_resource_len(pci_dev,0));
>  
> +#if 0  /* causes some trouble when reinserting the driver ... */
> +	pci_disable_device(pci_dev);
> +#endif
>  
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  

This is a common issue with several PCI drivers. Maybe it is a good idea to
backport it.

> diff -upr /tmp/stripped/drivers/media/video/tvp5150.c /tmp/not_stripped/drivers/media/video/tvp5150.c
> --- /tmp/stripped/drivers/media/video/tvp5150.c	2011-01-10 10:01:51.000000000 -0200
> +++ /tmp/not_stripped/drivers/media/video/tvp5150.c	2011-01-10 10:02:07.000000000 -0200
> @@ -220,6 +220,10 @@ static int tvp5150_log_status(struct v4l
>  			tvp5150_read(sd, TVP5150_STATUS_REG_3),
>  			tvp5150_read(sd, TVP5150_STATUS_REG_4),
>  			tvp5150_read(sd, TVP5150_STATUS_REG_5));
> +#if 0 /* This will pop a value from vbi reg */
> +	printk("tvp5150: VBI FIFO read data = 0x%02x\n",
> +			tvp5150_read(sd, TVP5150_VBI_FIFO_READ_DATA));
> +#endif
>  
>  	dump_reg_range(sd, "Teletext filter 1",   TVP5150_TELETEXT_FIL1_INI,
>  			TVP5150_TELETEXT_FIL1_END, 8);

Bogus.

> diff -upr /tmp/stripped/include/media/lirc.h /tmp/not_stripped/include/media/lirc.h
> --- /tmp/stripped/include/media/lirc.h	2011-01-10 10:01:49.000000000 -0200
> +++ /tmp/not_stripped/include/media/lirc.h	2011-01-10 10:02:05.000000000 -0200
> @@ -95,6 +95,12 @@
>  #define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
>  #define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
>  
> +#if 0	/* these ioctls are not used at the moment */
> +#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
> +#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
> +#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
> +#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
> +#endif
>  
>  /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
>  #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
> @@ -115,6 +121,23 @@
>   */
>  #define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
>  
> +#if 0	/* these ioctls are not used at the moment */
> +/*
> + * pulses shorter than this are filtered out by hardware (software
> + * emulation in lirc_dev?)
> + */
> +#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x00000019, __u32)
> +/*
> + * spaces shorter than this are filtered out by hardware (software
> + * emulation in lirc_dev?)
> + */
> +#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001a, __u32)
> +/*
> + * if filter cannot be set independantly for pulse/space, this should
> + * be used
> + */
> +#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001b, __u32)
> +#endif
>  
>  /*
>   * to set a range use
> @@ -128,5 +151,13 @@
>  
>  #define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
>  
> +#if 0	/* these ioctls are not used at the moment */
> +/*
> + * from the next key press on the driver will send
> + * LIRC_MODE2_FREQUENCY packets
> + */
> +#define LIRC_MEASURE_CARRIER_ENABLE    _IO('i', 0x00000021)
> +#define LIRC_MEASURE_CARRIER_DISABLE   _IO('i', 0x00000022)
> +#endif
>  
>  #endif

I think that the above were already backported.

> diff -upr /tmp/stripped/include/media/saa6752hs.h /tmp/not_stripped/include/media/saa6752hs.h
> --- /tmp/stripped/include/media/saa6752hs.h	2011-01-10 10:01:49.000000000 -0200
> +++ /tmp/not_stripped/include/media/saa6752hs.h	2011-01-10 10:02:05.000000000 -0200
> @@ -18,6 +18,53 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>  
> +#if 0 /* ndef _SAA6752HS_H */
> +#define _SAA6752HS_H
> +
> +enum mpeg_video_bitrate_mode {
> +	MPEG_VIDEO_BITRATE_MODE_VBR = 0, /* Variable bitrate */
> +	MPEG_VIDEO_BITRATE_MODE_CBR = 1, /* Constant bitrate */
> +
> +	MPEG_VIDEO_BITRATE_MODE_MAX
> +};
> +
> +enum mpeg_audio_bitrate {
> +	MPEG_AUDIO_BITRATE_256 = 0, /* 256 kBit/sec */
> +	MPEG_AUDIO_BITRATE_384 = 1, /* 384 kBit/sec */
> +
> +	MPEG_AUDIO_BITRATE_MAX
> +};
> +
> +enum mpeg_video_format {
> +	MPEG_VIDEO_FORMAT_D1 = 0,
> +	MPEG_VIDEO_FORMAT_2_3_D1 = 1,
> +	MPEG_VIDEO_FORMAT_1_2_D1 = 2,
> +	MPEG_VIDEO_FORMAT_SIF = 3,
> +
> +	MPEG_VIDEO_FORMAT_MAX
> +};
> +
> +#define MPEG_VIDEO_TARGET_BITRATE_MAX 27000
> +#define MPEG_VIDEO_MAX_BITRATE_MAX 27000
> +#define MPEG_TOTAL_BITRATE_MAX 27000
> +#define MPEG_PID_MAX ((1 << 14) - 1)
> +
> +struct mpeg_params {
> +	enum mpeg_video_bitrate_mode video_bitrate_mode;
> +	unsigned int video_target_bitrate;
> +	unsigned int video_max_bitrate; // only used for VBR
> +	enum mpeg_audio_bitrate audio_bitrate;
> +	unsigned int total_bitrate;
> +
> +	unsigned int pmt_pid;
> +	unsigned int video_pid;
> +	unsigned int audio_pid;
> +	unsigned int pcr_pid;
> +
> +	enum mpeg_video_format video_format;
> +};
> +
> +#endif // _SAA6752HS_H

Probably bogus. Nobody is working with saa6752hs anymore. This is an old hardware,
and this patch just adds some unused info to the header file.

Cheers,
Mauro
