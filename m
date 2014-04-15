Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1506 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaDOMmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 08:42:53 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3FCgnsG033018
	for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 14:42:52 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 548B32A0410
	for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 14:42:47 +0200 (CEST)
Message-ID: <534D2947.8020506@xs4all.nl>
Date: Tue, 15 Apr 2014 14:42:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] davinci fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request was posted earlier, but it contained a patch of mine
that was wrong. Luckily it hasn't been merged yet, so this pull request
replaces the old one. It is identical, except for being rebased and without
my bad patch.

Regards,

	Hans

The following changes since commit 277a163c83d7ba93fba1e8980d29a9f8bfcfba6c:

  Merge tag 'v3.15-rc1' into patchwork (2014-04-14 12:00:36 -0300)

are available in the git repository at:

                                                                                                                                    
  git://linuxtv.org/hverkuil/media_tree.git for-v3.15g                                                                              
                                                                                                                                    
for you to fetch changes up to eb174ed13a578141c494eadf9250d7fef32ce401:                                                            
                                                                                                                                    
  media: davinci: vpfe: make sure all the buffers unmapped and released (2014-04-15 14:35:21 +0200)                                 
                                                                                                                                    
----------------------------------------------------------------                                                                    
Lad, Prabhakar (5):                                                                                                                 
      media: davinci: vpif_capture: fix releasing of active buffers                                                                 
      media: davinci: vpif_display: fix releasing of active buffers                                                                 
      media: davinci: vpbe_display: fix releasing of active buffers                                                                 
      staging: media: davinci: vpfe: make sure all the buffers are released                                                         
      media: davinci: vpfe: make sure all the buffers unmapped and released                                                         
                                                                                                                                    
 drivers/media/platform/davinci/vpbe_display.c   | 16 +++++++++++++++-                                                              
 drivers/media/platform/davinci/vpfe_capture.c   |  2 ++                                                                            
 drivers/media/platform/davinci/vpif_capture.c   | 34 +++++++++++++++++++++++-----------                                            
 drivers/media/platform/davinci/vpif_display.c   | 35 +++++++++++++++++++++++------------                                           
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 13 +++++++++++--                                                                 
 5 files changed, 74 insertions(+), 26 deletions(-)
