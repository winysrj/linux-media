Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38021 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbdJIK4x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:56:53 -0400
Subject: Re: [PATCH 04/24] media: v4l2-mediabus: convert flags to enums and
 document them
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <8d351f92fb18148b4d53acdc7f7c8fb0e9f537d9.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mats Randgaard <matrandg@cisco.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Benoit Parrot <bparrot@ti.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6c1bdfed-9d23-1cd0-eb71-0b35206e5521@xs4all.nl>
Date: Mon, 9 Oct 2017 12:56:48 +0200
MIME-Version: 1.0
In-Reply-To: <8d351f92fb18148b4d53acdc7f7c8fb0e9f537d9.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> There is a mess with media bus flags: there are two sets of
> flags, one used by parallel and ITU-R BT.656 outputs,
> and another one for CSI2.
> 
> Depending on the type, the same bit has different meanings.
> 
> That's very confusing, and counter-intuitive. So, split them
> into two sets of flags, inside an enum.
> 
> This way, it becomes clearer that there are two separate sets
> of flags. It also makes easier if CSI1, CSP, CSI3, etc. would
> need a different set of flags.
> 
> As a side effect, enums can be documented via kernel-docs,
> so there will be an improvement at flags documentation.
> 
> Unfortunately, soc_camera and pxa_camera do a mess with
> the flags, using either one set of flags without proper
> checks about the type. That could be fixed, but, as both drivers
> are obsolete and in the process of cleanings, I opted to just
> keep the behavior, using an unsigned int inside those two
> drivers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice cleanup.

Regards,

	Hans
