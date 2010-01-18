Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54115 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab0ARUIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 15:08:14 -0500
Received: by bwz19 with SMTP id 19so2083433bwz.28
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 12:08:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B54BEF9.6060501@arcor.de>
References: <4B547EBF.6080105@arcor.de>
	 <829197381001180743k789f336er2bb368f4c689a41@mail.gmail.com>
	 <4B54BEF9.6060501@arcor.de>
Date: Mon, 18 Jan 2010 15:08:10 -0500
Message-ID: <829197381001181208k29be4253l3644a63ace312988@mail.gmail.com>
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 3:05 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> I see. I have set for test "max_len" to 3500 . So can send after main
> firmware wrote (3411 byte) a quitting request send (base firmware is
> 9144 byte).

It is highly unlikely that the tm6010 can do 3500 at a time.  Try
someting more reasonable like "32" or "64".

> Is it true that the tuner output frequency and the demodulator input frequency equal is?

Yes, typically the IF out of the tuner should match the IF on the demodulator.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
