Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KIiS6-0002LT-J5
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 13:12:17 +0200
Message-ID: <487C85ED.8060303@iki.fi>
Date: Tue, 15 Jul 2008 14:11:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Robert Goldner <robert@au-79.de>
References: <20080715064346.01ACC1BC39@agathe>
In-Reply-To: <20080715064346.01ACC1BC39@agathe>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unknown dvbt device 1ae7:0381 Xtensions 380U
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

Robert Goldner wrote:
> Hi,
> 
> has anyone ever tryed to get the Xtensions 380 working with linux?
> 
> url:
> 
> http://www.x-tensions.net/support.php?lang=de&view=solo&prod_num=XD-380
> But be carefull with the driver on this page. It differs a lot against the 
> driver included at the CD delivered with the stick.
> 
> I had a look into the windows driver (on the CD) and found nothing what
> could give an information which linux-driver is the right one (in my eyes). 
> If it is useful, I can put the windows driver to the www.
> 
> Is there any realistic hope, to get this device work with linux? I will
> test any patches and try any hints etc.

Looks like rebranded KWorld PlusTV 380U. Device is AF9015 chipset based. 
I can add support for this later today.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
