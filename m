Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4876 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3ANKu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 05:50:26 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id r0EAoLff071511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 11:50:24 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id E5A2B3A0011D
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 11:50:19 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.9] DocBook fixes/improvements
Date: Mon, 14 Jan 2013 11:50:21 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141150.21077.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of validation fixes and control documentation improvements.

Patchwork commands:

pwclient -u 'accepted' 16216
pwclient -u 'accepted' 16217
pwclient -u 'accepted' 16218

Regards,

	Hans

The following changes since commit 73ec66c000e9816806c7380ca3420f4e0638c40e:                                                                             
                                                                                                                                                         
  [media] stv0900: Multistream support (2013-01-06 11:08:44 -0200)                                                                                       
                                                                                                                                                         
are available in the git repository at:                                                                                                                  
                                                                                                                                                         
  git://linuxtv.org/hverkuil/media_tree.git docs                                                                                                         
                                                                                                                                                         
for you to fetch changes up to 30dc44447961be7e7d2a24ef152bfdeae48c8b8a:                                                                                 
                                                                                                                                                         
  DocBook: mention that EINVAL can be returned for invalid menu indices. (2013-01-11 14:51:13 +0100)                                                     
                                                                                                                                                         
----------------------------------------------------------------                                                                                         
Hans Verkuil (3):                                                                                                                                        
      DocBook: fix various validation errors                                                                                                             
      DocBook: improve the error_idx field documentation.                                                                                                
      DocBook: mention that EINVAL can be returned for invalid menu indices.                                                                             
                                                                                                                                                         
 Documentation/DocBook/media/v4l/common.xml              |    2 +-                                                                                       
 Documentation/DocBook/media/v4l/io.xml                  |    4 ++--                                                                                     
 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml |    2 +-                                                                                       
 Documentation/DocBook/media/v4l/v4l2.xml                |    5 +----                                                                                    
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml       |   28 ++++++++++++----------------                                                             
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml       |    8 ++++++--                                                                                 
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml  |   57 +++++++++++++++++++++++++++++++++++++++++++++++----------                                
 7 files changed, 70 insertions(+), 36 deletions(-)
