Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:54054 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3GRARw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 20:17:52 -0400
Date: Wed, 17 Jul 2013 21:17:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
Cc: linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130718001752.GA2318@localhost>
References: <20130716220418.GC10973@deadlock.dhs.org>
 <20130717084428.GA2334@localhost>
 <20130717213139.GA14370@deadlock.dhs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130717213139.GA14370@deadlock.dhs.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergey,

On Wed, Jul 17, 2013 at 11:31:39PM +0200, Sergey 'Jin' Bostandzhyan wrote:
> On Wed, Jul 17, 2013 at 05:44:29AM -0300, Ezequiel Garcia wrote:
> > On Wed, Jul 17, 2013 at 12:04:18AM +0200, Sergey 'Jin' Bostandzhyan wrote:
> > > 
> > > It generally works fine, I can, for example, open the video device using VLC,
> > > select one of the inputs and get the picture.
> > > 
> > > However, programs like motion or zoneminder fail, I am not quite sure if it
> > > is something that they might be doing or if it is a problem in the driver.
> > > 
> > > Basically, for both of the above, the problem is that VIDIOC_S_INPUT fails
> > > with EBUSY.
> > > 
> > 
> > I've just sent a patch to fix this issue.
> > 
> > Could you try it and let me know if it solves your issue?
> 
> thanks a lot! Just tried it, same fix is needed for vidioc_s_std(), then
> the errors in motion and zoneminder are gone!
> 

Ah... forgot to mention about that. I haven't included the fix for standard
setting, because either the stk1160 chip or the userspace application didn't
seem to behave properly: I got wrongly coloured frames when trying to
change the standard while streaming.

Can't your problem get fixed by setting an initial standard (e.g. at
/etc/motion configuration file)?

> Motion seems to work now, with zoneminder I get a lot of these messages:
> Jul 17 23:28:27 localhost kernel: [20641.931990] stk1160_copy_video: 5563 callbacks suppressed
> Jul 17 23:28:27 localhost kernel: [20641.931998] stk1160: buffer overflow detected
> Jul 17 23:28:27 localhost kernel: [20641.932000] stk1160: buffer overflow detected
> 
> Anything to worry about?
> 

Not sure. If you're changing the standard while streaming then maybe some component
is not doing things right.

I can take a look at the std thing later, but for now the input
fix looks definitely correct.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
