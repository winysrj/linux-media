Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:34521 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbKOULY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 15:11:24 -0500
Received: by ykfs79 with SMTP id s79so210029269ykf.1
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 12:11:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhJqAUsFKYvHQ=fgLyOVS657HQrOXa8U5XW4gbfKZpw5_g@mail.gmail.com>
References: <CAJ2oMh+vDtNv=hmtZ9Be=9FcUEezB=70vdrq=GpDiJt7aQ2cAA@mail.gmail.com>
	<CAJ2oMhJqAUsFKYvHQ=fgLyOVS657HQrOXa8U5XW4gbfKZpw5_g@mail.gmail.com>
Date: Sun, 15 Nov 2015 15:11:23 -0500
Message-ID: <CAGoCfiz7rJcn=vDTrFmQNF2ERjzxPqRanRbZtPM2GCBpqBSWgw@mail.gmail.com>
Subject: Re: ivtv: PVR family datasheet ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ran Shalit <ranshalit@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I actually refer to CX23418 chip, which I don't find its datasheet (I
> saw in code that cx18 can work in YUV raw capture, so I wanted to
> verify that CX23418 can capture YUV raw format).

The cx23418 datasheets are not publicly available, although I have
them under NDA and can likely answer specific questions if you have
any.

Yes, the 418 can capture both raw YUV format and compressed MPEG2, and
it's supported under Linux assuming you're using a card such as the
HVR-1600.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
