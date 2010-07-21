Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45619 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab0GUQeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 12:34:05 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 21 Jul 2010 11:33:54 -0500
Subject: RE: [media-ctl] [omap3camera:devel] How to use the app?
Message-ID: <A24693684029E5489D1D202277BE89445698C396@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE8944562E8B71@dlee02.ent.ti.com>
 <201006291222.47159.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201006291222.47159.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, June 29, 2010 5:23 AM
> To: Aguirre, Sergio
> Cc: Sakari Ailus; linux-media@vger.kernel.org
> Subject: Re: [media-ctl] [omap3camera:devel] How to use the app?
> 

<snip>

> 
> You will find a set of patches that remove the legacy video nodes attached
> to
> this e-mail. They haven't been applied to the omap3camera tree yet, as we
> still haven't fixed all userspace components yet, but they should get
> there in
> a few weeks hopefully. You should probably apply them to your tree to make
> sure you don't start using the legacy video nodes by mistake. They also
> remove
> a lot of code, which is always good, and remove the hardcoded number of
> sensors.

By any chance, do you keep rebasing these patches in a branch somewhere?

I tried rebasing them against latest 'devel' branch, but they fail on
omap34xxcam.c, because the removed content is not the same. The delta is
just an addition you did to reset all non-legacy links during init.

Is it ok to still remove this completely? Or is this going to be rellocated
somewhere?

The patch I'm talking about is named: "omap34xxcam: Reset all links before setting up the pipeline".

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
