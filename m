Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.pinguin@gmail.com>) id 1JRuYa-0007GA-3v
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 20:24:40 +0100
Received: by py-out-1112.google.com with SMTP id a29so2766473pyi.0
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 11:24:34 -0800 (PST)
Message-ID: <3efb10970802201124h35eb22baud965fe0d163e5fca@mail.gmail.com>
Date: Wed, 20 Feb 2008 20:24:34 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "P. van Gaans" <w3ird_n3rd@gmx.net>
In-Reply-To: <47BC0D27.6080003@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <47B19015.20208@gmx.net> <47B2F82F.6070804@Deuromedia.ro>
	<47B3512C.5010107@gmx.net> <47B62C4B.3020604@gmx.net>
	<47B97E8B.8090905@gmx.net> <47B98257.8060200@Deuromedia.ro>
	<47B99095.3080306@gmx.net> <47BBF770.2020000@Deuromedia.ro>
	<47BC0D27.6080003@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DiSEqC trouble with TT S-1500
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

Hello All,

Maybe I have the answer:
I also had problems with switches and LNBs which did not want to work properly.
Behind 1 receiver it worked properly, but behind another 2 different
DVB-S PCI cards, it just failed. I never suspected the LNB/Switch
setup, because it worked behind another receiver.
But, In the end it turned out that there was 1 LNB in my setup that
caused all the trouble, that LNB refused to cooperate with the
switches and other LNBs, when a DVB-S PCI card was used (both
Technisat Skystar 1CI, and TT-S1500). Once switched to this LNB, the
complete setup failed to work from that moment on. I could never
switch back to 1 of the previous LNBs, but the last (buggy) LNB still
worked if I switched back to it.

So, my advice is to start with 1 LNB behind a switch, once it works,
add another one, check if both LNBs still works, if so, add another
LNB and so on. Maybe you end up, just like me, with 1 LNB that
destroys the complete behavior.

So, my 3 TT-S1500s are properly working here now with MythTv and
DiseqC switches with 4 LNBs per card/switch. So, it _can_ work...


Good luck!


Kind Regards,

Remy



2008/2/20, P. van Gaans <w3ird_n3rd@gmx.net>:
> On 02/20/2008 10:48 AM, Doru Marin wrote:
>  > P. van Gaans wrote:
>  >> On 02/18/2008 02:04 PM, Doru Marin wrote:
>  >>
>  >>> P. van Gaans wrote:
>  >>>
>  >>>> On 02/16/2008 01:20 AM, P. van Gaans wrote:
>  >>>>
>  >>>>
>  >>>>> On 02/13/2008 09:21 PM, P. van Gaans wrote:
>  >>>>>
>  >>>>>> On 02/13/2008 03:01 PM, Doru Marin wrote:
>  >>>>>>
>  >>>>>>> Hi,
>  >>>>>>>
>  >>>>>>> Can you explain how you select those 4 positions ? DiSEqC
>  >>>>>>> commands or tone/voltage changes ?
>  >>>>>>> Also can you determine the input type of those positions (Hi/Low,
>  >>>>>>> H/V, etc) ? A scenario to see when and why that happens, would be
>  >>>>>>> more useful.
>  >>>>>>>
>  >>>>>>> P. van Gaans wrote:
>  >>>>>>>
>  >>>>>>>> Hi,
>  >>>>>>>>
>  >>>>>>>> I've got a Technotrend S-1500 (if it matters: I use it with
>  >>>>>>>> Kaffeine 0.8.3). It works mostly fine, but there's a strange
>  >>>>>>>> problem. With my Spaun 4/1 DiSEqC switch (they cost approx 25-40
>  >>>>>>>> euro), I can only switch without trouble to position 1 and 2. If
>  >>>>>>>> I tune directly to position 3 it won't lock.
>  >>>>>>>>
>  >>>>>>>> However, if I first tune to a channel on position 1 or 2 and try
>  >>>>>>>> a channel on position 3 after that, it will work. Position 4
>  >>>>>>>> however is completely unreachable.
>  >>>>>>>>
>  >>>>>>>> On a standalone receiver, there's no trouble with the same cable.
>  >>>>>>>>
>  >>>>>>>> Now Spaun is a really expensive and respected brand. So their
>  >>>>>>>> switches possibly work in a different way, because a cheap
>  >>>>>>>> Maximum 4/1 switch works perfectly with the S-1500. Position 1,
>  >>>>>>>> 2, 3 and 4 all work perfectly. I also did some "dry testing"
>  >>>>>>>> indoors and it looks like a 7 euro Satconn 4/1 switch would also
>  >>>>>>>> work fine, but a 17 euro Axing SPU 41-02 probably won't.
>  >>>>>>>>
>  >>>>>>>> I'm guessing this could be solved in stv0299.c but I'm not much
>  >>>>>>>> of an expert. I took a look at the code but I'm not really sure
>  >>>>>>>> what to do.
>  >>>>>>>>
>  >>>>>>>> _______________________________________________
>  >>>>>>>> linux-dvb mailing list
>  >>>>>>>> linux-dvb@linuxtv.org
>  >>>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >>>>>>>>
>  >>>>>> I select them with Kaffeine. Hi/low and H/V doesn't matter. I
>  >>>>>> tried upgrading to Kaffeine 0.8.5 but that doesn't make a
>  >>>>>> difference. The "scan" application has the same issues.
>  >>>>>>
>  >>>>>> _______________________________________________
>  >>>>>> linux-dvb mailing list
>  >>>>>> linux-dvb@linuxtv.org
>  >>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >>>>>>
>  >>>>>>
>  >>>>> Nobody any ideas? If not, does anybody have some idea what the
>  >>>>> difference between position 1+2, pos 3 and pos 4 could be? I was
>  >>>>> thinking 1 and 2 might be working because of toneburst, but I don't
>  >>>>> think Kaffeine uses such a signal and that doesn't explain why pos
>  >>>>> 3 works if first tuning to 1 or 2 and 4 doesn't work at all.
>  >>>>>
>  >>>>>
>  >>>> I've figured out a bit more. If I tune directly to postion 3, I get pos
>  >>>> 1. Whenever I tune to pos 4, I get pos 2.
>  >>>>
>  >>>> I'll also ask people from Kaffeine as I'm not sure if the problem is
>  >>>> in the application, driver or somewhere else.
>  >>>>
>  >>>> _______________________________________________
>  >>>> linux-dvb mailing list
>  >>>> linux-dvb@linuxtv.org
>  >>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >>>>
>  >>> Hi,
>  >>>
>  >>> Strange scenario. You're not saying anything about input types and
>  >>> the switch type. Are you sure that are properly connected ? How the
>  >>> switch inputs are marked and from where you got the input signals ?
>  >>> Please elaborate, if you want a proper answer.
>  >>> I suggest to play with 'scandvb' from dvb-apps package instead of
>  >>> Kaffeine. Look into scanning results if the scanned channels match
>  >>> with what you wished to have on those positions.
>  >>>
>  >>>
>  >> Hi,
>  >>
>  >> What do you mean with input type?
>  >>
>  >> Anyway, this is my config:
>  >>
>  >> Visiosat Bisat G3C for 19.2/28.2/23.5 + Triax 54cm for Hotbird
>  >> 4 quad LNBs
>  >>
>  >> Spaun SAR 411F:
>  >> A = Astra 19.2
>  >> B = Astra 28.2/Eurobird1
>  >> C = Astra 23.5
>  >> D = Hotbird
>  >>
>  >> Maximum 4/1:
>  >> A = Astra 19.2
>  >> B = Astra 28.2/Eurobird1
>  >> C = Astra 23.5
>  >> D = Hotbird
>  >>
>  >> All works fine on a standalone so it is connected correctly.
>  >>
>  >> _______________________________________________
>  >> linux-dvb mailing list
>  >> linux-dvb@linuxtv.org
>  >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >>
>  > Hi,
>  >
>  > Ok, If I understood you correctly, you're talking about only plain
>  > DiSEqC switch, with no polarity/tone management. Polarity and tone
>  > switching are done by LNB's.
>  > Recently, I found a branded switch, which was unable to decode a DiSEqC
>  > commands while polarity was on horizontal (18V).
>  > Maybe is the same situation, maybe not. That's why I asked you to check
>  > the polarity/tone settings of the channels while switching to a
>  > different channel on a different satellite.
>  >
>
>
> That's right, no multiswitches or something like that. The last time I
>  checked (a while ago), the Spaun was still completely working on my
>  standalones. But as I figured out yesterday, something is wrong with
>  that now. The standalones don't see D (Hotbird) anymore either. So I'm
>  first going to fix that.
>
>  Trying to switch from Flaunt (V) to 4fun.tv (V) doesn't work either, so
>  it's not the same problem I guess.
>
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
