Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JcnAl-0000fS-95
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 20:45:06 +0100
Message-ID: <47E41020.5040303@iki.fi>
Date: Fri, 21 Mar 2008 21:44:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <47E3CB84.3060208@iki.fi>
	<ea4209750803211111m2b1bd83dyc4ce3b38b7b3ee66@mail.gmail.com>
In-Reply-To: <ea4209750803211111m2b1bd83dyc4ce3b38b7b3ee66@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to disable RC-polling from driver
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

Albert Comerma wrote:
> Moi,
> I found this that perhaps is useful for you;
> to disable rc_polling on /etc/modprobe.d/options add;
> 
> options dvb_usb disable_rc_polling=1

yes I found this. But how I do that after reading eeprom in dvb-udb-module=

Antti
> 
> Albert
> 
> 2008/3/21, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>>:
> 
>     moi
>     Is there any designed way (for example callback) to disable RC-polling
>     (disable_rc_polling) from dvb-usb-driver module in runtime? There is
>     information regarding remote controller usage stored in eeprom and
>     therefore it is not possible use dvb_usb_device_properties structure
>     (structure is populated earlier).
> 
>     regards
>     Antti
> 
>     --
>     http://palosaari.fi/
> 
>     _______________________________________________
>     linux-dvb mailing list
>     linux-dvb@linuxtv.org <mailto:linux-dvb@linuxtv.org>
>     http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
