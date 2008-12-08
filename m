Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L9l4e-0003yx-NB
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 19:43:17 +0100
Message-ID: <493D6ABC.5060400@insite.cz>
Date: Mon, 08 Dec 2008 19:43:08 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <493BE666.8030007@insite.cz>
	<alpine.DEB.2.00.0812071856470.11349@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0812071856470.11349@ybpnyubfg.ybpnyqbznva>
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
> On Sun, 7 Dec 2008, Pavel Hofman wrote:
> 
> Sorry if I'm missing something, as I haven't been paying
> too much attention, but...
> 
> 
>> I added a few free-to-air channels I was able to tune in WinXP to 
>> channels.conf:
>>
>> Entertainment:12012:v:0:27500:2582:2581:8037
>> SkyNews:12207:v:0:27500:514:645:4707
>> WineTV:11555:h:1:27500:2372:2374:50435
>> AvaTest:11555:h:1:27500:2329:2330:50446
>> Vegas:11515:h:1:27500:3568:3567:8035
>> Faith:11515:h:1:27500:2375:2376:50455
>>
>> The first two on LNB0, the rest on LNB1.
> 
> I'm sorry, but these are all programmes which are sent
> over the 28E position (Astra2/Eurobird), for the UK.
> All of them.
> 
> Do you have two dishes pointed to the same satellite
> position, connected to LNBs 0 and 1 ?
> 
> 
>> Perhaps it is correct and the channels I checked broadcast no stream at 
>> this time. Since scan2 keeps failing, please is there a place to 
>> download recent channels.conf for Astra 19.2E so that I can test on many 
>> more channels?
> 
> And now you mention Astra 19E2, so I am very confused.
> 
> I would expect you should be able to receive 23E5 for
> the czech broadcasts -- but please explain your setup,
> which satellites you expect to see at which LNB position.
> 
> 
> Many of the frequencies and polarisations are re-used
> among different satellite positions -- that is the case
> for 28E and 19E from 10714 up to 10964 (at 28E, the
> frequencies above this have generally not been activated
> yet) and other frequencies *not* on Eurobird, which
> generally seem to share the same frequency both hor.
> and vertically.
> 
> That is, you will often get carrier for the same tuning
> parameters from different satellites.
> 
> 
> So, please ease my mind, and tell me what you expect to
> receive on LNBs 0 and 1 (and 2 and up if you have them).
> 
> 
> I could point you to an old-style channels.conf which I
> have for 19E2, as well as 28E, 23E5, and 13E, if you
> still need them, but I first want to be sure they'll help
> 
> 
> thanks
> barry bouwsma

Hi Barry,

Thanks a lot for your offer. I have a dual LNB (4 degrees apart), LNB0 
points to Astra19.2E, LNB1 points to Astra23.5E. I am able to tune both 
satellites now, nevertheless your channel.conf's for them would probably 
help.

Thanks,

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
