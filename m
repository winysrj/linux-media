Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56393 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932210AbdACJMJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 04:12:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Kevin Hilman <khilman@baylibre.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?B?R2/FgmFzemV3c2tp?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/5] davinci: VPIF: add DT support
Date: Tue, 03 Jan 2017 11:12:10 +0200
Message-ID: <57057847.C5XnZnHN9E@avalon>
In-Reply-To: <4a03b56e-1e01-8b2c-c2a1-1b72d30f103a@ti.com>
References: <20161207183025.20684-1-khilman@baylibre.com> <d4b0501a-f83a-c8b1-e460-1ba50f68cca7@xs4all.nl> <4a03b56e-1e01-8b2c-c2a1-1b72d30f103a@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

On Tuesday 03 Jan 2017 14:33:00 Sekhar Nori wrote:
> On Friday 16 December 2016 03:17 PM, Hans Verkuil wrote:
> > On 07/12/16 19:30, Kevin Hilman wrote:
> >> Prepare the groundwork for adding DT support for davinci VPIF drivers.
> >> This series does some fixups/cleanups and then adds the DT binding and
> >> DT compatible string matching for DT probing.
> >> 
> >> The controversial part from previous versions around async subdev
> >> parsing, and specifically hard-coding the input/output routing of
> >> subdevs, has been left out of this series.  That part can be done as a
> >> follow-on step after agreement has been reached on the path forward.
> >> With this version, platforms can still use the VPIF capture/display
> >> drivers, but must provide platform_data for the subdevs and subdev
> >> routing.
> >> 
> >> Tested video capture to memory on da850-lcdk board using composite
> >> input.
> > 
> > Other than the comment for the first patch this series looks good.
> > 
> > So once that's addressed I'll queue it up for 4.11.
> 
> Can you provide an immutable commit (as it will reach v4.11) with with
> this series applied? I have some platform changes to queue for v4.11
> that depend on the driver updates.

I don't think that's possible, given that Mauro rewrites all patches when 
handling pull requests to prepend [media] to the subject line and to add his 
SoB. Only Mauro can thus provide a stable branch, Hans can't.

-- 
Regards,

Laurent Pinchart

