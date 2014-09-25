Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37674 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaIYNpq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 09:45:46 -0400
Message-ID: <54241C81.60301@osg.samsung.com>
Date: Thu, 25 Sep 2014 07:45:37 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>,
	Shuah Khan <shuah.kh@samsung.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org>
In-Reply-To: <20140925125353.GA5129@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
> Hi Shuah,
> 
> ever since your patchset which implements suspend/resume
> for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
> In v3.15.y and v3.16.y it throws a request_firmware warning
> during hibernate + resume, and the /dev/dvb/ device nodes disappears after
> resume.  In current git v3.17-rc6-247-g005f800, it hangs
> after resume.  I bisected the hang in qemu to
> b89193e0b06f "media: em28xx - remove reset_resume interface",
> the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.
> 
> Regarding the request_firmware issue. I think a possible
> fix would be:

The request_firmware has been fixed. I ran into this on
Hauppauge WinTV HVR 950Q device. The fix is in xc5000
driver to not release firmware as soon as it loads.
With this fix firmware is cached and available in
resume path.

These patches are pulled into linux-media git couple
of days ago.

http://patchwork.linuxtv.org/patch/26073/
http://patchwork.linuxtv.org/patch/25345/

The reset_resume and this request firmware problem
might be related. Could you please try with the
above two patches and see if the problems goes away.
i.e without reverting

b89193e0b06f "media: em28xx - remove reset_resume interface"

Please let me know even if it works. If it doesn't could
you please send me full dmesg. I am curious if usb bus
is reset i.e looses power during hibernate. If it does,
it has to go through disconnect sequence. The reason
I removed the reset_resume is because it is a simple
resume routine that can't handle power loss to the bus.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
