Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LCn89-00026g-0Y
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 04:31:27 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1556174fga.25
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 19:31:21 -0800 (PST)
Message-ID: <412bdbff0812161931r17fc2371mfcb28306a3acc610@mail.gmail.com>
Date: Tue, 16 Dec 2008 22:31:21 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] RFC - xc5000 init_fw option is broken for HVR-950q
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

Hello,

It looks like because the reset callback is set *after* the
dvb_attach(xc5000...), the if the init_fw option is set the firmware
load will fail (saying "xc5000: no tuner reset callback function,
fatal")

We need to be setting the callback *before* the dvb_attach() to handle
this case.

Let me know if anybody sees anything wrong with this proposed patch,
otherwise I will submit a pull request.

Thanks,

Devin

diff -r 95d2c94ec371 linux/drivers/media/video/au0828/au0828-dvb.c
--- a/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
21:35:23 2008 -0500
+++ b/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
22:27:57 2008 -0500
@@ -382,6 +382,9 @@

        dprintk(1, "%s()\n", __func__);

+       /* define general-purpose callback pointer */
+       dvb->frontend->callback = au0828_tuner_callback;
+
        /* init frontend */
        switch (dev->board) {
        case AU0828_BOARD_HAUPPAUGE_HVR850:
@@ -431,8 +434,6 @@
                       __func__);
                return -1;
        }
-       /* define general-purpose callback pointer */
-       dvb->frontend->callback = au0828_tuner_callback;

        /* register everything */

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
