Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og117.obsmtp.com ([64.18.1.39]:52653 "HELO
	exprod6og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751745Ab2AKQik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:38:40 -0500
Received: by eaao10 with SMTP id o10so268155eaa.10
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:38:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
References: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
Date: Wed, 11 Jan 2012 10:38:37 -0600
Message-ID: <CAPc4S2ZXE-vveYsg5Lq1JNjnFRqM4CQCNXmcR7Lfxmcg+0Rqsg@mail.gmail.com>
Subject: Re: "cannot allocate memory" with IO_METHOD_USERPTR
From: Christopher Peters <cpeters@ucmo.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The board is a generic saa7134-based board, and the driver has been
forced to treat it as an "AVerMedia DVD EZMaker" (i.e. the option
"card=33" has been passed to the module)

On Wed, Jan 11, 2012 at 10:28 AM, Christopher Peters <cpeters@ucmo.edu> wrote:
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


-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
