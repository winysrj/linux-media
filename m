Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Khox5-0006I8-QE
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 19:12:01 +0200
Message-ID: <48D7D1D8.4090305@iki.fi>
Date: Mon, 22 Sep 2008 20:11:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Williams <andrew.williams@joratech.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>
References: <E57779B45D7559418D2EA8B6EC615674047F0A11@EXCHANGE.joratech.com>
	<546B4176F0487A4CBA62FC16EFC1D9D603D4B9@EXCHANGE.joratech.com>
In-Reply-To: <546B4176F0487A4CBA62FC16EFC1D9D603D4B9@EXCHANGE.joratech.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) /
 Afatech af9015 missing adapter1
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

Andrew Williams wrote:
> Good day everybody,
> Apologies if this is in HTML, sending from Outlook Web Access at the moment.
> 
> I am having a problem with the KWorld PlusTV Dual DVB-T Stick (DVB-T 
> 399U) / Afatech af9015 USB stick.
> 
> Firstly, thank you very much for the effort that everybody is putting 
> into this. Much appreciated.
> 
> Back to my problem:
> 
> The above tuner only registers one adapter in /dev/dvb with the latest
> build from http://linuxtv.org/hg/~anttip/af9015/
> 
> It does that under warmboot (firmware loaded) and coldboot conditions.
> 
> I have an older driver from http://linuxtv.org/hg/~anttip/af9015/ dated 
> the 13/09/2008
> which works perfectly under coldboot conditions in that it registers 
> adapter0 and adapter1 with frontend0 under each adapter.
> Unfortunately it does not work that well under warmboot conditions as it
> registers adapter0 and adapter1 but only registers a frontend0 under 
> adapter0.
> It fails to registers frontend0 under adapter1.
> 
> Thus the reason for me to try and upgrade to a later/more current driver.
> 
> I am trying to provide as much info as possible, so my apologies if 
> there is too much text attached.
> 
> Greatly appreciate if anybody could help me with regards to this.
> 
> Again, thanks for all the good work.

I have disabled 2nd adapter by default recently due to problems. 
Enabling 2nd FE causes driver sensitivity problems seen as mosaic pixels 
in picture. I don't know if this problem exists all devices... 2nd 
adapter can be enabled with module param, modprobe dvb-usb-af9015 
dual_mode=1 enables it. I will of course enable it by default when 
problem is found.

I did small change for GPIO setting to avoid warmboot/coldboot problem 
you have seen. Please test.
http://linuxtv.org/hg/~anttip/af9015_test

I also changed mxl5005s tuner RSSI enabled - Jose Alberto has found that 
old mxl5005 driver was using it always enabled and therefore better 
performance for his hardware.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
