Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54987 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaHaNcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 09:32:36 -0400
Received: by mail-pd0-f174.google.com with SMTP id ft15so4001491pdb.33
        for <linux-media@vger.kernel.org>; Sun, 31 Aug 2014 06:32:36 -0700 (PDT)
Message-ID: <540323F0.90809@gmail.com>
Date: Sun, 31 Aug 2014 22:32:32 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org>
In-Reply-To: <5402F91E.7000508@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,
thanks for the comment.

> it sounds wrong to export a second function besides tc90522_attach.
> This way there is a hard dependency of the bridge driver to the demod
> driver.
> In this case it is the only possible demod, but in general it violates
> the design of demod drivers and their connection to bridge drivers.

I agree. I missed that point.

> 
> si2168_probe at least has a solution for this:
> Write the pointer to the new i2c adapter into location stored in "struct
> i2c_adapter **" in the config structure.

I'll look into the si2168 code and update tc90522 in v3.

regards,
akihiro

