Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:40645 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1H0KgM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 06:36:12 -0400
Date: Sat, 27 Aug 2011 12:35:45 +0200
From: Florian Mickler <florian@mickler.org>
To: Markus Stephan <Markus_Stephan@freenet.de>
Cc: Jiri Slaby <jslaby@novell.com>, pboettcher@kernellabs.com,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: vp702x_fe_set_frontend+0x156/0x1a0 [dvb_usb_vp702x]
Message-ID: <20110827123545.4bcf0943@schatten.dmk.lab>
In-Reply-To: <4E580D7F.6070805@freenet.de>
References: <4E580D7F.6070805@freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Aug 2011 23:17:51 +0200
Markus Stephan <Markus_Stephan@freenet.de> wrote:

> Hi Florian,
> 
> Jiri made an other test kernel for me with your final + debug patch applied.
> 
> The box works fine and the message:
> vp702x: usb in operation failed. (-110)
> 
> seams to be triggered by:
> vp702x_fe_set_frontend+0x156/0x1a0 [dvb_usb_vp702x]
> 
> Full dmesg is attached.
> 
> Thank you,
> Markus Stephan

Hi!
Here is a patch to check if that failing op is even necessary. 

But even if it works I don't feel comfortable of suggesting this to be
applied, since I don't have any overview about the hardware supported by this
driver.
Maybe Patrick has any opinion on this, he wrote this driver after all :)

Regards,
Flo

>8------->8---------------->8--------->8---------------->8-----------
commit fdcb46dd3627683fc82d14488af10d3072e923f5
Author: Florian Mickler <florian@mickler.org>
Date:   Sat Aug 27 12:01:34 2011 +0200

    Let's check if that failing in-op is even necessary.
    
    Even if this turns out to be unnecessary, the right course of action is probably
    to still leave it there and demote the error message to debug information.

diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index ad16455..cb6c230 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -198,7 +198,7 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	st->status_check_interval = 250;
 	st->next_status_check = jiffies;
 
-	vp702x_usb_inout_op(st->d, cmd, 8, cmd, 10, 100);
+	vp702x_usb_out_op(st->d, REQUEST_OUT, 0, 0, cmd, 10);
 
 	if (cmd[2] == 0 && cmd[3] == 0)
 		deb_fe("tuning failed.\n");

