Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:50488 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZHSRQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 13:16:22 -0400
Received: by gxk1 with SMTP id 1so6168241gxk.17
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2009 10:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250701340.14727.28.camel@McM>
References: <1250679685.14727.14.camel@McM>
	 <829197380908190642sfabee2ahe599dda1df39678c@mail.gmail.com>
	 <1250701340.14727.28.camel@McM>
Date: Wed, 19 Aug 2009 13:16:23 -0400
Message-ID: <829197380908191016n8d7f21eq88ebe3a45816275b@mail.gmail.com>
Subject: Re: USB Wintv HVR-900 Hauppauge
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miguel <mcm@moviquity.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 1:02 PM, Miguel<mcm@moviquity.com> wrote:
> oh, what a shame, :-s
>
> The USB id is:
>
> Bus 001 Device 011: ID 2040:6600 Hauppauge
>
>
> is this the version you commented that is not supported?

Ah, ok.  So you really do have an HVR-900H and not an HVR-900 (either
R1 or R2).  Since this is the case, your device really is TM6000
based, but that development tree has not been worked on in a very long
time and is known to be broken.

Unfortunately, it is not clear when/if Mauro will ever get back to
getting that bridge to a supported state (it hasn't had any active
development in over nine months).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
