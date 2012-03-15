Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36192 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2CORPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:15:12 -0400
Received: by ghrr11 with SMTP id r11so3274523ghr.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 10:15:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F61FF2D.6010505@redhat.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
	<CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
	<CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
	<CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
	<CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com>
	<4F61C79E.6090603@redhat.com>
	<CALjTZvZR=Mr-eSVwy=Wd8ToikAX9bG23NLARRw_K0scT-_YeCg@mail.gmail.com>
	<4F61FF2D.6010505@redhat.com>
Date: Thu, 15 Mar 2012 14:15:11 -0300
Message-ID: <CALF0-+WJ9c579+=2QMamxpAngHJKWfZaWqOp_z=GvZKGy97VnA@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 3/15/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> If you won't take it, it is likely that some day someone will do it,
> but, as this is just a cleanup, the main developers won't likely
> have time for doing it, as they're generally busy adding support for
> new hardware.
>

I have no problem submitting the two patches in discussion.
(Actually, I've already wroten the first one).

If Rui wants to help me, it would be nice to get this tested,
since I don't have the necessary hardware.

One thing I haven't got clear is this: I've seen that ir_raw_init()
does not call request_module() directly but rather defers it
through a work queue.

I don't understand fully the rc code, but still I don't get what
happens if I need the raw decoders *now* (so to speak)
but the work queue hasn't been run yet?

Thanks,
Ezequiel.
