Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KEJ8p-0007Dr-Ig
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 09:22:08 +0200
Date: Thu, 3 Jul 2008 09:21:14 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0805201233050.23556@pub6.ifh.de>
Message-ID: <Pine.LNX.4.64.0807030908530.23258@pub4.ifh.de>
References: <Pine.LNX.4.64.0804062251380.6749@pub5.ifh.de>
	<Pine.LNX.4.64.0805201233050.23556@pub6.ifh.de>
MIME-Version: 1.0
Subject: [linux-dvb] CX24113 available (was: Re: Technisat SkyStar2 rev 2.7
 and 2.8 status)
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

Hi all,

Technisat was not able to release the binary driver so far, but BBTI 
(windows-driver writer company) was:

It can be found here: http://www.bbti.us/support.htm (bottom) . It is a 
package with instruction and the binary blob for the cx24113. I used it it 
should work with v4l-dvb and kernel between 2.6.18 and 2.6.25.

Unfortunately this is only a binary module, not GPL. It will taint your 
kernel. Conexant for this part of technology is not very GPL friendly.

best regards,
Patrick.

PS: Some guys who have contacted me personally are in BCC.


On Tue, 20 May 2008, Patrick Boettcher wrote:

> Update:
>
> Technisat just told me, that they will release a binary driver for the 
> cx24113 quite soon on their website (along with instructions). It will work 
> with a recent v4l-dvb, if not with the latest.
>
> They did not give me a date. I just know that they have something and that 
> they are going to release it.
>
> Patrick.
>
> On Sun, 6 Apr 2008, Patrick Boettcher wrote:
>
>>  Hi all,
>>
>>  I have some good news for some of you and not yet good news for some
>>  others.
>>
>>  First of all I have to say sorry, because I was relatively quiet recently
>>  even though I promised to be more open. To cut things short, I could not
>>  give any docs or code to other to help development, that's why I had to do
>>  it myself.
>>
>>  To cut things even shorter: on http://linuxtv.org/hg/~pb/v4l-dvb/ I just
>>  committed support for the SkyStar2 rev 2.7. I finished the changes needed
>>  in the s5h1420-driver and added the itd1000-driver. I'm using this card
>>  right now - it works. I don't know whether it works for everyone (I can't
>>  try Diseqc or any Satelite except Astra 19.2). I'm looking forward to hear
>>  some feedback about the driver.
>>
>>  Not so good news for the rev 2.8 users, yet. The driver is finished (I'm
>>  using it since 2 weeks under the same conditions as above), but I cannot
>>  make it open source yet, I'm doing my best to do it and will announce it,
>>  as soon as I have news.
>>
>>  Good luck at least for the 2.7 testers,
>>  Patrick.
>>
>>  --
>>    Mail: patrick.boettcher@desy.de
>>    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
>> 
>> 
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
