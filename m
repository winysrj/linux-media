Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JTSOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 14:14:16 -0400
Received: by bkbzt19 with SMTP id zt19so3846403bkb.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 11:14:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111020170811.GD7530@jannau.net>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
	<CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
	<20111020170811.GD7530@jannau.net>
Date: Thu, 20 Oct 2011 14:14:14 -0400
Message-ID: <CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Janne Grunau <j@jannau.net>
Cc: Taylor Ralph <taylor.ralph@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 1:08 PM, Janne Grunau <j@jannau.net> wrote:
> I think such scenario is unlikely but I don't know it for sure and
> I don't want to force anyone to test every firmware version.
> Ignoring them for firmware version < 16 should be safe since we assume
> they had no effect. Returning -EINVAL might break API-ignoring
> applications written with the HD PVR in mind but I think it's a better
> approach than silently ignoring those controls.

At this point, let's just make it so that the old behavior is
unchanged for old firmwares, meaning from both an API standpoint as
well as what the values are.  At some point if somebody cares enough
to go back and fix the support so that the controls actually work with
old firmwares, they can take that up as a separate task.  In reality,
it is likely that nobody will ever do that, as the "easy answer" is
just to upgrade to firmware 16.

Taylor, could you please tweak your patch to that effect and resubmit?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
