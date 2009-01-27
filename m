Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:45640 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZA0Qw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 11:52:59 -0500
Received: by ewy14 with SMTP id 14so1986544ewy.13
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 08:52:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497EF972.6090207@to-st.de>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
	 <497A27F7.8020201@to-st.de>
	 <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>
	 <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
	 <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
	 <497EC855.7050301@to-st.de>
	 <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>
	 <497EF972.6090207@to-st.de>
Date: Tue, 27 Jan 2009 17:52:57 +0100
Message-ID: <19a3b7a80901270852g5aaf6b99je59d6190cd70275@mail.gmail.com>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-media@vger.kernel.org, tobi@to-st.de
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

2009/1/27 Tobias Stoeber <tobi@to-st.de>:
> Hi Christoph,
>
> Just had a look at your zip archive and the files.
>
> Christoph Pfister schrieb:
>> I've updated my de-files:
>> - fixed the url (inserted the wrong one by accident)
>> - fixed vhf channels (they were using 8mhz because my trigger was wrong)
>> - add the the "# CHxy: name of programs" information
>> - 563 MHz --> 562 MHz (their pdf seems to use a wrong frequency for channel 32)

As Hermann already pointed out, I've committed these files to hg. I've
extracted as much information as possible from the pdf (there are
still errors remaining: a ch65 <--> 778 MHz mapping somewhere, which
I'll fix myself, and the Hamburg 1/4 <--> 1/8 duplication, which I
won't touch) and I've done some spot checks against the existing scan
data. This should help many regions (where the scan files were just
collecting dust). So please (re-)post your additions relative to these
files.

> You are right. 562 MHz as nominal frequency is correct, because for
> DVB-T this is calculated 306 MHz + channel number x 8 MHz. VHF would be
> 142.5 MHz + channel number x 7 MHz.
>
> It's just a centre frequency used for tuning purposes. The DVB-T signal
> should (ideally) use a 8 MHz width space from 559.25 MHz to 567.25 MHz
> for Ch 32.
>
>> But I haven't looked at the new documents proposed in this thread yet.
>
> I didn't compare that either. Could also be difficult, because of
> different revision dates.
>
> Looking through your files in the zip archive, it rose some questions in
> my mind:
>
> a) is it really useful to have scan files by federal state (Bundesland)?
>
> Just let me explain with an example. I live in Sachsen-Anhalt on the
> north of the Harz Mountains area. To effectivly ("best") use DVB-T I do
> combine both transmitters in Sachsen-Anhalt (Mt. Brocken) and from
> Niedersachsen (Braunschweig). This is because some channels are only
> available from a specific transmitting site (private channels only from
> Braunschweig, RBB only from Brocken). The same applies to other regions
> in Sachsen-Anhalt (south east will have reception from Sachsen and
> Thüringen, north east from Berlin / Brandeburg etc.)
>
> I think, this situation will also apply to other federal states.
>
> => I personally would prefer to stay with or alternatively provide a
> region based file, so I could look up and combine the regions of
> interest. What do you think?

There are always "edge" cases, between transmitters, regions or
countries. If you want, you can always c&p from different files (they
don't hurt each other). But the cost-benefit side looks a bit
different: Using that pdf I could (hopefully) produce working data for
many people. Imho taking care of all those intersection cases is more
effort and not necessarily justified. And I reall hope that auto-scan
will spread more ...

> b) Conflicting information
>
> In your "Sachsen-Anhalt" scanfile you list on Ch 24 the ARD multiplex
> with (Halle-Stadt):
>
> T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
> # CH24: Das Erste, arte, Phoenix, EinsFestival
>
> which is for a large part of Sachsen-Anhalt useless (we can't receive
> that), as we actually receive on Ch 24 (from Braunschweig)
>
> T 498000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
> # CH24: RTL, RTL II, Super RTL, VOX
>
> => have a look at QAM, its QAM64 in your scanfile and QAM16 for Ch24 we
> actually receive.
>
> => Does it matter, e.g. would instead of the unreceivable Ch24 from
> Halle-Stadt the Braunschweig Ch24 be found? (I did not test this).
>
> c) You clearly missed out some information. I noticed for instance Ch 37
> in Leipzig (Sachsen) which is the "Leipzig 1" multiplex
>
> Please have a look at the already posted link to SLM or my homepage:
>
> http://www.to-st.de/content/projects/dvb-t/dvbt-sender-leipzig.de.html
>
> On the other hand I doubt, that it would be a useful entry into a
> "Sachsen" scanfile because reception is limited to the area of the city
> of Lepzig.
>
> As I have no overview of regional "special projects" in other area, such
>  omissions in the files may apply to other areas too.
>
> @Barry
>
> Just as a sidenote and for historical purposes I may point you to:
>
> http://www.ifn.ing.tu-bs.de/itg/docs/030403Braunschweig/ITG030403Hoehne_Frequenzplanung.pdf
>
> which gives an overview how in 2003 the concept for the north of Germany
> had been planned. This information is obsolete and has changed, but the
> document show a bit, how decisions evolved in consideration of federal
> state and "Medienanstalt" boundaries (e.g. Bremen) etc.
>
> Regards, Tobias

Christoph
