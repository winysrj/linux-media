Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1IGC6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 22:58:36 -0400
Received: by bke11 with SMTP id 11so6018481bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 19:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
Date: Tue, 6 Sep 2011 22:58:35 -0400
Message-ID: <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 11:29 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> There are several issues with the original alsa_stream code that got
> fixed on xawtv3, made by me and by Hans de Goede. Basically, the
> code were re-written, in order to follow the alsa best practises.
>
> Backport the changes from xawtv, in order to make it to work on a
> wider range of V4L and sound adapters.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Mauro,

What tuners did you test this patch with?  I went ahead and did a git
pull of your patch series into my local git tree, and now my DVC-90
(an em28xx device) is capturing at 32 KHz instead of 48 (this is one
of the snd-usb-audio based devices, not em28xx-alsa).

Note I tested immediately before pulling your patch series and the
audio capture was working fine.

I think this patch series is going in the right direction in general,
but this patch in particular seems to cause a regression.  Is this
something you want to investigate?  I think we need to hold off on
pulling this series into the new tvtime master until this problem is
resolved.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
