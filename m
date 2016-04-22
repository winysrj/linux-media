Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43490 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbcDVOp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 10:45:26 -0400
Date: Fri, 22 Apr 2016 11:45:17 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>
Subject: Re: [PATCH 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
Message-ID: <20160422114517.0e7430bd@recife.lan>
In-Reply-To: <5719E03D.2010201@xs4all.nl>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
	<5719E03D.2010201@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Apr 2016 10:26:37 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Nick,
> 
> On 04/21/2016 11:31 AM, Nick Dyer wrote:
> > This is a series of patches to add diagnostic data support to the Atmel
> > maXTouch driver. It's a rewrite of the previous implementation which output via
> > debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.
> > 
> > There are significant performance advantages to putting this code into the
> > driver. The algorithm for retrieving the data has been fairly consistent across
> > a range of chips, with the exception of the mXT1386 series (see patch).
> > 
> > We have a utility which can read the data and display it in a useful format:
> > 	https://github.com/ndyer/heatmap/commits/heatmap-v4l
> > 
> > These patches are also available from
> > 	https://github.com/ndyer/linux/commits/diagnostic-v4l
> > 
> > Any feedback appreciated.  
> 
> FYI: we're working on a new buffer type for meta data:
> 
> https://patchwork.linuxtv.org/patch/33938/
> https://patchwork.linuxtv.org/patch/33939/

Nick,

One of the things I missed on your patchset is the content of the
new format you added (V4L2_PIX_FMT_YS16). You should be patching
the V4L2 docbook too, in order to add it there.

That's said, if the output is really an image, I don't think it
should be mapped via the new V4L2_BUF_TYPE_META_CAPTURE. This type of
buffer is meant to be used on non-image metadata, like image statistics
to feed auto whitebalance and other similar AAA algorithms.

It could still make sense to use the new device type (VFL_TYPE_META) for
such drivers, as we don't want applications to identify those devices as
if they are a webcam.

> 
> This would be an excellent fit for you. I expect that this new feature would be
> merged soon (for 4.7 or 4.8 at the latest) since it looks all pretty good to me.
> 
> So let's wait for this to be merged and then you can migrate to the new buffer
> type.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
