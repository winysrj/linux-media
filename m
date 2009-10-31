Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:45408 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbZJaXEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:04:32 -0400
Received: by pzk26 with SMTP id 26so2565216pzk.4
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 16:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303a8ee30910311546x41f919fey9e6acfbd161c0de8@mail.gmail.com>
References: <4ADED23C.2080002@uq.edu.au>
	 <303a8ee30910211233r111d3378vedc1672f68728717@mail.gmail.com>
	 <1257002647.3333.7.camel@pc07.localdom.local>
	 <303a8ee30910310948o107387c5g2d89665ea2bcde7e@mail.gmail.com>
	 <ef52a95d0910311508v644e998bke9e7955aa32d5da6@mail.gmail.com>
	 <303a8ee30910311543h178879d2wf79fd0045b8e6eb@mail.gmail.com>
	 <303a8ee30910311546x41f919fey9e6acfbd161c0de8@mail.gmail.com>
Date: Sun, 1 Nov 2009 10:04:37 +1100
Message-ID: <ef52a95d0910311604w5c696aean73e19af06014dee1@mail.gmail.com>
Subject: Re: Leadtek DTV-1000S
From: Michael Obst <m.obst@ugrad.unimelb.edu.au>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This problem is reproducible and occurs the same from a cold boot or
inserting saa7134. Analog tv has never worked on this card, I was
under the impression there was no analog tuner on the card (looking at
http://www.leadtek.com/eng/tv_tuner/image/digital_tv.pdf). The info
was simply from doing a modprobe on saa7134. The only lines in the
dmesg that were different from the old driver was

saa7130[0]/alsa: Leadtek Winfast DTV1000S doesn't support digital audio

So I guess the analog part has always failed

I am using the nvidia driver and a driver for my wireless card, I will
turn these off and see if I can get a different result.

During tuning for digital tv with the old driver I got

[ 1081.808505] tda18271: performing RF tracking filter calibration
[ 1086.152006] tda18271: RF tracking filter calibration complete
[ 1091.020535] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.


The final line did not appear when I tried to tune using the new version

[ 1225.904503] tda18271: performing RF tracking filter calibration
[ 1230.272003] tda18271: RF tracking filter calibration complete


Thanks
Michael Obst

2009/11/1 Michael Krufky <mkrufky@kernellabs.com>:
> On Sat, Oct 31, 2009 at 6:43 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>> On Sat, Oct 31, 2009 at 6:08 PM, Michael Obst
>> <m.obst@ugrad.unimelb.edu.au> wrote:
>>> Hi,
>>>    Thanks for fixing this, I can confirm that it now compiles and
>>> inserts and the remote works, so does the av input to the tvcard
>>> however the card does not seem to be able to tune any channels, I have
>>> checked the old driver and that is still able to tune in channels. The
>>> output from my dmesg is below.
>>>
>>> Thanks
>>> Michael Obst
>>
>> Michael,
>>
>> This is an interesting problem -- the part of your dmesg that stands
>> out to me is this:
>>
>>> [  502.928544] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
>>> [  502.960501] tda8290: no gate control were provided!
>>
>> That error message was added as a safety measure -- it shouldn't be
>> possible to ever hit that code path.  Are you running any non-GPL
>> binary drivers on your system, such as NVIDIA or anything else?
>>
>> Let me explain:
>>
>> The "no gate control were provided!" message was added by Mauro to the
>> tda8290 driver, mainly as a check to ensure that we don't call a null
>> function pointer.  The gate control is actually provided by the
>> tda8290 driver itself, by either tda8290_i2c_bridge or
>> tda8295_i2c_bridge, depending on which hardware is present.  In your
>> case, it's a tda8290.
>>
>> The function pointer is filled during the tda829x_attach() function,
>> before we call the tda829x_find_tuner function, where this error
>> message is displayed.  The only way for this to have occurred, as far
>> as I can tell,  is if the probe to detect the tda8290 itself had
>> failed.
>>
>> Have you repeated your test with the same problem each time, or did
>> this only happen once?
>>
>> Can you try again, from a cold reboot?
>>
>> Also, I'm just assuming that this failure occurred during a digital
>> tune -- is that correct?  Does analog television work?
>>
>> If the problem is reproducible, can you also show us dmesg during a failed tune?
>>
>> I'm very interested in hearing more about this -- please let me know.
>
> Oops, on second look, seems that the error occurred during analog
> bring-up ... does digital tv work?
>
> -Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
