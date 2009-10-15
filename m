Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:46480 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbZJOWA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 18:00:59 -0400
Received: by pxi42 with SMTP id 42so1138784pxi.5
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 15:00:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Oct 2009 19:00:23 -0300
Message-ID: <36be2c7a0910151500k847735dub3e1a8547f913e8c@mail.gmail.com>
Subject: Possible bug on libv4l read() emulation
From: Pablo Baena <pbaena@gmail.com>
To: linux-media@vger.kernel.org
Cc: Pablo Baena <pbaena@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a program where I use libv4l's read() emulation for simplicity.
But with most v4l2 webcams I've tried, I get kernel panics.

I have pics of the message if anyone cares to see them, I don't want
to flood the mailing list.

Basically, the names I see in the kernel panic from a uvcvideo card is:

uvc_queue_next_buffer
__bad_area_no_semaphore
do_page_fault

And a lot more.

TIA.
