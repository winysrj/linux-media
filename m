Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34178 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbbHaMhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 08:37:05 -0400
Received: by ioeu67 with SMTP id u67so13768108ioe.1
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2015 05:37:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Aug 2015 15:37:04 +0300
Message-ID: <CAJ2oMhKMaEVvqenk99pm=cf9kq_xxJ4+-K1+0xruUrH=6G7XAg@mail.gmail.com>
Subject: muxing ES to mpeg-ts
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I would please like to ask what is a good choice for muxing ES to mpeg
transport stream. It is required to do this in application (muxing the
encoder output into mpeg-ts which is transffered in ethernet udp).

I know that both ffmpeg and opencaster can support this.

What do you think will be a good choice for this ? (simplicity to
integrate in code, latency, debug, etc)

Regards,
Ran
