Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38492 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdLFSGe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 13:06:34 -0500
Received: by mail-wm0-f46.google.com with SMTP id 64so8632906wme.3
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 10:06:34 -0800 (PST)
Date: Wed, 6 Dec 2017 19:06:26 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: Re: [PATCH for 4.15] ddbridge update to 0.9.32
Message-ID: <20171206190626.13a2daeb@audiostation.wuest.de>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 15 Oct 2017 22:51:49 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> For the 4.15 merge window. These patches update the mainline ddbridge
> driver to version 0.9.32, which was released ~3 weeks ago by upstream.
> 
> Nothing really fancy in this series, in fact upstream applied many of
> the changes that went into the mainline driver, which was released as
> 0.9.32. A few more changes were applied though, namely the CI DuoFlex/
> PCIe Bridge support has been split from -core (like ie. the MaxS8 card
> support), upstream named the files with the MaxS8 support code
> "-max.[c|h]" (thus the rename), and everything was made checkpatch-
> strict clean.
> 
> One condition in stv0910.c:read_status() was missing in mainline and
> is being added in 7/8.
> 
> The series was tested for bisect safety and checked with smatch.
> 
> Please pull for 4.15.

Ping.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
