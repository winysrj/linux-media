Return-path: <linux-media-owner@vger.kernel.org>
Received: from belief.htu.tuwien.ac.at ([128.131.95.14]:34985 "EHLO
	belief.htu.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3GRAoV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 20:44:21 -0400
Date: Thu, 18 Jul 2013 02:44:19 +0200
From: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130718004419.GA14638@deadlock.dhs.org>
References: <20130716220418.GC10973@deadlock.dhs.org> <20130717084428.GA2334@localhost> <20130717213139.GA14370@deadlock.dhs.org> <20130718001752.GA2318@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718001752.GA2318@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Wed, Jul 17, 2013 at 09:17:53PM -0300, Ezequiel Garcia wrote:
> On Wed, Jul 17, 2013 at 11:31:39PM +0200, Sergey 'Jin' Bostandzhyan wrote:
> > On Wed, Jul 17, 2013 at 05:44:29AM -0300, Ezequiel Garcia wrote:
> > > On Wed, Jul 17, 2013 at 12:04:18AM +0200, Sergey 'Jin' Bostandzhyan wrote:
> > > > 
> > > > It generally works fine, I can, for example, open the video device using VLC,
> > > > select one of the inputs and get the picture.
> > > > 
> > > > However, programs like motion or zoneminder fail, I am not quite sure if it
> > > > is something that they might be doing or if it is a problem in the driver.
> > > > 
> > > > Basically, for both of the above, the problem is that VIDIOC_S_INPUT fails
> > > > with EBUSY.
> > > > 
> > > 
> > > I've just sent a patch to fix this issue.
> > > 
> > > Could you try it and let me know if it solves your issue?
> > 
> > thanks a lot! Just tried it, same fix is needed for vidioc_s_std(), then
> > the errors in motion and zoneminder are gone!
> > 
> 
> Ah... forgot to mention about that. I haven't included the fix for standard
> setting, because either the stk1160 chip or the userspace application didn't
> seem to behave properly: I got wrongly coloured frames when trying to
> change the standard while streaming.
> 
> Can't your problem get fixed by setting an initial standard (e.g. at
> /etc/motion configuration file)?

Actually it is set, so I do not really know why it attempts to set it
separately for each input. So basically that means, that the version I am
running now may cause some problems (I removed the busy check on vidioc_s_std
in my local module)... it does work however, maybe because it's just
setting the same standard over and over again which probably does not
cause any actual action on the chip?

> > Motion seems to work now, with zoneminder I get a lot of these messages:
> > Jul 17 23:28:27 localhost kernel: [20641.931990] stk1160_copy_video: 5563 callbacks suppressed
> > Jul 17 23:28:27 localhost kernel: [20641.931998] stk1160: buffer overflow detected
> > Jul 17 23:28:27 localhost kernel: [20641.932000] stk1160: buffer overflow detected
> > 
> > Anything to worry about?
> > 
> 
> Not sure. If you're changing the standard while streaming then maybe some component
> is not doing things right.

I only get these messages with zoneminder, with motion things seem to
work fine. One problem with zoneminder is, that it does not cycle the
inputs in a clean way, i.e. if I watch each "virtual" camera separately,
I see the image and then I do see some garbage that comes from the input
switching. But again, since motion handles it just fine, I would assume that
this is some zoneminder problem.. however I do not know if they are doing
anything legal or illegal in their code. I did configure the same standard 
for each input there too, so that part should not be different from
what motion is doing.

> I can take a look at the std thing later, but for now the input
> fix looks definitely correct.

Yes, thank you, this input fix solved the initial problem :)

Just ping me if you'd like me to test the std fix later, whenever you get to it.

Kind regards,
Sergey

