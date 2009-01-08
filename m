Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1LKuOb-0005G4-Ac
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 13:53:58 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id F278A33A94B
	for <linux-dvb@linuxtv.org>; Thu,  8 Jan 2009 13:53:15 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZnNa5Cf9a-sG for <linux-dvb@linuxtv.org>;
	Thu,  8 Jan 2009 13:53:08 +0100 (CET)
Received: from halim.local (p54AE4B2E.dip.t-dialin.net [84.174.75.46])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 6C5DA33A94C
	for <linux-dvb@linuxtv.org>; Thu,  8 Jan 2009 13:52:49 +0100 (CET)
Date: Thu, 8 Jan 2009 13:52:56 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090108125256.GA11168@halim.local>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] cannot unload dvb-usb-vp7045 with latest v4l-dvb branch
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

hello,
Yesterday I have updated my dvb driver from v4l-dvb.
After stopping vdr and all dvb apps I can't unload the driver
lsmod |grep vp7045 shows:

dvb_usb_vp7045          8036  4294967293
dvb_usb                17164  1 dvb_usb_vp7045
usbcore               118160  9 dvb_usb_vp7045,dvb_usb,usbhid,snd_usb_audio,snd_
usb_lib,hci_usb,ehci_hcd,uhci_hcd
Regards
halim


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
