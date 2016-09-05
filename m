Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34133 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754902AbcIEItL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 04:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <2306869.36BMUujrVm@avalon>
References: <1470757001-4333-1-git-send-email-geert+renesas@glider.be>
 <9895129.d3fHn4vy22@avalon> <CAMuHMdUzEsPNuqTn0pc0SwocoT3o5c0bxtrwKvUxJ6VvKRS7Yg@mail.gmail.com>
 <2306869.36BMUujrVm@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 5 Sep 2016 10:49:10 +0200
Message-ID: <CAMuHMdUeu8-Qrg2TRjuVYsS59G54up7NC2pee46vrBYWCSjB2g@mail.gmail.com>
Subject: Re: [PATCH] [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0
 on success
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Sep 5, 2016 at 10:25 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 05 Sep 2016 10:20:52 Geert Uytterhoeven wrote:
>> On Mon, Sep 5, 2016 at 10:17 AM, Laurent Pinchart wrote:
>> >> BTW, it seems I missed a few more s2ram resume errors:
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fe920000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fe960000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fe9a0000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fe9b0000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fe9c0000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fea20000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fea28000.vsp failed to resume noirq: error -13
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
>> >>     PM: Device fea30000.vsp failed to resume noirq: error -13
>> >>     vsp1 fea38000.vsp: failed to reset wpf.0
>> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -110
>> >>     PM: Device fea38000.vsp failed to resume noirq: error -110
>> >>
>> >> -13 == -EACCES, returned by rcar_fcp_enable() as pm_runtime_get_sync()
>> >> is called too early during system resume,
>> >
>> > Do you have a fix for this ? :-)
>>
>> Unfortuately not.
>
> Is this caused by the fact that pm_runtime_get_sync() is called on the FCP
> device before the FCP gets system-resumed ? Lovely PM order dependency :-/

It's called from resume_noirq. IIRC, it's called a second time from resume.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
