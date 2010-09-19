Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35741 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0ISA67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 20:58:59 -0400
Received: by eyb6 with SMTP id 6so1321551eyb.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 17:58:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=HzqGW6qLxhTXprNW03LsnGjZ4Cg_PC=Wspv1A@mail.gmail.com>
References: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
	<1284677325.2056.17.camel@morgan.silverblock.net>
	<AANLkTinddFfzQtaW_gUqi18OSPn437JTFiRa1HKM8Nva@mail.gmail.com>
	<1284812434.2053.28.camel@morgan.silverblock.net>
	<AANLkTi=HzqGW6qLxhTXprNW03LsnGjZ4Cg_PC=Wspv1A@mail.gmail.com>
Date: Sat, 18 Sep 2010 20:58:57 -0400
Message-ID: <AANLkTimX0-oLk2j5YTE_WeU1SCz=k2dH6SsjP1PReyuK@mail.gmail.com>
Subject: Re: HVR 1600 Distortion
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Josh Borke <joshborke@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Sep 18, 2010 at 8:42 PM, Josh Borke <joshborke@gmail.com> wrote:
> On Sat, Sep 18, 2010 at 8:20 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Fri, 2010-09-17 at 18:23 -0400, Josh Borke wrote:
>>> Thanks for the response!  Replies are in line.
>>>
>>> On Thu, Sep 16, 2010 at 6:48 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>>> > On Wed, 2010-09-15 at 22:54 -0400, Josh Borke wrote:
>>> >> I've recently noticed some distortion coming from my hvr1600 when
>>> >> viewing analog channels.  It happens to all analog channels with some
>>> >> slightly better than others.  I am running Fedora 12 linux with kernel
>>> >> version 2.6.32.21-166.
>>> >
>>> >
>>> >> I know I need to include more information but I'm not sure what to
>>> >> include.  Any help would be appreciated.
>>> >
>>> > 1. Would you say the distortion is something you would possibly
>>> > encounter on an analog television set, or does it look "uniquely
>>> > digital"?  On systems with a long uptime and lots of usage, MPEG encoder
>>> > firmware could wind up in a screwed up state giving weird output image.
>>> > Simple solution in this case is to reboot.
>>>
>>> I'm not sure if I would classify it as "uniquely digital".  The
>>> distortion happens across most of the screen with it being
>>> concentrated in the top third.  Additionally shows that include black
>>> bars the top black bar is seemingly stretched and the image seems like
>>> the colors are over-saturated where they colors are brighter.
>>> Rebooting had no effect :(
>>
>> OK.
>>
>>> > 2. Have you ensured your cable plant isn't affecting signal integrity?
>>> > http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
>>>
>>> The cable plant hasn't changed the signal strength or integrity as far
>>> as I know.
>>
>> OK.  Keep it in the back of your mind though.
>>
>>> > 3. Does this happen with only the RF tuner or only CVBS or only SVideo
>>> > or more than one of them?  If the problem is only with RF, then it could
>>> > be an incoming signal distortion problem.  Do you have cable or an over
>>> > the air antenna for analog RF?
>>>
>>> I only have input for the RF tuner.  I have cable for analog RF.
>>
>> Please try and test the output of a VCR or DVD play plugged into the
>> HVR-1600.  (We don't need sound, just the video.)
>>
>> This will tell us if the problem happens before the CX23418 chip's
>> analog front end (i.e. in the RF and analog tuner) or not.
>>
>>
>> $ v4l2-ctl -d /dev/video0 -n
>> (List of possible inputs displayed)
>>
>> $ v4l2-ctl -d /dev/video0 -i 2
>> Video input set to 2 (Composite 1)
>>
>> # v4l2-ctl -d /dev/video0 -s ntsc-m
>> Standard set to 00001000
>>
>> $ cat /dev/video0 > foo.mpg
>> ^C
>>
>
> I only have S-Video but doing this produced a perfect picture.

Before debugging any further, it might make sense to install the tuner
into a Windows box and make sure it's not just a hardware failure in
the can tuner.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
