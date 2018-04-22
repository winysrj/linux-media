Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64911 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751787AbeDVSFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 14:05:09 -0400
Date: Mon, 23 Apr 2018 02:05:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/4] sound, media: allow building ISA drivers it with
 COMPILE_TEST
Message-ID: <201804230149.oqm0qN8x%fengguang.wu@intel.com>
References: <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc1 next-20180420]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/media-radio-allow-building-ISA-drivers-with-COMPILE_TEST/20180422-180508
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> sound/isa/wss/wss_lib.c:551:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/wss/wss_lib.c:552:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/wss/wss_lib.c:553:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/wss/wss_lib.c:554:14: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/wss/wss_lib.c:555:14: sparse: restricted snd_pcm_format_t degrades to integer
>> sound/isa/wss/wss_lib.c:1003:58: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] format @@    got restricted sndint [signed] format @@
   sound/isa/wss/wss_lib.c:1003:58:    expected int [signed] format
   sound/isa/wss/wss_lib.c:1003:58:    got restricted snd_pcm_format_t
   sound/isa/wss/wss_lib.c:1046:58: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] format @@    got restricted sndint [signed] format @@
   sound/isa/wss/wss_lib.c:1046:58:    expected int [signed] format
   sound/isa/wss/wss_lib.c:1046:58:    got restricted snd_pcm_format_t
--
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
>> drivers/media/radio/radio-miropcm20.c:292:21: sparse: expression using sizeof(void)
--
>> sound/isa/cmi8328.c:195:5: sparse: symbol 'array_find' was not declared. Should it be static?
>> sound/isa/cmi8328.c:206:5: sparse: symbol 'array_find_l' was not declared. Should it be static?
--
>> sound/isa/sscape.c:477:23: sparse: expression using sizeof(void)
>> sound/isa/sscape.c:477:23: sparse: expression using sizeof(void)
--
>> sound/isa/msnd/msnd_pinnacle.c:85:32: sparse: incorrect type in assignment (different base types) @@    expected int [signed] play_sample_size @@    got restricted snd_pcm_format_int [signed] play_sample_size @@
   sound/isa/msnd/msnd_pinnacle.c:85:32:    expected int [signed] play_sample_size
   sound/isa/msnd/msnd_pinnacle.c:85:32:    got restricted snd_pcm_format_t [usertype] <noident>
>> sound/isa/msnd/msnd_pinnacle.c:88:35: sparse: incorrect type in assignment (different base types) @@    expected int [signed] capture_sample_size @@    got restricted snd_pcm_format_int [signed] capture_sample_size @@
   sound/isa/msnd/msnd_pinnacle.c:88:35:    expected int [signed] capture_sample_size
   sound/isa/msnd/msnd_pinnacle.c:88:35:    got restricted snd_pcm_format_t [usertype] <noident>
>> sound/isa/msnd/msnd_pinnacle.c:172:45: sparse: incorrect type in initializer (different address spaces) @@    expected void *pwDSPQData @@    got void [noderef] <avoid *pwDSPQData @@
   sound/isa/msnd/msnd_pinnacle.c:172:45:    expected void *pwDSPQData
   sound/isa/msnd/msnd_pinnacle.c:172:45:    got void [noderef] <asn:2>*
>> sound/isa/msnd/msnd_pinnacle.c:185:62: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd_pinnacle.c:185:62:    expected void const volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd_pinnacle.c:185:62:    got void *
>> sound/isa/msnd/msnd_pinnacle.c:344:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:344:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:344:33:    got void [noderef] <asn:2>*DAPQ
   sound/isa/msnd/msnd_pinnacle.c:348:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:348:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:348:33:    got void [noderef] <asn:2>*DARQ
   sound/isa/msnd/msnd_pinnacle.c:352:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:352:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:352:33:    got void [noderef] <asn:2>*MODQ
   sound/isa/msnd/msnd_pinnacle.c:356:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:356:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:356:33:    got void [noderef] <asn:2>*MIDQ
   sound/isa/msnd/msnd_pinnacle.c:360:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:360:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:360:33:    got void [noderef] <asn:2>*DSPQ
>> sound/isa/msnd/msnd_pinnacle.c:813:1: sparse: Using plain integer as NULL pointer
--
>> sound/isa/msnd/msnd.c:59:43: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:59:43:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:59:43:    got void *
   sound/isa/msnd/msnd.c:60:47: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:60:47:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:60:47:    got void *
   sound/isa/msnd/msnd.c:61:24: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:61:24:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:61:24:    got void *
   sound/isa/msnd/msnd.c:62:24: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:62:24:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:62:24:    got void *
>> sound/isa/msnd/msnd.c:165:40: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd.c:165:40:    expected void *base
   sound/isa/msnd/msnd.c:165:40:    got void [noderef] <asn:2>*DSPQ
>> sound/isa/msnd/msnd.c:274:49: sparse: incorrect type in initializer (different address spaces) @@    expected void *pDAQ @@    got void [noderef] <avoid *pDAQ @@
   sound/isa/msnd/msnd.c:274:49:    expected void *pDAQ
   sound/isa/msnd/msnd.c:274:49:    got void [noderef] <asn:2>*
>> sound/isa/msnd/msnd.c:277:27: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:277:27:    expected void const volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:277:27:    got void *pDAQ
   sound/isa/msnd/msnd.c:279:47: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:279:47:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:279:47:    got void *pDAQ
>> sound/isa/msnd/msnd.c:327:22: sparse: incorrect type in assignment (different address spaces) @@    expected void *DAQD @@    got void [noderef] <avoid *DAQD @@
   sound/isa/msnd/msnd.c:327:22:    expected void *DAQD
   sound/isa/msnd/msnd.c:327:22:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:331:54: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:331:54:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:331:54:    got void *
   sound/isa/msnd/msnd.c:337:40: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:337:40:    expected void const volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:337:40:    got void *
   sound/isa/msnd/msnd.c:340:60: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:340:60:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:340:60:    got void *
   sound/isa/msnd/msnd.c:373:42: sparse: incorrect type in initializer (different address spaces) @@    expected void *pDAQ @@    got void [noderef] <avoid *pDAQ @@
   sound/isa/msnd/msnd.c:373:42:    expected void *pDAQ
   sound/isa/msnd/msnd.c:373:42:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:385:30: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:385:30:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:385:30:    got void *
   sound/isa/msnd/msnd.c:386:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:386:32:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:386:32:    got void *
   sound/isa/msnd/msnd.c:387:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:387:32:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:387:32:    got void *
   sound/isa/msnd/msnd.c:388:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:388:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:388:53:    got void *
   sound/isa/msnd/msnd.c:389:50: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:389:50:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:389:50:    got void *
   sound/isa/msnd/msnd.c:390:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:390:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:390:53:    got void *
   sound/isa/msnd/msnd.c:391:57: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:391:57:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:391:57:    got void *
   sound/isa/msnd/msnd.c:392:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:392:32:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:392:32:    got void *
>> sound/isa/msnd/msnd.c:424:14: sparse: incorrect type in assignment (different address spaces) @@    expected void *pDAQ @@    got void [noderef] <avoid *pDAQ @@
   sound/isa/msnd/msnd.c:424:14:    expected void *pDAQ
   sound/isa/msnd/msnd.c:424:14:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:429:58: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:429:58:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:429:58:    got void *
   sound/isa/msnd/msnd.c:430:40: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:430:40:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:430:40:    got void *
   sound/isa/msnd/msnd.c:431:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:431:32:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:431:32:    got void *
   sound/isa/msnd/msnd.c:432:56: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:432:56:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:432:56:    got void *
   sound/isa/msnd/msnd.c:433:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:433:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:433:53:    got void *
   sound/isa/msnd/msnd.c:434:56: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:434:56:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:434:56:    got void *
   sound/isa/msnd/msnd.c:435:59: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:435:59:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:435:59:    got void *
   sound/isa/msnd/msnd.c:436:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:436:32:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:436:32:    got void *
>> sound/isa/msnd/msnd.c:488:27: sparse: incorrect type in assignment (different address spaces) @@    expected unsigned char *dma_area @@    got void [nounsigned char *dma_area @@
   sound/isa/msnd/msnd.c:488:27:    expected unsigned char *dma_area
   sound/isa/msnd/msnd.c:488:27:    got void [noderef] <asn:2>*mappedbase
   sound/isa/msnd/msnd.c:511:42: sparse: incorrect type in initializer (different address spaces) @@    expected void *pDAQ @@    got void [noderef] <avoid *pDAQ @@
   sound/isa/msnd/msnd.c:511:42:    expected void *pDAQ
   sound/isa/msnd/msnd.c:511:42:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:518:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:518:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:518:53:    got void *
   sound/isa/msnd/msnd.c:519:50: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:519:50:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:519:50:    got void *
   sound/isa/msnd/msnd.c:520:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:520:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:520:53:    got void *
   sound/isa/msnd/msnd.c:592:27: sparse: incorrect type in assignment (different address spaces) @@    expected unsigned char *dma_area @@    got void [nounsigned char *dma_area @@
   sound/isa/msnd/msnd.c:592:27:    expected unsigned char *dma_area
   sound/isa/msnd/msnd.c:592:27:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:657:50: sparse: incorrect type in initializer (different address spaces) @@    expected void *pDAQ @@    got void [noderef] <avoid *pDAQ @@
   sound/isa/msnd/msnd.c:657:50:    expected void *pDAQ
   sound/isa/msnd/msnd.c:657:50:    got void [noderef] <asn:2>*
   sound/isa/msnd/msnd.c:664:56: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:664:56:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:664:56:    got void *
   sound/isa/msnd/msnd.c:665:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:665:53:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:665:53:    got void *
   sound/isa/msnd/msnd.c:666:56: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd.c:666:56:    expected void volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd.c:666:56:    got void *
--
>> sound/isa/msnd/msnd_midi.c:122:49: sparse: incorrect type in initializer (different address spaces) @@    expected void *pwMIDQData @@    got void [noderef] <avoid *pwMIDQData @@
   sound/isa/msnd/msnd_midi.c:122:49:    expected void *pwMIDQData
   sound/isa/msnd/msnd_midi.c:122:49:    got void [noderef] <asn:2>*
>> sound/isa/msnd/msnd_midi.c:132:54: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd_midi.c:132:54:    expected void const volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd_midi.c:132:54:    got void *
--
>> sound/isa/msnd/msnd_pinnacle.c:85:32: sparse: incorrect type in assignment (different base types) @@    expected int [signed] play_sample_size @@    got restricted snd_pcm_format_int [signed] play_sample_size @@
   sound/isa/msnd/msnd_pinnacle.c:85:32:    expected int [signed] play_sample_size
   sound/isa/msnd/msnd_pinnacle.c:85:32:    got restricted snd_pcm_format_t [usertype] <noident>
>> sound/isa/msnd/msnd_pinnacle.c:88:35: sparse: incorrect type in assignment (different base types) @@    expected int [signed] capture_sample_size @@    got restricted snd_pcm_format_int [signed] capture_sample_size @@
   sound/isa/msnd/msnd_pinnacle.c:88:35:    expected int [signed] capture_sample_size
   sound/isa/msnd/msnd_pinnacle.c:88:35:    got restricted snd_pcm_format_t [usertype] <noident>
>> sound/isa/msnd/msnd_pinnacle.c:172:45: sparse: incorrect type in initializer (different address spaces) @@    expected void *pwDSPQData @@    got void [noderef] <avoid *pwDSPQData @@
   sound/isa/msnd/msnd_pinnacle.c:172:45:    expected void *pwDSPQData
   sound/isa/msnd/msnd_pinnacle.c:172:45:    got void [noderef] <asn:2>*
>> sound/isa/msnd/msnd_pinnacle.c:185:62: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2>*addr @@    got sn:2>*addr @@
   sound/isa/msnd/msnd_pinnacle.c:185:62:    expected void const volatile [noderef] <asn:2>*addr
   sound/isa/msnd/msnd_pinnacle.c:185:62:    got void *
>> sound/isa/msnd/msnd_pinnacle.c:344:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:344:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:344:33:    got void [noderef] <asn:2>*DAPQ
   sound/isa/msnd/msnd_pinnacle.c:348:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:348:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:348:33:    got void [noderef] <asn:2>*DARQ
   sound/isa/msnd/msnd_pinnacle.c:352:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:352:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:352:33:    got void [noderef] <asn:2>*MODQ
   sound/isa/msnd/msnd_pinnacle.c:356:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:356:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:356:33:    got void [noderef] <asn:2>*MIDQ
   sound/isa/msnd/msnd_pinnacle.c:360:33: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   sound/isa/msnd/msnd_pinnacle.c:360:33:    expected void *base
   sound/isa/msnd/msnd_pinnacle.c:360:33:    got void [noderef] <asn:2>*DSPQ
--
>> sound/isa/sb/emu8000_pcm.c:541:9: sparse: cast removes address space of expression
--
>> sound/isa/sb/sb16_csp.c:330:14: sparse: cast to restricted __le32
   sound/isa/sb/sb16_csp.c:335:31: sparse: cast to restricted __le32
>> sound/isa/sb/sb16_csp.c:358:35: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:384:73: sparse: cast to restricted __le32
   sound/isa/sb/sb16_csp.c:388:45: sparse: cast to restricted __le32
   sound/isa/sb/sb16_csp.c:400:52: sparse: cast to restricted __le32
   sound/isa/sb/sb16_csp.c:407:35: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:408:33: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:410:37: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:438:33: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:443:43: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:444:40: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:445:40: sparse: cast to restricted __le16
   sound/isa/sb/sb16_csp.c:345:49: sparse: cast to restricted __le32
>> sound/isa/sb/sb16_csp.c:743:22: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/sb/sb16_csp.c:748:22: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/sb/sb16_csp.c:753:22: sparse: restricted snd_pcm_format_t degrades to integer
--
>> sound/isa/sb/sb16_main.c:61:44: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/sb/sb16_main.c:69:50: sparse: restricted snd_pcm_format_t degrades to integer
>> sound/isa/sb/sb16_main.c:80:63: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] pcm_sfmt @@    got restricted snd_pcm_format_int [signed] pcm_sfmt @@
   sound/isa/sb/sb16_main.c:80:63:    expected int [signed] pcm_sfmt
   sound/isa/sb/sb16_main.c:80:63:    got restricted snd_pcm_format_t [usertype] format
   sound/isa/sb/sb16_main.c:109:44: sparse: restricted snd_pcm_format_t degrades to integer
   sound/isa/sb/sb16_main.c:118:63: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] pcm_sfmt @@    got restricted snd_pcm_format_int [signed] pcm_sfmt @@
   sound/isa/sb/sb16_main.c:118:63:    expected int [signed] pcm_sfmt
   sound/isa/sb/sb16_main.c:118:63:    got restricted snd_pcm_format_t [usertype] format

Please review and possibly fold the followup patch.

vim +551 sound/isa/wss/wss_lib.c

^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  542  
7779f75f sound/isa/wss/wss_lib.c       Krzysztof Helt 2008-07-31  543  static unsigned char snd_wss_get_format(struct snd_wss *chip,
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  544  					int format,
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  545  					int channels)
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  546  {
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  547  	unsigned char rformat;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  548  
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  549  	rformat = CS4231_LINEAR_8;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  550  	switch (format) {
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16 @551  	case SNDRV_PCM_FORMAT_MU_LAW:	rformat = CS4231_ULAW_8; break;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  552  	case SNDRV_PCM_FORMAT_A_LAW:	rformat = CS4231_ALAW_8; break;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  553  	case SNDRV_PCM_FORMAT_S16_LE:	rformat = CS4231_LINEAR_16; break;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  554  	case SNDRV_PCM_FORMAT_S16_BE:	rformat = CS4231_LINEAR_16_BIG; break;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  555  	case SNDRV_PCM_FORMAT_IMA_ADPCM:	rformat = CS4231_ADPCM_16; break;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  556  	}
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  557  	if (channels > 1)
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  558  		rformat |= CS4231_STEREO;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  559  #if 0
76d498e4 sound/isa/wss/wss_lib.c       Takashi Iwai   2009-02-05  560  	snd_printk(KERN_DEBUG "get_format: 0x%x (mode=0x%x)\n", format, mode);
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  561  #endif
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  562  	return rformat;
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  563  }
^1da177e sound/isa/cs423x/cs4231_lib.c Linus Torvalds 2005-04-16  564  

:::::: The code at line 551 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
