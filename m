Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36823 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0F2GdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 02:33:13 -0400
Received: by wwb18 with SMTP id 18so208595wwb.19
        for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 23:33:12 -0700 (PDT)
Date: Tue, 29 Jun 2010 09:32:55 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 2/2] V4L/DVB: radio-si4713: Add regulator framework
 support
Message-Id: <20100629093255.987259fd.jhnikula@gmail.com>
In-Reply-To: <1276452568-16366-2-git-send-email-jhnikula@gmail.com>
References: <1276452568-16366-1-git-send-email-jhnikula@gmail.com>
	<1276452568-16366-2-git-send-email-jhnikula@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Jun 2010 21:09:28 +0300
Jarkko Nikula <jhnikula@gmail.com> wrote:

> Convert the driver to use regulator framework instead of set_power callback.
> This with gpio_reset platform data provide cleaner way to manage chip VIO,
> VDD and reset signal inside the driver.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
> I don't have specifications for this chip so I don't know how long the
> reset signal must be active after power-up. I used 50 us from Maemo
> kernel sources for Nokia N900 and I can successfully enable-disable
> transmitter on N900 with vdd power cycling.
> ---

Ping? Any comments to these two Si4713 patches?


-- 
Jarkko
