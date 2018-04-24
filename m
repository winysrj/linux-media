Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753919AbeDXJLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:11:30 -0400
Date: Tue, 24 Apr 2018 17:10:57 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linux-next:master 1383/2517] sound/isa/ad1816a/ad1816a_lib.c:93:14:
 sparse: restricted snd_pcm_format_t degrades to integer
Message-ID: <201804241753.xKE1J7lG%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   43cd1f4979998ba0ef1c0b8e1c5d23d2de5ab172
commit: da112f13996de6e8dc0011f77ce8f7d0353dd14e [1383/2517] media: sound, isapnp: allow building more drivers with COMPILE_TEST
reproduce:
        # apt-get install sparse
        git checkout da112f13996de6e8dc0011f77ce8f7d0353dd14e
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> sound/isa/ad1816a/ad1816a_lib.c:93:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/ad1816a/ad1816a_lib.c:96:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/ad1816a/ad1816a_lib.c:99:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/ad1816a/ad1816a_lib.c:102:14: sparse: restricted snd_pcm_format_t degrades to integer
>> sound/isa/ad1816a/ad1816a_lib.c:253:53: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned int [unsigned] format @@    got restricted snd_unsigned int [unsigned] format @@
   sound/isa/ad1816a/ad1816a_lib.c:253:53:    expected unsigned int [unsigned] format
   sound/isa/ad1816a/ad1816a_lib.c:253:53:    got restricted snd_pcm_format_t [usertype] format
   sound/isa/ad1816a/ad1816a_lib.c:285:53: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned int [unsigned] format @@    got restricted snd_unsigned int [unsigned] format @@
   sound/isa/ad1816a/ad1816a_lib.c:285:53:    expected unsigned int [unsigned] format
   sound/isa/ad1816a/ad1816a_lib.c:285:53:    got restricted snd_pcm_format_t [usertype] format

vim +93 sound/isa/ad1816a/ad1816a_lib.c

^1da177e4 Linus Torvalds 2005-04-16   85  
^1da177e4 Linus Torvalds 2005-04-16   86  
cbdd0dd15 Takashi Iwai   2005-11-17   87  static unsigned char snd_ad1816a_get_format(struct snd_ad1816a *chip,
^1da177e4 Linus Torvalds 2005-04-16   88  					    unsigned int format, int channels)
^1da177e4 Linus Torvalds 2005-04-16   89  {
^1da177e4 Linus Torvalds 2005-04-16   90  	unsigned char retval = AD1816A_FMT_LINEAR_8;
^1da177e4 Linus Torvalds 2005-04-16   91  
^1da177e4 Linus Torvalds 2005-04-16   92  	switch (format) {
^1da177e4 Linus Torvalds 2005-04-16  @93  	case SNDRV_PCM_FORMAT_MU_LAW:
^1da177e4 Linus Torvalds 2005-04-16   94  		retval = AD1816A_FMT_ULAW_8;
^1da177e4 Linus Torvalds 2005-04-16   95  		break;
^1da177e4 Linus Torvalds 2005-04-16   96  	case SNDRV_PCM_FORMAT_A_LAW:
^1da177e4 Linus Torvalds 2005-04-16   97  		retval = AD1816A_FMT_ALAW_8;
^1da177e4 Linus Torvalds 2005-04-16   98  		break;
^1da177e4 Linus Torvalds 2005-04-16   99  	case SNDRV_PCM_FORMAT_S16_LE:
^1da177e4 Linus Torvalds 2005-04-16  100  		retval = AD1816A_FMT_LINEAR_16_LIT;
^1da177e4 Linus Torvalds 2005-04-16  101  		break;
^1da177e4 Linus Torvalds 2005-04-16  102  	case SNDRV_PCM_FORMAT_S16_BE:
^1da177e4 Linus Torvalds 2005-04-16  103  		retval = AD1816A_FMT_LINEAR_16_BIG;
^1da177e4 Linus Torvalds 2005-04-16  104  	}
^1da177e4 Linus Torvalds 2005-04-16  105  	return (channels > 1) ? (retval | AD1816A_FMT_STEREO) : retval;
^1da177e4 Linus Torvalds 2005-04-16  106  }
^1da177e4 Linus Torvalds 2005-04-16  107  
cbdd0dd15 Takashi Iwai   2005-11-17  108  static int snd_ad1816a_open(struct snd_ad1816a *chip, unsigned int mode)
^1da177e4 Linus Torvalds 2005-04-16  109  {
^1da177e4 Linus Torvalds 2005-04-16  110  	unsigned long flags;
^1da177e4 Linus Torvalds 2005-04-16  111  
^1da177e4 Linus Torvalds 2005-04-16  112  	spin_lock_irqsave(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  113  
^1da177e4 Linus Torvalds 2005-04-16  114  	if (chip->mode & mode) {
^1da177e4 Linus Torvalds 2005-04-16  115  		spin_unlock_irqrestore(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  116  		return -EAGAIN;
^1da177e4 Linus Torvalds 2005-04-16  117  	}
^1da177e4 Linus Torvalds 2005-04-16  118  
^1da177e4 Linus Torvalds 2005-04-16  119  	switch ((mode &= AD1816A_MODE_OPEN)) {
^1da177e4 Linus Torvalds 2005-04-16  120  	case AD1816A_MODE_PLAYBACK:
^1da177e4 Linus Torvalds 2005-04-16  121  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  122  			AD1816A_PLAYBACK_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  123  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  124  			AD1816A_PLAYBACK_IRQ_ENABLE, 0xffff);
^1da177e4 Linus Torvalds 2005-04-16  125  		break;
^1da177e4 Linus Torvalds 2005-04-16  126  	case AD1816A_MODE_CAPTURE:
^1da177e4 Linus Torvalds 2005-04-16  127  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  128  			AD1816A_CAPTURE_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  129  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  130  			AD1816A_CAPTURE_IRQ_ENABLE, 0xffff);
^1da177e4 Linus Torvalds 2005-04-16  131  		break;
^1da177e4 Linus Torvalds 2005-04-16  132  	case AD1816A_MODE_TIMER:
^1da177e4 Linus Torvalds 2005-04-16  133  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  134  			AD1816A_TIMER_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  135  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  136  			AD1816A_TIMER_IRQ_ENABLE, 0xffff);
^1da177e4 Linus Torvalds 2005-04-16  137  	}
^1da177e4 Linus Torvalds 2005-04-16  138  	chip->mode |= mode;
^1da177e4 Linus Torvalds 2005-04-16  139  
^1da177e4 Linus Torvalds 2005-04-16  140  	spin_unlock_irqrestore(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  141  	return 0;
^1da177e4 Linus Torvalds 2005-04-16  142  }
^1da177e4 Linus Torvalds 2005-04-16  143  
cbdd0dd15 Takashi Iwai   2005-11-17  144  static void snd_ad1816a_close(struct snd_ad1816a *chip, unsigned int mode)
^1da177e4 Linus Torvalds 2005-04-16  145  {
^1da177e4 Linus Torvalds 2005-04-16  146  	unsigned long flags;
^1da177e4 Linus Torvalds 2005-04-16  147  
^1da177e4 Linus Torvalds 2005-04-16  148  	spin_lock_irqsave(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  149  
^1da177e4 Linus Torvalds 2005-04-16  150  	switch ((mode &= AD1816A_MODE_OPEN)) {
^1da177e4 Linus Torvalds 2005-04-16  151  	case AD1816A_MODE_PLAYBACK:
^1da177e4 Linus Torvalds 2005-04-16  152  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  153  			AD1816A_PLAYBACK_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  154  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  155  			AD1816A_PLAYBACK_IRQ_ENABLE, 0x0000);
^1da177e4 Linus Torvalds 2005-04-16  156  		break;
^1da177e4 Linus Torvalds 2005-04-16  157  	case AD1816A_MODE_CAPTURE:
^1da177e4 Linus Torvalds 2005-04-16  158  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  159  			AD1816A_CAPTURE_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  160  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  161  			AD1816A_CAPTURE_IRQ_ENABLE, 0x0000);
^1da177e4 Linus Torvalds 2005-04-16  162  		break;
^1da177e4 Linus Torvalds 2005-04-16  163  	case AD1816A_MODE_TIMER:
^1da177e4 Linus Torvalds 2005-04-16  164  		snd_ad1816a_out_mask(chip, AD1816A_INTERRUPT_STATUS,
^1da177e4 Linus Torvalds 2005-04-16  165  			AD1816A_TIMER_IRQ_PENDING, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  166  		snd_ad1816a_write_mask(chip, AD1816A_INTERRUPT_ENABLE,
^1da177e4 Linus Torvalds 2005-04-16  167  			AD1816A_TIMER_IRQ_ENABLE, 0x0000);
^1da177e4 Linus Torvalds 2005-04-16  168  	}
^1da177e4 Linus Torvalds 2005-04-16  169  	if (!((chip->mode &= ~mode) & AD1816A_MODE_OPEN))
^1da177e4 Linus Torvalds 2005-04-16  170  		chip->mode = 0;
^1da177e4 Linus Torvalds 2005-04-16  171  
^1da177e4 Linus Torvalds 2005-04-16  172  	spin_unlock_irqrestore(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  173  }
^1da177e4 Linus Torvalds 2005-04-16  174  
^1da177e4 Linus Torvalds 2005-04-16  175  
cbdd0dd15 Takashi Iwai   2005-11-17  176  static int snd_ad1816a_trigger(struct snd_ad1816a *chip, unsigned char what,
d08a23e25 Ken Arromdee   2006-02-09  177  			       int channel, int cmd, int iscapture)
^1da177e4 Linus Torvalds 2005-04-16  178  {
^1da177e4 Linus Torvalds 2005-04-16  179  	int error = 0;
^1da177e4 Linus Torvalds 2005-04-16  180  
^1da177e4 Linus Torvalds 2005-04-16  181  	switch (cmd) {
^1da177e4 Linus Torvalds 2005-04-16  182  	case SNDRV_PCM_TRIGGER_START:
^1da177e4 Linus Torvalds 2005-04-16  183  	case SNDRV_PCM_TRIGGER_STOP:
^1da177e4 Linus Torvalds 2005-04-16  184  		spin_lock(&chip->lock);
^1da177e4 Linus Torvalds 2005-04-16  185  		cmd = (cmd == SNDRV_PCM_TRIGGER_START) ? 0xff: 0x00;
d08a23e25 Ken Arromdee   2006-02-09  186  		/* if (what & AD1816A_PLAYBACK_ENABLE) */
d08a23e25 Ken Arromdee   2006-02-09  187  		/* That is not valid, because playback and capture enable
d08a23e25 Ken Arromdee   2006-02-09  188  		 * are the same bit pattern, just to different addresses
d08a23e25 Ken Arromdee   2006-02-09  189  		 */
d08a23e25 Ken Arromdee   2006-02-09  190  		if (! iscapture)
^1da177e4 Linus Torvalds 2005-04-16  191  			snd_ad1816a_out_mask(chip, AD1816A_PLAYBACK_CONFIG,
^1da177e4 Linus Torvalds 2005-04-16  192  				AD1816A_PLAYBACK_ENABLE, cmd);
d08a23e25 Ken Arromdee   2006-02-09  193  		else
^1da177e4 Linus Torvalds 2005-04-16  194  			snd_ad1816a_out_mask(chip, AD1816A_CAPTURE_CONFIG,
^1da177e4 Linus Torvalds 2005-04-16  195  				AD1816A_CAPTURE_ENABLE, cmd);
^1da177e4 Linus Torvalds 2005-04-16  196  		spin_unlock(&chip->lock);
^1da177e4 Linus Torvalds 2005-04-16  197  		break;
^1da177e4 Linus Torvalds 2005-04-16  198  	default:
4c9f1d3ed Takashi Iwai   2009-02-05  199  		snd_printk(KERN_WARNING "invalid trigger mode 0x%x.\n", what);
^1da177e4 Linus Torvalds 2005-04-16  200  		error = -EINVAL;
^1da177e4 Linus Torvalds 2005-04-16  201  	}
^1da177e4 Linus Torvalds 2005-04-16  202  
^1da177e4 Linus Torvalds 2005-04-16  203  	return error;
^1da177e4 Linus Torvalds 2005-04-16  204  }
^1da177e4 Linus Torvalds 2005-04-16  205  
cbdd0dd15 Takashi Iwai   2005-11-17  206  static int snd_ad1816a_playback_trigger(struct snd_pcm_substream *substream, int cmd)
^1da177e4 Linus Torvalds 2005-04-16  207  {
cbdd0dd15 Takashi Iwai   2005-11-17  208  	struct snd_ad1816a *chip = snd_pcm_substream_chip(substream);
^1da177e4 Linus Torvalds 2005-04-16  209  	return snd_ad1816a_trigger(chip, AD1816A_PLAYBACK_ENABLE,
d08a23e25 Ken Arromdee   2006-02-09  210  				   SNDRV_PCM_STREAM_PLAYBACK, cmd, 0);
^1da177e4 Linus Torvalds 2005-04-16  211  }
^1da177e4 Linus Torvalds 2005-04-16  212  
cbdd0dd15 Takashi Iwai   2005-11-17  213  static int snd_ad1816a_capture_trigger(struct snd_pcm_substream *substream, int cmd)
^1da177e4 Linus Torvalds 2005-04-16  214  {
cbdd0dd15 Takashi Iwai   2005-11-17  215  	struct snd_ad1816a *chip = snd_pcm_substream_chip(substream);
^1da177e4 Linus Torvalds 2005-04-16  216  	return snd_ad1816a_trigger(chip, AD1816A_CAPTURE_ENABLE,
d08a23e25 Ken Arromdee   2006-02-09  217  				   SNDRV_PCM_STREAM_CAPTURE, cmd, 1);
^1da177e4 Linus Torvalds 2005-04-16  218  }
^1da177e4 Linus Torvalds 2005-04-16  219  
cbdd0dd15 Takashi Iwai   2005-11-17  220  static int snd_ad1816a_hw_params(struct snd_pcm_substream *substream,
cbdd0dd15 Takashi Iwai   2005-11-17  221  				 struct snd_pcm_hw_params *hw_params)
^1da177e4 Linus Torvalds 2005-04-16  222  {
^1da177e4 Linus Torvalds 2005-04-16  223  	return snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
^1da177e4 Linus Torvalds 2005-04-16  224  }
^1da177e4 Linus Torvalds 2005-04-16  225  
cbdd0dd15 Takashi Iwai   2005-11-17  226  static int snd_ad1816a_hw_free(struct snd_pcm_substream *substream)
^1da177e4 Linus Torvalds 2005-04-16  227  {
^1da177e4 Linus Torvalds 2005-04-16  228  	return snd_pcm_lib_free_pages(substream);
^1da177e4 Linus Torvalds 2005-04-16  229  }
^1da177e4 Linus Torvalds 2005-04-16  230  
cbdd0dd15 Takashi Iwai   2005-11-17  231  static int snd_ad1816a_playback_prepare(struct snd_pcm_substream *substream)
^1da177e4 Linus Torvalds 2005-04-16  232  {
cbdd0dd15 Takashi Iwai   2005-11-17  233  	struct snd_ad1816a *chip = snd_pcm_substream_chip(substream);
^1da177e4 Linus Torvalds 2005-04-16  234  	unsigned long flags;
cbdd0dd15 Takashi Iwai   2005-11-17  235  	struct snd_pcm_runtime *runtime = substream->runtime;
5b8f7f732 Takashi Iwai   2005-08-03  236  	unsigned int size, rate;
^1da177e4 Linus Torvalds 2005-04-16  237  
^1da177e4 Linus Torvalds 2005-04-16  238  	spin_lock_irqsave(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  239  
^1da177e4 Linus Torvalds 2005-04-16  240  	chip->p_dma_size = size = snd_pcm_lib_buffer_bytes(substream);
^1da177e4 Linus Torvalds 2005-04-16  241  	snd_ad1816a_out_mask(chip, AD1816A_PLAYBACK_CONFIG,
^1da177e4 Linus Torvalds 2005-04-16  242  		AD1816A_PLAYBACK_ENABLE | AD1816A_PLAYBACK_PIO, 0x00);
^1da177e4 Linus Torvalds 2005-04-16  243  
^1da177e4 Linus Torvalds 2005-04-16  244  	snd_dma_program(chip->dma1, runtime->dma_addr, size,
^1da177e4 Linus Torvalds 2005-04-16  245  			DMA_MODE_WRITE | DMA_AUTOINIT);
^1da177e4 Linus Torvalds 2005-04-16  246  
5b8f7f732 Takashi Iwai   2005-08-03  247  	rate = runtime->rate;
5b8f7f732 Takashi Iwai   2005-08-03  248  	if (chip->clock_freq)
5b8f7f732 Takashi Iwai   2005-08-03  249  		rate = (rate * 33000) / chip->clock_freq;
5b8f7f732 Takashi Iwai   2005-08-03  250  	snd_ad1816a_write(chip, AD1816A_PLAYBACK_SAMPLE_RATE, rate);
^1da177e4 Linus Torvalds 2005-04-16  251  	snd_ad1816a_out_mask(chip, AD1816A_PLAYBACK_CONFIG,
^1da177e4 Linus Torvalds 2005-04-16  252  		AD1816A_FMT_ALL | AD1816A_FMT_STEREO,
^1da177e4 Linus Torvalds 2005-04-16 @253  		snd_ad1816a_get_format(chip, runtime->format,
^1da177e4 Linus Torvalds 2005-04-16  254  			runtime->channels));
^1da177e4 Linus Torvalds 2005-04-16  255  
^1da177e4 Linus Torvalds 2005-04-16  256  	snd_ad1816a_write(chip, AD1816A_PLAYBACK_BASE_COUNT,
^1da177e4 Linus Torvalds 2005-04-16  257  		snd_pcm_lib_period_bytes(substream) / 4 - 1);
^1da177e4 Linus Torvalds 2005-04-16  258  
^1da177e4 Linus Torvalds 2005-04-16  259  	spin_unlock_irqrestore(&chip->lock, flags);
^1da177e4 Linus Torvalds 2005-04-16  260  	return 0;
^1da177e4 Linus Torvalds 2005-04-16  261  }
^1da177e4 Linus Torvalds 2005-04-16  262  

:::::: The code at line 93 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
