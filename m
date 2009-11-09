Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57032 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZKIWRC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 17:17:02 -0500
Received: by bwz27 with SMTP id 27so3998275bwz.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 14:17:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091109215613.34D829C44F@smtp01.udag.de>
References: <20091109215613.34D829C44F@smtp01.udag.de>
Date: Mon, 9 Nov 2009 17:17:05 -0500
Message-ID: <829197380911091417k73feb40at7db0ad01ef79d23e@mail.gmail.com>
Subject: Re: Problems with Terratec Hybrid USB XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Sven Tischer <Sven@tischers.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 4:56 PM, Sven Tischer <Sven@tischers.net> wrote:
>
> Hello,
> i get this message while connecting my terratec Hybrid USB XS to Ubuntu 9.10

The support was added after 2.6.31 went out.  Install the latest
v4l-dvb code using the following instructions:
http://linuxtv.org/repo

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
