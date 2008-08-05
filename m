Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mika.batsman@gmail.com>) id 1KQI74-0001Qi-Jf
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 10:41:54 +0200
Received: by an-out-0708.google.com with SMTP id c18so625571anc.125
	for <linux-dvb@linuxtv.org>; Tue, 05 Aug 2008 01:41:45 -0700 (PDT)
Message-ID: <48981245.2050900@gmail.com>
Date: Tue, 05 Aug 2008 11:41:41 +0300
From: =?ISO-8859-1?Q?Mika_B=E5tsman?= <mika.batsman@gmail.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>	<4879FA31.2080803@kolumbus.fi>	<4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>	<487BB17D.8080707@kolumbus.fi>	<D5C41D41-A72D-4603-9AD1-67A8C5E73289@oberste-berghaus.de>
	<488CAE63.9070204@kolumbus.fi> <488F0D80.7010607@gmail.com>
	<489766A4.7070907@kolumbus.fi>
In-Reply-To: <489766A4.7070907@kolumbus.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
 (VP-2040) &	mantis driver
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

Marko Ristola wrote:
> Mika B=E5tsman kirjoitti:
>> Hi,
>> I also tried your patch because I've had freezes since I got these =

>> cards. Unfortunately it didn't help me. Got a whooping 5min uptime =

>> before it all went wrong again. I have 2x Cinergy C + 2.6.24-19 + vdr =

>> 1.6.
>>
> Do you have a heat problem? Have you checked your motherboard sensors?
> Have you checked that your memory is okay? Air flows easilly?

Memory was the first thing I suspected but memtest went through 10+ =

times without a fail. Heat shouldn't be a problem either. There's a big =

efficient, noisy fan in the back of the case.

The machine works fine when dvb is watched with dvbyell =

http://www.dvbyell.org/ which has cards set to fixed frequency ie. card1 =

-> 152Mhz and card2 -> 290Mhz. At least for me the problem occurs only =

with apps like mythtv and vdr which change the frequency of the tuner.

-Mika

>> I did:
>> hg clone http://jusst.de/hg/mantis
>> replaced mantis_dma.c with the one you attached, renamed =

>> MANTIS_GPIF_RDWRN -> MANTIS_GPIF_HIFRDWRN
>> make && make install && reboot
>>
>> Am I missing something? It seemed to compile and install fine.
>>
>> You said that the mantis_dma.c in jusst.de mantis head is not the =

>> latest version. Where can it be found then?
> I have my own driver version which I have given for Finnish people for =

> easy installation with remote control support for Twinhan 2033.
> (Personally I'm not pleased with the card: now after some years of =

> development the card works well enough for me finally).
> =

> So the most important feature of my driver for Finnish people has been =

> the easy compile and install and that the driver ("release") is tested =

> for Twinhan 2033.
> Secondly I have given for some Finnish people the Twinhan 2033 remote =

> control support included.
> Maybe somebody from Finland would be interested with the DMA transfer =

> fixes, if they have unsolved quality problems. That's a fact that those =

> tweaks helped me although the root cause is a bit uncertain. Other =

> features of my driver version like suspend/resume aren't very important.
> =

> Regards,
> Marko Ristola
> =

>>
>> Regards,
>> Mika B=E5tsman
>>
>> Marko Ristola wrote:
>>>
>>> Hi,
>>>
>>> Unfortunately I have been busy.
>>>
>>> The patch you tried was against jusst.de Mantis Mercurial branch head.
>>> Your version of mantis_dma.c is not the latest version and thus the =

>>> patch didn't
>>> apply cleanly.
>>>
>>> Here is the version that I use currently. It doesn't compile straight =

>>> against jusst.de/mantis head.
>>> It might work for you because MANTIS_GPIF_RDWRN is not renamed as =

>>> MANTIS_GPIF_HIFRDWRN.
>>>
>>> If it doesn't compile please rename MANTIS_GPIF_RDWRN occurrences =

>>> into MANTIS_GPIF_HIFRDWRN on that file.
>>> Otherwise the file should work as it is.
>>>
>>> Best regards,
>>> Marko Ristola
>>>
>>> Leif Oberste-Berghaus kirjoitti:
>>>> Hi Marko,
>>>>
>>>> I tried to patch the driver but I'm getting an error message:
>>>>
>>>> root@mediapc:/usr/local/src/test/mantis-0b04be0c088a# patch -p1 < =

>>>> mantis_dma.c.aligned_dma_trs.patch
>>>> patching file linux/drivers/media/dvb/mantis/mantis_dma.c
>>>> patch: **** malformed patch at line 22: int mantis_dma_exit(struct =

>>>> mantis_pci *mantis)
>>>>
>>>> Any ideas?
>>>>
>>>> Regards
>>>> Leif
>>>>
>>>>
>>>> Am 14.07.2008 um 22:05 schrieb Marko Ristola:
>>>>
>>>>> Hi Leif,
>>>>>
>>>>> Here is a patch that implements the mentioned DMA transfer =

>>>>> improvements.
>>>>> I hope that these contain also the needed fix for you.
>>>>> You can apply it into jusst.de/mantis Mercurial branch.
>>>>> It modifies linux/drivers/media/dvb/mantis/mantis_dma.c only.
>>>>> I have compiled the patch against 2.6.25.9-76.fc9.x86_64.
>>>>>
>>>>> cd mantis
>>>>> patch -p1 < mantis_dma.c.aligned_dma_trs.patch
>>>>>
>>>>> Please tell us whether my patch helps you or not: if it helps, some =

>>>>> of my patch might get into jusst.de as
>>>>> a fix for your problem.
>>>>>
>>>>> Best Regards,
>>>>> Marko
>>>>
>>>>
>>>
>>> ------------------------------------------------------------------------
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
