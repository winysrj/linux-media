Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53329 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2GFGry (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 02:47:54 -0400
Received: by wibhr14 with SMTP id hr14so478010wib.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 23:47:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120706064332.GA30009@pengutronix.de>
References: <1341556309-2934-1-git-send-email-javier.martin@vista-silicon.com>
	<20120706064332.GA30009@pengutronix.de>
Date: Fri, 6 Jul 2012 08:47:53 +0200
Message-ID: <CACKLOr09nCrfdu6CreRsBckzfaKDT1o7fhRXWZq-iwAKcDUAGg@mail.gmail.com>
Subject: Re: media: i.MX27: Fix emma-prp clocks in mx2_camera.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 July 2012 08:43, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Javier,
>
> On Fri, Jul 06, 2012 at 08:31:49AM +0200, Javier Martin wrote:
>> This driver wasn't converted to the new clock changes
>> (clk_prepare_enable/clk_disable_unprepare). Also naming
>> of emma-prp related clocks for the i.MX27 was not correct.
>
> Thanks for fixing this. Sorry for breaking this in the first place.
>
>> @@ -1668,12 +1658,26 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>>               goto exit;
>>       }
>>
>> -     pcdev->clk_csi = clk_get(&pdev->dev, NULL);
>> +     pcdev->clk_csi = devm_clk_get(&pdev->dev, NULL);
>>       if (IS_ERR(pcdev->clk_csi)) {
>>               dev_err(&pdev->dev, "Could not get csi clock\n");
>>               err = PTR_ERR(pcdev->clk_csi);
>>               goto exit_kfree;
>>       }
>> +     pcdev->clk_emma_ipg = devm_clk_get(&pdev->dev, "ipg");
>> +     if (IS_ERR(pcdev->clk_emma_ipg)) {
>> +             err = PTR_ERR(pcdev->clk_emma_ipg);
>> +             goto exit_kfree;
>> +     }
>> +     pcdev->clk_emma_ahb = devm_clk_get(&pdev->dev, "ahb");
>> +     if (IS_ERR(pcdev->clk_emma_ahb)) {
>> +             err = PTR_ERR(pcdev->clk_emma_ahb);
>> +             goto exit_kfree;
>> +     }
>
> So we have three clocks involved here, a csi ahb clock and two emma
> clocks. Can we rename the clocks to:
>
>         clk_register_clkdev(clk[csi_ahb_gate], "ahb", "mx2-camera.0");
>         clk_register_clkdev(clk[emma_ahb_gate], "emma-ahb", "mx2-camera.0");
>         clk_register_clkdev(clk[emma_ipg_gate], "emma-ipg", "mx2-camera.0");
>
> The rationale is that the csi_ahb_gate really is a ahb clock related to
> the csi whereas the emma clocks are normally for the emma device, but
> the csi driver happens to use parts of the emma.

Yes, I find it quite appealing. Let me send a new patch.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
