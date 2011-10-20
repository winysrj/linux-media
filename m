Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1JTT0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 15:26:41 -0400
Received: by wwe6 with SMTP id 6so4659138wwe.1
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 12:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
	<CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
	<20111020170811.GD7530@jannau.net>
	<CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
Date: Thu, 20 Oct 2011 15:26:39 -0400
Message-ID: <CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Taylor Ralph <taylor.ralph@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 2:14 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Oct 20, 2011 at 1:08 PM, Janne Grunau <j@jannau.net> wrote:
>> I think such scenario is unlikely but I don't know it for sure and
>> I don't want to force anyone to test every firmware version.
>> Ignoring them for firmware version < 16 should be safe since we assume
>> they had no effect. Returning -EINVAL might break API-ignoring
>> applications written with the HD PVR in mind but I think it's a better
>> approach than silently ignoring those controls.
>
> At this point, let's just make it so that the old behavior is
> unchanged for old firmwares, meaning from both an API standpoint as
> well as what the values are.  At some point if somebody cares enough
> to go back and fix the support so that the controls actually work with
> old firmwares, they can take that up as a separate task.  In reality,
> it is likely that nobody will ever do that, as the "easy answer" is
> just to upgrade to firmware 16.
>
> Taylor, could you please tweak your patch to that effect and resubmit?
>

Sure, I'll try to get to it tonight and have it tested.

Regards.
--
Taylor
