Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:44317 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZG3Mdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 08:33:46 -0400
Received: by yxe26 with SMTP id 26so2440109yxe.4
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 05:33:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7140DD.7040405@iol.it>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <4A7140DD.7040405@iol.it>
Date: Thu, 30 Jul 2009 08:33:46 -0400
Message-ID: <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 30, 2009 at 2:42 AM, Valerio Messina<efa@iol.it> wrote:
 yesterday evening I downloaded the sources with mercurial, compiled and
> installed.
> Same result, from dmesg the firmware file 'xc3028-v27.fw' is missing.
> When I put it in /lib/firmware Kaffeine video/audio work, but no IR.
>
> ready to help in debugging,
> Valerio

You are correct that you will continue to see the message about
'xc3028-v27.fw' being missing until you install the firmware.  We do
not currently have the rights to redistribute it, which is why you
have to install it manually.

How are you testing the IR support?  And are you using the Terratec
remote control that came with the product?  Have you tried opening a
text editor, hitting the "1" key, and seeing if the character appears?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
