Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47587 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3EPLUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 07:20:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: omap3 : isp clock a : Difference between dmesg frequency and actual frequency with 3.9
Date: Thu, 16 May 2013 13:21:12 +0200
Message-ID: <4943563.lUEuHDFNBN@avalon>
In-Reply-To: <CAGGh5h3cFqCyjhncLTSfuL+vceO6CWDUTWgBsLGW=-spn6Z8qA@mail.gmail.com>
References: <CAGGh5h1CKAUKwdM=Y7W5_ycDoucXLVF8vpxpEKJF_5naGzhPDQ@mail.gmail.com> <CAGGh5h3cFqCyjhncLTSfuL+vceO6CWDUTWgBsLGW=-spn6Z8qA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Thursday 16 May 2013 10:21:14 jean-philippe francois wrote:
> 2013/5/15 jean-philippe francois <jp.francois@cynove.com>:
> > Hi,
> > 
> > I am working on a dm3730 based camera.
> > The sensor input clock is provided by the cpu via the CAM_XCLK pin.
> > Here is the corresponding log :
> > 
> > [    9.115966] Entering cam_set_xclk
> > [    9.119781] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> > 24685714 Hz
> > [    9.121337] ov10x33 1-0010: sensor id : 0xa630
> > [   10.293640] Entering cam_set_xclk
> > [   10.297149] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz
> > [   10.393920] Entering cam_set_xclk
> > [   10.397979] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> > 24685714 Hz
> > 
> > However, when mesured on the actual pin, the frequency is around 30 MHz
> > 
> > The crystal clock is 19.2 MHz
> > All this was correct with 3.6.11.
> 
> Sorry for the resend, wrong tab and enter key sequence in gmail ...
> 
> It seems the dpll4_m5_ck is not correctly set,
> 3.6.11 code in isp.c (without error handling)
> 
>     r = clk_set_rate(isp->clock[ISP_CLK_DPLL4_M5_CK],
>               CM_CAM_MCLK_HZ/divisor);
>     ...
>     r = clk_enable(isp->clock[ISP_CLK_CAM_MCLK]);
> 
> 3.9 code in isp.c (without error handling)
> 
>     r = clk_set_rate(isp->clock[ISP_CLK_CAM_MCLK],
>               CM_CAM_MCLK_HZ/divisor);
> 
>     r = clk_prepare_enable(isp->clock[ISP_CLK_CAM_MCLK]);
> 
> The PLL settings ie multiplier and divisor are the same in each case,
> but the dmesg output differ :
> Here is what happens when isp_enable_clock is called on 3.6
> 
> 3.6
>     [   10.133697] Entering cam_set_xclk
>     [   10.137573] clock: clksel_round_rate_div: dpll4_m5_ck
> target_rate 172800000
>     [   10.137573] clock: new_div = 5, new_rate = 172800000
>     [   10.137603] clock: dpll4_m5_ck: set rate to 172800000
>     [   10.138061] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> 24685714 Hz
> 
> 3.9
>     [    9.095581] Entering cam_set_xclk
>     [    9.102661] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to
> 24685714 Hz
> 
> So the frequency setting register are correctly set, but the actual
> output frequency is not.
> maybe dpll4 is not correctly locked ? I will also check
> isp_enable_clock is really called.
> But I suppose it is, because except for the frequency, everything is
> working correctly.

Does the following patch fix the issue ?

commit 577f8ea9ba7b1276096713b8148b3a8fca96d805
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Thu May 16 13:15:40 2013 +0200

    ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
    
    Commit 7b2e1277598e4187c9be3e61fd9b0f0423f97986 ("ARM: OMAP3: clock:
    Back-propagate rate change from cam_mclk to dpll4_m5") enabled clock
    rate back-propagation from cam_mclk do dpll4_m5 on OMAP3630 only.
    Perform back-propagation on other OMAP3 platforms as well.
    
    Reported-by: Jean-Philippe François <jp.francois@cynove.com>
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 4579c3c..c21065a 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -418,7 +418,8 @@ static struct clk_hw_omap dpll4_m5x2_ck_hw = {
 	.clkdm_name	= "dpll4_clkdm",
 };
 
-DEFINE_STRUCT_CLK(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names, dpll4_m5x2_ck_ops);
+DEFINE_STRUCT_CLK_FLAGS(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names,
+			dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
 
 static struct clk dpll4_m5x2_ck_3630 = {
 	.name		= "dpll4_m5x2_ck",


-- 
Regards,

Laurent Pinchart

