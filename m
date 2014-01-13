Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2961 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaAMKGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 05:06:01 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s0DA5w7g063309
	for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 11:06:00 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EBFED2A00A0
	for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:59:59 +0100 (CET)
Message-ID: <52D3B91F.4070404@xs4all.nl>
Date: Mon, 13 Jan 2014 10:59:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d20e4ed6d30c6ecee315eea0efb3449c3591d09e:                                                        
                                                                                                                                    
  [media] em28xx: use a better value for I2C timeouts (2014-01-10 06:10:07 -0200)                                                   
                                                                                                                                    
are available in the git repository at:                                                                                             
                                                                                                                                    
  git://linuxtv.org/hverkuil/media_tree.git for-v3.14c                                                                              
                                                                                                                                    
for you to fetch changes up to 190a7f631e1f972912d1777aadbaa6854be00085:                                                            

  vb2: Check if there are buffers before streamon (2014-01-10 16:09:53 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      go7007-loader: fix usb_dev leak

Hans Verkuil (1):
      Revert "[media] videobuf_vm_{open,close} race fixes"

Levente Kurusa (1):
      media: bt8xx: add missing put_device call

Ricardo Ribalda (1):
      vb2: Check if there are buffers before streamon

 drivers/media/pci/bt8xx/bttv-gpio.c           |  2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c | 12 +++++-------
 drivers/media/v4l2-core/videobuf-dma-sg.c     | 10 ++++------
 drivers/media/v4l2-core/videobuf-vmalloc.c    | 10 ++++------
 drivers/media/v4l2-core/videobuf2-core.c      |  5 +++++
 drivers/staging/media/go7007/go7007-loader.c  |  4 +++-
 6 files changed, 22 insertions(+), 21 deletions(-)
