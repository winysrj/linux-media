Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:54711 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaIYSR4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 14:17:56 -0400
Date: Thu, 25 Sep 2014 20:17:47 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140925181747.GA21522@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
 <20140925160134.GA6207@linuxtv.org>
 <5424539D.8090503@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5424539D.8090503@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 25, 2014 at 11:40:45AM -0600, Shuah Khan wrote:
> 
> Right. I introduced DVB_FE_DEVICE_RESUME code to resume
> problems in drx39xxj driver. Because I had to make it not
> toggle power on the fe for resume. In other words, for it
> to differentiate between disconnect and resume conditions.
> 
> dvb_frontend_resume() is used by dvb_usbv2 dvb_usb_core -
> dvb_usbv2_resume_common()
> 
> Calling dvb_frontend_reinitialise() from dvb_frontend_resume()
> could break dvb_usbv2 drivers because it has handling for
> reset_resume in its core in dvb_usbv2_reset_resume()

Needs testing...

> reverting media: em28xx - remove reset_resume interface
> might be a short-term solution. I think the longterm
> solution is adding a dvb_frontend_reset_resume() that
> does dvb_frontend_reinitialise() just like you suggested.
> 
> In addition, em28xx will call dvb_frontend_reset_resume()
> from its reset_resume
> 
> What do you think?

The dvb_frontend_resume() is also too risky for short term
fix, but I think it does the right thing.  Let's sleep over
it a few nights.

For short term I think there is no way around the
b89193e0b06f revert.  You don't want a kernel with
hang-after-resume bugs to hit major distributions
like Ubuntu.  For the xc5000 firmware issue I think
you should get the patches from the development
branch into 3.17 (and 3.16-stable).  If you have the
patches ready, tell me and I'll test.


Thanks,
Johannes
