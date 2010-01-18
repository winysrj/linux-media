Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53776 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab0ARPQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 10:16:58 -0500
Received: by fxm25 with SMTP id 25so551320fxm.21
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 07:16:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
	 <829197380912220750j116894baw8343010b123f929@mail.gmail.com>
	 <ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
	 <ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
Date: Mon, 18 Jan 2010 10:16:54 -0500
Message-ID: <829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com>
Subject: Re: em28xx driver - xc3028 tuner - readreg error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 10:01 AM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Hi all,
>
> I am still having problem using v4l-dvb drivers with Terratec Cinergy T USB XS.
> As reported in first mail, I am using the last version of v4l-dvb
> drivers with few lines adjustment in order to make this driver to
> enable dvb for my dvb only device (this because official v4l-dvb
> driver actually doesn't support my device at all)
> I have cleaned my distro (openSuse 11.2 x86-64) about all the v4l
> modules provided by distro's repositories, and I compiled modified
> v4l-dvb source.
> So acutally I am using a cleaned version of v4l-dvb.
>
> But the
> [ 1483.314420] zl10353_read_register: readreg error (reg=127, ret==-19)
> [ 1483.315166] mt352_read_register: readreg error (reg=127, ret==-19)
> error isn't solved yet.
> Could it be related to the firmware I am using?

No, this has nothing to do with firmware.  It is probably an issue
where the gpio configuration is wrong and the demod is being held in
reset (hence it won't respond to i2c commands).

The 0ccd:0043 is on my todo list of devices to work on (they sent me a
sample board), although it's not the highest priority on my list given
how old it is.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
