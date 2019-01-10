Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110E0C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 19:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C83BB20879
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 19:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfAJTtt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 14:49:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAJTtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 14:49:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0AJnS1D125430;
        Thu, 10 Jan 2019 19:49:33 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2ptj3e9fjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 19:49:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0AJnX3V003120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jan 2019 19:49:33 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0AJnXSC007073;
        Thu, 10 Jan 2019 19:49:33 GMT
Received: from kadam (/41.202.241.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Jan 2019 11:49:31 -0800
Date:   Thu, 10 Jan 2019 22:49:25 +0300
From:   kbuild test robot <lkp@intel.com>
To:     kbuild@01.org, Michael Tretter <m.tretter@pengutronix.de>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild-all@01.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] allegro: add Allegro DVT video IP core driver
Message-ID: <20190110194925.GI1718@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109113037.28430-3-m.tretter@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9132 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901100153
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Michael,

url:    https://github.com/0day-ci/linux/commits/Michael-Tretter/Add-ZynqMP-VCU-Allegro-DVT-H-264-encoder-driver/20190110-020930
base:   git://linuxtv.org/media_tree.git master

smatch warnings:
drivers/staging/media/allegro-dvt/allegro-core.c:616 allegro_mbox_write() error: uninitialized symbol 'err'.
drivers/staging/media/allegro-dvt/allegro-core.c:743 v4l2_profile_to_mcu_profile() warn: signedness bug returning '(-22)'
drivers/staging/media/allegro-dvt/allegro-core.c:753 v4l2_level_to_mcu_level() warn: signedness bug returning '(-22)'
drivers/staging/media/allegro-dvt/allegro-core.c:1162 allegro_receive_message() warn: struct type mismatch 'mcu_msg_header vs mcu_msg_encode_one_frm_response'

# https://github.com/0day-ci/linux/commit/573e9a62ef9a92c1f26f120a89aba1514b97b2b2
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 573e9a62ef9a92c1f26f120a89aba1514b97b2b2
vim +/err +616 drivers/staging/media/allegro-dvt/allegro-core.c

573e9a62 Michael Tretter 2019-01-09  568  
573e9a62 Michael Tretter 2019-01-09  569  static int allegro_mbox_write(struct allegro_dev *dev,
573e9a62 Michael Tretter 2019-01-09  570  			      struct allegro_mbox *mbox, void *src, size_t size)
573e9a62 Michael Tretter 2019-01-09  571  {
573e9a62 Michael Tretter 2019-01-09  572  	struct mcu_msg_header *header = src;
573e9a62 Michael Tretter 2019-01-09  573  	unsigned int tail;
573e9a62 Michael Tretter 2019-01-09  574  	size_t size_no_wrap;
573e9a62 Michael Tretter 2019-01-09  575  	int err;
573e9a62 Michael Tretter 2019-01-09  576  
573e9a62 Michael Tretter 2019-01-09  577  	if (!src)
573e9a62 Michael Tretter 2019-01-09  578  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  579  
573e9a62 Michael Tretter 2019-01-09  580  	if (size > mbox->size) {
573e9a62 Michael Tretter 2019-01-09  581  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  582  			 "message (%lu bytes) to large for mailbox (%lu bytes)\n",
573e9a62 Michael Tretter 2019-01-09  583  			 size, mbox->size);
573e9a62 Michael Tretter 2019-01-09  584  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  585  	}
573e9a62 Michael Tretter 2019-01-09  586  
573e9a62 Michael Tretter 2019-01-09  587  	if (header->length != size - sizeof(*header)) {
573e9a62 Michael Tretter 2019-01-09  588  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  589  			 "invalid message length: %u bytes (expected %lu bytes)\n",
573e9a62 Michael Tretter 2019-01-09  590  			 header->length, size - sizeof(*header));
573e9a62 Michael Tretter 2019-01-09  591  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  592  	}
573e9a62 Michael Tretter 2019-01-09  593  
573e9a62 Michael Tretter 2019-01-09  594  	v4l2_dbg(2, debug, &dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  595  		"write command message: type %s, body length %d\n",
573e9a62 Michael Tretter 2019-01-09  596  		msg_type_name(header->type), header->length);
573e9a62 Michael Tretter 2019-01-09  597  
573e9a62 Michael Tretter 2019-01-09  598  	mutex_lock(&mbox->lock);
573e9a62 Michael Tretter 2019-01-09  599  	regmap_read(dev->sram, mbox->tail, &tail);
573e9a62 Michael Tretter 2019-01-09  600  	if (tail > mbox->size) {
573e9a62 Michael Tretter 2019-01-09  601  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  602  			 "invalid tail (0x%x): must be smaller than mailbox size (0x%lx)\n",
573e9a62 Michael Tretter 2019-01-09  603  			 tail, mbox->size);
573e9a62 Michael Tretter 2019-01-09  604  		err = -EIO;
573e9a62 Michael Tretter 2019-01-09  605  		goto out;
573e9a62 Michael Tretter 2019-01-09  606  	}
573e9a62 Michael Tretter 2019-01-09  607  	size_no_wrap = min(size, mbox->size - (size_t)tail);
573e9a62 Michael Tretter 2019-01-09  608  	regmap_bulk_write(dev->sram, mbox->data + tail, src, size_no_wrap / 4);
573e9a62 Michael Tretter 2019-01-09  609  	regmap_bulk_write(dev->sram, mbox->data,
573e9a62 Michael Tretter 2019-01-09  610  			  src + size_no_wrap, (size - size_no_wrap) / 4);
573e9a62 Michael Tretter 2019-01-09  611  	regmap_write(dev->sram, mbox->tail, (tail + size) % mbox->size);
573e9a62 Michael Tretter 2019-01-09  612  
573e9a62 Michael Tretter 2019-01-09  613  out:
573e9a62 Michael Tretter 2019-01-09  614  	mutex_unlock(&mbox->lock);
573e9a62 Michael Tretter 2019-01-09  615  
573e9a62 Michael Tretter 2019-01-09 @616  	return err;
573e9a62 Michael Tretter 2019-01-09  617  }
573e9a62 Michael Tretter 2019-01-09  618  
573e9a62 Michael Tretter 2019-01-09  619  static ssize_t allegro_mbox_read(struct allegro_dev *dev,
573e9a62 Michael Tretter 2019-01-09  620  				 struct allegro_mbox *mbox,
573e9a62 Michael Tretter 2019-01-09  621  				 void *dst, size_t nbyte)
573e9a62 Michael Tretter 2019-01-09  622  {
573e9a62 Michael Tretter 2019-01-09  623  	struct mcu_msg_header *header;
573e9a62 Michael Tretter 2019-01-09  624  	unsigned int head;
573e9a62 Michael Tretter 2019-01-09  625  	ssize_t size;
573e9a62 Michael Tretter 2019-01-09  626  	size_t body_no_wrap;
573e9a62 Michael Tretter 2019-01-09  627  
573e9a62 Michael Tretter 2019-01-09  628  	regmap_read(dev->sram, mbox->head, &head);
573e9a62 Michael Tretter 2019-01-09  629  	if (head > mbox->size) {
573e9a62 Michael Tretter 2019-01-09  630  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  631  			 "invalid head (0x%x): must be smaller than mailbox size (0x%lx)\n",
573e9a62 Michael Tretter 2019-01-09  632  			 head, mbox->size);
573e9a62 Michael Tretter 2019-01-09  633  		return -EIO;
573e9a62 Michael Tretter 2019-01-09  634  	}
573e9a62 Michael Tretter 2019-01-09  635  
573e9a62 Michael Tretter 2019-01-09  636  	/* Assume that the header does not wrap. */
573e9a62 Michael Tretter 2019-01-09  637  	regmap_bulk_read(dev->sram, mbox->data + head,
573e9a62 Michael Tretter 2019-01-09  638  			 dst, sizeof(*header) / 4);
573e9a62 Michael Tretter 2019-01-09  639  	header = dst;
573e9a62 Michael Tretter 2019-01-09  640  	size = header->length + sizeof(*header);
573e9a62 Michael Tretter 2019-01-09  641  	if (size > mbox->size || size & 0x3) {
573e9a62 Michael Tretter 2019-01-09  642  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  643  			 "invalid message length: %lu bytes (maximum %lu bytes)\n",
573e9a62 Michael Tretter 2019-01-09  644  			 header->length + sizeof(*header), mbox->size);
573e9a62 Michael Tretter 2019-01-09  645  		return -EIO;
573e9a62 Michael Tretter 2019-01-09  646  	}
573e9a62 Michael Tretter 2019-01-09  647  	if (size > nbyte) {
573e9a62 Michael Tretter 2019-01-09  648  		v4l2_err(&dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  649  			 "destination buffer too small: %lu bytes (need %lu bytes)\n",
573e9a62 Michael Tretter 2019-01-09  650  			 nbyte, size);
573e9a62 Michael Tretter 2019-01-09  651  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  652  	}
573e9a62 Michael Tretter 2019-01-09  653  
573e9a62 Michael Tretter 2019-01-09  654  	/*
573e9a62 Michael Tretter 2019-01-09  655  	 * The message might wrap within the mailbox. If the message does not
573e9a62 Michael Tretter 2019-01-09  656  	 * wrap, the first read will read the entire message, otherwise the
573e9a62 Michael Tretter 2019-01-09  657  	 * first read will read message until the end of the mailbox and the
573e9a62 Michael Tretter 2019-01-09  658  	 * second read will read the remaining bytes from the beginning of the
573e9a62 Michael Tretter 2019-01-09  659  	 * mailbox.
573e9a62 Michael Tretter 2019-01-09  660  	 *
573e9a62 Michael Tretter 2019-01-09  661  	 * Skip the header, as was already read to get the size of the body.
573e9a62 Michael Tretter 2019-01-09  662  	 */
573e9a62 Michael Tretter 2019-01-09  663  	body_no_wrap = min((size_t)header->length,
573e9a62 Michael Tretter 2019-01-09  664  			   (mbox->size - (head + sizeof(*header))));
573e9a62 Michael Tretter 2019-01-09  665  	regmap_bulk_read(dev->sram, mbox->data + head + sizeof(*header),
573e9a62 Michael Tretter 2019-01-09  666  			 dst + sizeof(*header), body_no_wrap / 4);
573e9a62 Michael Tretter 2019-01-09  667  	regmap_bulk_read(dev->sram, mbox->data,
573e9a62 Michael Tretter 2019-01-09  668  			 dst + sizeof(*header) + body_no_wrap,
573e9a62 Michael Tretter 2019-01-09  669  			 (header->length - body_no_wrap) / 4);
573e9a62 Michael Tretter 2019-01-09  670  
573e9a62 Michael Tretter 2019-01-09  671  	regmap_write(dev->sram, mbox->head, (head + size) % mbox->size);
573e9a62 Michael Tretter 2019-01-09  672  
573e9a62 Michael Tretter 2019-01-09  673  	v4l2_dbg(2, debug, &dev->v4l2_dev,
573e9a62 Michael Tretter 2019-01-09  674  		"read status message: type %s, body length %d\n",
573e9a62 Michael Tretter 2019-01-09  675  		msg_type_name(header->type), header->length);
573e9a62 Michael Tretter 2019-01-09  676  
573e9a62 Michael Tretter 2019-01-09  677  	return size;
573e9a62 Michael Tretter 2019-01-09  678  }
573e9a62 Michael Tretter 2019-01-09  679  
573e9a62 Michael Tretter 2019-01-09  680  static void allegro_mcu_interrupt(struct allegro_dev *dev)
573e9a62 Michael Tretter 2019-01-09  681  {
573e9a62 Michael Tretter 2019-01-09  682  	regmap_write(dev->regmap, AL5_MCU_INTERRUPT, BIT(0));
573e9a62 Michael Tretter 2019-01-09  683  }
573e9a62 Michael Tretter 2019-01-09  684  
573e9a62 Michael Tretter 2019-01-09  685  static void allegro_mcu_send_init(struct allegro_dev *dev,
573e9a62 Michael Tretter 2019-01-09  686  				  dma_addr_t suballoc_dma, size_t suballoc_size)
573e9a62 Michael Tretter 2019-01-09  687  {
573e9a62 Michael Tretter 2019-01-09  688  	struct mcu_msg_init_request msg;
573e9a62 Michael Tretter 2019-01-09  689  
573e9a62 Michael Tretter 2019-01-09  690  	msg.header.type = MCU_MSG_TYPE_INIT;
573e9a62 Michael Tretter 2019-01-09  691  	msg.header.length = sizeof(msg) - sizeof(msg.header);
573e9a62 Michael Tretter 2019-01-09  692  	msg.reserved0 = 0;
573e9a62 Michael Tretter 2019-01-09  693  	msg.suballoc_dma = lower_32_bits(suballoc_dma) | MCU_CACHE_OFFSET;
573e9a62 Michael Tretter 2019-01-09  694  	msg.suballoc_size = suballoc_size;
573e9a62 Michael Tretter 2019-01-09  695  
573e9a62 Michael Tretter 2019-01-09  696  	/* TODO Add L2 cache support. */
573e9a62 Michael Tretter 2019-01-09  697  	msg.l2_cache[0] = -1;
573e9a62 Michael Tretter 2019-01-09  698  	msg.l2_cache[1] = -1;
573e9a62 Michael Tretter 2019-01-09  699  	msg.l2_cache[2] = -1;
573e9a62 Michael Tretter 2019-01-09  700  
573e9a62 Michael Tretter 2019-01-09  701  	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
573e9a62 Michael Tretter 2019-01-09  702  	allegro_mcu_interrupt(dev);
573e9a62 Michael Tretter 2019-01-09  703  }
573e9a62 Michael Tretter 2019-01-09  704  
573e9a62 Michael Tretter 2019-01-09  705  static u32 v4l2_pixelformat_to_mcu_format(u32 pixelformat)
573e9a62 Michael Tretter 2019-01-09  706  {
573e9a62 Michael Tretter 2019-01-09  707  	switch (pixelformat) {
573e9a62 Michael Tretter 2019-01-09  708  	case V4L2_PIX_FMT_NV12:
573e9a62 Michael Tretter 2019-01-09  709  		/* AL_420_8BITS: 0x100 -> NV12, 0x88 -> 8 bit */
573e9a62 Michael Tretter 2019-01-09  710  		return 0x100 | 0x88;
573e9a62 Michael Tretter 2019-01-09  711  	default:
573e9a62 Michael Tretter 2019-01-09  712  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  713  	}
573e9a62 Michael Tretter 2019-01-09  714  }
573e9a62 Michael Tretter 2019-01-09  715  
573e9a62 Michael Tretter 2019-01-09  716  static u32 v4l2_colorspace_to_mcu_colorspace(enum v4l2_colorspace colorspace)
573e9a62 Michael Tretter 2019-01-09  717  {
573e9a62 Michael Tretter 2019-01-09  718  	switch (colorspace) {
573e9a62 Michael Tretter 2019-01-09  719  	case V4L2_COLORSPACE_DEFAULT:
573e9a62 Michael Tretter 2019-01-09  720  		/* fallthrough */
573e9a62 Michael Tretter 2019-01-09  721  	default:
573e9a62 Michael Tretter 2019-01-09  722  		/* e_ColorSpace.UNKNOWN */
573e9a62 Michael Tretter 2019-01-09  723  		return 0;
573e9a62 Michael Tretter 2019-01-09  724  	}
573e9a62 Michael Tretter 2019-01-09  725  }
573e9a62 Michael Tretter 2019-01-09  726  
573e9a62 Michael Tretter 2019-01-09  727  static s8 v4l2_pixelformat_to_mcu_codec(u32 pixelformat)
573e9a62 Michael Tretter 2019-01-09  728  {
573e9a62 Michael Tretter 2019-01-09  729  	switch (pixelformat) {
573e9a62 Michael Tretter 2019-01-09  730  	case V4L2_PIX_FMT_H264:
573e9a62 Michael Tretter 2019-01-09  731  		return 1;
573e9a62 Michael Tretter 2019-01-09  732  	default:
573e9a62 Michael Tretter 2019-01-09  733  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  734  	}
573e9a62 Michael Tretter 2019-01-09  735  }
573e9a62 Michael Tretter 2019-01-09  736  
573e9a62 Michael Tretter 2019-01-09  737  static u8 v4l2_profile_to_mcu_profile(enum v4l2_mpeg_video_h264_profile profile)
573e9a62 Michael Tretter 2019-01-09  738  {
573e9a62 Michael Tretter 2019-01-09  739  	switch (profile) {
573e9a62 Michael Tretter 2019-01-09  740  	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
573e9a62 Michael Tretter 2019-01-09  741  		return 66;
573e9a62 Michael Tretter 2019-01-09  742  	default:
573e9a62 Michael Tretter 2019-01-09 @743  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  744  	}
573e9a62 Michael Tretter 2019-01-09  745  }
573e9a62 Michael Tretter 2019-01-09  746  
573e9a62 Michael Tretter 2019-01-09  747  static u16 v4l2_level_to_mcu_level(enum v4l2_mpeg_video_h264_level level)
573e9a62 Michael Tretter 2019-01-09  748  {
573e9a62 Michael Tretter 2019-01-09  749  	switch (level) {
573e9a62 Michael Tretter 2019-01-09  750  	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
573e9a62 Michael Tretter 2019-01-09  751  		return 20;
573e9a62 Michael Tretter 2019-01-09  752  	default:
573e9a62 Michael Tretter 2019-01-09 @753  		return -EINVAL;
573e9a62 Michael Tretter 2019-01-09  754  	}
573e9a62 Michael Tretter 2019-01-09  755  }
573e9a62 Michael Tretter 2019-01-09  756  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
