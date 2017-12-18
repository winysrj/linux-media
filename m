Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41269 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932954AbdLRP0S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 10:26:18 -0500
Date: Mon, 18 Dec 2017 13:26:11 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 00/17] kernel-doc: add supported to document nested
 structs/
Message-ID: <20171218132611.2898a42b@vento.lan>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  4 Oct 2017 08:48:38 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Right now, it is not possible to document nested struct and nested unions.
> kernel-doc simply ignore them.
> 
> Add support to document them.
> 
> Patches 1 to 6 improve kernel-doc documentation to reflect what
> kernel-doc currently supports and import some stuff from the
> old kernel-doc-nano-HOWTO.txt.
> 
> Patch 7 gets rid of the old documentation (kernel-doc-nano-HOWTO.txt).
> 
> 
> Patch 8 gets rid of the now unused output formats for kernel-doc: since 
> we got rid of all DocBook stuff, we should not need them anymore. The
> reason for dropping it (despite cleaning up), is that it doesn't make 
> sense to invest time on adding new features for formats that aren't
> used anymore.
> 
> Patch 9 improves argument handling, printing script usage if an
> invalid argument is passed and accepting both -cmd and --cmd
> forms.
> 
> Patch 10 changes the default output format to ReST, as this is a way
> more used than man output nowadays.
> 
> Patch 11 solves an issue after ReST conversion, where tabs were not
> properly handled on kernel-doc tags.
> 
> Patch 12 adds support for parsing kernel-doc nested structures and 
> unions.
> 
> Patch 13 does a cleanup, removing $nexted parameter at the
> routines that handle structs.
> 
> Patch 14 Improves warning output by printing the identifier where
> the warning occurred.
> 
> Patch 15 complements patch 12, by adding support for function
> definitions inside nested structures. It is needed by some media
> docs with use such kind of things.
> 
> Patch 16 improves nested struct handling even further, allowing it
> to handle cases where a nested named struct/enum with multiple
> identifiers added (e. g. struct { ... } foo, bar;).
> 
> Patch 17 adds documentation for nested union/struct inside w1_netlink.
> 
> The entire patch series are at my development tree, at:
>     https://git.linuxtv.org/mchehab/experimental.git/log/?h=nested-fix-v4b

I'm applying all patches from this series that either didn't have
any comments of whose editorial comments I fully embraced.

The patches that weren't applied from this series are:
	0008-media-v4l2-device.h-document-ancillary-macros.patch
	0010-media-v4l2-ioctl.h-convert-debug-macros-into-enum-an.patch
	0014-media-v4l2-async-simplify-v4l2_async_subdev-structur.patch
	0015-media-v4l2-async-better-describe-match-union-at-asyn.patch

I'll send later a patch series with those - probably together with
other documentation patches from the other two series I sent - that
need further reviews.

Thanks,
Mauro
