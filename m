Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58548 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab1K3RX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:23:27 -0500
Received: by iage36 with SMTP id e36so1058504iag.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 09:23:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED65C46.20502@netup.ru>
References: <4ED65C46.20502@netup.ru>
Date: Wed, 30 Nov 2011 12:23:26 -0500
Message-ID: <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
Subject: Re: LinuxTV ported to Windows
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Abylay Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/11/30 Abylay Ospan <aospan@netup.ru>:
> Hello,
>
> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista, XP,
> win7 tested). Results available under GPL and can be checkout from git
> repository:
> https://github.com/netup/netup-dvb-s2-ci-dual
>
> Binary builds (ready to install) available in build directory. Currently
> NetUP Dual DVB-S2 CI card supported (
> http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).
>
> Driver based on Microsoft BDA standard, but some features (DiSEqC, CI)
> supported by custom API, for more details see netup_bda_api.h file.
>
> Any comments, suggestions are welcome.
>
> --
> Abylai Ospan<aospan@netup.ru>
> NetUP Inc.

Am I the only one who thinks this is a legally ambigious grey area?
Seems like this could be a violation of the GPL as the driver code in
question links against a proprietary kernel.

I don't want to start a flame war, but I don't see how this is legal.
And you could definitely question whether it goes against the
intentions of the original authors to see their GPL driver code being
used in non-free operating systems.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
