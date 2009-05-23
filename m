Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:37228 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZEWOtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 10:49:09 -0400
Received: by fxm12 with SMTP id 12so404928fxm.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 07:49:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0905230704n4f8b725aj3dc3021187d5ae12@mail.gmail.com>
References: <d9def9db0905230704n4f8b725aj3dc3021187d5ae12@mail.gmail.com>
Date: Sat, 23 May 2009 16:49:10 +0200
Message-ID: <d9def9db0905230749r3e39de5m3f4e1c28c1d596bd@mail.gmail.com>
Subject: Re: [PATCH] em28xx device mode detection based on endpoints
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 4:04 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> Hi,
>
> for em28xx devices the device node detection can be based on the
> encoded endpoint address, for example EP 0x81 (USB IN, Interrupt),
> 0x82 (analog video EP), 0x83 (analog audio ep), 0x84 (mpeg-ts input
> EP).
> It is not necessary that digital TV devices have a frontend, the
> em28xx chip only specifies an MPEG-TS input EP.
>
> Following patch adds a check based on the Endpoints, although it might
> be extended that all devices match the possible devicenodes based on
> the endpoints, currently the driver registers an analog TV node by
> default for all unknown devices which is not necessarily correct, this
> patch disables the ATV node if no analog TV endpoint is available.
>

Signed-off-by: Markus Rechberger <mrechberger@gmail.com>

> best regards,
> Markus
>
