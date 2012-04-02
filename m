Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63814 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2DBMcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 08:32:47 -0400
Received: by vbbff1 with SMTP id ff1so1634627vbb.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 05:32:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F799A99.9010209@mlbassoc.com>
References: <4F799A99.9010209@mlbassoc.com>
Date: Mon, 2 Apr 2012 14:32:46 +0200
Message-ID: <CA+2YH7svJoCnvUPQGPr=YOsEQBZ16J5y9QGjFyfNmdjeLum4cA@mail.gmail.com>
Subject: Re: OMAP3ISP won't start
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 2, 2012 at 2:24 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> Just to be clear - I did have to make a few patches to both the
> TVP5150 driver and CCDC part of OMAP3ISP as some of the BT656
> support is still not in Laurent's tree.  I'll send patches, etc,
> once I get it working, but as mentioned above, at least at the
> register level, these are set up the same as in my working tree.

What patches did you add on top of Laurent tree?

I had a look some days ago and for example it's missing the right
setup for VD0/VD1 (no VD1 and VD0 set to half height), this could be
the cause of a not working isp. You can check if you get interrupts
from the isp (/proc/interrupts).

Another thing that is missing is the logic in the irq handler that
wait for a complete frame before calling next video buffer (or
something like that).

Enrico
