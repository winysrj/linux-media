Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50169 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934523AbaH0P06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 11:26:58 -0400
MIME-Version: 1.0
Message-ID: <trinity-94241b67-ba3b-473f-bc89-84fecd218ba9-1409153216294@3capp-gmx-bs58>
From: "Martin Hinteregger" <martin.hinti@gmx.at>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFI] OMAP4 ISS: l3_interrupt_handler Errors due to wrong
 initialized iss_fck?
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 Aug 2014 17:26:56 +0200
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get both CSI2 interfaces up and running through the ISS 
on the v3.16 kernel for the TI OMAP4 Blaze platform (omap4430 ES 2.3 
revision).

Trough a omap_device_build() call (using the "iss" omap_hwmod) I call the 
iss_probe function. It devm_clk_get's both the iss_ctrlclk and the iss_fck. 
Since I am building the kernel with the omap4-sdp-es23plus device tree 
appended, I figured I need to define the iss_fck in the omap44xx-clocks.dtsi 
file, right after the iss_ctrlclk, as following:

iss_fck: iss_fck {
	#clock-cells = <0>;
	compatible = "ti,gate-clock";
	clocks = <&ducati_clk_mux_ck>;
	ti,bit-shift = <1>;
	reg = <0x1020>;
};

For that, I used the information in [1], the TI clock tree tool and the 
Linux documentation.

Now the omap4iss_get() call throws L3 Standard Errors, right after the first 
time the interrupts, set in iss_enable_interrupts, occur. I am pretty sure the 
cause for that is a wrong initialization of the iss_fck (since I haven't 
changed much more), even though the kernel runs through and the 
"cat clk_summary ¦ grep iss" command in /sys/kernel/debug/clk/ writes:
iss_ctrlclk         0            1    96000000          0
iss_fck             0            1   400000000          0

Could there be an error in the device tree entry stated above? Or might I be 
missing something else? Has anyone ever enabled iss_fck through device tree?

BTW I've also added iss_fck as an opt_clk in omap_hwmod_44xx_data and added 
the clock to the ti_dt_clk struct.

Thanks,
Martin

[1] http://www.ti.com/pdfs/wtbu/OMAP4430_ES2.x_PUBLIC_TRM_vAJ.zip
