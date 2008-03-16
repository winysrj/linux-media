Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Jagxw-0006yH-PR
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 01:43:10 +0100
Message-ID: <47DC6D11.6010004@linuxtv.org>
Date: Sat, 15 Mar 2008 20:42:57 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	
	<47DAC42D.7010306@iki.fi> <47DAC4BE.5090805@iki.fi>	
	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>	
	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>	
	<47DBDB9F.5060107@iki.fi>	
	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>	
	<47DC64F4.9070403@iki.fi>	
	<abf3e5070803151727o55dcc0d1q82bac14352330fd7@mail.gmail.com>	
	<47DC6BC6.4080307@iki.fi>
	<abf3e5070803151740o27c1cb0axd6f1eb2d1ad76721@mail.gmail.com>
In-Reply-To: <abf3e5070803151740o27c1cb0axd6f1eb2d1ad76721@mail.gmail.com>
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
> On Sun, Mar 16, 2008 at 11:37 AM, Antti Palosaari <crope@iki.fi> wrote:
>   
>> Jarryd Beck wrote:
>>  > Here's the first frequency it tuned to, as you can see the
>>  > one you set auto on is still auto, it didn't seem to autodetect
>>  > anything. It was the same for all the other frequencies as well.
>>  >
>>  >>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>  > WARNING: >>> tuning failed!!!
>>  >>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>  > (tuning failed)
>>  > WARNING: >>> tuning failed!!!
>>
>>  It does not matter what scan outputs as tuning parameters because it
>>  just shows same parameter that are set by used tuning file (at least
>>  when tuning fails). Driver will still try to auto detect correct
>>  parameters. In this case it still fails for reason or other that is not
>>  found yet.
>>
>>
>>
>>  regards
>>  Antti
>>  --
>>  http://palosaari.fi/
>>
>>     
>
> So the fact that it failed isn't actually telling us anything extra then?
> Would it only have been useful if it had actually worked?
> Also just to make sure I'm using the right drivers here, I'm using
> Michael's patch and not Antti's patch. Since it kernel oopses with
> both, Antti, do you want me to try with just your patch and not
> Michael's?
>
> Jarryd.
>   
You need to use that patch of mine because I dont think the af9015 i2c
likes 39-byte i2c transfers.  The patch that I sent to you breaks the
tda182x1 register initialization into 16 register chunks.

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
