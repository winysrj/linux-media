Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from colin.muc.de ([193.149.48.1] helo=mail.muc.de ident=qmailr)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hm@seneca.muc.de>) id 1MnS2J-0005QM-Nd
	for linux-dvb@linuxtv.org; Tue, 15 Sep 2009 09:01:12 +0200
Date: Tue, 15 Sep 2009 08:41:15 +0200
From: Harald Milz <hm@seneca.muc.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090915064115.GA20603@seneca.muc.de>
References: <8CB2022318A0220-1E84-15EE@WEBMAIL-MZ13.sysops.aol.com>
	<20090914101458.GA18504@seneca.muc.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090914101458.GA18504@seneca.muc.de>
Subject: Re: [linux-dvb] Need help with TT S2-3650 w/ s2-liplianin
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

On Mon, Sep 14, 2009 at 12:14:58PM +0200, Harald Milz wrote:
> Sep 14 11:52:03 seneca kernel: pctv452e_power_ctrl: 0
> Sep 14 11:52:21 seneca kernel: usbcore: deregistering interface driver pctv452e
> Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (5/0)
> Sep 14 11:52:21 seneca kernel: pctv452e: CI error -22; AA 1F 46 -> AA 1F 46.
> Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (5/-30719)
> Sep 14 11:52:21 seneca kernel: pctv452e: CI error -22; AA 20 46 -> AA 20 46.
> Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (11/-30719)
> Sep 14 11:52:21 seneca kernel: pctv452e: I2C error -22; AA 21  10 04 00 -> AA 21  10 04 00.
> Sep 14 11:52:21 seneca kernel: dvb-usb: bulk message failed: -22 (10/-30719)
> Sep 14 11:52:21 seneca kernel: pctv452e: I2C error -22; AA 22  D0 03 00 -> AA 22  D0 03 00.

Today, after stopping VDR I get loads and loads of

Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 68  D0 03 00 -> AA 68  D0 03 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/0)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 69  D0 02 00 -> AA 69  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6A  D0 02 00 -> AA 6A  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (10/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6B  D0 03 00 -> AA 6B  D0 03 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6C  D0 02 00 -> AA 6C  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (10/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6D  D0 03 00 -> AA 6D  D0 03 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (10/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6E  D0 03 00 -> AA 6E  D0 03 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 6F  D0 02 00 -> AA 6F  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 70  D0 02 00 -> AA 70  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 71  D0 02 00 -> AA 71  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 72  D0 02 00 -> AA 72  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 73  D0 02 00 -> AA 73  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 74  D0 02 00 -> AA 74  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 75  D0 02 00 -> AA 75  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 76  D0 02 00 -> AA 76  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 77  D0 02 00 -> AA 77  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)
Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 78  D0 02 00 -> AA 78  D0 02 00.
Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30719)


The module cannot be unloaded: 

dvb_usb_pctv452e       23052  18

hg clone of Sep 13, 2009. 

What can be done here?


-- 
Linus:	I guess it's wrong always to be worrying about tomorrow.  Maybe
	we should think only about today.
Charlie Brown:
	No, that's giving up.  I'm still hoping that yesterday will get
	better.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
