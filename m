Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57029 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZIPPmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 11:42:46 -0400
Received: by bwz19 with SMTP id 19so3586798bwz.37
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2009 08:42:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB0E373.3080307@yahoo.it>
References: <4AAB74BC.9050508@pragl.cz>
	 <829197380909120633o8b9e0e2i2b1295cc054afc14@mail.gmail.com>
	 <4AB0E373.3080307@yahoo.it>
Date: Wed, 16 Sep 2009 11:42:49 -0400
Message-ID: <829197380909160842j4cc1e8ebtb14491e5d421019@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle 320e (em28xx/xc2028): scan finds just first
	channel
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: SebaX75 <sebax75@yahoo.it>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 16, 2009 at 9:09 AM, SebaX75 <sebax75@yahoo.it> wrote:
> On 12/09/2009 15:33, Devin Heitmueller has wrote:
>>
>> On Sat, Sep 12, 2009 at 6:15 AM, Miroslav Pragl - mailing lists
>> <lists.subscriber@pragl.cz>  wrote:
>>>
>>> Hello,
>>> I've compiled and installed latest v4l-dvb and dvb-apps, extracted xceive
>>> firmware, so far so good. Distro is Fedora 11, x64
>>> (2.6.30.5-43.fc11.x86_64)
>>>
>>> Unfortunately scan finds only the first channel:
>>
>> <snip>
>>
>> Hello Miroslav,
>>
>> Are you absolutely sure you installed the latest code, including "make
>> unload" to unload the currently running modules?  I fixed this exact
>> regression back in June, so I would be extremely surprised if you are
>> really seeing this in the latest code.
>>
>> I would suggest using the following commands, and then reboot:
>>
>> <unplug device>
>> hg clone http://linuxtv.org/hg/v4l-dvb
>> cd v4l-dvb
>> make&&  make install&&  make unload
>> reboot
>> <plug in device>
>>
>> Then see if it still happens.
>>
>> Cheers,
>>
>> Devin
>>
>
> Hi Devin,
> I'm the person that has joined yesterday night on IRC channel to talk with
> you about this post.
>
> During July, I've already talked with you about a problem
> (http://www.mail-archive.com/linux-media@vger.kernel.org/msg07728.html), but
> I was new and not very able to do debug and explain the problem with good
> test case.
> After two months of tests and 3 adapters used (Hauppauge Nova-T, a china
> generic Intel CE9500B1 and Pinnable Hybrid Stick 320E EEPROM-ID=0x9567eb1a,
> EEPROM-hash=0xb8846b20 - only this one don't work), I've more information
> for you.
>
> My configuration is very similar to Miroslav, Fedora 11 with kernel
> 2.6.30.5-43.fc11.i686.PAE; v4l-dvb tree downloaded yesterday (15/09/2009)
> and I use scandvb to scan the channels. I've tryed your repository too,
> em28xx-vbi3, but it seems the same. The driver compile without problem, the
> system is rebooted every time I recompile it, modules are inserted without
> options and dmesg doesn't show any errors (http://pastebin.com/f340bf982).
>
> Now the problem, very similar to Miroslav if MUX transmit only one channel;
> during tuning, the DVB-T stop on first MUX tuned and all MUX found after
> this one are not tuned and channels are not recognized.
> During tests, I've seen that if I change the MUX order in input file for
> scandvb, I can get channels list tuned from first MUX... after more tuning
> sessions to compile the list, the problem persist during normal view of
> transmission...
>
> If you need more info ask to me, I'll be very happy to help you; if for you
> is useful, I've saved a tuning session with usbsnoop from windows and I've
> not done this for linux, but if you need it I can do (I need some time to do
> this because I don't know where to start).
>
> Thanks for your support,
> Sebastian
>

Hello Sebastian,

Please do the following:

unplug the device
reboot
modprobe tuner-xc2028 debug=1
plug in the device
Make the two tuning attempts so that the failure gets logged.
Send me the full dmesg output (making sure it includes from the time
the device was connected).

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
