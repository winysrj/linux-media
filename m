Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JjcaO-0002DM-Om
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 17:51:45 +0200
Message-ID: <47FCE5FB.9080003@iki.fi>
Date: Wed, 09 Apr 2008 18:51:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>	<47FA3A7A.3010002@iki.fi>
	<47FAFDDA.4050109@iki.fi>	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>	<47FC373F.5060006@iki.fi>
	<c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>
In-Reply-To: <c4e36d110804090130s5b66a357s3ec754a1d617b30@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Benoit Paquin <benoitpaquindk@gmail.com>
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

Zdenek Kabelac wrote:
> 2008/4/9, Antti Palosaari <crope@iki.fi>:
>> Zdenek Kabelac wrote:
>>
>>> As it looks like my AverTV Hybrid Volar HX is a little bit of no use

> Well it's AF9013 - but as could be seen in the source - the code looks like
> it should support both chips  AF9015 & AF9013 - do I had to set manually
> some bits somewhere ?

AF9013 is DVB-T demodulator and AF9015 is integrated USB-bridge + AF9013 
demodulator. Your device does not have AF9015 at all. DVB-T USB-device 
needs logically three "chips". USB-bridge, demodulator and tuner. As I 
can understand there is CY7C68013 USB-bridge, AF9013 demodulator and 
TDA18271 tuner. First you should try to find driver for demodulator. 
After thats is OK we can try to connect AF9013 demodulator to USB-bridge 
and TDA18271 tuner to AF9013 demodulator.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
