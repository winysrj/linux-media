Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41209 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOL4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 06:56:17 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so8762137wiv.1
        for <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 03:56:16 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 15 Dec 2014 11:56:16 +0000
Message-ID: <CA+S3egD3p9p2MVNZqWAZ3zvcuJ3KQn9KDZp_Hm1im0NhiPfP3g@mail.gmail.com>
Subject: [tvtime] Broke support for cards with multiple numbers of the input
From: grigore calugar <zradu1100@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After commit:http://git.linuxtv.org/cgit.cgi/tvtime.git/commit/?id=c49ebc47c51e0bcf9e8c4403efdf0f31bf1b4479
support for support for cards with multiple numbers of the input is
broken. My tuner has 4 inputs and after this commit I can not select
any from OSD menu.
