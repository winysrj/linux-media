Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:49356 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3DNVUJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 17:20:09 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] bttv: Add noname Bt848 capture card with 14MHz xtal
Date: Sun, 14 Apr 2013 23:19:47 +0200
Cc: linux-media@vger.kernel.org
References: <201304141839.10168.linux@rainbow-software.org>
In-Reply-To: <201304141839.10168.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304142319.47887.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 April 2013 18:39:09 Ondrej Zary wrote:
> Add support for noname Bt848 capture-only card (3x composite, 1x S-VHS)
> with 14MHz crystal:
> http://www.rainbow-software.org/images/hardware/bt848_.jpg

Noticed that it takes ages to load the bttv module (about 30 seconds).
If "disable_ir=1" parameter is used, it loads immediately.
I wonder why the bttv driver probes for IR chips even when the "has_remote" 
flag is not set?

-- 
Ondrej Zary
