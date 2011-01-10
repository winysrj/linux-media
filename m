Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:16581 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab1AJMjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:39:20 -0500
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Andy Walls <awalls@md.metrocast.net>
To: Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294512347.16924.28.camel@gagarin>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost>
	 <1294512347.16924.28.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 07:39:09 -0500
Message-ID: <1294663149.2084.41.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-08 at 19:45 +0100, Lawrence Rust wrote:
> On Sat, 2011-01-08 at 09:22 -0500, Andy Walls wrote:

> Thanks for the info on the PVR-150.  It largely confirmed what I had
> surmised - that the two cards disagree about serial audio data format.
> Before my patch, the wm8775 was programmed for Philips mode but the
> CX25843 on the PVR-150 is setup for Sony I2S mode!!  On the Nova-S, the
> cx23883 is setup (in cx88-tvaudio.c) for Philips mode.  The patch
> changed the wm8775 to Sony I2S mode because the existing setup gave
> noise, indicative of a mismatch.
> 
> It is my belief that either the wm8775 datasheet is wrong or there are
> inverters on the SCLK lines between the wm8775 and cx25843/23883. It is
> also plausible that Conexant have it wrong and both their datasheets are
> wrong.
> 
> Anyway, I have revised the patch (attached) so that the wm8775 is kept
> in Philips mode (to please the PVR-150) and the cx23883 on the Nove-S is
> now switched to Sony I2S mode (like the PVR-150) and this works fine.

I will try and review and test this coming weekend.


> The change is trivial, just 2 lines, so they're shouldn't be any other
> consequences.  However, could this affect any other cards? 

That is the problem with code reuse, for multiple board models, in all
the I2C modules.  It makes code increasingly more difficult to maintain
as more different board models are supported and tested.

But now there is infrastructure in place to pass board specific info
down to the I2C v4l2_subdevice drivers.  If the wm8775 driver were
changed to provide a wm8775-specific platform-data structure for bridge
drivers to use, bridge drivers could fill it out and call
v4l2_i2c_new_subdev_board() to instantiate the wm8775 device instance
specific to the board: Nova-S, PVR-150, or whatever.

See the interaction between the ivtv and cx25840 module in this patch as
an example:

https://patchwork.kernel.org/patch/465571/

(Not all of the details are visible in the patch, since some were
already there for the .s_config call in cx25840.)

Obviously, the wm8775 module would need code added to take different
actions when passed different platform data.  However, that the best way
to make sure one doesn't accidentally affect other boards.

> NB I have only tested this patch on my Nova-S, no other.

I do see one problem with your patch at the moment:

diff --git a/include/media/wm8775.c b/include/media/wm8775.c
...
+       sd->grp_id = WM8775_GID; /* subdev group id */
...
diff --git a/include/media/wm8775.h b/include/media/wm8775.h
...
+/* subdev group ID */
+#define WM8775_GID (1 << 0)
+
...


The wm8775 module probably should not define WM8775_GID and definitely
should not set sd->grp_id.  The sd->grp_id is for the bridge driver's
use for that v4l2_subdev instance.  Some bridge drivers may expect it to
be 0 unless they set it themselves.  The group ID values should be
defined in the bridge driver, and the sd->grp_id field should be set by
the bridge driver.

You would want to do that in cx88.  See cx23885, ivtv, and cx18 as
examples of bridge drivers that use the group id field.

Regards,
Andy

