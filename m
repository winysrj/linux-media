Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jh44l-0005nQ-AE
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 16:36:32 +0200
Message-ID: <47F399AA.2080802@iki.fi>
Date: Wed, 02 Apr 2008 17:35:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Nick Andrew <nick-linuxtv@nick-andrew.net>
References: <20080329024154.GA23883@localhost>	<47EDCE27.4050101@optusnet.com.au>
	<47EE1056.9050804@iki.fi>	<47EE3C5E.8080001@optusnet.com.au>
	<20080402023911.GA27360@tull.net>
In-Reply-To: <20080402023911.GA27360@tull.net>
Cc: dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Afatech 9015
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

moro,
I can answer those questions

Nick Andrew wrote:
> G'day ausgnome,
> 
> On Sat, Mar 29, 2008 at 11:55:58PM +1100, ausgnome wrote:
>> I used this tree
>> http://linuxtv.org/hg/~anttip/af9015/
> 
> Did you need to modify the code at all?

No. Driver supports also this TDA18211HDC1 tuner and used USB-IDs are 
Afatech default ones.
Other supported tuners are MT2060 (MT2061), QT1010 and TDA182xx -series. 
Tuners used with AF9015 but not supported are Maxlinear MXL5003 and 
Freescale mc44s803. Anyhow, adding support for new tuners is easy if 
there is driver for tuner.
I can try to add MXL5003 support if there is someone who can take some 
usb-sniffs and test changes.

> And what's your "lsusb" output?

It is most likely ~same as all AF9015 devices.

> 
> Nick.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
