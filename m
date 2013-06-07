Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3855 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGKb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:31:26 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r57AVEkE002060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 7 Jun 2013 12:31:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 97CA435C0003
	for <linux-media@vger.kernel.org>; Fri,  7 Jun 2013 12:31:13 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11
Date: Fri, 7 Jun 2013 12:31:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071231.14136.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 -0300)

are available in the git repository at:                                                                                                              
                                                                                                                                                     
  git://linuxtv.org/hverkuil/media_tree.git for-v3.11                                                                                                
                                                                                                                                                     
for you to fetch changes up to 219cb7fa5f127e423ef178a17bfe409b5b522d91:                                                                             
                                                                                                                                                     
  media: i2c: ths7303: make the pdata as a constant pointer (2013-06-07 10:34:59 +0200)                                                              
                                                                                                                                                     
----------------------------------------------------------------                                                                                     
Antti Palosaari (1):                                                                                                                                 
      radio-keene: add delay in order to settle hardware                                                                                             
                                                                                                                                                     
Hans Verkuil (6):                                                                                                                                    
      mxl111sf: don't redefine pr_err/info/debug                                                                                                     
      hdpvr: fix querystd 'unknown format' return.                                                                                                   
      hdpvr: code cleanup                                                                                                                            
      hdpvr: improve error handling                                                                                                                  
      ml86v7667: fix the querystd implementation                                                                                                     
      radio-keene: set initial frequency.                                                                                                            
                                                                                                                                                     
Lad, Prabhakar (4):                                                                                                                                  
      ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata                                                                                 
      media: i2c: ths7303: remove init_enable option from pdata                                                                                      
      media: i2c: ths7303: remove unnecessary function ths7303_setup()                                                                               
      media: i2c: ths7303: make the pdata as a constant pointer                                                                                      
                                                                                                                                                     
Vladimir Barinov (2):                                                                                                                                
      adv7180: add more subdev video ops                                                                                                             
      ML86V7667: new video decoder driver                                                                                                            
                                                                                                                                                     
 arch/arm/mach-davinci/board-dm365-evm.c       |    1 -                                                                                              
 drivers/media/i2c/Kconfig                     |    9 ++                                                                                             
 drivers/media/i2c/Makefile                    |    1 +                                                                                              
 drivers/media/i2c/adv7180.c                   |   46 ++++++++++                                                                                     
 drivers/media/i2c/ml86v7667.c                 |  431 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
 drivers/media/i2c/ths7303.c                   |   48 +++--------                                                                                    
 drivers/media/radio/radio-keene.c             |    7 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   90 ++++++++++----------
 drivers/media/usb/hdpvr/hdpvr-control.c       |   21 ++---
 drivers/media/usb/hdpvr/hdpvr-video.c         |   72 ++++++++--------
 drivers/media/usb/hdpvr/hdpvr.h               |    1 +
 include/media/ths7303.h                       |    2 -
 13 files changed, 597 insertions(+), 140 deletions(-)
 create mode 100644 drivers/media/i2c/ml86v7667.c
