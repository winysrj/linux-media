Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34424 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbcFWWlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 18:41:16 -0400
Date: Thu, 23 Jun 2016 15:41:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
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
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
Subject: Re: [PATCH v5 1/9] [media] v4l2-core: Add support for touch devices
Message-ID: <20160623224112.GQ32561@dtor-ws>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466633313-15339-2-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466633313-15339-2-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 22, 2016 at 11:08:25PM +0100, Nick Dyer wrote:
> Some touch controllers send out touch data in a similar way to a
> greyscale frame grabber.
> 
> Use a new device prefix v4l-touch for these devices, to stop generic
> capture software from treating them as webcams.
> 
> Add formats:
> - V4L2_TCH_FMT_DELTA_TD16 for signed 16-bit touch deltas
> - V4L2_TCH_FMT_DELTA_TD08 for signed 16-bit touch deltas
> - V4L2_TCH_FMT_TU16 for unsigned 16-bit touch data
> - V4L2_TCH_FMT_TU08 for unsigned 8-bit touch data
> 
> This support will be used by:
> * Atmel maXTouch (atmel_mxt_ts)
> * Synaptics RMI4.
> * sur40
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>

Hans/Mauro, when you merge this can you make a stable branch (maybe
based on 4.6) so I can pull it in as well and then merge the rest?

Thanks!

-- 
Dmitry
