Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from colin.muc.de ([193.149.48.1] helo=mail.muc.de ident=qmailr)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hm@seneca.muc.de>) id 1Mn8pz-0000W0-3b
	for linux-dvb@linuxtv.org; Mon, 14 Sep 2009 12:31:11 +0200
Date: Mon, 14 Sep 2009 12:14:58 +0200
From: Harald Milz <hm@seneca.muc.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090914101458.GA18504@seneca.muc.de>
References: <8CB2022318A0220-1E84-15EE@WEBMAIL-MZ13.sysops.aol.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8CB2022318A0220-1E84-15EE@WEBMAIL-MZ13.sysops.aol.com>
Subject: [linux-dvb] Need help with TT S2-3650 w/ s2-liaplianin
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi,

I'm using 2 TT S2-3650 with s2-liaplianin (HG clone from Sep 13, 2009, and an
older release from June, dunno which one). OS is openSUSE 11.1 with the latest
official update kernel 2.6.27.29-0.1-default, vdr is -1.7.0 with Ext Patch 72.
When starting up, everything seems to run fine but after a while pctv452e
spits out lots of messages like 

Sep 14 11:52:03 seneca kernel: pctv452e_power_ctrl: 0
Sep 14 11:52:21 seneca kernel: usbcore: deregistering interface driver pctv452e
Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (5/0)
Sep 14 11:52:21 seneca kernel: pctv452e: CI error -22; AA 1F 46 -> AA 1F 46.
Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (5/-30719)
Sep 14 11:52:21 seneca kernel: pctv452e: CI error -22; AA 20 46 -> AA 20 46.
Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (11/-30719)
Sep 14 11:52:21 seneca kernel: pctv452e: I2C error -22; AA 21  10 04 00 -> AA 21  10 04 00.
Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (10/-30719)
Sep 14 11:52:21 seneca kernel: pctv452e: I2C error -22; AA 22  D0 03 00 -> AA 22  D0 03 00.
 
in this case after shutting down VDR and unloading the modules. 

I'm not using a CAM so far so is this a problem I should be worried about? 

Another issue I'm worried about is that sometimes I cannot unload the module
because the usage count is at 17 or 18, forcing me to reboot the machine which
reduces the WAF greatly :-/ 

Anything I can do to help debug these problems? Basically, SD and HD reception
work fine. It's just that the stability of the pctv452e driver appears to be
not that great yet. 

BTW one of the S2-3650 boxes is actually a Satelco Easywatch HDTV USB CI. I'll
add the similarity to the wiki some time. 

While we're at it - is there any plan to merge the S2-3650 drivers into the
official V4L tree? 

-- 
One man's theology is another man's belly laugh.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
