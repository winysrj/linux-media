Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L9oSR-0004gR-KK
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 23:20:07 +0100
Message-ID: <493D9D8B.9010106@insite.cz>
Date: Mon, 08 Dec 2008 23:19:55 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <493BE666.8030007@insite.cz>
	<c74595dc0812070822p73746bdel9894de34c87a733f@mail.gmail.com>
	<493D69C8.2080904@insite.cz>
	<alpine.DEB.2.00.0812082101180.14915@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812082101180.14915@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
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



BOUWSMA Barry napsal(a):
> On Mon, 8 Dec 2008, Pavel Hofman wrote:
> 
>> Results of the scan give very often zero APID, VPID:
>>
>> Sky Cust Ch:11934:v:0:27500:0:0:4505:5
>> Cartoon Network Game 4:12012:v:0:27500:0:2603:8005:5
>> Video Application Val:12012:v:0:27500:2518:2519:8015:5
>> Sky Bingo:12012:v:0:27500:0:0:8032:5
>> Sky Bet, Vegas & Sky Poker:12012:v:0:27500:0:0:8076:5
> 
> These are all programmes -- or rather, data services or MHP/
> OpenTV/whatever BSkyB uses -- at 28E -- nowhere else.
> 
> Your sat dish is clearly misaligned -- you are probably
> receiving your CZ/SK/Kabel Deutschland/NL correctly at
> 23E5, but instead of 19E2, you are receiving 28E, with
> english speaking programmes for the UK -- the majority
> of the 19E2 programmes are german language, with a few
> french, spanish, and a handful of other languages.
> 
> Do you have a normal satellite receiver?  If so, use
> that, as you move your dish slightly in one direction
> (to the direction of the sunset) until you receive your
> CZ stations -- although now they will be received on
> the other LNB input -- and then you should be seeing
> the programmes from 19E2.
> 
> As long as you are receiving FreeSat/BSkyB programmes,
> there is no way that an Astra 19E2 scanfile will help.
> 
> 
> barry bouwsma

Hi Barry,

You are of course right, it took me a while to get it :) Scanning with 
Astra 28E2 revealed all the programs. Thanks a lot for your help.

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
