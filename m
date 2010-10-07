Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0JGMqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 08:46:07 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o97Ck7Gb014081
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:46:07 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o97Ck4sg028624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:46:06 -0400
Date: Thu, 7 Oct 2010 09:45:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] V4L/DVB: lirc_igorplugusb: Fix a compilation waring
Message-ID: <20101007094541.567882bc@pedra>
In-Reply-To: <f3a134520bf3f816b8f7192426af875603a1434e.1286455481.git.mchehab@redhat.com>
References: <f3a134520bf3f816b8f7192426af875603a1434e.1286455481.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/staging/lirc/lirc_igorplugusb.c: In function ‘usb_remote_probe’:
drivers/staging/lirc/lirc_igorplugusb.c:393: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘unsigned int’

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/lirc/lirc_igorplugusb.c b/drivers/staging/lirc/lirc_igorplugusb.c
index bce600e..e680d88 100644
--- a/drivers/staging/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/lirc/lirc_igorplugusb.c
@@ -390,7 +390,7 @@ static int usb_remote_probe(struct usb_interface *intf,
 	devnum = dev->devnum;
 	maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
 
-	dprintk(DRIVER_NAME "[%d]: bytes_in_key=%lu maxp=%d\n",
+	dprintk(DRIVER_NAME "[%d]: bytes_in_key=%zu maxp=%d\n",
 		devnum, CODE_LENGTH, maxp);
 
 
-- 
1.7.1


