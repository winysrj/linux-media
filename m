Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39619 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2DBVZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:25:54 -0400
Received: by vcqp1 with SMTP id p1so1958379vcq.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333400524.30070.83.camel@hp0>
References: <1333400524.30070.83.camel@hp0>
Date: Mon, 2 Apr 2012 17:25:53 -0400
Message-ID: <CAGoCfiyzkXmTn0adSNVmhv586sxL7FKDnqhnpgJ50+5as5DEGg@mail.gmail.com>
Subject: Re: NTSC_443 problem in v4l and em28x
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: colineby@isallthat.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 2, 2012 at 5:02 PM, Colin Eby <colineby@isallthat.com> wrote:
> There's clear evidence I can get some kind of tool chain to work in
> Windows. But I wondered if there wasn't some fine tuning to the driver
> that would get Linux rig to work.  And I wondered if there were known
> issues around the NTSC_443 norm. Forgive me if I've missed any, but I
> haven't found any so far.

I've done a bunch of work on that driver, and the answer is probably
really simple - 443 is so rare that none of the developers has the
playback hardware to test with.  I'm not even sure my analog signal
generator will output the format.

Unfortunately, until some developer needs it to work and has the time
to debug it, you're probably out of luck.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
