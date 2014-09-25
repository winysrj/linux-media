Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37752 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaIYSp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 14:45:26 -0400
Message-ID: <542462C4.7020907@osg.samsung.com>
Date: Thu, 25 Sep 2014 12:45:24 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com> <20140925160134.GA6207@linuxtv.org> <5424539D.8090503@osg.samsung.com> <20140925181747.GA21522@linuxtv.org>
In-Reply-To: <20140925181747.GA21522@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2014 12:17 PM, Johannes Stezenbach wrote:
> On Thu, Sep 25, 2014 at 11:40:45AM -0600, Shuah Khan wrote:
>>
>> Right. I introduced DVB_FE_DEVICE_RESUME code to resume
>> problems in drx39xxj driver. Because I had to make it not
>> toggle power on the fe for resume. In other words, for it
>> to differentiate between disconnect and resume conditions.
>>
>> dvb_frontend_resume() is used by dvb_usbv2 dvb_usb_core -
>> dvb_usbv2_resume_common()
>>
>> Calling dvb_frontend_reinitialise() from dvb_frontend_resume()
>> could break dvb_usbv2 drivers because it has handling for
>> reset_resume in its core in dvb_usbv2_reset_resume()
> 
> Needs testing...

Right

> 
>> reverting media: em28xx - remove reset_resume interface
>> might be a short-term solution. I think the longterm
>> solution is adding a dvb_frontend_reset_resume() that
>> does dvb_frontend_reinitialise() just like you suggested.
>>
>> In addition, em28xx will call dvb_frontend_reset_resume()
>> from its reset_resume
>>
>> What do you think?
> 
> The dvb_frontend_resume() is also too risky for short term
> fix, but I think it does the right thing.  Let's sleep over
> it a few nights.

Good plan.

> 
> For short term I think there is no way around the
> b89193e0b06f revert.  You don't want a kernel with
> hang-after-resume bugs to hit major distributions
> like Ubuntu.  For the xc5000 firmware issue I think
> you should get the patches from the development
> branch into 3.17 (and 3.16-stable).  If you have the
> patches ready, tell me and I'll test.
> 

Revert is good. Just checked 3.16 and we are good
on that. It needs to be reverted from 3.17 for sure.

ok now I know why the second path didn't
apply. It depends on another change that added resume
function

7ab1c07614b984778a808dc22f84b682fedefea1

You don't need the second patch. The first patch applied
to 3.17 and fails on 3.16

http://patchwork.linuxtv.org/patch/26073/

I am working on 3.16 back-port for the first one to 3.16
and send one shortly for you to test.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
