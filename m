Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52995 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1IFKeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 06:34:12 -0400
Received: by gwaa12 with SMTP id a12so3364798gwa.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 03:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109061227.18685.laurent.pinchart@ideasonboard.com>
References: <1315303380-20698-1-git-send-email-javier.martin@vista-silicon.com>
	<201109061227.18685.laurent.pinchart@ideasonboard.com>
Date: Tue, 6 Sep 2011 12:34:10 +0200
Message-ID: <CACKLOr3SnRLD=dv6NgPZjwQ48gSH_vN9u5xVK4M-PnwDmDaK-A@mail.gmail.com>
Subject: Re: [PATCH] mt9p031: Do not use PLL if external frequency is the same
 as target frequency.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 September 2011 12:27, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Tuesday 06 September 2011 12:03:00 Javier Martin wrote:
>> This patch adds a check to see whether ext_freq and target_freq are equal
>> and, if true, PLL won't be used.
>
> Thanks for the patch.
>
> As you're touching PLL code, what about fixing PLL setup by computing
> parameters dynamically instead of using a table of hardcoded values ? :-)

Hi Laurent,
I'm not exactly struggling with PLL code right now. I've just get a
new prototype which provides an external 48MHz oscillator for the
clock. So, no need to use PLL there and thus the purpose of this
patch.

However, as you said, dynamic configuration of PLL is one of the
pending issues on the driver and I might address it myself in the
future, but it depends on requirements of the project.


Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
