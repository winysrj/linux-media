Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37741 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaIYSBP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 14:01:15 -0400
Message-ID: <54245869.8030502@osg.samsung.com>
Date: Thu, 25 Sep 2014 12:01:13 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <20140925125353.GA5129@linuxtv.org> <54241C81.60301@osg.samsung.com> <20140925160134.GA6207@linuxtv.org> <20140925173613.GA12900@linuxtv.org>
In-Reply-To: <20140925173613.GA12900@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On 09/25/2014 11:36 AM, Johannes Stezenbach wrote:
> On Thu, Sep 25, 2014 at 06:01:34PM +0200, Johannes Stezenbach wrote:

> FWIW, there are six other xc5000 patches in the queue:
> 
> http://git.linuxtv.org/cgit.cgi/media_tree.git/log/drivers/media/tuners/xc5000.c?h=devel-3.17-rc6
> 
> I'm assuming this is the development branch for the 3.18 merge window,
> so the question is how will the issue be fixed in 3.17 and 3.16-stable?
> If you have patches I'm ready to test.
> 
> FWIW, I tried v3.17-rc6-247-g005f800 with only my suggested
> dvb_frontend_resume() change, it breaks in another place after
> resume and then still hangs.  I think the b89193e0b06f revert is needed to 
> fix the hang.  If you care, the dmesg after resume:

Our messages crossed looks like. Yes this problem needs
to be fixed in stable. Reverting b89193e0b06f is definitely
an option, however I think we might see problems on other
devices. b89193e0b06f fixed problem on KWorld stick I have.

Mauro said b89193e0b06f is causing problems on some
USB ehci/xhci drivers.

Let's go ahead and revert it for now. I will work on
getting this reset_resume sorted out with the solution
I proposed in my previous email. I hope it is okay to
take you up un your offer to test.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
