Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61498 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:22:06 -0400
Received: by mail-qa0-f42.google.com with SMTP id k15so1985356qaq.29
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 06:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU437-SMTP74F4D6277B11F3F5F92D16BA900@phx.gbl>
References: <1414268243-29514-1-git-send-email-mkrufky@linuxtv.org>
	<BLU437-SMTP74F4D6277B11F3F5F92D16BA900@phx.gbl>
Date: Thu, 30 Oct 2014 09:22:03 -0400
Message-ID: <CAGoCfiyT3TMzsLk81d-1XVtpw2XyBP8tfs_THd6Hhzux_f_hUA@mail.gmail.com>
Subject: Re: [PATCH 2/3] xc5000: add IF output level control
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@hotmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Richard Vollkommer <linux@hauppauge.com>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 25, 2014 at 4:17 PM, Michael Krufky <mkrufky@hotmail.com> wrote:
> From: Richard Vollkommer <linux@hauppauge.com>
>
> Adds control of the IF output level to the xc5000 tuner
> configuration structure.  Increases the IF level to the
> demodulator to fix failure to lock and picture breakup
> issues (with the au8522 demodulator, in the case of the
> Hauppauge HVR950Q).
>
> This patch works with all XC5000 firmware versions.
>
> Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
