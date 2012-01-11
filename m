Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:39445 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751608Ab2AKQaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:30:15 -0500
Received: by bkbzu5 with SMTP id zu5so1092324bkb.39
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:30:13 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Jan 2012 10:28:30 -0600
Message-ID: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
Subject: "cannot allocate memory" with IO_METHOD_USERPTR
From: Christopher Peters <cpeters@ucmo.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So as I said in my previous email, I got video out of my card.  Now
I'm trying to capture video using a piece of software called
"openreplay".  Its v4l2 capture code is based heavily on the capture
example at http://v4l2spec.bytesex.org/spec/capture-example.html, so I
thought I'd try compiling the example code to see what I got.

When I ran the capture example with this command-line: "
./capture_example -u" (to use application allocated buffers) I got:

"VIDIOC_QBUF error 12, Cannot allocate memory"

I'm running Mythbuntu 11.10, Ubuntu kernel 3.0.0-14-generic.  All
CONFIG_*V4L* options are set to 'y' or 'm', and all modules matching
"v4l2-*" are loaded.

What do I need to do to make application allocated buffers work?

-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
