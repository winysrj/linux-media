Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbcAVTRY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 14:17:24 -0500
Date: Sat, 23 Jan 2016 03:15:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: drivers/media/v4l2-core/videobuf2-core.c:2784:33-34: Unneeded
 semicolon
Message-ID: <201601230336.WZKkXVfa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3e1e21c7bfcfa9bf06c07f48a13faca2f62b3339
commit: af3bac1a7c8a21ff4f4edede397cba8e3f8ee503 [media] media: videobuf2: Move vb2_fileio_data and vb2_thread to core part
date:   5 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/v4l2-core/videobuf2-core.c:2784:33-34: Unneeded semicolon

vim +2784 drivers/media/v4l2-core/videobuf2-core.c

  2768				call_void_qop(q, wait_finish, q);
  2769				if (!threadio->stop)
  2770					ret = vb2_core_dqbuf(q, b, 0);
  2771				call_void_qop(q, wait_prepare, q);
  2772				dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
  2773			}
  2774			if (ret || threadio->stop)
  2775				break;
  2776			try_to_freeze();
  2777	
  2778			vb = q->bufs[b->index];
  2779			if (b->state == VB2_BUF_STATE_DONE)
  2780				if (threadio->fnc(vb, threadio->priv))
  2781					break;
  2782			call_void_qop(q, wait_finish, q);
  2783			if (copy_timestamp)
> 2784				b->timestamp = ktime_get_ns();;
  2785			if (!threadio->stop)
  2786				ret = vb2_core_qbuf(q, b->index, b);
  2787			call_void_qop(q, wait_prepare, q);
  2788			if (ret || threadio->stop)
  2789				break;
  2790		}
  2791	
  2792		/* Hmm, linux becomes *very* unhappy without this ... */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
