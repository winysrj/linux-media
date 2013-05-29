Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42359 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966228Ab3E2ONx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:13:53 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK00JLOCLHYD30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 15:13:51 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MNK00FNJCUWFCA0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 15:13:51 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] Next features in mem2mem drivers
Date: Wed, 29 May 2013 16:13:43 +0200
Message-id: <022301ce5c76$ba966d80$2fc34880$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56
-0300)

are available in the git repository at:

  git://git.linuxtv.org/kdebski/media.git master

for you to fetch changes up to 413833e6da43c96272b7b98ccc8e90ff0a925e41:

  coda: do not call v4l2_m2m_job_finish from .job_abort (2013-05-29 15:10:39
+0200)

----------------------------------------------------------------
Philipp Zabel (9):
      coda: fix ENC_SEQ_OPTION for CODA7
      coda: frame stride must be a multiple of 8
      coda: stop setting bytesused in buf_prepare
      coda: clear registers in coda_hw_init
      coda: simplify parameter buffer setup code
      coda: per-product list of codecs instead of list of formats
      coda: add coda_encode_header helper function
      coda: replace completion with mutex
      coda: do not call v4l2_m2m_job_finish from .job_abort

 drivers/media/platform/coda.c |  600
++++++++++++++++++++++-------------------
 drivers/media/platform/coda.h |   11 +-
 2 files changed, 326 insertions(+), 285 deletions(-)




