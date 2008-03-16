Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47DC7A51.7040103@iki.fi>
Date: Sun, 16 Mar 2008 03:39:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi>	<47DAC4BE.5090805@iki.fi>	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>	<47DBDB9F.5060107@iki.fi>	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>	<47DC64F4.9070403@iki.fi>
	<47DC6E0A.9000904@linuxtv.org>
	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>
In-Reply-To: <abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
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

Jarryd Beck wrote:
> You won't believe this, but it worked. I think every time I tried both
> patches together I left .no_reconnect in. I tried it again with both
> patches applied, no other modifications, and it worked.
> 
> Thanks for all your help,
> Jarryd.

Great. I will finalize support for this tuner and add it to tree.

It will take some time because I will need to test whether or not there 
is maximum byte count in af9015 i2c-hardware. If yes, there is two 
solutions 1) print error to log that too long i2c-transfer => tuner 
driver needs changed. 2) Split i2c-transfer in the driver. Is there any 
other driver that splits i2c-messages?

Can you make some test to find solution where no_reconnect is not used, 
means same as no_reconnect=0 ? There is #if 0 / #if 1 definitions in 
download firmware. Also sleep in same place can be changed.

This (reconnection after fw download) is really problem. Any ideas to 
resolving it is highly welcome.

regards
Antti Palosaari
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
