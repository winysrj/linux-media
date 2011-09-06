Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52000 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1IFJEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 05:04:41 -0400
Received: by yxj19 with SMTP id 19so2806970yxj.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 02:04:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109061048.03550.laurent.pinchart@ideasonboard.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201109021327.59221.laurent.pinchart@ideasonboard.com>
	<CA+2YH7vEWijtbwuX_JsDwLtkGNLEbUBDBFadqT3wWtQWTJnfzA@mail.gmail.com>
	<201109061048.03550.laurent.pinchart@ideasonboard.com>
Date: Tue, 6 Sep 2011 11:04:40 +0200
Message-ID: <CA+2YH7v=g0rOgspQ-0=tNgQeL2yHoFh=Q1PxZdJfUFv-XhUJZQ@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 10:48 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 05 September 2011 18:37:04 Enrico wrote:
>> Now the problem is that the fix is weird...as you suggested you must
>> use half height values for VD0 and VD1 (2/3) interrupts, problem is
>> that it only works if you DISABLE vd1 interrupt.
>> If it is enabled the vd1_isr is run (once) and nothing else happens.
>
> Have you set VD0 at half height and VD1 at 1/3 height ?

Yes, i also tried some "offset" on vd1 / 3 to see if the vd0 interrupt
was just being lost but with no success.

Maybe disabling the ccdc ( __cdc_enable(.. , 0) ) in vd1_isr makes the
vd0 interrupt to not be triggered, i don't know...

Enrico
