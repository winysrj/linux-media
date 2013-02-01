Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37625 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3BALom (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 06:44:42 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so470576wid.6
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 03:44:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130201060747.615e545c@redhat.com>
References: <CAJ_iqtYTjVdx0rcx3RTbGPqy_eiUX_9VJAxvo--fsLvaJh=Q5g@mail.gmail.com>
	<20130201060747.615e545c@redhat.com>
Date: Fri, 1 Feb 2013 12:44:39 +0100
Message-ID: <CAJ_iqtbaqW9iKj_oqdwK69Dq746UMSuGecOtMYf5tThk1r=K0g@mail.gmail.com>
Subject: Re: media_build: getting a TerraTec H7 working?
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Feb 1, 2013 at 9:07 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Well, I prefer to not use w_scan for DVB-C. It will take a long time to
> run, as it will try a large number of possibilities and still it might
> not find the channels, if your cable operator is using some weird setup


I don't think my cable operator is doing anything weird. As I wrote in
my original post: " (using a different DVBC-adapter, w_scan finds
almost 200 channels)".
FWIW, w_scan completes in about 30 minutes here.

>
> w_scan by default tries only QAM-64 and QAM-256, as those are the typical
> modulation types used, but it is up to your cable operator to decide. They
> might be doing something weird.

See my comment above; w_scan works with another DVB-C adapter, and
finds almost 200 channels.
Why wouldn't it work with the H7?

> It should be noticed that DVB-C2 is not supported by this frontend.

Noted.
Not that I think it matters for me.


-- 
Regards,
Torfinn Ingolfsen
