Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52915 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaKWHyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 02:54:11 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so2929120wiw.9
        for <linux-media@vger.kernel.org>; Sat, 22 Nov 2014 23:54:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54710310.6070806@edernet.hu>
References: <546C5494.4000908@edernet.hu>
	<alpine.DEB.2.10.1411202148420.1388@dl160.lan>
	<54710310.6070806@edernet.hu>
Date: Sun, 23 Nov 2014 09:54:10 +0200
Message-ID: <CAAZRmGz03-BTEzKP815LtxNb+AxMThHw3o6F5gHP80oeQyC8vw@mail.gmail.com>
Subject: Re: SAA7164 firmware for Asus MyCinema
From: Olli Salonen <olli.salonen@iki.fi>
To: =?UTF-8?Q?=C3=89der_Zsolt?= <zsolt.eder@edernet.hu>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zsolt,

In order to support a card in Linux in general, there needs to be a
driver for the PCIe bridge, the demodulator and the tuner. Then these
building blocks must be put together in a way that makes sense.

You've already identified the PCIe bridge (NXP SAA7164), the
demodulator (TDA 10046) and the tuner (Taifun 6034T aka Infineon
TUA6034). Now here comes the bad news - even if the PCIe bridge and
the demod are supported by existing drivers, the TUA6034 is not
supported by currently. You would need to write or get someone to
write a driver for the TUA6034. In order for this to be possible you'd
need to get the specifications from the manufacturer (often not
possible, but worth trying) or reverse-engineer the Windows driver
(often quite tricky, especially since taking a trace from a PCIe
device can be a lot of work).

Might I suggest that you add also a wiki page in the LinuxTV wiki if
you're anyway looking at this? Basically you can document the same
things you've very well documented on your website there, but please
use the template that the other devices on the site are more or less
using. http://www.linuxtv.org/wiki/index.php/ASUS is a good starting
point. Even if the conclusion is that the card will not work your
research might save someone else time in the future.

Cheers,
-olli


On 22 November 2014 at 23:41, Éder Zsolt <zsolt.eder@edernet.hu> wrote:
> Hi Olli,
>
> Sorry, unfortunately was not me on IRC.
>
> So as you wrote, I followed your instructions, and I collect as information
> as I can from the board.
> I made a small site quickly with some photos, you found it here:
> http://myoop.hu/tuner.html
>
> While I took the photos I found that my card is Asus MyCinema
> EHD2-100/PT/FM/AV/RC.
>
> Can you help me how should I continue my work with this tuner?
>
> Thank you very much in advance.
>
> Best regards,
> Zsolt
>
> 2014.11.20. 20:51 keltezéssel, Olli Salonen írta:
>>
>> On Wed, 19 Nov 2014, Éder Zsolt wrote:
>>
>>> Hi,
>>>
>>> I found at the site:
>>> http://www.linuxtv.org/wiki/index.php/ATSC_PCIe_Cards that if I have a
>>> TV-tuner card which is currently unsupported, you may help me how I can make
>>> workable this device.
>>>
>>> I have an Asus MyCinema EHD3-100/NAQ/FM/AV/MCE RC dual TV-Tuner card with
>>> SAA7164 chipset.
>>
>>
>> Did we talk about this in IRC a couple of days ago?
>>
>> If not, you will need to find out which demodulator and tuner are used on
>> that card. You can find those by looking at the physical card. Read the text
>> on the bigger ICs and try to put them in the google to find out the
>> components used. The tuner might be under metal shielding, in which case it
>> might be a bit more tricky to find out.
>>
>> Looking at the files in the Windows driver package might give you some
>> hints as well.
>>
>> Cheers,
>> -olli
>
>
