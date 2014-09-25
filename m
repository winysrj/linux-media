Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10640 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaIYOKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 10:10:53 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NCG007AJNE33380@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Sep 2014 10:10:51 -0400 (EDT)
Date: Thu, 25 Sep 2014 11:10:46 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-id: <20140925111046.1bb1b2d9.m.chehab@samsung.com>
In-reply-to: <54241C81.60301@osg.samsung.com>
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes and Shuah,

Em Thu, 25 Sep 2014 07:45:37 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Hi Johannes,
> 
> On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
> > Hi Shuah,
> > 
> > ever since your patchset which implements suspend/resume
> > for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
> > In v3.15.y and v3.16.y it throws a request_firmware warning
> > during hibernate + resume, and the /dev/dvb/ device nodes disappears after
> > resume.  In current git v3.17-rc6-247-g005f800, it hangs
> > after resume.  I bisected the hang in qemu to
> > b89193e0b06f "media: em28xx - remove reset_resume interface",
> > the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.

Yes, that patch is very likely wrong. I talked with some PM
maintainers with experience at the USB core: basically, some drivers
call reset_resume, while others call resume. So, drivers need to
implement both callbacks in order to be properly resumed.

> > 
> > Regarding the request_firmware issue. I think a possible
> > fix would be:
> 
> The request_firmware has been fixed. I ran into this on
> Hauppauge WinTV HVR 950Q device. The fix is in xc5000
> driver to not release firmware as soon as it loads.
> With this fix firmware is cached and available in
> resume path.
> 
> These patches are pulled into linux-media git couple
> of days ago.
> 
> http://patchwork.linuxtv.org/patch/26073/
> http://patchwork.linuxtv.org/patch/25345/
> 
> The reset_resume and this request firmware problem
> might be related. Could you please try with the
> above two patches and see if the problems goes away.
> i.e without reverting
> 
> b89193e0b06f "media: em28xx - remove reset_resume interface"

This patch should be reverted anyway, as it is breaking resume
for some USB ehci/xhci drivers.

> 
> Please let me know even if it works. If it doesn't could
> you please send me full dmesg. I am curious if usb bus
> is reset i.e looses power during hibernate. If it does,
> it has to go through disconnect sequence. The reason
> I removed the reset_resume is because it is a simple
> resume routine that can't handle power loss to the bus.
> 
> thanks,
> -- Shuah
> 
> 
