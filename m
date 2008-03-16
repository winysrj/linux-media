Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JakV0-0004Rb-5s
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 05:29:31 +0100
Message-ID: <47DCA21A.5030801@linuxtv.org>
Date: Sun, 16 Mar 2008 00:29:14 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DAC4BE.5090805@iki.fi>	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>	<47DBDB9F.5060107@iki.fi>	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>	<47DC64F4.9070403@iki.fi>
	<47DC6E0A.9000904@linuxtv.org>	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>	<47DC7A51.7040103@iki.fi>
	<abf3e5070803151901o793c92b5u93dd61d3ff6c8db1@mail.gmail.com>
	<47DC8045.4070204@iki.fi>
In-Reply-To: <47DC8045.4070204@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Antti Palosaari wrote:
> Jarryd Beck wrote:
>> Also there's a blue light that comes on in windows when I tune, but
>> it didn't
>> come on in linux when tuned. Would it be possible to work
>> out how to make that light come on when it has successfully tuned?
>
> Should be peace of cake to fix. I will check it later...
>
> Antti
Antti,

I created an attach-time parameter to limit the i2c transfer size during
tda18271 initialization.  Please take a look:

http://linuxtv.org/hg/~mkrufky/tda18271/rev/8ab90c649c7b

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
