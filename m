Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35468 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1IEQhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 12:37:05 -0400
Received: by yie30 with SMTP id 30so3477640yie.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 09:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109021327.59221.laurent.pinchart@ideasonboard.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201109012014.32996.laurent.pinchart@ideasonboard.com>
	<CA+2YH7s9EEQi55TbzhE7yHdFB196t5g24Za0WJbWut+SzZHv2A@mail.gmail.com>
	<201109021327.59221.laurent.pinchart@ideasonboard.com>
Date: Mon, 5 Sep 2011 18:37:04 +0200
Message-ID: <CA+2YH7vEWijtbwuX_JsDwLtkGNLEbUBDBFadqT3wWtQWTJnfzA@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 2, 2011 at 1:27 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 02 September 2011 11:02:23 Enrico wrote:
>> Right now my problem is that i can't get the isp to generate
>> interrupts, i think there is some isp configuration error.
>
> If your device generates interlaced images that's not surprising, as the CCDC
> will only receive half the number of lines it expects.

Yes that was the first thing i tried, anyway now i have it finally
working. Well at least yavta doesn't hang, do you know some
application to see raw yuv images?

Now the problem is that the fix is weird...as you suggested you must
use half height values for VD0 and VD1 (2/3) interrupts, problem is
that it only works if you DISABLE vd1 interrupt.
If it is enabled the vd1_isr is run (once) and nothing else happens.

Enrico
