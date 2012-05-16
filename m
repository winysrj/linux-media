Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51282 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2EPPOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 11:14:34 -0400
Received: by vbbff1 with SMTP id ff1so762139vbb.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 08:14:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <497D0E3C-3068-4E0C-AE16-625323D66402@pg.canterbury.ac.nz>
References: <497D0E3C-3068-4E0C-AE16-625323D66402@pg.canterbury.ac.nz>
Date: Wed, 16 May 2012 17:14:33 +0200
Message-ID: <CA+2YH7sMNmcEub539E8reAoRtH46PPRqfN=X3qhEuw_E2btLCA@mail.gmail.com>
Subject: Re: Status of gstreamer video capture/encoding
From: Enrico <ebutera@users.berlios.de>
To: Simon Knopp <simon.knopp@pg.canterbury.ac.nz>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 16, 2012 at 2:26 AM, Simon Knopp
<simon.knopp@pg.canterbury.ac.nz> wrote:
> Hi all,
>
> I am trying to understand the current state of video capture and encoding using gstreamer for kernels >= 2.6.39 on an OMAP3530.
>
> Currently on 2.6.34 (omap3-2.6.34-caspapx) I use essentially:
>        v4l2src ! TIVidenc1 codecName=h264enc ! rtph264pay ! udpsink
>
> 1)  As far as I understand, 'yavta' is currently the only way to capture from media-ctl-based cameras -- gstreamer's v4l2src doesn't work for these cameras. Is this correct?
>
> 2)  I have read that 'subdevsrc' or 'mcsrc' is capable of doing this [1], though I'm not sure whether they're somehow meego-specific. Has anyone tried these source elements on a Gumstix Overo?


I don't know the current situation, but up to some months ago v4l2src
was not working with media-ctl-based cameras. Never tried subdevsrc or
mcsrc.


> 3)  As far as using the DSP for encoding video, Last I heard no one had done it yet [2]. Has anyone had success with either 'gst-ti', 'gst-dsp', or 'gst-openmax' [3,4,5] on 3.x kernels?

Yes it works, i use gst-ti for video encoding with kernel 3.2
(omap3530+tvp5150).

Enrico
