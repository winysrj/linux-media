Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpgw01.world4you.com ([80.243.163.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <treitmayr@devbase.at>) id 1LHHgV-0002ew-1R
	for linux-dvb@linuxtv.org; Mon, 29 Dec 2008 13:57:27 +0100
Received: from [85.127.250.87] (helo=[192.168.1.76])
	by smtpgw01.world4you.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67) (envelope-from <treitmayr@devbase.at>)
	id 1LHHft-0002P4-TX
	for linux-dvb@linuxtv.org; Mon, 29 Dec 2008 13:56:53 +0100
From: Thomas Reitmayr <treitmayr@devbase.at>
To: linux-dvb@linuxtv.org
Date: Mon, 29 Dec 2008 13:56:49 +0100
Message-Id: <1230555409.14295.11.camel@localhost>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] usb-urb.c: Fix initialization of URB list.
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

The following patch was sent to this list back in May 2008
(http://linuxtv.org/pipermail/linux-dvb/2008-May/025952.html) and had a
followup of myself in October 2008.
As the kernel oops with USB DVB receivers happens again and again I want
to propose to finally apply this patch to the v4l-dvb repository.
Thanks,
-Thomas

Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>

--- linux-old/drivers/media/dvb/dvb-usb/usb-urb.c	2008-12-29 13:50:33.000000000 +0100
+++ linux/drivers/media/dvb/dvb-usb/usb-urb.c	2008-12-29 13:52:19.000000000 +0100
@@ -160,7 +160,8 @@ static int usb_bulk_urb_init(struct usb_
 				stream->props.u.bulk.buffersize,
 				usb_urb_complete, stream);
 
-		stream->urb_list[i]->transfer_flags = 0;
+		stream->urb_list[i]->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		stream->urb_list[i]->transfer_dma = stream->dma_addr[i];
 		stream->urbs_initialized++;
 	}
 	return 0;





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
