Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:52796 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164118AbdD1Gb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 02:31:29 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@kernel.org, g.liakhovetski@gmx.de,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] pxa_camera: fix module remove codepath for v4l2 clock
References: <4391b498-0a75-ff42-6a7e-65aef0fada07@tul.cz>
        <87efwd1wus.fsf@belgarion.home>
        <c95ef700-d34d-5aa2-ef92-ad1aa7dd5a0d@tul.cz>
Date: Fri, 28 Apr 2017 08:31:21 +0200
In-Reply-To: <c95ef700-d34d-5aa2-ef92-ad1aa7dd5a0d@tul.cz> (Petr Cvek's
        message of "Fri, 28 Apr 2017 06:51:56 +0200")
Message-ID: <87a87111s6.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> I will post some other bugfixes (and feature adding) for pxa_camera soon. Do you wish to be CC'd? 
>
> P.S. Who is the the maintainer of pxa_camera BTW? Still Guennadi Liakhovetski?
Euh no, that's me.

I had submitted a patch for that here :
  https://patchwork.kernel.org/patch/9316499

Hans, do you want to pick it up ?

Cheers.

-- 
Robert
