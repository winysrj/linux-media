Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52363 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbcDVI0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:26:45 -0400
Subject: Re: [PATCH 0/8] Input: atmel_mxt_ts - output raw touch diagnostic
 data via V4L
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5719E03D.2010201@xs4all.nl>
Date: Fri, 22 Apr 2016 10:26:37 +0200
MIME-Version: 1.0
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nick,

On 04/21/2016 11:31 AM, Nick Dyer wrote:
> This is a series of patches to add diagnostic data support to the Atmel
> maXTouch driver. It's a rewrite of the previous implementation which output via
> debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.
> 
> There are significant performance advantages to putting this code into the
> driver. The algorithm for retrieving the data has been fairly consistent across
> a range of chips, with the exception of the mXT1386 series (see patch).
> 
> We have a utility which can read the data and display it in a useful format:
> 	https://github.com/ndyer/heatmap/commits/heatmap-v4l
> 
> These patches are also available from
> 	https://github.com/ndyer/linux/commits/diagnostic-v4l
> 
> Any feedback appreciated.

FYI: we're working on a new buffer type for meta data:

https://patchwork.linuxtv.org/patch/33938/
https://patchwork.linuxtv.org/patch/33939/

This would be an excellent fit for you. I expect that this new feature would be
merged soon (for 4.7 or 4.8 at the latest) since it looks all pretty good to me.

So let's wait for this to be merged and then you can migrate to the new buffer
type.

Regards,

	Hans
