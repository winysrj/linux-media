Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60255 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0GKOGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jul 2010 10:06:40 -0400
Received: by eya25 with SMTP id 25so439038eya.19
        for <linux-media@vger.kernel.org>; Sun, 11 Jul 2010 07:06:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100711131859.GD7406@lisa.snow-crash.org>
References: <20100711131859.GD7406@lisa.snow-crash.org>
Date: Sun, 11 Jul 2010 10:06:38 -0400
Message-ID: <AANLkTikoRriePHgH5xhQwfOg8kHfOJmt0_kMERPmbMLa@mail.gmail.com>
Subject: Re: Support for Pinnacle PCTV Quatro stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Alexander Wirt <formorer@formorer.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 11, 2010 at 9:18 AM, Alexander Wirt <formorer@formorer.de> wrote:
> Hi,
>
> I recently got a Pinnacle PCTV Quatro stick which announces itself as PCTV
> 510e (ID: 2304:0242). It seemed that the em28xx-new driver had support for that
> stick, but as this is dead I know need some help. Is there anywhere support
> for this stick available?

Not currently.  The problem isn't the em28xx driver.  The device uses
the Micronas drx-k demodulator, for which there is not currently any
open source driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
