Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from u15184586.onlinehome-server.com ([82.165.244.70])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@metrofindings.com>) id 1KqSs4-00050r-8s
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 15:26:34 +0200
From: Mark Kimsal <mark@metrofindings.com>
To: linux-dvb@linuxtv.org
Date: Thu, 16 Oct 2008 09:25:51 -0400
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810160925.51556.mark@metrofindings.com>
Subject: [linux-dvb] [PATCH] Add syntek corp device to au0828
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

The woodbury is the first model I chose, and it seems to work.  I tried two 
others and they do not tune any channels, although the module au0828 does 
load.  Watching ATSC works fine, haven't tried NTSC or QAM.

diff -r 9273407ca6e1 linux/drivers/media/video/au0828/au0828-cards.c
--- a/linux/drivers/media/video/au0828/au0828-cards.c   Wed Oct 15 02:50:03 
2008 +0400
+++ b/linux/drivers/media/video/au0828/au0828-cards.c   Thu Oct 16 09:23:50 
2008 -0400
@@ -212,6 +212,8 @@ struct usb_device_id au0828_usb_id_table
                .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
        { USB_DEVICE(0x2040, 0x8200),
                .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
+       { USB_DEVICE(0x05e1, 0x0400),
+               .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
        { },
 };


-- 
Mark Kimsal
http://biz.metrofindings.com/
Fax: 866-375-1590

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
