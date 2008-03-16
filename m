Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JaiCJ-0007Af-7l
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 03:02:06 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1667462tia.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 19:01:58 -0700 (PDT)
Message-ID: <abf3e5070803151901o793c92b5u93dd61d3ff6c8db1@mail.gmail.com>
Date: Sun, 16 Mar 2008 13:01:57 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47DC7A51.7040103@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47DAC4BE.5090805@iki.fi>
	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>
	<47DBDB9F.5060107@iki.fi>
	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>
	<47DC64F4.9070403@iki.fi> <47DC6E0A.9000904@linuxtv.org>
	<abf3e5070803151827s1f77d519o728f160126b28ac5@mail.gmail.com>
	<47DC7A51.7040103@iki.fi>
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

On Sun, Mar 16, 2008 at 12:39 PM, Antti Palosaari <crope@iki.fi> wrote:
> Jarryd Beck wrote:
>  > You won't believe this, but it worked. I think every time I tried both
>  > patches together I left .no_reconnect in. I tried it again with both
>  > patches applied, no other modifications, and it worked.
>  >
>  > Thanks for all your help,
>  > Jarryd.
>
>  Great. I will finalize support for this tuner and add it to tree.
>
>  It will take some time because I will need to test whether or not there
>  is maximum byte count in af9015 i2c-hardware. If yes, there is two
>  solutions 1) print error to log that too long i2c-transfer => tuner
>  driver needs changed. 2) Split i2c-transfer in the driver. Is there any
>  other driver that splits i2c-messages?
>
>  Can you make some test to find solution where no_reconnect is not used,
>  means same as no_reconnect=0 ? There is #if 0 / #if 1 definitions in
>  download firmware. Also sleep in same place can be changed.
>
>  This (reconnection after fw download) is really problem. Any ideas to
>  resolving it is highly welcome.
>
>  regards
>  Antti Palosaari
>  --
>  http://palosaari.fi/
>

I'll have a fiddle with no_reconnect and the firmware download and see what
happens.
Also there's a blue light that comes on in windows when I tune, but it didn't
come on in linux when tuned. Would it be possible to work
out how to make that light come on when it has successfully tuned?

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
