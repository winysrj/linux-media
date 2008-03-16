Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JaiEK-0007sY-TQ
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 03:04:09 +0100
Message-ID: <47DC8012.3050809@linuxtv.org>
Date: Sat, 15 Mar 2008 22:04:02 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi>	<47DAC4BE.5090805@iki.fi>	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>	<47DBDB9F.5060107@iki.fi>	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>	<47DC64F4.9070403@iki.fi>
	<47DC6E0A.9000904@linuxtv.org>
	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>
In-Reply-To: <abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
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
> On Sun, Mar 16, 2008 at 11:47 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Antti Palosaari wrote:
>>  > I have no idea how to debug more. Without device it is rather hard to
>>  > test many things. It will help a little if we know is tuner locked.
>>  > Mike, is it easy to add debug writing for tuner to indicate if tuner
>>  > is locked or not locked? I have used that method earlier with mt2060
>>  > tuner...
>>
>>  There is a lock bit in register 0x01[6]  but I have not found it to be
>>  reliable, especially not on the c1 part.
>>
>>  -Mike
>>
>>
>>
> 
> You won't believe this, but it worked. I think every time I tried both
> patches together I left .no_reconnect in. I tried it again with both
> patches applied, no other modifications, and it worked.
> 
> Thanks for all your help,
> Jarryd.

This is great news!  For an experiment, can you try once more without my patch applied?

This will just confirm whether or not we can write all 39 registers at once.

If the patch that I gave you is truly needed, then I will integrate it into the official driver.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
