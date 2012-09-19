Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46073 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2ISUwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 16:52:02 -0400
Received: by obbuo13 with SMTP id uo13so844875obb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 13:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl>
References: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl>
Date: Wed, 19 Sep 2012 16:52:01 -0400
Message-ID: <CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: oliver@schinagl.nl
Cc: linux-media@vger.kernel.org, crope@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 19, 2012 at 2:44 PM,  <oliver@schinagl.nl> wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>
> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
> in its current form gets detected and loads properly.
>
> Scanning using dvbscan works without problems, Locking onto a channel
> using tzap also works fine. Only playback using tzap -r + mplayer was
> tested and was fully functional.

Hi Oliver,

The previous thread suggested that this driver didn't work with
dvbv5-scan and w_scan.  Is that still the case?  If so, do we really
want a "half working" driver upstream?  Seems like this is more likely
to cause support headaches than the device not being supported at all
(since users will "think" it's supported but it's actually broken in
some pretty common use cases).

Or perhaps I'm mistaken and the issues have been addressed and now it
works with all the common applications.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
