Return-path: <linux-media-owner@vger.kernel.org>
Received: from edernet.hu ([78.131.56.161]:42931 "EHLO mail.edernet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaKVVmV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Nov 2014 16:42:21 -0500
Message-ID: <54710310.6070806@edernet.hu>
Date: Sat, 22 Nov 2014 22:41:36 +0100
From: =?ISO-8859-2?Q?=C9der_Zsolt?= <zsolt.eder@edernet.hu>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: SAA7164 firmware for Asus MyCinema
References: <546C5494.4000908@edernet.hu> <alpine.DEB.2.10.1411202148420.1388@dl160.lan>
In-Reply-To: <alpine.DEB.2.10.1411202148420.1388@dl160.lan>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

Sorry, unfortunately was not me on IRC.

So as you wrote, I followed your instructions, and I collect as 
information as I can from the board.
I made a small site quickly with some photos, you found it here:
http://myoop.hu/tuner.html

While I took the photos I found that my card is Asus MyCinema 
EHD2-100/PT/FM/AV/RC.

Can you help me how should I continue my work with this tuner?

Thank you very much in advance.

Best regards,
Zsolt

2014.11.20. 20:51 keltezéssel, Olli Salonen írta:
> On Wed, 19 Nov 2014, Éder Zsolt wrote:
>
>> Hi,
>>
>> I found at the site: 
>> http://www.linuxtv.org/wiki/index.php/ATSC_PCIe_Cards that if I have 
>> a TV-tuner card which is currently unsupported, you may help me how I 
>> can make workable this device.
>>
>> I have an Asus MyCinema EHD3-100/NAQ/FM/AV/MCE RC dual TV-Tuner card 
>> with SAA7164 chipset.
>
> Did we talk about this in IRC a couple of days ago?
>
> If not, you will need to find out which demodulator and tuner are used 
> on that card. You can find those by looking at the physical card. Read 
> the text on the bigger ICs and try to put them in the google to find 
> out the components used. The tuner might be under metal shielding, in 
> which case it might be a bit more tricky to find out.
>
> Looking at the files in the Windows driver package might give you some 
> hints as well.
>
> Cheers,
> -olli

