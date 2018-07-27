Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbeG0OJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 10:09:05 -0400
Date: Fri, 27 Jul 2018 09:47:08 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?UTF-8?B?TWF0aWpldmnEhw==?= <filip.matijevic.pz@gmail.com>,
        mchehab@s-opensource.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180727094708.18ef4e4e@coco.lan>
In-Reply-To: <20180708213258.GA18217@amd>
References: <20180708213258.GA18217@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 8 Jul 2018 23:32:58 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Add support for opening multiple devices in v4l2_open(), and for
> mapping controls between devices.
> 
> This is necessary for complex devices, such as Nokia N900.

Hi Pavel,

I tried to apply it here, but it seems that there are something
wrong with the patch:

$ quilt push -f --merge
Applying patch patches/lmml_50901_libv4l_make_libv4l2_usable_on_devices_with_complex_pipeline.patch
patching file lib/include/libv4l2.h
patching file lib/libv4l2/libv4l2-priv.h
patching file lib/libv4l2/libv4l2.c
Hunk #6 NOT MERGED at 1830-1857.
misordered hunks! output would be garbled
Hunk #7 FAILED at 1224.
Hunk #8 NOT MERGED at 1858-2057.
1 out of 8 hunks FAILED -- saving rejects to file lib/libv4l2/libv4l2.c.rej
patching file lib/libv4lconvert/control/libv4lcontrol.c
Applied patch patches/lmml_50901_libv4l_make_libv4l2_usable_on_devices_with_complex_pipeline.patch (forced; needs refresh)

I even tried to reset the tree to a patchset earlier than July, 8.
Same issue.

I could manually try to fix it, but that misordered hunks
warning is weird. Makes me wonder if the patch is not mangled.

Could you please re-send it on the top of upstream? Better to use
git send-email, as it won't mangle your patch.

Alternatively, please send me a ssh public key in private, and I'll
give you access to the repository where you can store those patches.

Thanks!
Mauro



Thanks,
Mauro
