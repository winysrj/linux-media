Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46306 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2CUAFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 20:05:13 -0400
Received: by obbeh20 with SMTP id eh20so315081obb.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 17:05:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Mar 2012 21:05:13 -0300
Message-ID: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
Subject: [Q] v4l buffer format inside isoc
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm a little lost while writing a driver for an easycap device
(saa7113 capture device).
I have my isoc handler, and the isoc urb flying OK.
I also have the videobuf2 queue setup (or at least I think so), and I understand
I need to call vb2_buffer_done() with a filled buffer.

What I DON'T understand is how should I fill such buffer?
I mean, what *format* comes inside the isoc buffer?

Should I look at saa7113 datasheet?
Should I base in em28xx?

I'm sorry to ask such a generic question.
Perhaps, someone cares enough to give me a hint.

Thanks,
Ezequiel.
