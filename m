Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36398 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbFKTse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 15:48:34 -0400
Received: by qkx62 with SMTP id 62so7652991qkx.3
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 12:48:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433576698-1780-2-git-send-email-olli.salonen@iki.fi>
References: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
	<1433576698-1780-2-git-send-email-olli.salonen@iki.fi>
Date: Thu, 11 Jun 2015 15:48:33 -0400
Message-ID: <CALzAhNV4zpNWjGs-bQ6S-JzReauFC69bwfi4JaQw+JhX3xNMOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "[media] saa7164: Improvements for I2C handling"
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 6, 2015 at 3:44 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
> This reverts commit ad90b6b0f10566d4a5546e27fe455ce3b5e6b6c7.
>
> This patch breaks I2C communication towards Si2168. After reverting and
> applying the other patch in this series the I2C communication is
> correct.

Tested-By: Steven Toth <stoth@kernellabs.com>

Checked with a HVR-2205 and a HVR-2215, firmware loads as expected.

Thanks for chasing this down Olli.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
