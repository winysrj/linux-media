Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37697 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaIYPHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 11:07:50 -0400
Message-ID: <54242FC3.7090801@osg.samsung.com>
Date: Thu, 25 Sep 2014 09:07:47 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Johannes Stezenbach <js@linuxtv.org>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com> <20140925111046.1bb1b2d9.m.chehab@samsung.com>
In-Reply-To: <20140925111046.1bb1b2d9.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2014 08:10 AM, Mauro Carvalho Chehab wrote:
> Hi Johannes and Shuah,
> 
> Em Thu, 25 Sep 2014 07:45:37 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Hi Johannes,
>>
>> On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
>>> Hi Shuah,
>>>
>>> ever since your patchset which implements suspend/resume
>>> for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
>>> In v3.15.y and v3.16.y it throws a request_firmware warning
>>> during hibernate + resume, and the /dev/dvb/ device nodes disappears after
>>> resume.  In current git v3.17-rc6-247-g005f800, it hangs
>>> after resume.  I bisected the hang in qemu to
>>> b89193e0b06f "media: em28xx - remove reset_resume interface",
>>> the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.
> 
> Yes, that patch is very likely wrong. I talked with some PM
> maintainers with experience at the USB core: basically, some drivers
> call reset_resume, while others call resume. So, drivers need to
> implement both callbacks in order to be properly resumed.
> 
>>>
>>> Regarding the request_firmware issue. I think a possible
>>> fix would be:
>>
>> The request_firmware has been fixed. I ran into this on
>> Hauppauge WinTV HVR 950Q device. The fix is in xc5000
>> driver to not release firmware as soon as it loads.
>> With this fix firmware is cached and available in
>> resume path.
>>
>> These patches are pulled into linux-media git couple
>> of days ago.
>>
>> http://patchwork.linuxtv.org/patch/26073/
>> http://patchwork.linuxtv.org/patch/25345/
>>
>> The reset_resume and this request firmware problem
>> might be related. Could you please try with the
>> above two patches and see if the problems goes away.
>> i.e without reverting
>>
>> b89193e0b06f "media: em28xx - remove reset_resume interface"
> 
> This patch should be reverted anyway, as it is breaking resume
> for some USB ehci/xhci drivers.
> 

Simply reverting this patch probably won't fix the problems.
You are right, we need resume() and reset_resume() interfaces.
After revert, reset_resume() will be resume() and this will
work on systems that maintain current to usb bus during suspend.
However, I think having the same code handling both cases will
fail on systems that don't maintain power to usb bus. i.e
when the bus goes through reset, driver has to do more than a
simple resume.

Coupled with that there are drivers like xc5000 that release
firmware right after load which are a problem for resume
because they wait for firmware to be available. So these drivers
need to be fixed to cache firmware.

So the right fix would be to reset_resume() handle the reset
case. This is one of the reasons why I am interested finding
if these two patches help fix the entire problem.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
