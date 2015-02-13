Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56741 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068AbbBMKQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 05:16:16 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5BAE360093
	for <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 12:16:12 +0200 (EET)
Date: Fri, 13 Feb 2015 12:16:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v3.20] Fix USERPTR buffers for vb2 dma-contig mem type
Message-ID: <20150213101611.GJ32575@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This single patch fixes setting the write parameter to 1 for
get_user_pages() on writable buffers. Without this using USERPTR buffers
with the dma-contig mem type will corrupt system memory.

This is directly applicable to fixes and master branches and should be
pulled into both.

The following changes since commit 4bad5d2d25099a42e146d7b18d2b98950ed287f5:

  [media] dvb_net: Convert local hex dump to print_hex_dump_debug (2015-02-03 18:24:44 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git vb2-fix

for you to fetch changes up to 5a433fbc3ead7d65143bf039eb77512d0558e2e7:

  vb2: Fix dma_dir setting for dma-contig mem type (2015-02-13 12:14:31 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      vb2: Fix dma_dir setting for dma-contig mem type

 drivers/media/v4l2-core/videobuf2-dma-contig.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
