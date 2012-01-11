Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58642 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2AKQh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:37:56 -0500
Received: by vbbfc26 with SMTP id fc26so644897vbb.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:37:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
References: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
Date: Wed, 11 Jan 2012 11:37:55 -0500
Message-ID: <CAGoCfiy0zaUCUCU7fF=pdetc1TwgXAUCTLi3JM7nCLM8z+rdYg@mail.gmail.com>
Subject: Re: "cannot allocate memory" with IO_METHOD_USERPTR
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Christopher Peters <cpeters@ucmo.edu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:28 AM, Christopher Peters <cpeters@ucmo.edu> wrote:
> So as I said in my previous email, I got video out of my card.  Now
> I'm trying to capture video using a piece of software called
> "openreplay".  Its v4l2 capture code is based heavily on the capture
> example at http://v4l2spec.bytesex.org/spec/capture-example.html, so I
> thought I'd try compiling the example code to see what I got.
>
> When I ran the capture example with this command-line: "
> ./capture_example -u" (to use application allocated buffers) I got:
>
> "VIDIOC_QBUF error 12, Cannot allocate memory"
>
> I'm running Mythbuntu 11.10, Ubuntu kernel 3.0.0-14-generic.  All
> CONFIG_*V4L* options are set to 'y' or 'm', and all modules matching
> "v4l2-*" are loaded.
>
> What do I need to do to make application allocated buffers work?

USERPTR buffers don't work with many drivers (for example, those that
use videobuf-vmalloc).  You should use the mmap method, which is
supported by every card I can think of.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
