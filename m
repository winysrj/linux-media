Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63685 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab2CMSDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 14:03:10 -0400
Received: by eekc41 with SMTP id c41so483412eek.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 11:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120313185037.4059a869@endymion.delvare>
References: <20120313185037.4059a869@endymion.delvare>
Date: Tue, 13 Mar 2012 13:57:19 -0400
Message-ID: <CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] dib0700: Drop useless check when remote key
 is pressed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2012 at 1:50 PM, Jean Delvare <khali@linux-fr.org> wrote:
> struct dvb_usb_device *d can never be NULL so don't waste time
> checking for this.
>
> Rationale: the urb's context is set when usb_fill_bulk_urb() is called
> in dib0700_rc_setup(), and never changes after that. d is dereferenced
> unconditionally in dib0700_rc_setup() so it can't be NULL or the
> driver would crash right away.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
> Devin, am I missing something?

I think this was just a case of defensive coding where I didn't want
to dereference something without validating the pointer first (out of
fear that it got called through some other code path that I didn't
consider).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
