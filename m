Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out113.alice.it ([85.37.17.113])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sarkiaponius@alice.it>) id 1JdivT-0006sg-MD
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 10:25:08 +0100
Message-ID: <47E7731D.7000706@alice.it>
Date: Mon, 24 Mar 2008 10:23:41 +0100
From: Andrea Giuliano <sarkiaponius@alice.it>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Morgan_T=F8rvolt?= <morgan.torvolt@gmail.com>
References: <47E56272.8050307@alice.it>
	<3cc3561f0803230425p60486919m9685f4a145df7635@mail.gmail.com>
In-Reply-To: <3cc3561f0803230425p60486919m9685f4a145df7635@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help needed...
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dear Morgan,

first of all I thank you for your kind answer, and I also thank Octavio =

  Ascanio and Hermann.

Actually, before you answer I solved my problem in a way that seems to =

me very close to your suggestion.

Looking a lyngsat and kingofsat I found that every single channel found =

by dvbscan is on a frequency which is just 19 or 20 units less than the =

one listed on those sites. For example, 11804 on lyngsat corresponds to =

11785=3D11804-19 on the dvbscan output.

So I started trying different values of frequency, but without results. =

Finally, I really can't say why, I tried to change "V" to "H" ... et =

voil=E0: I could be able to see RaiNews24!

Then I tried exactly what you suggested: the -c option. This way I got, =

with some minor problems, a list of RAI channels on 11804 and 11766, but =

still with the wrong frequencies.

To be precise, here is a working channels.conf file which I can now use =

to watch and record RAI channels perfectly fine:

nettuno1:11785:h:0:27500:519:657:3410
nettuno2:11785:h:0:27500:513:651:3410
rai1:11747:h:0:27500:512:650:3401
rai2:11747:h:0:27500:513:651:3402
rai3:11747:h:0:27500:514:652:3403
raiedu1:11785:h:0:27500:514:652:3527
raiedu2:11747:h:0:27500:518:656:3406
raigulp:11785:h:0:27500:522:663:3410
raimed:11747:h:0:27500:515:653:3404
rainews24:11785:h:0:27500:516:654:3521
senato:11747:h:0:27500:8190:92:3408

You will notice the "h" polarity. According to lyngsat, there are no =

channels on "11785 H", or, if any, they definitely are not RAI channels. =

The same, if I remember correctly, applies for "11747 H".

My practical conclusion is: "11804 V" stands for "11875 H" and "11766 V" =

stands for "11747 H". No other way to get things working.

To some extents, my results are in some accord with your suggestions. =

Actually, the cable should be about 30 meters long. I can't say anything =

about the point 1) of your answer, but I also have many foreign channels =

tuned with the wrong frequency, but the right polarity. At present it =

would take a bit of time to show you some example of this, I'll dot my =

best about this.

Anyway, now I got a practical result, and that's a start.

Many thanks and best regards.

Morgan T=F8rvolt wrote:
> On 22/03/2008, Andrea Giuliano <sarkiaponius@alice.it> wrote:
>> Hi,
>>
>>  I can szap many free channels from Hotbird 13E, but none on some
>>  frequencies. For example, if the "test" file just contains the line:
>>
>>     S 11766000 V 27500000 2/3
>>
>>  that I took from http://www.lyngsat.com/hotbird.html as many other which
>>  instead work percectly, the command:
>>
>>     scan test > channels.conf
>>
>>  alway gives the following output:
>>
>>  scanning prova
>>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>  initial transponder 11766000 V 27500000 2
>>   >>> tune to: 11766:v:0:27500
>>  WARNING: >>> tuning failed!!!
>>   >>> tune to: 11766:v:0:27500 (tuning failed)
>>  WARNING: >>> tuning failed!!!
>>  ERROR: initial tuning failed
>>  dumping lists (0 services)
>>  Done.
>>
>>  On the other hand, if I put manually some lines in channels.conf for
>>  such a frequency, I can zap to those channels, but in most cases I watch
>>  a different channel, not the one I expected to see.
>>
>>  This doesn't happen on other frequencies.
>>
>>  May be of some help the fact that I'm writing from Italy, and I cannot
>>  get channels from the scan for the most important italian channels: in
>>  particular, none of RAI network, nor Mediaset network, the biggest
>>  network in Italy.
>>
>>  Also, the signal became rather good after I bought an amplifier.
>>  Actually, I can see and record perfectly fine many channels. I don't
>>  think I have signal strength problems.
>>
>>  Any hint will be very much appreciated.
>>
>>  Best regards.
>>
>>  --
>>  Andrea
>>
>>  _______________________________________________
>>  linux-dvb mailing list
>>  linux-dvb@linuxtv.org
>>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>  _______________________________________________
>>  linux-dvb mailing list
>>  linux-dvb@linuxtv.org
>>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> =

> Getting a different mux is only possible int a few very special cases.
> 1. Your LNB is 90 degrees off, giving vertical where you should have
> horizontal and vice verca.
> 2. You get the wrong polarization or frequency, possibly because of a
> too long cable dampening the 18V or something like that so that the
> LNB does not switch.
> =

> This is easy to check actually. Use zap to go to the "wrong" mux, and
> then use dvbscan -c (scan current mux) to get a listing of the
> channels on the mux. Then locate the mux using lyngsat. You will then
> see if there is a difference in polarization or frequency that can be
> explained by a error in lo frequency (if the frequency is off by
> 10600-9750=3D850MHz) or polarization. I am quite confident that you will
> find one of these to be the case. The frequency can be a bit away from
> 850MHz since the tuner is usually able to achieve sync with a lot of
> offset (I have seen a tuner sync with more than 15MHz offset).
> =

> The error can as mentioned be caused by a long cable, but a faulty LNB
> or tuner-card is of course also a possible explaination. Check if an
> ordinary stb works.
> =

> -Morgan-


-- =

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
