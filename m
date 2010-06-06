Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48769 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab0FFBd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jun 2010 21:33:26 -0400
Received: by gwb15 with SMTP id 15so569485gwb.19
        for <linux-media@vger.kernel.org>; Sat, 05 Jun 2010 18:33:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100606010752.4a138f82@romy.gusto>
References: <20100606010752.4a138f82@romy.gusto>
Date: Sat, 5 Jun 2010 21:33:24 -0400
Message-ID: <AANLkTin-QLz0lM1bpGer_a71YHbnoN-dTQrPRjwtCfo3@mail.gmail.com>
Subject: Re: hvr4000 doesnt work w/ dvb-s2 nor DVB-T
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Lars Schotte <lars.schotte@schotteweb.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 5, 2010 at 7:07 PM, Lars Schotte <lars.schotte@schotteweb.de> wrote:
> so basically my question is, what makes you think, that HVR4000 is able
> to play DVB-S2 streams when it doesn't?!

Well, the fact that the developer who added the Linux S2-API support
did it for that card would be a pretty good indicator that it should
work.

> so I have tried this out, run w_scan which printed me also all the
> DVB-S2 channels out and provided me a tuning list (channels.conf) and
> then I tried to tune in w/ "szap-s2 -S 1 -c ~/.mplayer/channels.conf
> ZDFHD"

If w_scan gave you a channel list, that is a pretty good sign that the
card is working.  You probably are just feeding the zap tool the wrong
arguments (something which someone who has more familiarity than I do
with dvb-s2 would probably be able to help you with.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
