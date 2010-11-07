Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53129 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0KGSu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Nov 2010 13:50:57 -0500
Received: by wyb36 with SMTP id 36so2761453wyb.19
        for <linux-media@vger.kernel.org>; Sun, 07 Nov 2010 10:50:56 -0800 (PST)
Subject: Re:  IX2505V: i2c transfer error code ignored
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201011071457.14929.zzam@gentoo.org>
References: <201011071457.14929.zzam@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 18:50:50 +0000
Message-ID: <1289155850.4638.7.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-11-07 at 14:57 +0100, Matthias Schwarzott wrote:
> Hello Malcolm!
> 
> It seems that ix2505v driver ignores a i2c error in ix2505v_read_status_reg.
> This looks like a typing error using (ret = 1) instead of correct (ret == 1).
> 
> The attached patch fixes this.

Hi Matthias,

Thanks for picking that up.

Acked-by: Malcolm Priestley <tvboxspy@gmail.com>

Regards


Malcolm




