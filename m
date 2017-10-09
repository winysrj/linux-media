Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63518 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdJIMfl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 08:35:41 -0400
Date: Mon, 9 Oct 2017 09:35:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Benoit Parrot <bparrot@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Osciak <pawel@osciak.com>, Pavel Machek <pavel@ucw.cz>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Helen Koike <helen.koike@collabora.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund@ragnatech.se>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mike Isely <isely@pobox.com>,
        Hans Liljestrand <ishkamiel@gmail.com>
Subject: Re: [PATCH 00/24] V4L2 kAPI cleanups and documentation improvements
 part 2
Message-ID: <20171009093527.32f8d976@vento.lan>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Oct 2017 07:19:06 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> That's the second part of my V4L2 kAPI documentation improvements.
> It is meant to reduce the gap between the kAPI media headers
> and documentation, at least with regards to kernel-doc markups.
> 
> We should likely write more things at the ReST files under Documentation/
> to better describe some of those APIs (VB2 being likely the first candidate),
> but at least let's be sure that all V4L2 bits have kernel-doc markups.

Forgot to mention: 

This series, together with the part1 one is on this tree:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=v4l-docs-part2-v1

As I may not have time to address the remaining kAPI bits for
a while, let me document what kAPIs at include/media main dir
are still out of sync:

	- cec-pin.h: struct cec_pin;
	- cec.h: several structs;
	- media-device.h, media-devnode.h: a couple of defines;
	- rc-core.h: ancillary functions;
	- soc-camera.h, v4l2-clk.h, videobuf-*.h - probably not
	  worth the efforts, as those are obsolete kAPI;
	- v4l2-common.h: print macros. IMHO, we should try to get
	  rid of them, and use dev_foo() everywhere;
	- v4l2-fwnode.h: In this specific case, Sakari has a patch
	  series addressing it, moving existing documentation from
	  v4l2-fwnode.c;
	- v4l2-mem2mem.h: v4l2 ioctl helpers aren't documented;
	- videobuf2-*.h: This series contain several documentation
	  improvements there for VB2 core and V4L2, with are the
	  most important ones - as they're used by the drivers.
	  The other headers are either undocumented or barely
	  documented.

PS.: It should be noticed that there are other files under
     include/media and inside their sub-directories that aren't
     part of the media kAPI, but are driver-specific stuff,
     like, for example, imx.h, vsp1.h and i2c/ subdir.


Thanks,
Mauro
