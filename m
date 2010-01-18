Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32704.mail.mud.yahoo.com ([68.142.207.248]:43726 "HELO
	web32704.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751715Ab0ARHNP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 02:13:15 -0500
Message-ID: <879792.63542.qm@web32704.mail.mud.yahoo.com>
Date: Sun, 17 Jan 2010 23:13:14 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: [Patch 3/3] Kworld 315U
To: linux-media@vger.kernel.org
Cc: "Mauro Carvalho ChehabDevin Heitmueller <dheitmueller@kernellabs.com>"
	<mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch to bring device out of power saving mode.  
 
Signed-off-by: Franklin Meng<fmeng2002@yahoo.com>

diff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-core.c                   
--- a/linux/drivers/media/video/em28xx/em28xx-core.c    Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Sun Jan 17 22:54:21 2010 -0800
@@ -1132,6 +1132,7 @@                                                                 
  */                                                                                  
 void em28xx_wake_i2c(struct em28xx *dev)                                             
 {                                                                                    
+       v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);                   
        v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);                     
        v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,                     
                        INPUT(dev->ctl_input)->vmux, 0, 0);                           




      
