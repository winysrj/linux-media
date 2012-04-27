Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52939 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760660Ab2D0Sos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 14:44:48 -0400
Received: by eekc41 with SMTP id c41so282133eek.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 11:44:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F95C3ED.8060209@iki.fi>
References: <1327228731.2540.3.camel@tvbox>
	<4F2185A1.2000402@redhat.com>
	<201204152353103757288@gmail.com>
	<201204201601166255937@gmail.com>
	<4F9130BB.8060107@iki.fi>
	<201204211045557968605@gmail.com>
	<4F958640.9010404@iki.fi>
	<CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
	<4F95C3ED.8060209@iki.fi>
Date: Fri, 27 Apr 2012 21:44:46 +0300
Message-ID: <CAF0Ff2kJqvC6ME6brfTXNfiYvkwhK+juZoYqZaQ7r+7c1MRN_A@mail.gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "nibble.max" <nibble.max@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello Antti,

sorry that i wasn't able to get back to you earlier.

On Tue, Apr 24, 2012 at 12:04 AM, Antti Palosaari <crope@iki.fi> wrote:
> Hello Konstantin,
>
> Good to heard you and finally got your reply to thread.
>
>
> On 23.04.2012 22:51, Konstantin Dimitrov wrote:
>>
>> Antti, i already commented about ds3103 drivers months ago:
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg41135.html
>>
>> and from my point of view nothing have changed - ds3103 chip is almost
>> the same as ds3000 and the driver i made for ds3000 from scratch is
>> what was used ds3103 drivers to be created. so, what you actually is
>> suggesting - my driver to be removed from the kernel and driver that
>> was made based on my hard work to be included and that driver author
>> even refuses to acknowledge my work?!  such practices are really good
>> for the open-source community, don't you think? also, we already have
>> one case for example, where to satisfy someone's interests two drivers
>> for the same demodulators (STV090x family of chips) were accepted in
>> the kernel - i doubt anyone actually can tell why there are 2 drivers
>> for STV090x in the kernel and instead the community to support the
>> driver for STV090x that was made with more open-source ideas in mind,
>> i.e. the one that can work with any STV090x design and which relies
>> less on code copyrighted by ST - anyway, those details about STV090x
>> drivers are off-topic here, but i'm still giving them as example,
>> because the fact is that already once such mess was created having
>> multiple drivers for the same generation of chips in the kernel and
>> apparently those practices will continue if someone don't raise those
>> questions out loud.
>>
>> also, why Montage tuner code should be spitted from the demodulator
>> code? is there any evidence that any Montage tuner (ts2020 or ts2022)
>> can work with 3rd party demodulator different than ds3000 or ds3103?
>
>
> I don't know what is situation of these Montage chips and what are possible
> combinations. *But* there is many existing cases from the DVB-T I am aware.
> Things are done wrongly and all is implemented as a one big blob. After that
> new device is arrived and we cannot support it since existing drivers are
> not split. And it is not single case...
>

i understand your point, but i believe with DVB-T is quite different
than with DVB-S2, i.e. it's very rare to mix DVB-S2 tuners and
demodulators in such way how it's done with DVB-T. in fact, i'm not
aware of any such mixes in real-life. also, below i will give a lot of
technical details, i.e. facts about CX24116 or TDA10071 and CX24118A
and then i'm sure you will understand my point why the same discussion
can be made for CX24116 and TDA10071 drivers.

> It may happen or it may not happen. You never known. But still it is nice to
> split drivers correctly to avoid such problems that could be possible in
> some day. And I don't even know how much those tuners and demods differs - I
> only saw that patch and it looked there was some differences, even so much
> that two tuner drivers could be good choice.
>
>
>> are there such designs in real-life, e.g. either Montage demodulator
>> with 3rd party tuner or actually more importantly for what you're
>> suggesting Montage tuner (ts2020 or ts2022) with third party
>> demodulator? it's more or less the same case as with cx24116 (and
>> tda10071) demodulator, where the tuner (cx24118a) is controlled by the
>> firmware and thus it's solely part of the demodulator driver, even
>> that it's possible to control the cx24118a tuner that is used with
>> cx24116 (and tda10071) designs directly bypassing the firmware. so,
>> why we don't change in that way the cx24116 (and tda10071) drivers
>> too?
>
>
> CX24116 and TDA10071 (I made TDA10071) are somehow different as tuner is
> driven by demodulator firmware. There is no tuner that needs to be driven by
> driver at least for now.

it's off-topic, but anyway i think it would be useful information to
you and most of it is in the public domains anyway and thus i won't
break any rules. so, you can google for:

* "s2TDQR-C005F" and get the datasheet of LG NIM that consists of
CX24118A + CX24116, read page 14 of it, there is figure diagram about
it : in short it gives you all the details how CX24118A is connected
to the CX24116 and explains that when there is no support for the
tuner in CX24116 firmware then "tuner pass-through" can be used and
that CX24118A also can be used with "tuner pass-through", i.e. direct
control no matter that it's supported tuner in the CX24116 firmware

* now google for BS2F7HZ0165 datasheet in PDF (not the product brief,
the datasheet is scanned and ugly looking), which is SHARP NIM that
consists of CX24118A + CX24116 and on page 6 you can get even more
information and even how to program the "tuner pass-through" mode

* further more you can google for MDVBS2-24116, which is NIM made by
Comtech with CX24118A + CX24116  and get all CX24118A control
registers and their meaning

so, the above 3 PDFs that are in the public domain gives you enough to
develop CX24118A driver and bypass CX24116 or TDA10071 firmware using
"tuner pass-through" and control CX24118A directly not using the
demodulator firmware. why no one do it that way - i guess for the
reason i don't split Montage demodulator and tuner code - no CX24118A
is used only together with CX24116 or TDA10071, they are "married
couple" and both CX24116 or TDA10071 firmware are capable to control
CX24118A tuner. yet as even first datasheet mentions another tuner
CX24128 can be used and then "tuner pass-through" mode and splitting
the CX24116 or TDA10071 driver and their firmware from the tuner
control is necessary. so, if nothing else that supports with real
facts what i meant with my question - that if we start splitting tuner
from demodulator for DVB-S2 drivers then CX24116 or TDA10071 should
also be re-worked, i.e. support for tuner pass-through" be added, etc
in case in future for example someone will use CX24116 or TDA10071
with another compatible tuner than is not supported by the firmware. i
hope you better get my point now and even that i add some excitement
to it, because the above information will make you know much more
about CX24116 or TDA10071 from someone like me that made drivers for
them a long time ago, but unfortunately i'm not allowed to make them
public, but hopefully one day i at least be in position where i can
submit patches to the current open-source drivers adding some things
that are currently missing from them.

> There is also some DVB-T devices that has demod and
> tuner which are both controlled by USB -interface firmware and thus no
> chipset driver needed - only some stuff that implements frontend. But for
> the Montage demod/tuner there is clearly both chips driven by the driver.
>

actually, not that clear, because we don't know what Montage firmware
is doing (it's micro-controller core and it can do anything) and
Montage tuner and demodulator are connected to each other in the same
fashion as CX24116 or TDA10071 with CX24118A for which i gave enough
details above.

>
>> i just don't see what's the motivation behind what you're suggesting,
>> because ds3103 is almost the same as ds3000 from driver point of view
>> and one driver code can be used for both and Montage tuners in
>> question can work only with those demodulators (or at least are used
>> in practice only with them). so, if there are any evidences that's not
>> true then OK let's split them, but if not then what's the point of
>> that?
>
>
> I want to split those correctly as it looked splitting could clear driver.
> Also what I suspect those problems Max had were coming from the fact it was
> not split and it makes driver complex when Max added new tuner and demod
> versions.
>
> And my opinion is still it should be split and as a original driver author
> you are correct person to split it :) But you did not replied so I proposed
> Max should do it in order to go ahead.
>
> And I apologize I proposed removing your driver, I know having own driver is
> something like own baby. But also having own baby it means you should care
> it also.
>

yes, but when someone want to use it for something it was not
originally intended to be used, i think that person should contribute
the necessary changes.

> And what goes the original conflict you linked I am not going to comment. I
> still hope you can say what should be done and review the code in order to
> get support that new demod/tuner combo.
>

from my point of view the discussion about splitting Montage tuner and
demodulator code, which i have some reservations to do, because of all
arguments i explained above, is just shifting the discussion from the
real issue in question - copyright of "m88ds3103" driver.

> I just want things to done correctly. One driver per one entity. Just keep
> it simple and clean to extend later.
>
> So let it be short, is my interpretation correct if I say you want all these
> 4 chips (ds3000/ds3103/ts2020/ts2022) to be driven by single driver?
>

i don't know if ts2022 is as close to ts2020 as ds3000 to ds3103, but
if yes then they should be controlled by the same driver, i.e. driver
for "Montage ds3k" generation of demodulators and if my argument about
CX24116 or TDA10071 with CX24118A are ignored then and Montage tuner
and demodulator code is split by 2 drivers: driver for "Montage ds3k"
generation of demodulators and driver for "Montage ts202x" generation
of tuners.

>
> regards
> Antti
> --
> http://palosaari.fi/

best regards,
konstantin
