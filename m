Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50946 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969121AbdEAEnX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:43:23 -0400
Subject: Re: [PATCH] [media] pxa_camera: fix module remove codepath for v4l2
 clock
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <4391b498-0a75-ff42-6a7e-65aef0fada07@tul.cz>
 <87efwd1wus.fsf@belgarion.home> <c95ef700-d34d-5aa2-ef92-ad1aa7dd5a0d@tul.cz>
 <87a87111s6.fsf@belgarion.home>
Cc: mchehab@kernel.org, g.liakhovetski@gmx.de,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        slapin@ossfans.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <b9c94483-5990-9a3f-31d3-7b65e5ccac44@tul.cz>
Date: Mon, 1 May 2017 06:44:28 +0200
MIME-Version: 1.0
In-Reply-To: <87a87111s6.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 28.4.2017 v 08:31 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> I will post some other bugfixes (and feature adding) for pxa_camera soon. Do you wish to be CC'd? 
>>
>> P.S. Who is the the maintainer of pxa_camera BTW? Still Guennadi Liakhovetski?
> Euh no, that's me.

OK ... so when I remove the ov9640 driver from soc_camera (palmz72 and magician used it with soc_camera+pxa_camera) does that mean I will be its maintainer?

Petr
