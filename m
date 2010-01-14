Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48174 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0ANKQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:16:48 -0500
Received: by fxm25 with SMTP id 25so308919fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <846899811001140206h6c903418rfdd80f23d26a3bee@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
	 <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
	 <846899811001140206h6c903418rfdd80f23d26a3bee@mail.gmail.com>
Date: Thu, 14 Jan 2010 14:16:45 +0400
Message-ID: <1a297b361001140216n15ac8e5dg1cf4253445b4971@mail.gmail.com>
Subject: Re: About driver architecture
From: Manu Abraham <abraham.manu@gmail.com>
To: HoP <jpetrous@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 2:06 PM, HoP <jpetrous@gmail.com> wrote:
> Hi Manu,
>
> 2010/1/14 Manu Abraham <abraham.manu@gmail.com>:
>> Well, the SAA716x is only the PCI Express interface. There is no video
>> capture involved in there with the STi7109. It is a full fledged DVB
>> STB SOC.
>>
>> OSD is handled by the STi7109 on that STB.
>> http://www.st.com/stonline/products/literature/bd/11660/sti7109.pdf
>>
>> Though it is not complete, that driver, it still does handle it,
>> through the firmware interface. These are the kind of devices that you
>> find on a DVB STB, i must say.
>>
>> On a DVB STB, what happens is that you load a vendor specific firmware
>> on the SOC. The SOC is just issued the firmware commands, that's how a
>> STB works in principle. A DVB STB can be considered to have 2 outputs,
>> ie if you use it as a PC card, you can output the whole thing to your
>> PC monitor, or output it to a TV set. But in the case of the STB, you
>> have a TV output alone.
>>
>
> I never know about use of stb7109 in any PCI card. It is surprise
> to me. Interesting what firmware is loaded to stb7109. Is it STM's
> proprietary os21 or even linux?


I don't know what is loaded exactly, right now. It is something
proprietary from Technotrend.

I guess it could be OS21 at the moment, couldn't be WinCE. Although
this could change any time, as we can load Linux also on it some time
in the future ;-)

The card is a Technotrend TT S2-6400 Premium Full Fledged card, with a
STi7109, STV0900 Dual DVB-S2 demodulator, HDMI outputs, SPDIF etc. The
STi7109 SOC being so large and with so many features, it's a shame to
call it a card, maybe it should be called a STB or a PC.  A neat and
well built device though, even though the hardware is very much in
it's initial stages.

Regards,
Manu
