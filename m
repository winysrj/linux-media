Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63948 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2AZPSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 10:18:13 -0500
Received: by vbbfc26 with SMTP id fc26so451583vbb.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 07:18:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F213FEF.8030309@iki.fi>
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
	<4F2117D6.20702@iki.fi>
	<CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
	<4F213FEF.8030309@iki.fi>
Date: Thu, 26 Jan 2012 10:18:12 -0500
Message-ID: <CAGoCfiwxyExePmtWRP_FVdoXA1wY2egg8b72dO878MtTF5iB3g@mail.gmail.com>
Subject: Re: 290e locking issue
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Claus Olesen <ceolesen@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 26, 2012 at 6:58 AM, Antti Palosaari <crope@iki.fi> wrote:
> I think it is maybe some incapability of em28xx driver. Maybe it could be
> something to do with USB HCI too...

>From a USB standpoint there isn't a whole lot the em28xx driver could
do wrong.  It's an isoc device, and perhaps it's not clearing it's
bandwidth reservation after streaming is done, but even in that case
it shouldn't prevent a disk from working since those are typically
bulk devices.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
