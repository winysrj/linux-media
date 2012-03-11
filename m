Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37903 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2CKPev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 11:34:51 -0400
Received: by vcqp1 with SMTP id p1so3246865vcq.19
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2012 08:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201203111725.58006.remi@remlab.net>
References: <201203111608.48843.remi@remlab.net>
	<201203111725.58006.remi@remlab.net>
Date: Sun, 11 Mar 2012 11:34:50 -0400
Message-ID: <CAGoCfiwM_FPAbRhZf4UfiWU7XkY6_WvHzT-v9qyBF9nZ=HaR-A@mail.gmail.com>
Subject: Re: Mapping frontends to demuxes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org, vlc-devel@videolan.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/11 Rémi Denis-Courmont <remi@remlab.net>:
> By the way, the bt8xx driver exposes ATSC but not ITU J.83 annex B. This is
> contrary to all other ATSC frontends. Is this correct?

Many of the older cards didn't support J.83 annex B (i.e. ClearQAM).
Whether the device supports ClearQAM or not is actually controlled by
the demodulator driver, not the bridge driver.

If you provide specifically which product you are talking about (the
product name and PCI ID), it's easy enough to confirm by taking a
quick look at the source.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
