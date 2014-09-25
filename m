Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37735 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbaIYRks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 13:40:48 -0400
Message-ID: <5424539D.8090503@osg.samsung.com>
Date: Thu, 25 Sep 2014 11:40:45 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com> <20140925160134.GA6207@linuxtv.org>
In-Reply-To: <20140925160134.GA6207@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2014 10:01 AM, Johannes Stezenbach wrote:
> Hi Shuah,
> 
> On Thu, Sep 25, 2014 at 07:45:37AM -0600, Shuah Khan wrote:
>> On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
>>> ever since your patchset which implements suspend/resume
>>> for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
>>> In v3.15.y and v3.16.y it throws a request_firmware warning
>>> during hibernate + resume, and the /dev/dvb/ device nodes disappears after
>>> resume.  In current git v3.17-rc6-247-g005f800, it hangs
>>> after resume.  I bisected the hang in qemu to
>>> b89193e0b06f "media: em28xx - remove reset_resume interface",
>>> the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.
>>>
>>> Regarding the request_firmware issue. I think a possible
>>> fix would be:
> 
> I think you should take a closer look at the code you snipped.
> Maybe this fixes the root of the issue you worked around
> with the DVB_FE_DEVICE_RESUME thing, namely calling
> fe->ops.tuner_ops.init from wrong context.

Sorry for aggressive snipping. :)

Right. I introduced DVB_FE_DEVICE_RESUME code to resume
problems in drx39xxj driver. Because I had to make it not
toggle power on the fe for resume. In other words, for it
to differentiate between disconnect and resume conditions.

dvb_frontend_resume() is used by dvb_usbv2 dvb_usb_core -
dvb_usbv2_resume_common()

Calling dvb_frontend_reinitialise() from dvb_frontend_resume()
could break dvb_usbv2 drivers because it has handling for
reset_resume in its core in dvb_usbv2_reset_resume()

reverting media: em28xx - remove reset_resume interface
might be a short-term solution. I think the longterm
solution is adding a dvb_frontend_reset_resume() that
does dvb_frontend_reinitialise() just like you suggested.

In addition, em28xx will call dvb_frontend_reset_resume()
from its reset_resume

What do you think?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
