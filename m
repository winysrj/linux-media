Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaIXMl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] [media] s5p_mfc_opr_v6: fix wrong type for registers
Date: Wed, 24 Sep 2014 09:41:41 -0300
Message-Id: <ee43ef05512b006ad6f2245877884b57ed25877a.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411562226.git.mchehab@osg.samsung.com>
References: <cover.1411562226.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch, there are several warnings related to bad
types for registers. Worse than that, there are too many errors,
preventing smatch to warn about real issues. So, fix them:

drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:414:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:414:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:414:35:    got void *const d_stream_data_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:415:34: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:415:34:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:415:34:    got void *const d_cpb_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:416:39: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:416:39:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:416:39:    got void *const d_cpb_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:417:40: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:417:40:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:417:40:    got void *const d_cpb_buffer_offset
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:441:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:441:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:441:46:    got void *const d_num_dpb
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:442:40: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:442:40:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:442:40:    got void *const d_first_plane_dpb_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:443:42: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:443:42:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:443:42:    got void *const d_second_plane_dpb_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:445:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:445:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:445:35:    got void *const d_scratch_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:446:47: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:446:47:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:446:47:    got void *const d_scratch_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:450:33: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:450:33:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:450:33:    got void *const d_first_plane_dpb_stride_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:452:33: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:452:33:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:452:33:    got void *const d_second_plane_dpb_stride_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:460:46: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:460:46:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:460:46:    got void *const d_mv_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:461:47: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:461:47:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:461:47:    got void *const d_num_mv
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:475:61: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:475:61:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:475:61:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:479:62: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:479:62:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:479:62:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:492:65: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:492:65:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:492:65:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:505:38: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:505:38:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:505:38:    got void *const instance_id
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:520:30: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:520:30:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:520:30:    got void *const e_stream_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:521:30: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:521:30:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:521:30:    got void *const e_stream_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:535:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:535:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:535:32:    got void *const e_source_first_plane_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:536:32: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:536:32:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:536:32:    got void *const e_source_second_plane_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:549:33: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:549:33:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:549:33:    got void *const e_encoded_source_first_plane_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:550:33: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:550:33:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:550:33:    got void *const e_encoded_source_second_plane_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:552:42: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:552:42:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:552:42:    got void *const e_recon_luma_dpb_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:553:42: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:553:42:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:553:42:    got void *const e_recon_chroma_dpb_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:575:56: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:575:56:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:575:56:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:577:58: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:577:58:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:577:58:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:579:57: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:579:57:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:579:57:    got void *
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:585:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:585:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:585:35:    got void *const e_scratch_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:586:47: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:586:47:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:586:47:    got void *const e_scratch_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:590:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:590:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:590:35:    got void *const e_tmv_buffer0
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:592:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:592:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:592:35:    got void *const e_tmv_buffer1
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:603:38: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:603:38:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:603:38:    got void *const instance_id
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:619:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:619:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:619:41:    got void *const e_mslice_mode
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:621:52: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:621:52:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:621:52:    got void *const e_mslice_size_mb
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:624:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:624:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:624:54:    got void *const e_mslice_size_bits
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:626:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:626:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:626:37:    got void *const e_mslice_size_mb
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:627:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:627:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:627:37:    got void *const e_mslice_size_bits
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:643:40: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:643:40:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:643:40:    got void *const e_frame_width
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:645:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:645:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:645:41:    got void *const e_frame_height
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:648:40: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:648:40:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:648:40:    got void *const e_cropped_frame_width
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:650:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:650:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:650:41:    got void *const e_cropped_frame_height
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:652:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:652:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:652:29:    got void *const e_frame_crop_offset
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:657:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:657:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:657:29:    got void *const e_gop_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:665:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:665:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:665:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:669:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:669:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:669:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:673:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:673:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:673:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:679:45: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:679:45:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:679:45:    got void *const e_ir_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:680:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:680:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:680:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:685:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:685:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:685:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:688:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:688:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:688:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:690:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:690:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:690:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:695:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:695:37:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:695:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:697:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:697:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:697:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:699:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:699:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:699:37:    got void *const pixel_format
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:702:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:702:37:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:702:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:704:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:704:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:704:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:706:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:706:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:706:37:    got void *const pixel_format
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:709:37: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:709:37:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:709:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:711:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:711:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:711:37:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:713:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:713:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:713:37:    got void *const pixel_format
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:718:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:718:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:718:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:720:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:720:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:720:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:723:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:723:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:723:29:    got void *const e_padding_ctrl
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:734:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:734:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:734:37:    got void *const e_padding_ctrl
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:741:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:741:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:741:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:746:33: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:746:33:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:746:33:    got void *const e_rc_bit_rate
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:748:35: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:748:35:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:748:35:    got void *const e_rc_bit_rate
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:753:43: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:753:43:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:753:43:    got void *const e_rc_mode
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:755:43: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:755:43:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:755:43:    got void *const e_rc_mode
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:759:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:759:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:759:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:766:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:766:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:766:29:    got void *const e_enc_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:769:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:769:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:769:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:771:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:771:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:771:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:775:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:775:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:775:29:    got void *const e_mv_hor_range
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:778:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:778:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:778:29:    got void *const e_mv_ver_range
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:780:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:780:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:780:29:    got void *const e_frame_insertion
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:781:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:781:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:781:29:    got void *const e_roi_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:782:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:782:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:782:29:    got void *const e_param_change
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:783:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:783:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:783:29:    got void *const e_rc_roi_ctrl
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:784:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:784:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:784:29:    got void *const e_picture_tag
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:786:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:786:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:786:29:    got void *const e_bit_count_enable
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:787:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:787:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:787:29:    got void *const e_max_bit_count
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:788:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:788:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:788:29:    got void *const e_min_bit_count
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:790:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:790:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:790:29:    got void *const e_metadata_buffer_addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:791:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:791:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:791:29:    got void *const e_metadata_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:812:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:812:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:812:29:    got void *const e_gop_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:815:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:815:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:815:29:    got void *const e_gop_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:823:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:823:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:823:29:    got void *const e_picture_profile
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:826:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:826:29:    expected void const volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:826:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:830:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:830:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:830:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:835:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:835:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:835:29:    got void *const e_rc_config
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:843:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:843:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:843:29:    got void *const e_rc_qp_bound
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:846:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:846:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:846:29:    got void *const e_fixed_picture_qp
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:852:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:852:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:852:37:    got void *const e_fixed_picture_qp
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:860:37: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:860:37:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:860:37:    got void *const e_rc_frame_rate
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:867:41: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:867:41:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:867:41:    got void *const e_vbv_buffer_size
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:870:54: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:870:54:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:870:54:    got void *const e_vbv_init_delay
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:876:29: warning: incorrect type in argument 2 (different address spaces)
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:876:29:    expected void volatile [noderef] <asn:2>*addr
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:876:29:    got void *const e_h264_options
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:881:41: warning: too many warnings

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 7a7ad32ee608..de2b8c69daa5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -20,254 +20,254 @@
 struct s5p_mfc_regs {
 
 	/* codec common registers */
-	void *risc_on;
-	void *risc2host_int;
-	void *host2risc_int;
-	void *risc_base_address;
-	void *mfc_reset;
-	void *host2risc_command;
-	void *risc2host_command;
-	void *mfc_bus_reset_ctrl;
-	void *firmware_version;
-	void *instance_id;
-	void *codec_type;
-	void *context_mem_addr;
-	void *context_mem_size;
-	void *pixel_format;
-	void *metadata_enable;
-	void *mfc_version;
-	void *dbg_info_enable;
-	void *dbg_buffer_addr;
-	void *dbg_buffer_size;
-	void *hed_control;
-	void *mfc_timeout_value;
-	void *hed_shared_mem_addr;
-	void *dis_shared_mem_addr;/* only v7 */
-	void *ret_instance_id;
-	void *error_code;
-	void *dbg_buffer_output_size;
-	void *metadata_status;
-	void *metadata_addr_mb_info;
-	void *metadata_size_mb_info;
-	void *dbg_info_stage_counter;
+	volatile void __iomem *risc_on;
+	volatile void __iomem *risc2host_int;
+	volatile void __iomem *host2risc_int;
+	volatile void __iomem *risc_base_address;
+	volatile void __iomem *mfc_reset;
+	volatile void __iomem *host2risc_command;
+	volatile void __iomem *risc2host_command;
+	volatile void __iomem *mfc_bus_reset_ctrl;
+	volatile void __iomem *firmware_version;
+	volatile void __iomem *instance_id;
+	volatile void __iomem *codec_type;
+	volatile void __iomem *context_mem_addr;
+	volatile void __iomem *context_mem_size;
+	volatile void __iomem *pixel_format;
+	volatile void __iomem *metadata_enable;
+	volatile void __iomem *mfc_version;
+	volatile void __iomem *dbg_info_enable;
+	volatile void __iomem *dbg_buffer_addr;
+	volatile void __iomem *dbg_buffer_size;
+	volatile void __iomem *hed_control;
+	volatile void __iomem *mfc_timeout_value;
+	volatile void __iomem *hed_shared_mem_addr;
+	volatile void __iomem *dis_shared_mem_addr;/* only v7 */
+	volatile void __iomem *ret_instance_id;
+	volatile void __iomem *error_code;
+	volatile void __iomem *dbg_buffer_output_size;
+	volatile void __iomem *metadata_status;
+	volatile void __iomem *metadata_addr_mb_info;
+	volatile void __iomem *metadata_size_mb_info;
+	volatile void __iomem *dbg_info_stage_counter;
 
 	/* decoder registers */
-	void *d_crc_ctrl;
-	void *d_dec_options;
-	void *d_display_delay;
-	void *d_set_frame_width;
-	void *d_set_frame_height;
-	void *d_sei_enable;
-	void *d_min_num_dpb;
-	void *d_min_first_plane_dpb_size;
-	void *d_min_second_plane_dpb_size;
-	void *d_min_third_plane_dpb_size;/* only v8 */
-	void *d_min_num_mv;
-	void *d_mvc_num_views;
-	void *d_min_num_dis;/* only v7 */
-	void *d_min_first_dis_size;/* only v7 */
-	void *d_min_second_dis_size;/* only v7 */
-	void *d_min_third_dis_size;/* only v7 */
-	void *d_post_filter_luma_dpb0;/*  v7 and v8 */
-	void *d_post_filter_luma_dpb1;/* v7 and v8 */
-	void *d_post_filter_luma_dpb2;/* only v7 */
-	void *d_post_filter_chroma_dpb0;/* v7 and v8 */
-	void *d_post_filter_chroma_dpb1;/* v7 and v8 */
-	void *d_post_filter_chroma_dpb2;/* only v7 */
-	void *d_num_dpb;
-	void *d_num_mv;
-	void *d_init_buffer_options;
-	void *d_first_plane_dpb_stride_size;/* only v8 */
-	void *d_second_plane_dpb_stride_size;/* only v8 */
-	void *d_third_plane_dpb_stride_size;/* only v8 */
-	void *d_first_plane_dpb_size;
-	void *d_second_plane_dpb_size;
-	void *d_third_plane_dpb_size;/* only v8 */
-	void *d_mv_buffer_size;
-	void *d_first_plane_dpb;
-	void *d_second_plane_dpb;
-	void *d_third_plane_dpb;
-	void *d_mv_buffer;
-	void *d_scratch_buffer_addr;
-	void *d_scratch_buffer_size;
-	void *d_metadata_buffer_addr;
-	void *d_metadata_buffer_size;
-	void *d_nal_start_options;/* v7 and v8 */
-	void *d_cpb_buffer_addr;
-	void *d_cpb_buffer_size;
-	void *d_available_dpb_flag_upper;
-	void *d_available_dpb_flag_lower;
-	void *d_cpb_buffer_offset;
-	void *d_slice_if_enable;
-	void *d_picture_tag;
-	void *d_stream_data_size;
-	void *d_dynamic_dpb_flag_upper;/* v7 and v8 */
-	void *d_dynamic_dpb_flag_lower;/* v7 and v8 */
-	void *d_display_frame_width;
-	void *d_display_frame_height;
-	void *d_display_status;
-	void *d_display_first_plane_addr;
-	void *d_display_second_plane_addr;
-	void *d_display_third_plane_addr;/* only v8 */
-	void *d_display_frame_type;
-	void *d_display_crop_info1;
-	void *d_display_crop_info2;
-	void *d_display_picture_profile;
-	void *d_display_luma_crc;/* v7 and v8 */
-	void *d_display_chroma0_crc;/* v7 and v8 */
-	void *d_display_chroma1_crc;/* only v8 */
-	void *d_display_luma_crc_top;/* only v6 */
-	void *d_display_chroma_crc_top;/* only v6 */
-	void *d_display_luma_crc_bot;/* only v6 */
-	void *d_display_chroma_crc_bot;/* only v6 */
-	void *d_display_aspect_ratio;
-	void *d_display_extended_ar;
-	void *d_decoded_frame_width;
-	void *d_decoded_frame_height;
-	void *d_decoded_status;
-	void *d_decoded_first_plane_addr;
-	void *d_decoded_second_plane_addr;
-	void *d_decoded_third_plane_addr;/* only v8 */
-	void *d_decoded_frame_type;
-	void *d_decoded_crop_info1;
-	void *d_decoded_crop_info2;
-	void *d_decoded_picture_profile;
-	void *d_decoded_nal_size;
-	void *d_decoded_luma_crc;
-	void *d_decoded_chroma0_crc;
-	void *d_decoded_chroma1_crc;/* only v8 */
-	void *d_ret_picture_tag_top;
-	void *d_ret_picture_tag_bot;
-	void *d_ret_picture_time_top;
-	void *d_ret_picture_time_bot;
-	void *d_chroma_format;
-	void *d_vc1_info;/* v7 and v8 */
-	void *d_mpeg4_info;
-	void *d_h264_info;
-	void *d_metadata_addr_concealed_mb;
-	void *d_metadata_size_concealed_mb;
-	void *d_metadata_addr_vc1_param;
-	void *d_metadata_size_vc1_param;
-	void *d_metadata_addr_sei_nal;
-	void *d_metadata_size_sei_nal;
-	void *d_metadata_addr_vui;
-	void *d_metadata_size_vui;
-	void *d_metadata_addr_mvcvui;/* v7 and v8 */
-	void *d_metadata_size_mvcvui;/* v7 and v8 */
-	void *d_mvc_view_id;
-	void *d_frame_pack_sei_avail;
-	void *d_frame_pack_arrgment_id;
-	void *d_frame_pack_sei_info;
-	void *d_frame_pack_grid_pos;
-	void *d_display_recovery_sei_info;/* v7 and v8 */
-	void *d_decoded_recovery_sei_info;/* v7 and v8 */
-	void *d_display_first_addr;/* only v7 */
-	void *d_display_second_addr;/* only v7 */
-	void *d_display_third_addr;/* only v7 */
-	void *d_decoded_first_addr;/* only v7 */
-	void *d_decoded_second_addr;/* only v7 */
-	void *d_decoded_third_addr;/* only v7 */
-	void *d_used_dpb_flag_upper;/* v7 and v8 */
-	void *d_used_dpb_flag_lower;/* v7 and v8 */
+	volatile void __iomem *d_crc_ctrl;
+	volatile void __iomem *d_dec_options;
+	volatile void __iomem *d_display_delay;
+	volatile void __iomem *d_set_frame_width;
+	volatile void __iomem *d_set_frame_height;
+	volatile void __iomem *d_sei_enable;
+	volatile void __iomem *d_min_num_dpb;
+	volatile void __iomem *d_min_first_plane_dpb_size;
+	volatile void __iomem *d_min_second_plane_dpb_size;
+	volatile void __iomem *d_min_third_plane_dpb_size;/* only v8 */
+	volatile void __iomem *d_min_num_mv;
+	volatile void __iomem *d_mvc_num_views;
+	volatile void __iomem *d_min_num_dis;/* only v7 */
+	volatile void __iomem *d_min_first_dis_size;/* only v7 */
+	volatile void __iomem *d_min_second_dis_size;/* only v7 */
+	volatile void __iomem *d_min_third_dis_size;/* only v7 */
+	volatile void __iomem *d_post_filter_luma_dpb0;/*  v7 and v8 */
+	volatile void __iomem *d_post_filter_luma_dpb1;/* v7 and v8 */
+	volatile void __iomem *d_post_filter_luma_dpb2;/* only v7 */
+	volatile void __iomem *d_post_filter_chroma_dpb0;/* v7 and v8 */
+	volatile void __iomem *d_post_filter_chroma_dpb1;/* v7 and v8 */
+	volatile void __iomem *d_post_filter_chroma_dpb2;/* only v7 */
+	volatile void __iomem *d_num_dpb;
+	volatile void __iomem *d_num_mv;
+	volatile void __iomem *d_init_buffer_options;
+	volatile void __iomem *d_first_plane_dpb_stride_size;/* only v8 */
+	volatile void __iomem *d_second_plane_dpb_stride_size;/* only v8 */
+	volatile void __iomem *d_third_plane_dpb_stride_size;/* only v8 */
+	volatile void __iomem *d_first_plane_dpb_size;
+	volatile void __iomem *d_second_plane_dpb_size;
+	volatile void __iomem *d_third_plane_dpb_size;/* only v8 */
+	volatile void __iomem *d_mv_buffer_size;
+	volatile void __iomem *d_first_plane_dpb;
+	volatile void __iomem *d_second_plane_dpb;
+	volatile void __iomem *d_third_plane_dpb;
+	volatile void __iomem *d_mv_buffer;
+	volatile void __iomem *d_scratch_buffer_addr;
+	volatile void __iomem *d_scratch_buffer_size;
+	volatile void __iomem *d_metadata_buffer_addr;
+	volatile void __iomem *d_metadata_buffer_size;
+	volatile void __iomem *d_nal_start_options;/* v7 and v8 */
+	volatile void __iomem *d_cpb_buffer_addr;
+	volatile void __iomem *d_cpb_buffer_size;
+	volatile void __iomem *d_available_dpb_flag_upper;
+	volatile void __iomem *d_available_dpb_flag_lower;
+	volatile void __iomem *d_cpb_buffer_offset;
+	volatile void __iomem *d_slice_if_enable;
+	volatile void __iomem *d_picture_tag;
+	volatile void __iomem *d_stream_data_size;
+	volatile void __iomem *d_dynamic_dpb_flag_upper;/* v7 and v8 */
+	volatile void __iomem *d_dynamic_dpb_flag_lower;/* v7 and v8 */
+	volatile void __iomem *d_display_frame_width;
+	volatile void __iomem *d_display_frame_height;
+	volatile void __iomem *d_display_status;
+	volatile void __iomem *d_display_first_plane_addr;
+	volatile void __iomem *d_display_second_plane_addr;
+	volatile void __iomem *d_display_third_plane_addr;/* only v8 */
+	volatile void __iomem *d_display_frame_type;
+	volatile void __iomem *d_display_crop_info1;
+	volatile void __iomem *d_display_crop_info2;
+	volatile void __iomem *d_display_picture_profile;
+	volatile void __iomem *d_display_luma_crc;/* v7 and v8 */
+	volatile void __iomem *d_display_chroma0_crc;/* v7 and v8 */
+	volatile void __iomem *d_display_chroma1_crc;/* only v8 */
+	volatile void __iomem *d_display_luma_crc_top;/* only v6 */
+	volatile void __iomem *d_display_chroma_crc_top;/* only v6 */
+	volatile void __iomem *d_display_luma_crc_bot;/* only v6 */
+	volatile void __iomem *d_display_chroma_crc_bot;/* only v6 */
+	volatile void __iomem *d_display_aspect_ratio;
+	volatile void __iomem *d_display_extended_ar;
+	volatile void __iomem *d_decoded_frame_width;
+	volatile void __iomem *d_decoded_frame_height;
+	volatile void __iomem *d_decoded_status;
+	volatile void __iomem *d_decoded_first_plane_addr;
+	volatile void __iomem *d_decoded_second_plane_addr;
+	volatile void __iomem *d_decoded_third_plane_addr;/* only v8 */
+	volatile void __iomem *d_decoded_frame_type;
+	volatile void __iomem *d_decoded_crop_info1;
+	volatile void __iomem *d_decoded_crop_info2;
+	volatile void __iomem *d_decoded_picture_profile;
+	volatile void __iomem *d_decoded_nal_size;
+	volatile void __iomem *d_decoded_luma_crc;
+	volatile void __iomem *d_decoded_chroma0_crc;
+	volatile void __iomem *d_decoded_chroma1_crc;/* only v8 */
+	volatile void __iomem *d_ret_picture_tag_top;
+	volatile void __iomem *d_ret_picture_tag_bot;
+	volatile void __iomem *d_ret_picture_time_top;
+	volatile void __iomem *d_ret_picture_time_bot;
+	volatile void __iomem *d_chroma_format;
+	volatile void __iomem *d_vc1_info;/* v7 and v8 */
+	volatile void __iomem *d_mpeg4_info;
+	volatile void __iomem *d_h264_info;
+	volatile void __iomem *d_metadata_addr_concealed_mb;
+	volatile void __iomem *d_metadata_size_concealed_mb;
+	volatile void __iomem *d_metadata_addr_vc1_param;
+	volatile void __iomem *d_metadata_size_vc1_param;
+	volatile void __iomem *d_metadata_addr_sei_nal;
+	volatile void __iomem *d_metadata_size_sei_nal;
+	volatile void __iomem *d_metadata_addr_vui;
+	volatile void __iomem *d_metadata_size_vui;
+	volatile void __iomem *d_metadata_addr_mvcvui;/* v7 and v8 */
+	volatile void __iomem *d_metadata_size_mvcvui;/* v7 and v8 */
+	volatile void __iomem *d_mvc_view_id;
+	volatile void __iomem *d_frame_pack_sei_avail;
+	volatile void __iomem *d_frame_pack_arrgment_id;
+	volatile void __iomem *d_frame_pack_sei_info;
+	volatile void __iomem *d_frame_pack_grid_pos;
+	volatile void __iomem *d_display_recovery_sei_info;/* v7 and v8 */
+	volatile void __iomem *d_decoded_recovery_sei_info;/* v7 and v8 */
+	volatile void __iomem *d_display_first_addr;/* only v7 */
+	volatile void __iomem *d_display_second_addr;/* only v7 */
+	volatile void __iomem *d_display_third_addr;/* only v7 */
+	volatile void __iomem *d_decoded_first_addr;/* only v7 */
+	volatile void __iomem *d_decoded_second_addr;/* only v7 */
+	volatile void __iomem *d_decoded_third_addr;/* only v7 */
+	volatile void __iomem *d_used_dpb_flag_upper;/* v7 and v8 */
+	volatile void __iomem *d_used_dpb_flag_lower;/* v7 and v8 */
 
 	/* encoder registers */
-	void *e_frame_width;
-	void *e_frame_height;
-	void *e_cropped_frame_width;
-	void *e_cropped_frame_height;
-	void *e_frame_crop_offset;
-	void *e_enc_options;
-	void *e_picture_profile;
-	void *e_vbv_buffer_size;
-	void *e_vbv_init_delay;
-	void *e_fixed_picture_qp;
-	void *e_rc_config;
-	void *e_rc_qp_bound;
-	void *e_rc_qp_bound_pb;/* v7 and v8 */
-	void *e_rc_mode;
-	void *e_mb_rc_config;
-	void *e_padding_ctrl;
-	void *e_air_threshold;
-	void *e_mv_hor_range;
-	void *e_mv_ver_range;
-	void *e_num_dpb;
-	void *e_luma_dpb;
-	void *e_chroma_dpb;
-	void *e_me_buffer;
-	void *e_scratch_buffer_addr;
-	void *e_scratch_buffer_size;
-	void *e_tmv_buffer0;
-	void *e_tmv_buffer1;
-	void *e_ir_buffer_addr;/* v7 and v8 */
-	void *e_source_first_plane_addr;
-	void *e_source_second_plane_addr;
-	void *e_source_third_plane_addr;/* v7 and v8 */
-	void *e_source_first_plane_stride;/* v7 and v8 */
-	void *e_source_second_plane_stride;/* v7 and v8 */
-	void *e_source_third_plane_stride;/* v7 and v8 */
-	void *e_stream_buffer_addr;
-	void *e_stream_buffer_size;
-	void *e_roi_buffer_addr;
-	void *e_param_change;
-	void *e_ir_size;
-	void *e_gop_config;
-	void *e_mslice_mode;
-	void *e_mslice_size_mb;
-	void *e_mslice_size_bits;
-	void *e_frame_insertion;
-	void *e_rc_frame_rate;
-	void *e_rc_bit_rate;
-	void *e_rc_roi_ctrl;
-	void *e_picture_tag;
-	void *e_bit_count_enable;
-	void *e_max_bit_count;
-	void *e_min_bit_count;
-	void *e_metadata_buffer_addr;
-	void *e_metadata_buffer_size;
-	void *e_encoded_source_first_plane_addr;
-	void *e_encoded_source_second_plane_addr;
-	void *e_encoded_source_third_plane_addr;/* v7 and v8 */
-	void *e_stream_size;
-	void *e_slice_type;
-	void *e_picture_count;
-	void *e_ret_picture_tag;
-	void *e_stream_buffer_write_pointer; /*  only v6 */
-	void *e_recon_luma_dpb_addr;
-	void *e_recon_chroma_dpb_addr;
-	void *e_metadata_addr_enc_slice;
-	void *e_metadata_size_enc_slice;
-	void *e_mpeg4_options;
-	void *e_mpeg4_hec_period;
-	void *e_aspect_ratio;
-	void *e_extended_sar;
-	void *e_h264_options;
-	void *e_h264_options_2;/* v7 and v8 */
-	void *e_h264_lf_alpha_offset;
-	void *e_h264_lf_beta_offset;
-	void *e_h264_i_period;
-	void *e_h264_fmo_slice_grp_map_type;
-	void *e_h264_fmo_num_slice_grp_minus1;
-	void *e_h264_fmo_slice_grp_change_dir;
-	void *e_h264_fmo_slice_grp_change_rate_minus1;
-	void *e_h264_fmo_run_length_minus1_0;
-	void *e_h264_aso_slice_order_0;
-	void *e_h264_chroma_qp_offset;
-	void *e_h264_num_t_layer;
-	void *e_h264_hierarchical_qp_layer0;
-	void *e_h264_frame_packing_sei_info;
-	void *e_h264_nal_control;/* v7 and v8 */
-	void *e_mvc_frame_qp_view1;
-	void *e_mvc_rc_bit_rate_view1;
-	void *e_mvc_rc_qbound_view1;
-	void *e_mvc_rc_mode_view1;
-	void *e_mvc_inter_view_prediction_on;
-	void *e_vp8_options;/* v7 and v8 */
-	void *e_vp8_filter_options;/* v7 and v8 */
-	void *e_vp8_golden_frame_option;/* v7 and v8 */
-	void *e_vp8_num_t_layer;/* v7 and v8 */
-	void *e_vp8_hierarchical_qp_layer0;/* v7 and v8 */
-	void *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
-	void *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
+	volatile void __iomem *e_frame_width;
+	volatile void __iomem *e_frame_height;
+	volatile void __iomem *e_cropped_frame_width;
+	volatile void __iomem *e_cropped_frame_height;
+	volatile void __iomem *e_frame_crop_offset;
+	volatile void __iomem *e_enc_options;
+	volatile void __iomem *e_picture_profile;
+	volatile void __iomem *e_vbv_buffer_size;
+	volatile void __iomem *e_vbv_init_delay;
+	volatile void __iomem *e_fixed_picture_qp;
+	volatile void __iomem *e_rc_config;
+	volatile void __iomem *e_rc_qp_bound;
+	volatile void __iomem *e_rc_qp_bound_pb;/* v7 and v8 */
+	volatile void __iomem *e_rc_mode;
+	volatile void __iomem *e_mb_rc_config;
+	volatile void __iomem *e_padding_ctrl;
+	volatile void __iomem *e_air_threshold;
+	volatile void __iomem *e_mv_hor_range;
+	volatile void __iomem *e_mv_ver_range;
+	volatile void __iomem *e_num_dpb;
+	volatile void __iomem *e_luma_dpb;
+	volatile void __iomem *e_chroma_dpb;
+	volatile void __iomem *e_me_buffer;
+	volatile void __iomem *e_scratch_buffer_addr;
+	volatile void __iomem *e_scratch_buffer_size;
+	volatile void __iomem *e_tmv_buffer0;
+	volatile void __iomem *e_tmv_buffer1;
+	volatile void __iomem *e_ir_buffer_addr;/* v7 and v8 */
+	volatile void __iomem *e_source_first_plane_addr;
+	volatile void __iomem *e_source_second_plane_addr;
+	volatile void __iomem *e_source_third_plane_addr;/* v7 and v8 */
+	volatile void __iomem *e_source_first_plane_stride;/* v7 and v8 */
+	volatile void __iomem *e_source_second_plane_stride;/* v7 and v8 */
+	volatile void __iomem *e_source_third_plane_stride;/* v7 and v8 */
+	volatile void __iomem *e_stream_buffer_addr;
+	volatile void __iomem *e_stream_buffer_size;
+	volatile void __iomem *e_roi_buffer_addr;
+	volatile void __iomem *e_param_change;
+	volatile void __iomem *e_ir_size;
+	volatile void __iomem *e_gop_config;
+	volatile void __iomem *e_mslice_mode;
+	volatile void __iomem *e_mslice_size_mb;
+	volatile void __iomem *e_mslice_size_bits;
+	volatile void __iomem *e_frame_insertion;
+	volatile void __iomem *e_rc_frame_rate;
+	volatile void __iomem *e_rc_bit_rate;
+	volatile void __iomem *e_rc_roi_ctrl;
+	volatile void __iomem *e_picture_tag;
+	volatile void __iomem *e_bit_count_enable;
+	volatile void __iomem *e_max_bit_count;
+	volatile void __iomem *e_min_bit_count;
+	volatile void __iomem *e_metadata_buffer_addr;
+	volatile void __iomem *e_metadata_buffer_size;
+	volatile void __iomem *e_encoded_source_first_plane_addr;
+	volatile void __iomem *e_encoded_source_second_plane_addr;
+	volatile void __iomem *e_encoded_source_third_plane_addr;/* v7 and v8 */
+	volatile void __iomem *e_stream_size;
+	volatile void __iomem *e_slice_type;
+	volatile void __iomem *e_picture_count;
+	volatile void __iomem *e_ret_picture_tag;
+	volatile void __iomem *e_stream_buffer_write_pointer; /*  only v6 */
+	volatile void __iomem *e_recon_luma_dpb_addr;
+	volatile void __iomem *e_recon_chroma_dpb_addr;
+	volatile void __iomem *e_metadata_addr_enc_slice;
+	volatile void __iomem *e_metadata_size_enc_slice;
+	volatile void __iomem *e_mpeg4_options;
+	volatile void __iomem *e_mpeg4_hec_period;
+	volatile void __iomem *e_aspect_ratio;
+	volatile void __iomem *e_extended_sar;
+	volatile void __iomem *e_h264_options;
+	volatile void __iomem *e_h264_options_2;/* v7 and v8 */
+	volatile void __iomem *e_h264_lf_alpha_offset;
+	volatile void __iomem *e_h264_lf_beta_offset;
+	volatile void __iomem *e_h264_i_period;
+	volatile void __iomem *e_h264_fmo_slice_grp_map_type;
+	volatile void __iomem *e_h264_fmo_num_slice_grp_minus1;
+	volatile void __iomem *e_h264_fmo_slice_grp_change_dir;
+	volatile void __iomem *e_h264_fmo_slice_grp_change_rate_minus1;
+	volatile void __iomem *e_h264_fmo_run_length_minus1_0;
+	volatile void __iomem *e_h264_aso_slice_order_0;
+	volatile void __iomem *e_h264_chroma_qp_offset;
+	volatile void __iomem *e_h264_num_t_layer;
+	volatile void __iomem *e_h264_hierarchical_qp_layer0;
+	volatile void __iomem *e_h264_frame_packing_sei_info;
+	volatile void __iomem *e_h264_nal_control;/* v7 and v8 */
+	volatile void __iomem *e_mvc_frame_qp_view1;
+	volatile void __iomem *e_mvc_rc_bit_rate_view1;
+	volatile void __iomem *e_mvc_rc_qbound_view1;
+	volatile void __iomem *e_mvc_rc_mode_view1;
+	volatile void __iomem *e_mvc_inter_view_prediction_on;
+	volatile void __iomem *e_vp8_options;/* v7 and v8 */
+	volatile void __iomem *e_vp8_filter_options;/* v7 and v8 */
+	volatile void __iomem *e_vp8_golden_frame_option;/* v7 and v8 */
+	volatile void __iomem *e_vp8_num_t_layer;/* v7 and v8 */
+	volatile void __iomem *e_vp8_hierarchical_qp_layer0;/* v7 and v8 */
+	volatile void __iomem *e_vp8_hierarchical_qp_layer1;/* v7 and v8 */
+	volatile void __iomem *e_vp8_hierarchical_qp_layer2;/* v7 and v8 */
 };
 
 struct s5p_mfc_hw_ops {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index e9d1eaf72682..ed3d20f12184 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1880,7 +1880,7 @@ static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
 	s5p_mfc_clock_on();
-	writel(data, (void *)ofs);
+	writel(data, (volatile void __iomem *)ofs);
 	s5p_mfc_clock_off();
 }
 
@@ -1890,7 +1890,7 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = readl((void *)ofs);
+	ret = readl((volatile void __iomem *)ofs);
 	s5p_mfc_clock_off();
 
 	return ret;
-- 
1.9.3

