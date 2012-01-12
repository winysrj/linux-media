Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49441 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2ALO36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 09:29:58 -0500
Received: by qadb17 with SMTP id b17so344372qad.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 06:29:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0C3D1B.2010904@gmail.com>
References: <4F0C3D1B.2010904@gmail.com>
Date: Thu, 12 Jan 2012 14:29:57 +0000
Message-ID: <CAH4Ag-AYbVH-LgGBt0EVb_Z09qcem0_80=LZystDTw=t4egFBQ@mail.gmail.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
From: Simon Jones <sijones2010@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 January 2012 13:28, Jim Darby <uberscubajim@gmail.com> wrote:
> I've been using a PCTV Nanostick T2 USB DVB-T2 receiver (one of the few that
> supports DVB-T2) for over six months with a 3.0 kernel with no problems.
>

> Seeing the 3.2 kernel I thought I'd upgrade and now I seem to have hit a
> problem.
>

> This is running on a 32-bit system.
>
> Everything works fine if I boot with the 3.0.0 kernel.
>

I have this tuner in Arch x64, with 2 Dual DVB-T and a dual DVB-S2
(Tevii S660), kernel 3.2 rc7 working perfect.

I do have it in a usb3 port due to an issue with the usb drivers for
the motherboard I have, I found that there is bugs in the drivers for
usb2 chipset so the work around is I use usb3.

I have had this tuner work in 3.0 and 3.1 kernel as well, no issues....
