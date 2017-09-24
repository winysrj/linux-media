Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:54193 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750799AbdIXJmJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 05:42:09 -0400
Subject: Re: f26: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS PLUS
 TV"
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
 <20170924090417.GA24153@ubuntu.windy>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <bef36e1c-84e7-7f64-49d2-bc80a437866d@eyal.emu.id.au>
Date: Sun, 24 Sep 2017 19:42:07 +1000
MIME-Version: 1.0
In-Reply-To: <20170924090417.GA24153@ubuntu.windy>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for writing Vince,

On 24/09/17 19:04, Vincent McIntyre wrote:
> On Sat, Sep 23, 2017 at 10:48:34PM +1000, Eyal Lebedinsky wrote:
>> On 18/09/17 14:26, Eyal Lebedinsky wrote:
>>> I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe
>>
>> I have upgraded to f26 and this driver still fails to tune the "Leadtek Winfast DTV2000 DS PLUS TV".
>>
>>> which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
>>> but I get no channels tuned when I run mythfrontend or scandvb.
>>>
>>> Is anyone using this combination?
>>> Is this the correct way to use this tuner?
>>
>> Is this the wrong list? If so then please suggest a more suitable one.
> 
> It's the right list. The problem is nobody seems to care.

This is really sad.
Seeing so many patches on this list, I hoped there is another list more suitable
for issues that users encounter.

> I have one of these too, I was able to get it tune at one time
> but there were some problems that I never ended up running down.
> 
> I was planning to dig it out and have a play with it again.

Thanks, this may help. I also hoped to get a response from people who have this card
working on f26. Maybe it will work for you (fingers crossed).

> Just to confirm - you're building the media_build git tree on f26
> and those drivers are the ones that are not working, yes?

No, but I did try this before (on f24).

However I did build the media_build git tree two days ago (on f26) but did not
install it yet. Just to confirm, when testing on f24, after an install I find
duplicated drivers:

/lib/modules/4.11.12-100.fc24.x86_64/kernel/drivers/media/usb/dvb-usb-v2/dvb-usb-rtl28xxu.ko.xz
/lib/modules/4.11.12-100.fc24.x86_64/kernel/drivers/media/usb/dvb-usb-v2/dvb-usb-rtl28xxu.ko

The second one is from my build. I assume it has precedence over the original?

> If not, you need to try that to get any help here.

Sure, I am comfortable building from git/source.

> Have a look at https://git.linuxtv.org/media_build.git/about/
> and let me know if you need further help with that.

No worries. What I did before was simple:

	git clone git://linuxtv.org/media_build.git
	cd media_build
	make distclean
	./build
	make install

> It may be possible to get the driver into debug mode and get more
> information logged. I'm not sure this will work but give it a go.
> 
> First set up the dynamic debug filesystem (may already be there)
> # cat >> /etc/fstab
> debugfs /sys/kernel/debug debugfs defaults 0 0
> ^D
> # mount -av
> 
> Turn on debug printing for the modules of interest
> # echo 'module rtl2832 +p' > /sys/kernel/debug/dynamic_debug/control
> # echo 'module dvb_usb_rtl28xxu +p' > /sys/kernel/debug/dynamic_debug/control

This evening there are a few recordings scheduled that I do not want to risk (I am now
using a few USB tuners I had laying around) but I will try this in the morning and
report the results to the list.

> Vince

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
