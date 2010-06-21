Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:47928 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab0FUQvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 12:51:35 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>,
	"Ozan \?a\?layan" <ozan@pardus.org.tr>,
	Manu Abraham <manu@linuxtv.org>, stable@kernel.org
Subject: Re: [PATCH] Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to  make modules auto-loadable
References: <1277110376-6993-1-git-send-email-bjorn@mork.no>
	<AANLkTilghfY5tsC0V4m6IQ1VIFE-j-rB4i6Xi2mYevwV@mail.gmail.com>
Date: Mon, 21 Jun 2010 18:51:22 +0200
In-Reply-To: <AANLkTilghfY5tsC0V4m6IQ1VIFE-j-rB4i6Xi2mYevwV@mail.gmail.com>
	(VDR User's message of "Mon, 21 Jun 2010 09:12:23 -0700")
Message-ID: <87vd9c72id.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VDR User <user.vdr@gmail.com> writes:

> Instead of copy&paste patches from Manu's tree, maybe it's better to
> just wait for him to push all the changes into v4l.  

I certainly agree that having him push all the changes would be much
better. And nothing would please me more than seeing this happen.

But I do *not* agree that "just wait" is better.  We have waited for 4
months.  It did not work.  Why do you think that waiting more will work
better? 

> There have been
> many bug fixes & improvements Manu has done that haven't been pushed
> into v4l yet

I guess there is.  I only know of the two now 4 months old bug fixes in
http://jusst.de/hg/mantis-v4l-dvb but there can of course be much more
happening without me knowing.  There could be other trees.  But without
pointers (we have a perfectly good MAINTAINERS for this), it's very hard
to find such things.

In fact, I do have some problems getting oriented in the V4L/DVB world.
There seem to be a number of dead development trees scattered all
around.  But I guess that's to be expected, since there have been major
reorganisations lately.  To the better, IMHO.  I'm looking forward to
having Linus' kernel track the V4L/DVB development more closely, and not
having to replace a whole subsystem every time I want to test a new
driver.

> and I think it's better to sync the entire driver instead
> of cherry picking patches here & there.

Yes.  And I did hesitate to do this.  But this one patch is really
wanted to make the driver fully functional (users do expect PCI drivers
to autoload nowadays). It could have been in 2.6.34.  As it looks now,
it won't make 2.6.35...

Why wait?  What's the point of collecting a large number (or small
number for that sake) of patches in some development tree only very few
developers even know exists?  Push them upstream as soon as possible.
The initial driver development is of course something else.  I
appreciate the need to develop something working before pushing it. But
simple fixes like this one?  Just push it.




Bjørn
