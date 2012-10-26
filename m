Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54703 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2JZJVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 05:21:32 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so239359wib.1
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2012 02:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025135047.30674062@redhat.com>
References: <1348831603-18007-1-git-send-email-javier.martin@vista-silicon.com>
	<20120929132556.22c48312@hpe.lwn.net>
	<CACKLOr0DQZ9q0yN7NEShAtEMaXf50HgWwaq2s1c84yAj7HShSw@mail.gmail.com>
	<20121025135047.30674062@redhat.com>
Date: Fri, 26 Oct 2012 11:21:31 +0200
Message-ID: <CACKLOr0dvarRhemat3a9JRuJ-132bg2+4-j9Bbat7_6EQMMFvA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ov7670: migrate this sensor and its users to ctrl framework.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	rusty@rustcorp.com.au, dsd@laptop.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


On 25 October 2012 17:50, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Hi Javier,
>
> Em Thu, 25 Oct 2012 15:27:08 +0200
> javier Martin <javier.martin@vista-silicon.com> escreveu:
>
>> Hi Mauro, Jon,
>> any more issues related with this series?
>
> Patch doesn't apply anymore:
>
> patching file drivers/media/i2c/ov7670.c
> Hunk #2 succeeded at 191 (offset -32 lines).
> Hunk #3 succeeded at 220 (offset -35 lines).
> Hunk #4 succeeded at 1062 (offset -153 lines).
> Hunk #5 succeeded at 1091 (offset -153 lines).
> Hunk #6 succeeded at 1127 (offset -153 lines).
> Hunk #7 succeeded at 1147 (offset -153 lines).
> Hunk #8 succeeded at 1195 (offset -153 lines).
> Hunk #9 succeeded at 1211 (offset -153 lines).
> Hunk #10 succeeded at 1237 (offset -153 lines).
> Hunk #11 succeeded at 1255 (offset -153 lines).
> Hunk #12 succeeded at 1351 (offset -153 lines).
> Hunk #13 FAILED at 1605.
> Hunk #14 FAILED at 1616.
> Hunk #15 succeeded at 1434 (offset -189 lines).
> 2 out of 15 hunks FAILED -- rejects in file drivers/media/i2c/ov7670.c
>
> Could you please rebase it? I tried to force its merge, but
> it seemed that the conflicts are not that trivial, so I prefer
> if you could do it and test if everything still applies.

You need to apply the series in the following order:

Firstly: [PATCH v2 0/5] media: ov7670: driver cleanup and support for ov7674.
Secondly: [PATCH v3 0/4] ov7670: migrate this sensor and its users to
ctrl framework.

This shouldn't cause any troubles. Otherwise, please let me know.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
