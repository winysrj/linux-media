Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33420 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbcHWNMB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 09:12:01 -0400
MIME-Version: 1.0
In-Reply-To: <36812690.Ma8PvjacQ5@avalon>
References: <1470757001-4333-1-git-send-email-geert+renesas@glider.be> <36812690.Ma8PvjacQ5@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 23 Aug 2016 15:11:59 +0200
Message-ID: <CAMuHMdWoq+F6YWTEGtLc5G4PTQO=F19VaEire9JAr+0z7PxJ-g@mail.gmail.com>
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

On Wed, Aug 17, 2016 at 2:55 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 09 Aug 2016 17:36:41 Geert Uytterhoeven wrote:
>> When resuming from suspend-to-RAM on r8a7795/salvator-x:
>>
>>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
>>     PM: Device fe940000.fdp1 failed to resume noirq: error 1
>>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
>>     PM: Device fe944000.fdp1 failed to resume noirq: error 1
>>     dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns 1
>>     PM: Device fe948000.fdp1 failed to resume noirq: error 1
>>
>> According to its documentation, rcar_fcp_enable() returns 0 on success
>> or a negative error code if an error occurs.  Hence
>> fdp1_pm_runtime_resume() and vsp1_pm_runtime_resume() forward its return
>> value to their callers.
>>
>> However, rcar_fcp_enable() forwards the return value of
>> pm_runtime_get_sync(), which can actually be 1 on success, leading to
>> the resume failure above.
>>
>> To fix this, consider only negative values returned by
>> pm_runtime_get_sync() to be failures.
>>
>> Fixes: 7b49235e83b2347c ("[media] v4l: Add Renesas R-Car FCP driver")
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>>  drivers/media/platform/rcar-fcp.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/rcar-fcp.c
>> b/drivers/media/platform/rcar-fcp.c index
>> 0ff6b1edf1dbf677..7e944479205d4059 100644
>> --- a/drivers/media/platform/rcar-fcp.c
>> +++ b/drivers/media/platform/rcar-fcp.c
>> @@ -99,10 +99,16 @@ EXPORT_SYMBOL_GPL(rcar_fcp_put);
>>   */
>>  int rcar_fcp_enable(struct rcar_fcp_device *fcp)
>>  {
>> +     int error;
>
> I was going to write that the driver uses "ret" instead of "error" for integer
> status return values, but it doesn't as there no such value stored in a
> variable at all. I will thus argue that it will use that style later, so let's
> keep the style consistent with the to-be-written code if you don't mind :-)
>
> Apart from that,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> and applied to my tree.

Thanks!

Where exactly has this been applied?

>>       if (!fcp)
>>               return 0;
>>
>> -     return pm_runtime_get_sync(fcp->dev);
>> +     error = pm_runtime_get_sync(fcp->dev);
>> +     if (error < 0)
>> +             return error;
>> +
>> +     return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(rcar_fcp_enable);

BTW, it seems I missed a few more s2ram resume errors:

    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fe920000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fe960000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fe9a0000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fe9b0000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fe9c0000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fea20000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fea28000.vsp failed to resume noirq: error -13
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -13
    PM: Device fea30000.vsp failed to resume noirq: error -13
    vsp1 fea38000.vsp: failed to reset wpf.0
    dpm_run_callback(): pm_genpd_resume_noirq+0x0/0x90 returns -110
    PM: Device fea38000.vsp failed to resume noirq: error -110

-13 == -EACCES, returned by rcar_fcp_enable() as pm_runtime_get_sync()
is called too early during system resume,
-110 = ETIMEDOUT, returned by vsp1_device_init() due to the failure
to reset wpf.0.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
