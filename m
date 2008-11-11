Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kzu8E-0006fq-GI
	for linux-dvb@linuxtv.org; Tue, 11 Nov 2008 15:22:17 +0100
Message-ID: <49199510.6040809@iki.fi>
Date: Tue, 11 Nov 2008 16:22:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rasjid Wilcox <rasjidw@gmail.com>
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>
	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>
In-Reply-To: <bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

Rasjid Wilcox wrote:
> Hello,
> 
> I have a DigitalNow TinyTwin, which I have got working with the
> drivers from http://linuxtv.org/hg/~anttip/af9015/summary
> 
> However, I seem to only be able to use one of the two tuners on the
> card.  I'm not sure if this is a limitation of the driver, of mythtv,
> or of my knowledge.  Any suggestions on how to get both tuners on the
> card working with Myth would be greatly appreciated.

I disabled 2nd tuner by default due to bad performance I faced up with 
my hardware. Anyhow, you can enable it by module param, use modprobe 
dvb-usb-af9015 dual_mode=1 . Test it and please report.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
