Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39851 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaHEPCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 11:02:49 -0400
Received: by mail-ob0-f176.google.com with SMTP id wo20so766626obc.35
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 08:02:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Tue, 5 Aug 2014 17:02:48 +0200
Message-ID: <CA+2YH7ud=y5WtG-Zhr3d+66LiX2+OgWDVCXqxSCe_+r69iK+9A@mail.gmail.com>
Subject: Re: [PATCH 0/8] OMAP3 ISP CCDC fixes
From: Enrico <ebutera@users.sourceforge.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 1, 2014 at 3:46 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hello,
>
> This patch series fixes several stability issues related to the CCDC,
> especially (but not exclusively) in BT.656 mode.
>
> The patches apply on top of the OMAP3 ISP CCDC BT.656 mode support series
> previously posted. You can find both series at
>
>         git://linuxtv.org/pinchartl/media.git omap3isp/bt656
>
> I'm not sure to be completely happy with the last three patches. The CCDC
> state machine is getting too complex for my tastes, race conditions becoming
> too hard to spot. This doesn't mean the code is wrong, but a rewrite of the
> state machine will probably needed sooner than later.

I tested this patch series on an igep proton (omap3530) with tvp5150,
kernel 3.16, bt656 mode.
All issues i had with the first series are fixed, so:

Tested-by: Enrico Butera <ebutera@users.sourceforge.net>
