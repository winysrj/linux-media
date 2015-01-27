Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbA0HyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 02:54:20 -0500
Date: Tue, 27 Jan 2015 10:54:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Benoit Parrot <bparrot@ti.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Darren Etheridge <detheridge@ti.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 66/93]
 drivers/media/platform/am437x/am437x-vpfe.c:2027 vpfe_start_streaming()
 error: double unlock 'spin_lock:&vpfe->dma_queue_lock'
Message-ID: <20150127075403.GH6507@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   e32b31ae45c18679c186e67aa41d0e2318cae487
commit: 417d2e507edcb5cf15eb344f86bd3dd28737f24e [66/93] [media] media: platform: add VPFE capture driver support for AM437X

drivers/media/platform/am437x/am437x-vpfe.c:2027 vpfe_start_streaming() error: double unlock 'spin_lock:&vpfe->dma_queue_lock'
drivers/media/platform/am437x/am437x-vpfe.c:2027 vpfe_start_streaming() error: double unlock 'irqsave:flags'

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout 417d2e507edcb5cf15eb344f86bd3dd28737f24e
vim +2027 drivers/media/platform/am437x/am437x-vpfe.c

417d2e50 Benoit Parrot 2014-12-09  2011  
417d2e50 Benoit Parrot 2014-12-09  2012  	vpfe_pcr_enable(&vpfe->ccdc, 1);
417d2e50 Benoit Parrot 2014-12-09  2013  
417d2e50 Benoit Parrot 2014-12-09  2014  	ret = v4l2_subdev_call(sdinfo->sd, video, s_stream, 1);
417d2e50 Benoit Parrot 2014-12-09  2015  	if (ret < 0) {
417d2e50 Benoit Parrot 2014-12-09  2016  		vpfe_err(vpfe, "Error in attaching interrupt handle\n");
417d2e50 Benoit Parrot 2014-12-09  2017  		goto err;
417d2e50 Benoit Parrot 2014-12-09  2018  	}
417d2e50 Benoit Parrot 2014-12-09  2019  
417d2e50 Benoit Parrot 2014-12-09  2020  	return 0;
417d2e50 Benoit Parrot 2014-12-09  2021  
417d2e50 Benoit Parrot 2014-12-09  2022  err:
417d2e50 Benoit Parrot 2014-12-09  2023  	list_for_each_entry_safe(buf, tmp, &vpfe->dma_queue, list) {
417d2e50 Benoit Parrot 2014-12-09  2024  		list_del(&buf->list);
417d2e50 Benoit Parrot 2014-12-09  2025  		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
417d2e50 Benoit Parrot 2014-12-09  2026  	}
417d2e50 Benoit Parrot 2014-12-09 @2027  	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
417d2e50 Benoit Parrot 2014-12-09  2028  
417d2e50 Benoit Parrot 2014-12-09  2029  	return ret;
417d2e50 Benoit Parrot 2014-12-09  2030  }
417d2e50 Benoit Parrot 2014-12-09  2031  
417d2e50 Benoit Parrot 2014-12-09  2032  /*
417d2e50 Benoit Parrot 2014-12-09  2033   * vpfe_stop_streaming : Stop the DMA engine
417d2e50 Benoit Parrot 2014-12-09  2034   * @vq: ptr to vb2_queue
417d2e50 Benoit Parrot 2014-12-09  2035   *

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
