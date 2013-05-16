Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33512 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3EPHyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 03:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGGh5h1CKAUKwdM=Y7W5_ycDoucXLVF8vpxpEKJF_5naGzhPDQ@mail.gmail.com>
References: <CAGGh5h1CKAUKwdM=Y7W5_ycDoucXLVF8vpxpEKJF_5naGzhPDQ@mail.gmail.com>
Date: Thu, 16 May 2013 09:54:07 +0200
Message-ID: <CAGGh5h0zsTLGp-Bzy8FEpESqp7Vs2wUfpiu8Mqtu9Uy9EhwTyA@mail.gmail.com>
Subject: Re: omap3 : isp clock a : Difference between dmesg frequency and
 actual frequency with 3.9
From: jean-philippe francois <jp.francois@cynove.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/5/15 jean-philippe francois <jp.francois@cynove.com>:
> Hi,
>
> I am working on a dm3730 based camera.
> The sensor input clock is provided by the cpu via the CAM_XCLK pin.
> Here is the corresponding log :
>
> [    9.115966] Entering cam_set_xclk
> [    9.119781] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 24685714 Hz
> [    9.121337] ov10x33 1-0010: sensor id : 0xa630
> [   10.293640] Entering cam_set_xclk
> [   10.297149] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
> [   10.393920] Entering cam_set_xclk
> [   10.397979] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 24685714 Hz
>
> However, when mesured on the actual pin, the frequency is around 30 MHz
>
> The crystal clock is 19.2 MHz
> All this was correct with 3.6.11.

It seems the dpll4_m5_ck is not correctly set,
3.6.11 code in isp.c (without error handling)

    r = clk_set_rate(isp->clock[ISP_CLK_DPLL4_M5_CK],
              CM_CAM_MCLK_HZ/divisor);
    ...
    r = clk_enable(isp->clock[ISP_CLK_CAM_MCLK]);

3.9 code in isp.c (without error handling)

    r = clk_set_rate(isp->clock[ISP_CLK_CAM_MCLK],
              CM_CAM_MCLK_HZ/divisor);


>
> Jean-Philippe Francois
