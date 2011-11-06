Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54765 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1KFW0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 17:26:04 -0500
Received: by faao14 with SMTP id o14so4555307faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 14:26:03 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <201111041249.24661.laurent.pinchart@ideasonboard.com>
References: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
	<201111041249.24661.laurent.pinchart@ideasonboard.com>
Date: Sun, 6 Nov 2011 16:26:02 -0600
Message-ID: <CABcw_Omf-xChfK8qu5u95KUqvnrKu99WQiPRWvZTmpy4rW6xiw@mail.gmail.com>
Subject: Re: media0 not showing up on beagleboard-xm
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Nov 4, 2011 at 6:49 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Chris,
>
> On Tuesday 25 October 2011 04:48:13 Chris Whittenburg wrote:
>> I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
>> beagleboard-xm.
>
> You will need board code to register the OMAP3 ISP platform device that will
> then be picked by the OMAP3 ISP driver. Example of such board code can be
> found at
>
> http://git.linuxtv.org/pinchartl/media.git/commit/37f505296ccd3fb055e03b2ab15ccf6ad4befb8d

I followed your example to add the MT9P031 support, and now I get
/dev/media0 and /dev/video0 to 7.

I don't have the actual sensor hooked up yet.

If I try "media-ctl -p", I see lots of "Failed to open subdev device
node" msgs.
http://pastebin.com/F1TC9A1n

This is with the media-ctl utility from:
http://feeds.angstrom-distribution.org/feeds/core/ipk/eglibc/armv7a/base/media-ctl_0.0.1-r0_armv7a.ipk

I also tried with the latest from your media-ctl repository, but got
the same msgs.

Is this an issue with my 3.0.8 kernel not being compatible with
current media-ctl utility?  Is there some older commit that I should
build from?  Or maybe it is just a side effect of the sensor not being
connected yet.

thanks.
