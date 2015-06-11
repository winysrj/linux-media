Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:32785 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbbFKTqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 15:46:48 -0400
Received: by qkhg32 with SMTP id g32so7669224qkh.0
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 12:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
References: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
Date: Thu, 11 Jun 2015 15:46:47 -0400
Message-ID: <CALzAhNWPXyBWY-JDg8zcBNpnf75Fcn26-aDNwC03HpgbBc8i1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] saa7164: change Si2168 reglen to 0 bit
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 6, 2015 at 3:44 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
> The i2c_reg_len for Si2168 should be 0 for correct I2C communication.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

Tested-By: Steven Toth <stoth@kernellabs.com>

Checked with a HVR-2205 and a HVR-2215, firmware loads as expected.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
