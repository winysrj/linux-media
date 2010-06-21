Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:30943 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab0FUP1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 11:27:42 -0400
Received: by ey-out-2122.google.com with SMTP id 25so336955eya.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 08:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277132966.27109.24.camel@phat>
References: <1277132966.27109.24.camel@phat>
Date: Mon, 21 Jun 2010 11:22:16 -0400
Message-ID: <AANLkTil3akZ0OAahETLyHv9Wc0eG3UrEz3RAmsg7GSlU@mail.gmail.com>
Subject: Re: How to use aux input on ATI TV Wonder 600 USB?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Freitas <sflist@ihonk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 11:09 AM, Steve Freitas <sflist@ihonk.com> wrote:
> Hi all,
>
> I have an ATI TV Wonder 600 USB and have successfully used it for its
> DVB features, thanks to the work of many of you on this list. However,
> this device also has an auxiliary s-video/composite input[1] which I'd
> like to use in VLC, and I can't figure out how. Is there any capability
> in the driver to switch to that?
>
> I'm using kernel 2.6.32 on Debian, with firmware xc3028L-v36.fw. The
> device's USB id is 0438:b002.
>
> I'm happy to provide any other logs or info requested and appreciate any
> help I can get.

Yes, it's fully supported.  But bear in mind it's an analog input, so
you need to use a V4L application as opposed to something designed for
DVB.  Once you use an analog app (such as tvtime), just toggle over to
input 1 for composite or input 2 for S-Video (input zero is the analog
tuner input).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
