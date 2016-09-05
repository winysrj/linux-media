Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754579AbcIEIZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 04:25:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success
Date: Mon, 05 Sep 2016 11:25:46 +0300
Message-ID: <2306869.36BMUujrVm@avalon>
In-Reply-To: <CAMuHMdUzEsPNuqTn0pc0SwocoT3o5c0bxtrwKvUxJ6VvKRS7Yg@mail.gmail.com>
References: <1470757001-4333-1-git-send-email-geert+renesas@glider.be> <9895129.d3fHn4vy22@avalon> <CAMuHMdUzEsPNuqTn0pc0SwocoT3o5c0bxtrwKvUxJ6VvKRS7Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 05 Sep 2016 10:20:52 Geert Uytterhoeven wrote:
> On Mon, Sep 5, 2016 at 10:17 AM, Laurent Pinchart wrote:
> >> BTW, it seems I missed a few more s2ram resume errors:
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fe920000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fe960000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fe9a0000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fe9b0000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fe9c0000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fea20000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fea28000.vsp failed to resume noirq: error -13
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
> >>     PM: Device fea30000.vsp failed to resume noirq: error -13
> >>     vsp1 fea38000.vsp: failed to reset wpf.0
> >>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -110
> >>     PM: Device fea38000.vsp failed to resume noirq: error -110
> >> 
> >> -13 == -EACCES, returned by rcar_fcp_enable() as pm_runtime_get_sync()
> >> is called too early during system resume,
> > 
> > Do you have a fix for this ? :-)
> 
> Unfortuately not.

Is this caused by the fact that pm_runtime_get_sync() is called on the FCP 
device before the FCP gets system-resumed ? Lovely PM order dependency :-/

-- 
Regards,

Laurent Pinchart

