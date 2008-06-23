Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout1.informatik.tu-muenchen.de ([131.159.0.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <acher@in.tum.de>) id 1KAozJ-000746-4a
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 18:33:53 +0200
Date: Mon, 23 Jun 2008 18:35:30 +0200
From: Georg Acher <acher@in.tum.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080623163529.GI32218@localhost>
References: <DDA4E5EE-7DCC-4EA1-A5A8-622C1A61B945@admin.grnet.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DDA4E5EE-7DCC-4EA1-A5A8-622C1A61B945@admin.grnet.gr>
Subject: Re: [linux-dvb] Problem "watching" (not tuning to?) Astra
	HD	Promo/Anixe HD
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

> I have no problem tuning with
> http://dev.kewl.org/hauppauge/experimental/szap-meow.tgz 
>   to any DVB-S or DVB-S2 QPSK/8PSK transponder I have tried. However  
> there seems to be a problem with the reception of the Astra HD Promo  
> service at 11914500H on Astra1H. 

The demo loop is crap. It contains errors and PTS problems. Any HD receiver
displays this "demo" with judder and visible artifacts.

-- 
         Georg Acher, acher@in.tum.de
         http://www.lrr.in.tum.de/~acher
         "Oh no, not again !" The bowl of petunias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
