Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:43648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0DRTpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 15:45:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1561608fgg.1
        for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 12:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BCB50AF.9030008@tvdr.de>
References: <4BC19294.4010200@tvdr.de>
	 <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>
	 <4BCB06E7.8050806@tvdr.de>
	 <x2l1a297b361004180751y1e8c89f2pafbd257d8107e50c@mail.gmail.com>
	 <4BCB50AF.9030008@tvdr.de>
Date: Sun, 18 Apr 2010 23:45:34 +0400
Message-ID: <j2g1a297b361004181245redcf8a69odd957f583404b158@mail.gmail.com>
Subject: Re: [linux-media] Re: [linux-media] Re: [PATCH] Add FE_CAN_PSK_8 to
	allow apps to identify PSK_8 capable DVB devices
From: Manu Abraham <abraham.manu@gmail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 18, 2010 at 10:34 PM, Klaus Schmidinger
<Klaus.Schmidinger@tvdr.de> wrote:

>> Eventually, it implies that, all DVB-S2 devices are 8PSK capable, but
>> not all 8PSK capable devices are DVB-S2 capable.
>
> Since there are already FE_CAN_* flags for all but PSK_8, I guess
> it would make sense that all devices that support PSK_8 set the
> related FE_CAN_PSK_8 flag (or FE_CAN_8PSK, if you insist in continuing the
> suboptimal naming scheme), independent of the "Turbo FEC" thing.
>
>> Now, assume the FE_CAN_PSK8 or FE_CAN8PSK flag; Does it really make
>> any sense, when it is applied to the whole group of 8PSK frontends ? I
>> guess not. You would require a flag that is capable of distinguishing
>> between the S2 8PSK category and the other category.
>
> There already is such a flag: FE_CAN_2G_MODULATION.


I guess, in the long run, FE_CAN_8PSK or FE_CAN_PSK8 or whatever scheme; might
not make any difference between FE_CAN_2G_MODULATION for a satellite delivery
system in the long run.

Additionally, Turbo FEC is not restricted to 8PSK modulation scheme alone ..
http://www.comtechefdata.com/datasheets/ds-cdm600-600L.pdf
http://www.datasheetdir.com/CX24114+download

That said, I don't really care about the exact naming of the flag, was
just a logical thought
that came to me between the difference in the error correction mode
alone, with no difference
to the modulation schema ...



>> Looking back at history, originally France Telecom introduced the
>> superior Error Correction scheme called Turbo Mode or so called
>> Concatenated FEC mode on a 8PSK modulated carrier. This was a great
>> approach, but they wanted to people to pay them a royalty and hence
>> the general acceptance for it went down. In the initial phase, it was
>> implemented in the Americas and for small clients alone. Eventually,
>> the rest of the world wanted a royalty free approach and thus came
>> LDPC which is just as good.
>>
>> So eventually while the difference between these 2 carriers is that
>> while both are 8PSK modulated stream, the Error correction used with
>> France Telecom's proprietary stream is Concatenated Codes, while for
>> S2 and DVB.org it became LDPC.
>>
>> As you can see, the discriminating factor is the FEC, in this
>> condition and nothing else. You will need a flag to discriminate
>> between the FEC types, rather than the modulation, if things were to
>> look more logical.
>
> I guess the problem, as I can see now, is that there is now way
> of telling from the SI data that a transponder uses "8psk turbo fec",
> or is there?
>
> Would it make sense to differentiate this in the following way:
>
> - an 8psk transponder on DVB-S is "turbo fec"
> - an 8psk transponder on DVB-S2 is  *not* "turbo fec"
>
> ? So an "8psk/DVB-S" transpoder will require a device that has
> FE_CAN_TURBO_FEC set, while an "8psk/DVB-S2" transpoder simply
> requires a DVB-S2 device (since there is no FE_CAN_PSK_8).

(I have no real life experience with the Turbo FEC stream),
with regards to the satellite_delivrey_system_descriptor:
modulation_system will be always DVB-S  with regards to Turbo FEC
streams and not DVB-S2
while
modulation_type will be 8PSK or QPSK for the Turbo FEC capable devices.
Maybe someone having a Turbo FEC device can verify this ?


Eventually, you would be able to use the flags or a combination of it
at the driver side;

and with regards to the SI: modulation_system and modulation_type it's
possible to handle a 8PSK Turbo FEC stream, but it might be a bit more
trickier to handle a QPSK Turbo FEC stream.


Regards,
Manu
