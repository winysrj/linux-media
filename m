Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42528 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3HSWnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 18:43:07 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so6187707obb.23
        for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 15:43:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52127667.8050202@bitfrost.no>
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54>
	<520F643C.70306@iki.fi>
	<5210B5F3.4040607@bitfrost.no>
	<CALzAhNXUKZPEyFe0eND3Lb3dQwfVaMUWS30kx0sQJj7YG2rKow@mail.gmail.com>
	<52127667.8050202@bitfrost.no>
Date: Tue, 20 Aug 2013 01:43:04 +0300
Message-ID: <CAF0Ff2mQP6+a5693kf3Vq7AHHG5--1keZMvdp-YX4o4OLk3Y-g@mail.gmail.com>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Hans Petter Selasky <hps@bitfrost.no>
Cc: Steven Toth <stoth@kernellabs.com>, Antti Palosaari <crope@iki.fi>,
	Ulf <mopp@gmx.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Hans,

On Mon, Aug 19, 2013 at 10:47 PM, Hans Petter Selasky <hps@bitfrost.no> wrote:
> On 08/18/13 21:02, Steven Toth wrote:
>>>
>>> FYI: The Si2168 driver is available from "dvbsky-linux-3.9-hps-v2.diff"
>>> inside. Maybe the Si2165 is similar?
>>
>>
>> Excellent.
>>
>
> Hi Guys,
>
> I was contacted by someone claiming to be from "RSD" ??, named Danny Griegs,
> off-list, claiming I have the source code for sit2.c and cannot distribute
> it.
>

there is www.rsd.de, which is abbreviation for rohde-schwarz-something
and to where that side is actually redirecting. so, they are
German-based company making DVB equipment and maybe if that's the same
RSD that Danny Griegs guy could be legit. however, nothing in the
binary you used proves they have any ownership over the binary or the
code compiled in it. so, you can ask them to show you their NDA with
Silicon Labs - after all they can't have access to that information in
the code without valid NDA with Silicon Labs.

> I want to make clear to everyone that the tarball I've provided only
> contains the C-equivalent of the "objdump -dx" output from the
> media_build-bst/v4l/sit2.o.x86 which is distributed officially by DVBSKY.
>

so, there is no any guarantee that the code Max Nibble packed in that
binary is really his creation - he had a history of copy-left
practices - for example some time ago he tried to change the copyright
notice of code i released under GPL:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg41135.html

as its main architecture was based on 'cx24116.c' made by Steven Toth
and others, even the work of 'ds3000' demodulator is quite different
and i made a lot of changes in the code leaving almost no resemblance
with 'cx24116.c'.

so, if you search the list there are few discussions about 'ds3000',
which i made and what Max Nibble did with it. also, Max Nibble is most
likely not his real name - those DVBsky-brand products are made by
Chinese company with the notorious name of "BestTunar" (yes, i didn't
make spelling error here). in any case that's issue between RSD/Danny
Griegs and Max Nibble, not between you and them. also, you can check
the originating IP of the email from RSD/Danny Griegs and ensure it's
not some of the many personalities of Max Nibble - he writes from IP
addresses located at Shenzhen, China.

> He claimed I had to pull the tarball off my site right away or face legal
> actions. I cannot understand this, and would like to ask you guys what you
> think. Obviously my sit2.c is too similar to their "licensed" sit2.c. And
> now these guys want to send a lawyer after me. What a mess. Should I laugh
> or cry. Any advice from you guys about this?
>
> BTW: The hexdump of the sit2.o.x86 contains the string "license=GPL". Does
> that give me any rights to redistribute the re-assembled C-code ?
>

i'm not an intellectual property lawyer, but what you did is at least
honest, i mean add notice:

"Max Nibble wrote the initial code, but only released it in binary
form. Assembly to C conversion done by HP Selasky."

and as far as you can tell the license of the code in the binary
module is GPL, because recently similar as what you did with that
driver happened with close-source driver made by me - that driver
included both open-source patches to GPL code and thus GPL and not
open-source module - all the code for it was submitted as several
patches to V4L and the submitter when i confronted:

http://www.spinics.net/lists/linux-media/msg65888.html

just said - i didn't know you made that:

http://www.spinics.net/lists/linux-media/msg65889.html

how convenient even thought 'modinfo' of the not-open-source module of
the initial driver lists the license as not-GPL and my name and email
as author and thus all changes that are made as part of that driver
are clearly why and who made them. anyway, i just move one, because it
seems even open-source community like V4L is no longer supportive of
the real authorship and don't care the things to be open-sourced in
some proper way, which is damaging for the community if you ask me.

so, as i mentioned on one of the links above, i don't see anything
wrong with clean-room reverse-engineering, even if that includes
disassembling of some binary as you did (a lot of open-source drivers
are made that way, when there is no publicly available datasheets), as
far as that is mentioned as note, which you did - i mean if you have
full understanding of the driver work then it's fine and you can even
maintain it and make no any notes, but otherwise it's just a bunch of
magic numbers that are reversed from the binary and nothing more, i.e.
you can't maintain and extent its functionality beyond what's in the
binary and totally ignore and give no credit to the one that made the
binary - let's say some of the chip initialization values needs to be
changed due to a bug. so, in the last case i guess that has more
negative impact than it helps, because even like my case that NDAs are
preventing the driver to become open-source that doesn't mean at some
point it wouldn't be open-sourced in a proper way, i.e. with
permission from those which intellectual property prevents being
open-sourced. however, net results of the whole story i told is that i
can't commit and contribute even to the code that was open-sourced
based on my work. so, anyway, what i'm saying is that your case is not
precedent for V4L and so even for my case if some of the parties
decides i guess have grounds for that and can take legal actions, but
that didn't stop anyone and the code to be submitted to V4L.

best regards,
konstantin

>>
>>> 00002460  63 28 29 20 66 61 69 6c  65 64 0a 00 01 36 73 69  |c()
>>> failed...6si|
>>> 00002470  74 32 3a 20 25 73 2c 20  70 6f 77 65 72 20 75 70  |t2: %s,
>>> power up|
>>> 00002480  0a 00 01 36 73 69 74 32  3a 20 25 73 2c 20 70 6f  |...6sit2:
>>> %s, po|
>>> 00002490  77 65 72 20 75 70 5b 25  64 5d 0a 00 76 65 72 73  |wer
>>> up[%d]..vers|
>>> 000024a0  69 6f 6e 3d 31 2e 30 30  00 6c 69 63 65 6e 73 65
>>> |ion=1.00.license|
>>> 000024b0  3d 47 50 4c 00 61 75 74  68 6f 72 3d 4d 61 78 20
>>> |=GPL.author=Max |
>>> 000024c0  4e 69 62 62 6c 65 20 3c  6e 69 62 62 6c 65 2e 6d  |Nibble
>>> <nibble.m|
>>> 000024d0  61 78 40 67 6d 61 69 6c  2e 63 6f 6d 3e 00 64 65
>>> |ax@gmail.com>.de|
>>> 000024e0  73 63 72 69 70 74 69 6f  6e 3d 73 69 74 32 20 64
>>> |scription=sit2 d|
>>> 000024f0  65 6d 6f 64 75 6c 61 74  6f 72 20 64 72 69 76 65  |emodulator
>>> drive|
>>> 00002500  72 00 70 61 72 6d 3d 73  69 74 32 5f 64 65 62 75
>>> |r.parm=sit2_debu|
>>> 00002510  67 3a 41 63 74 69 76 61  74 65 73 20 66 72 6f 6e  |g:Activates
>>> fron|
>>> 00002520  74 65 6e 64 20 64 65 62  75 67 67 69 6e 67 20 28  |tend
>>> debugging (|
>>> 00002530  64 65 66 61 75 6c 74 3a  30 29 00 70 61 72 6d 74
>>> |default:0).parmt|
>>> 00002540  79 70 65 3d 73 69 74 32  5f 64 65 62 75 67 3a 69
>>> |ype=sit2_debug:i|
>
>
> Thank you.
>
> --HPS
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
