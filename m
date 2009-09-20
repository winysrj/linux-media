Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.188])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <SRS0=Dki3=FL=gmx.de=jens.nixdorf@srs.kundenserver.de>)
	id 1MpOZJ-0003OJ-7z
	for linux-dvb@linuxtv.org; Sun, 20 Sep 2009 17:43:17 +0200
Received: from miniserver.lan (localhost.localdomain [127.0.0.1])
	by miniserver.lan (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id
	n8KFgWcb015696
	for <linux-dvb@linuxtv.org>; Sun, 20 Sep 2009 17:42:33 +0200
Date: Sun, 20 Sep 2009 17:42:20 +0200
From: Jens Nixdorf <jens.nixdorf@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <200909201742.20628.jens.nixdorf@gmx.de>
In-Reply-To: <20090915064115.GA20603@seneca.muc.de>
References: <8CB2022318A0220-1E84-15EE@WEBMAIL-MZ13.sysops.aol.com>
References: <20090914101458.GA18504@seneca.muc.de>
References: <20090915064115.GA20603@seneca.muc.de>
MIME-Version: 1.0
Content-Disposition: inline
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

Am Dienstag, 15. September 2009 08:41:15 schrieb Harald Milz:
> 
> Today, after stopping VDR I get loads and loads of
> 
> Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22; AA 68  D0 03 00 ->
>  AA 68  D0 03 00. Sep 15 08:38:43 seneca kernel: dvb-usb: bulk message
>  failed: -22 (9/0) Sep 15 08:38:43 seneca kernel: pctv452e: I2C error -22;
>  AA 69  D0 02 00 -> AA 69  D0 02 00. Sep 15 08:38:43 seneca kernel:
>  dvb-usb: bulk message failed: -22 (9/-30719)
[...]
> 
> 
> The module cannot be unloaded:
> 
> dvb_usb_pctv452e       23052  18
> 

Same here within freevdr2.0d, an ubuntu 9.04-derivate. When this is happening, 
the system isnt usable anymore. No input is acknowledged from this point, not 
from keyboard, not over the net (ssh).

regards, Jens

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
