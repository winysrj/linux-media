Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:38309 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZKAG1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 01:27:44 -0500
Received: by qyk4 with SMTP id 4so2123523qyk.33
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 23:27:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303a8ee30910311617v586db724wdafe1c94ef508a17@mail.gmail.com>
References: <4ADED23C.2080002@uq.edu.au>
	 <303a8ee30910211233r111d3378vedc1672f68728717@mail.gmail.com>
	 <1257002647.3333.7.camel@pc07.localdom.local>
	 <303a8ee30910310948o107387c5g2d89665ea2bcde7e@mail.gmail.com>
	 <ef52a95d0910311508v644e998bke9e7955aa32d5da6@mail.gmail.com>
	 <303a8ee30910311543h178879d2wf79fd0045b8e6eb@mail.gmail.com>
	 <303a8ee30910311546x41f919fey9e6acfbd161c0de8@mail.gmail.com>
	 <ef52a95d0910311604w5c696aean73e19af06014dee1@mail.gmail.com>
	 <303a8ee30910311617v586db724wdafe1c94ef508a17@mail.gmail.com>
Date: Sun, 1 Nov 2009 02:27:49 -0400
Message-ID: <303a8ee30910312327v1a1d98d9xa29f6723a47b6b58@mail.gmail.com>
Subject: Re: Leadtek DTV-1000S
From: Michael Krufky <mkrufky@kernellabs.com>
To: Michael Obst <m.obst@ugrad.unimelb.edu.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 7:17 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>> 2009/11/1 Michael Krufky <mkrufky@kernellabs.com>:
>>> On Sat, Oct 31, 2009 at 6:43 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>>>> On Sat, Oct 31, 2009 at 6:08 PM, Michael Obst
>>>> <m.obst@ugrad.unimelb.edu.au> wrote:
>>>>> Hi,
>>>>>    Thanks for fixing this, I can confirm that it now compiles and
>>>>> inserts and the remote works, so does the av input to the tvcard
>>>>> however the card does not seem to be able to tune any channels, I have
>>>>> checked the old driver and that is still able to tune in channels. The
>>>>> output from my dmesg is below.
>>>>>
>>>>> Thanks
>>>>> Michael Obst
>>>>
>>>> Michael,
>>>>
>>>> This is an interesting problem -- the part of your dmesg that stands
>>>> out to me is this:
>>>>
>>>>> [  502.928544] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
>>>>> [  502.960501] tda8290: no gate control were provided!
>>>>
>>>> That error message was added as a safety measure -- it shouldn't be
>>>> possible to ever hit that code path.  Are you running any non-GPL
>>>> binary drivers on your system, such as NVIDIA or anything else?
>>>>
>>>> Let me explain:
>>>>
>>>> The "no gate control were provided!" message was added by Mauro to the
>>>> tda8290 driver, mainly as a check to ensure that we don't call a null
>>>> function pointer.  The gate control is actually provided by the
>>>> tda8290 driver itself, by either tda8290_i2c_bridge or
>>>> tda8295_i2c_bridge, depending on which hardware is present.  In your
>>>> case, it's a tda8290.
>>>>
>>>> The function pointer is filled during the tda829x_attach() function,
>>>> before we call the tda829x_find_tuner function, where this error
>>>> message is displayed.  The only way for this to have occurred, as far
>>>> as I can tell,  is if the probe to detect the tda8290 itself had
>>>> failed.
>>>>
>>>> Have you repeated your test with the same problem each time, or did
>>>> this only happen once?
>>>>
>>>> Can you try again, from a cold reboot?
>>>>
>>>> Also, I'm just assuming that this failure occurred during a digital
>>>> tune -- is that correct?  Does analog television work?
>>>>
>>>> If the problem is reproducible, can you also show us dmesg during a failed tune?
>>>>
>>>> I'm very interested in hearing more about this -- please let me know.
>>>
>>> Oops, on second look, seems that the error occurred during analog
>>> bring-up ... does digital tv work?
>>>
>>> -Mike
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
> On Sat, Oct 31, 2009 at 7:04 PM, Michael Obst
> <m.obst@ugrad.unimelb.edu.au> wrote:
>> This problem is reproducible and occurs the same from a cold boot or
>> inserting saa7134. Analog tv has never worked on this card, I was
>> under the impression there was no analog tuner on the card (looking at
>> http://www.leadtek.com/eng/tv_tuner/image/digital_tv.pdf). The info
>> was simply from doing a modprobe on saa7134. The only lines in the
>> dmesg that were different from the old driver was
>>
>> saa7130[0]/alsa: Leadtek Winfast DTV1000S doesn't support digital audio
>>
>> So I guess the analog part has always failed
>>
>> I am using the nvidia driver and a driver for my wireless card, I will
>> turn these off and see if I can get a different result.
>>
>> During tuning for digital tv with the old driver I got
>>
>> [ 1081.808505] tda18271: performing RF tracking filter calibration
>> [ 1086.152006] tda18271: RF tracking filter calibration complete
>> [ 1091.020535] hda-intel: IRQ timing workaround is activated for card
>> #0. Suggest a bigger bdl_pos_adj.
>>
>>
>> The final line did not appear when I tried to tune using the new version
>>
>> [ 1225.904503] tda18271: performing RF tracking filter calibration
>> [ 1230.272003] tda18271: RF tracking filter calibration complete
>
> Michael,
>
> The policy on this mailing list is to reply BELOW the quoted text.
> Please keep this in mind for the future.
>
> I didn't realize the board had a saa7130 chipset -- That explains a
> lot.  This means that there actually is no tda8290 on the board.  (the
> tda8290 is usually found inside the saa7131 chipset)
>
> You can remove the line, TUNER_PHILIPS_TDA8290 from the card
> definition in saa7134-cards.c -- replace it with TUNER_ABSENT.
>
> That shouldn't fix the problem, but it would be interesting to hear if
> it changes anything.  I see that communication with the tuner is
> working properly...  It's taking 5 seconds to complete the rf tracking
> filter calibration in either case, so we know that the line of
> communication to the tuner itself isn't a problem.
>
> I think this will be easier if we meet in irc.  Can you meed me in
> #linuxtv on irc.freenode.net?
>
> If not, please enable module option debug=1 to tda18271 and send back
> full dmesg, unedited, including startup of the device and a tune
> attempt.
>
> Also, enable debug=1 for the tda10048 module -- maybe something
> changed there.  I just tested this code with my ATSC saa7134 board
> that uses the tda18271, and it's working fine, so I doubt it's the
> tuner persay, but we should investigate anyway.
>
> -Mike
>

For any interested readers, Michael did some testing and helped me to
find the cause of the problem... Turns out one of my recent tda18271
changesets broke the std_map override functionality of the tda18271
driver -- I already pushed up a fix and requested merge to the master
branch.

For those that want their dtv1000s board working with the latest code,
use the following tree:

http://kernellabs.com/hg/~mkrufky/dtv1000s-fix

I will delete the tree once the fix is merged into the v4l-dvb master branch.

-Mike
