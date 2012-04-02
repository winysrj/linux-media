Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39677 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2DBVag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:30:36 -0400
Received: by vbbff1 with SMTP id ff1so1982006vbb.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333400524.30070.83.camel@hp0>
References: <1333400524.30070.83.camel@hp0>
Date: Mon, 2 Apr 2012 17:30:36 -0400
Message-ID: <CAGoCfizjVx5JJwZxN2vU9r6_OGKCG6iJCMTQ0bRusJEHztWoiw@mail.gmail.com>
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

It's probably also worth mentioning that if you want to try to debug
this yourself, the problem is probably in the saa711x driver (the
video decoder chip in the Dazzle), not the em28xx driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
