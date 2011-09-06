Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57776 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1IFJKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 05:10:24 -0400
Received: by yie30 with SMTP id 30so3843064yie.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 02:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109061049.32114.laurent.pinchart@ideasonboard.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201109021327.59221.laurent.pinchart@ideasonboard.com>
	<CA+2YH7vEWijtbwuX_JsDwLtkGNLEbUBDBFadqT3wWtQWTJnfzA@mail.gmail.com>
	<201109061049.32114.laurent.pinchart@ideasonboard.com>
Date: Tue, 6 Sep 2011 11:10:23 +0200
Message-ID: <CA+2YH7uS4cvyCFj+uL-W-SCpSCcZBt0R-EVYHow2xXt1zEiJHg@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 10:49 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 05 September 2011 18:37:04 you wrote:
>> Yes that was the first thing i tried, anyway now i have it finally
>> working. Well at least yavta doesn't hang, do you know some
>> application to see raw yuv images?

I made a typo since in fact it's uyvy ( so a tool to covert from yuv
will not work ;) ), but if someone will ever need it:

ffmpeg -f rawvideo -pix_fmt uyvy422 -s 720x628 -i frame-000001.bin frame-1.png

Enrico
