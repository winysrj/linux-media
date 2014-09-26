Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37896 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbaIZPWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 11:22:55 -0400
Message-ID: <542584CD.6060507@osg.samsung.com>
Date: Fri, 26 Sep 2014 09:22:53 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140926080824.GA8382@linuxtv.org> <20140926071411.61a011bd@recife.lan> <20140926110727.GA880@linuxtv.org> <20140926084215.772adce9@recife.lan> <20140926090316.5ae56d93@recife.lan> <20140926122721.GA11597@linuxtv.org> <20140926101222.778ebcaf@recife.lan> <20140926132513.GA30084@linuxtv.org> <20140926142543.GA3806@linuxtv.org> <54257888.90802@osg.samsung.com> <20140926150602.GA15766@linuxtv.org>
In-Reply-To: <20140926150602.GA15766@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2014 09:06 AM, Johannes Stezenbach wrote:
> On Fri, Sep 26, 2014 at 08:30:32AM -0600, Shuah Khan wrote:
>> On 09/26/2014 08:25 AM, Johannes Stezenbach wrote:
>>>
>>> So, what is happening is that the em28xx driver still async initializes
>>> while the initramfs already has started resume.  Thus the rootfs in not
>>> mounted and the firmware is not loadable.  Maybe this is only an issue
>>> of my qemu test because I compiled a non-modular kernel but don't have
>>> the firmware in the initramfs for testing simplicity?
>>>
>>>
>>
>> Right. We have an issue when media drivers are compiled static
>> (non-modular). I have been debugging that problem for a while.
>> We have to separate the two cases - if you are compiling em28xx
>> as static then you will run into the issue.
> 
> So I compiled em28xx as modules and installed them in my qemu image.
> One issue solved, but it still breaks after resume:
> 
> [   20.212162] usb 1-1: reset high-speed USB device number 2 using ehci-pci
> [   20.503868] em2884 #0: Resuming extensions
> [   20.505275] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
> [   20.533513] drxk: status = 0x439130d9
> [   20.534282] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> [   23.008852] em2884 #0: writing to i2c device at 0x52 failed (error=-5)
> [   23.011408] drxk: i2c write error at addr 0x29
> [   23.013187] drxk: write_block: i2c write error at addr 0x8303b4
> [   23.015440] drxk: Error -5 while loading firmware
> [   23.017291] drxk: Error -5 on init_drxk
> [   23.018835] em2884 #0: fe0 resume 0
> 
> Any idea on this?
> 

Looks like this is what's happening:
during suspend:

drxk_sleep() gets called and marks state->m_drxk_state == DRXK_UNINITIALIZED

init_drxk() does download_microcode() and this step fails
because the conditions in which init_drxk() gets called
from drxk_attach() are different.

i2c isn't ready.

Is it possible for you to test this without power loss
on usb assuming this test run usb bus looses power?

If you could do the following tests and see if there is
a difference:

echo mem > /sys/power/state
vs
echo disk > /sys/power/state

If it is possible, with and without reset_resume hook.
Sorry, I wish I have the hardware :(

I am looking to order it now and see if I get it early
next week at the latest.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
