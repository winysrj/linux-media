Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39187 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2AZTlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 14:41:02 -0500
Received: by vbbfc26 with SMTP id fc26so705101vbb.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 11:41:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGa-wNNgaboTTOP8UgrrbDjJbrFokKhJ03wpwYWs+_9MVQh+-w@mail.gmail.com>
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
	<4F2117D6.20702@iki.fi>
	<CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
	<4F213FEF.8030309@iki.fi>
	<CAGa-wNO5GihQcxBF88yXC7B=PO3upw-pN5YGzJ5Rm_+Sji9iBg@mail.gmail.com>
	<4F21989A.9080300@iki.fi>
	<CAGa-wNNgaboTTOP8UgrrbDjJbrFokKhJ03wpwYWs+_9MVQh+-w@mail.gmail.com>
Date: Thu, 26 Jan 2012 14:41:00 -0500
Message-ID: <CAGoCfizeVjnctXU3W-vDUw+-jxQu1tgxSTw2LRA-ja+RJ5e_uw@mail.gmail.com>
Subject: Re: 290e locking issue
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Claus Olesen <ceolesen@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 26, 2012 at 2:25 PM, Claus Olesen <ceolesen@gmail.com> wrote:
> I just came to think of my old 800e because also it is a em28xx device
> and for what it is worth I just tried it and it does not exhibit the
> issue. it's dmesg is

Wow, that's *really* surprising (I did both the original em2874 driver
support as well as the 800e driver, and as a result am intimately
familiar with the differences).  I'm not sure what is going on there.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
