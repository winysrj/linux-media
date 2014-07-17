Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63191 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaGQSTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 14:19:13 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so6688989igc.6
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 11:19:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Jul 2014 02:19:13 +0800
Message-ID: <CAPPBsXWjpH6UJSoTT=XxX4HGtavrWKs0ShenwyvDyQ8fdvWDeg@mail.gmail.com>
Subject: RTL2836 analysis
From: yawoo <yawoogle@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to analyse my DTMB / DMB-TH TV tuner, and here is the components:
USB bridge: RTL2832P, Demod: RTL2836S, Tuner: FC0012

Thanks to Antti's analysis tool, I have generated some codes. I can
match parts of codes with Realtek original source code rtl2832u-2.2.2.
But the beginning codes I cannot really understand. What it actually
performs, such as power-on demod, tuner, or something else?

ret = rtl28xx_wr_regs(d, 0x2148, "\x10\x02", 2); // generated <--
usb_epa_fifo_reset():write_usb_sys_register(p_state,
RTD2831_RMAP_INDEX_USB_EPA_CTL, 0x0210)
ret = rtl28xx_wr_regs(d, 0x2148, "\x00\x00", 2); // generated <--
rtl2832u_power_ctrl():rtl28xx_wr_regs(d, USB_EPA_CTL, "\x00\x00", 2)
ret = rtl28xx_wr_regs(d, 0x300b, "\x02", 1); // generated <--
DEMOD_CTL1 (rtl2831u.c:rtl2831u_power_ctrl())
ret = rtl28xx_wr_regs(d, 0x3000, "\xa0", 1); // generated <--
DEMOD_CTL (#1010 0000)
ret = rtl28xx_wr_regs(d, 0x3000, "\x80", 1); // generated <--
DEMOD_CTL (#1000 0000): set BIT5 off
ret = rtl28xx_wr_regs(d, 0x3000, "\xa0", 1); // generated <--
DEMOD_CTL (#1010 0000): set BIT5 on
ret = rtl28xx_wr_regs(d, 0x3000, "\xa8", 1); // generated <--
DEMOD_CTL (#1010 1000): set BIT3 on
ret = rtl28xx_wr_regs(d, 0x3000, "\xe8", 1); // generated <--
DEMOD_CTL (#1110 1000): set BIT6 on
ret = rtl28xx_wr_regs(d, 0x3001, "\x09", 1); // generated <--
GPIO_OUTPUT_VAL (#0000 1001)
ret = rtl28xx_wr_regs(d, 0x3001, "\x29", 1); // generated <--
GPIO_OUTPUT_VAL (#0010 1001): set BIT5 on
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\x09", 1); // generated <--
GPIO_OUTPUT_VAL (#0000 1001): set BIT5 off
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\x08", 1); // generated <--
GPIO_OUTPUT_VAL (#0000 1000): set BIT0 off
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\x48", 1); // generated <--
GPIO_OUTPUT_VAL (#0100 1000): set BIT6 on
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated

Below the remaining parts of the codes that I have analysed:

ret = rtl2836_wr_regs(priv, 0x01, 0, "\x05", 1); // generated <--
demod_rtl2836:InitRegTable[] begin
ret = rtl2836_wr_regs(priv, 0x02, 0, "\x20", 1); // generated ...
ret = rtl2836_wr_regs(priv, 0x03, 0, "\x00", 1); // generated
ret = rtl2836_wr_regs(priv, 0x0e, 0, "\x25", 1); // generated
ret = rtl2836_wr_regs(priv, 0x11, 0, "\x53", 1); // generated
ret = rtl2836_wr_regs(priv, 0x12, 0, "\x91", 1); // generated
ret = rtl2836_wr_regs(priv, 0x16, 0, "\x03", 1); // generated
ret = rtl2836_wr_regs(priv, 0x19, 0, "\x19", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1b, 0, "\xcc", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1f, 0, "\x05", 1); // generated
ret = rtl2836_wr_regs(priv, 0x20, 0, "\x77", 1); // generated
ret = rtl2836_wr_regs(priv, 0x20, 0, "\x77", 1); // generated
ret = rtl2836_wr_regs(priv, 0x03, 1, "\x38", 1); // generated
ret = rtl2836_wr_regs(priv, 0x31, 1, "\x01", 1); // generated
ret = rtl2836_wr_regs(priv, 0x67, 1, "\x30", 1); // generated
ret = rtl2836_wr_regs(priv, 0x68, 1, "\x10", 1); // generated
ret = rtl2836_wr_regs(priv, 0x7f, 1, "\x05", 1); // generated
ret = rtl2836_wr_regs(priv, 0xda, 1, "\x91", 1); // generated
ret = rtl2836_wr_regs(priv, 0xdb, 1, "\x05", 1); // generated
ret = rtl2836_wr_regs(priv, 0x09, 2, "\x0a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x10, 2, "\x31", 1); // generated
ret = rtl2836_wr_regs(priv, 0x11, 2, "\x31", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1b, 2, "\x1e", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1e, 2, "\x3a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1f, 2, "\x1f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x21, 2, "\x3f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x24, 2, "\x01", 1); // generated
ret = rtl2836_wr_regs(priv, 0x27, 2, "\x17", 1); // generated
ret = rtl2836_wr_regs(priv, 0x31, 2, "\x35", 1); // generated
ret = rtl2836_wr_regs(priv, 0x32, 2, "\x3f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x4f, 2, "\x1a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5a, 2, "\x05", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5b, 2, "\x08", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5c, 2, "\x08", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5e, 2, "\xa8", 1); // generated
ret = rtl2836_wr_regs(priv, 0x70, 2, "\x0c", 1); // generated
ret = rtl2836_wr_regs(priv, 0x77, 2, "\x29", 1); // generated
ret = rtl2836_wr_regs(priv, 0x7a, 2, "\x2f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x81, 2, "\x0a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x8d, 2, "\x77", 1); // generated
ret = rtl2836_wr_regs(priv, 0x8e, 2, "\x87", 1); // generated
ret = rtl2836_wr_regs(priv, 0x93, 2, "\xff", 1); // generated
ret = rtl2836_wr_regs(priv, 0x94, 2, "\x03", 1); // generated
ret = rtl2836_wr_regs(priv, 0x9d, 2, "\xff", 1); // generated
ret = rtl2836_wr_regs(priv, 0x9e, 2, "\x03", 1); // generated
ret = rtl2836_wr_regs(priv, 0xa8, 2, "\xff", 1); // generated
ret = rtl2836_wr_regs(priv, 0xa9, 2, "\x03", 1); // generated
ret = rtl2836_wr_regs(priv, 0xa3, 2, "\x15", 1); // generated
ret = rtl2836_wr_regs(priv, 0x01, 3, "\x00", 1); // generated
ret = rtl2836_wr_regs(priv, 0x04, 3, "\x20", 1); // generated
ret = rtl2836_wr_regs(priv, 0x09, 3, "\x10", 1); // generated
ret = rtl2836_wr_regs(priv, 0x14, 3, "\xe4", 1); // generated
ret = rtl2836_wr_regs(priv, 0x15, 3, "\x62", 1); // generated
ret = rtl2836_wr_regs(priv, 0x16, 3, "\x8c", 1); // generated
ret = rtl2836_wr_regs(priv, 0x17, 3, "\x11", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1b, 3, "\x40", 1); // generated
ret = rtl2836_wr_regs(priv, 0x1c, 3, "\x14", 1); // generated
ret = rtl2836_wr_regs(priv, 0x23, 3, "\x40", 1); // generated
ret = rtl2836_wr_regs(priv, 0x24, 3, "\xd6", 1); // generated
ret = rtl2836_wr_regs(priv, 0x2b, 3, "\x60", 1); // generated
ret = rtl2836_wr_regs(priv, 0x2c, 3, "\x16", 1); // generated
ret = rtl2836_wr_regs(priv, 0x33, 3, "\x40", 1); // generated
ret = rtl2836_wr_regs(priv, 0x3b, 3, "\x44", 1); // generated
ret = rtl2836_wr_regs(priv, 0x43, 3, "\x41", 1); // generated
ret = rtl2836_wr_regs(priv, 0x4b, 3, "\x40", 1); // generated
ret = rtl2836_wr_regs(priv, 0x53, 3, "\x4a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x58, 3, "\x1c", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5b, 3, "\x5a", 1); // generated
ret = rtl2836_wr_regs(priv, 0x5f, 3, "\xe0", 1); // generated
ret = rtl2836_wr_regs(priv, 0x02, 4, "\x07", 1); // generated
ret = rtl2836_wr_regs(priv, 0x03, 4, "\x09", 1); // generated
ret = rtl2836_wr_regs(priv, 0x04, 4, "\x0b", 1); // generated
ret = rtl2836_wr_regs(priv, 0x05, 4, "\x0d", 1); // generated
ret = rtl2836_wr_regs(priv, 0x07, 4, "\x1f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x07, 4, "\x1f", 1); // generated
ret = rtl2836_wr_regs(priv, 0x0e, 4, "\x18", 1); // generated
ret = rtl2836_wr_regs(priv, 0x10, 4, "\x1c", 1); // generated
ret = rtl2836_wr_regs(priv, 0x12, 4, "\x1c", 1); // generated
ret = rtl2836_wr_regs(priv, 0x2f, 4, "\x00", 1); // generated
ret = rtl2836_wr_regs(priv, 0x30, 4, "\x20", 1); // generated
ret = rtl2836_wr_regs(priv, 0x31, 4, "\x40", 1); // generated
ret = rtl2836_wr_regs(priv, 0x3e, 4, "\x02", 1); // generated
ret = rtl2836_wr_regs(priv, 0x3e, 4, "\x02", 1); // generated
ret = rtl2836_wr_regs(priv, 0x3e, 4, "\x02", 1); // generated
ret = rtl2836_wr_regs(priv, 0x3f, 4, "\x10", 1); // generated ...
ret = rtl2836_wr_regs(priv, 0x4a, 4, "\x01", 1); // generated <--
demod_rtl2836:InitRegTable[] End
ret = rtl2836_wr_regs(priv, 0x50, 4, "\x8c", 1); // generated <--
demod_rtl2836:TsInterfaceInitTable[] Begin
ret = rtl2836_wr_regs(priv, 0x51, 4, "\x01", 1); // generated ...
ret = rtl2836_wr_regs(priv, 0x52, 4, "\x01", 1); // generated <--
demod_rtl2836:TsInterfaceInitTable[] End
ret = fc0013_writereg(priv, 0x09, 0x7e); // generated
ret = fc0013_writereg(priv, 0x06, 0x0b); // generated
ret = fc0013_writereg(priv, 0x09, 0x6e); // generated
ret = fc0013_writereg(priv, 0x06, 0x0a); // generated
ret = rtl2836_wr_regs(priv, 0x6a, 1, "\x0f", 1); // generated <--
rtl2836_SetIfFreqHz():
ret = rtl2836_wr_regs(priv, 0x31, 1, "\x01", 1); // generated <--
rtl2836_SetIfFreqHz():
ret = rtl2836_wr_regs(priv, 0x32, 1, "\x00", 1); // generated <--
rtl2836_SetIfFreqHz():
ret = rtl2836_wr_regs(priv, 0x33, 1, "\x00", 1); // generated <--
rtl2836_SetIfFreqHz():
ret = rtl2836_wr_regs(priv, 0x31, 1, "\x01", 1); // generated <--
rtl2836_SetIfFreqHz():
ret = fc0013_writereg(priv, 0x01, 0x05); // generated
ret = fc0013_writereg(priv, 0x02, 0x10); // generated
ret = fc0013_writereg(priv, 0x03, 0x00); // generated
ret = fc0013_writereg(priv, 0x04, 0x00); // generated
ret = fc0013_writereg(priv, 0x05, 0x0f); // generated
ret = fc0013_writereg(priv, 0x06, 0x00); // generated
ret = fc0013_writereg(priv, 0x07, 0x20); // generated
ret = fc0013_writereg(priv, 0x08, 0xff); // generated
ret = fc0013_writereg(priv, 0x09, 0x6e); // generated
ret = fc0013_writereg(priv, 0x0a, 0xb8); // generated
ret = fc0013_writereg(priv, 0x0b, 0x82); // generated
ret = fc0013_writereg(priv, 0x0c, 0xfc); // generated
ret = fc0013_writereg(priv, 0x0d, 0x06); // generated
ret = fc0013_writereg(priv, 0x0e, 0x00); // generated
ret = fc0013_writereg(priv, 0x0f, 0x00); // generated
ret = fc0013_writereg(priv, 0x10, 0x00); // generated
ret = fc0013_writereg(priv, 0x11, 0x02); // generated
ret = fc0013_writereg(priv, 0x12, 0x1f); // generated
ret = fc0013_writereg(priv, 0x13, 0x08); // generated
ret = fc0013_writereg(priv, 0x14, 0x00); // generated
ret = fc0013_writereg(priv, 0x15, 0x0c); // generated
ret = fc0013_writereg(priv, 0x10, 0x00); // generated
ret = fc0013_writereg(priv, 0x0d, 0x16); // generated
ret = fc0013_writereg(priv, 0x10, 0x0b); // generated
ret = fc0013_writereg(priv, 0x01, 0x04); // generated
ret = fc0013_writereg(priv, 0x02, 0x1e); // generated
ret = fc0013_writereg(priv, 0x03, 0x15); // generated
ret = fc0013_writereg(priv, 0x04, 0x55); // generated
ret = fc0013_writereg(priv, 0x05, 0x0f); // generated
ret = fc0013_writereg(priv, 0x06, 0x08); // generated
ret = fc0013_writereg(priv, 0x0e, 0x80); // generated
ret = fc0013_writereg(priv, 0x0e, 0x00); // generated
ret = fc0013_writereg(priv, 0x0e, 0x00); // generated
ret = fc0013_writereg(priv, 0x01, 0x04); // generated
ret = fc0013_writereg(priv, 0x02, 0x1e); // generated
ret = fc0013_writereg(priv, 0x03, 0x15); // generated
ret = fc0013_writereg(priv, 0x04, 0x55); // generated
ret = fc0013_writereg(priv, 0x05, 0x0f); // generated
ret = fc0013_writereg(priv, 0x06, 0x08); // generated
ret = fc0013_writereg(priv, 0x0e, 0x80); // generated
ret = fc0013_writereg(priv, 0x0e, 0x00); // generated
ret = fc0013_writereg(priv, 0x0e, 0x00); // generated
ret = rtl2836_wr_regs(priv, 0xf8, 3, "\x00", 1); // generated <--
rtl2832_set_parameters(): RTL2836 signal present
ret = rtl2836_wr_regs(priv, 0x4d, 3, "\x29", 1); // generated <--
rtl2832_set_parameters(): RTL2836 Hold Stage=9
ret = rtl2836_wr_regs(priv, 0x4e, 3, "\xa5", 1); // generated <--
rtl2832_set_parameters(): RTL2836 Hold Stage=9
ret = rtl2836_wr_regs(priv, 0x4f, 3, "\x94", 1); // generated <--
rtl2832_set_parameters(): RTL2836 Hold Stage=9
ret = rtl2836_wr_regs(priv, 0x15, 2, "\x0f", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x15, 7, 0, 0xf)
ret = rtl2836_wr_regs(priv, 0x1e, 2, "\x3a", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x1e, 6, 0, 0x3a)
ret = rtl2836_wr_regs(priv, 0x1f, 2, "\x19", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x1f, 5, 0, 0x19)
ret = rtl2836_wr_regs(priv, 0x23, 2, "\x1e", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x23, 4, 0, 0x1e)
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x00", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x0)
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x01", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x1)
ret = rtl2836_wr_regs(priv, 0x15, 2, "\x0f", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x15, 7, 0, 0xf)
ret = rtl2836_wr_regs(priv, 0x1e, 2, "\x3a", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x1e, 6, 0, 0x3a)
ret = rtl2836_wr_regs(priv, 0x1f, 2, "\x19", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x1f, 5, 0, 0x19)
ret = rtl2836_wr_regs(priv, 0x23, 2, "\x1e", 1); // generated <--
rtl2836_func2_Reset():SetRegMaskBits(pDemod, 0x23, 4, 0, 0x1e)
ret = fc0013_writereg(priv, 0x13, 0x10); // generated
ret = fc0013_writereg(priv, 0x13, 0x10); // generated
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x00", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x0)
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x01", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x1)
ret = rtl2836_wr_regs(priv, 0x4d, 3, "\x49", 1); // generated <--
rtl2836_scan_procedure(): RTL2836 Release Stage=9
ret = rtl2836_wr_regs(priv, 0x4e, 3, "\x29", 1); // generated <--
rtl2836_scan_procedure(): RTL2836 Release Stage=9
ret = rtl2836_wr_regs(priv, 0x4f, 3, "\x95", 1); // generated <--
rtl2836_scan_procedure(): RTL2836 Release Stage=9
ret = rtl2836_wr_regs(priv, 0x15, 2, "\x04", 1); // generated <--
rtl2836_func2_Update():SetRegMaskBits(pDemod, 0x15, 7, 0, 0x4)
ret = rtl2836_wr_regs(priv, 0x1e, 2, "\x0a", 1); // generated <--
rtl2836_func2_Update():SetRegMaskBits(pDemod, 0x1e, 6, 0, 0xa)
ret = rtl2836_wr_regs(priv, 0x1f, 2, "\x3f", 1); // generated <--
rtl2836_func2_Update():SetRegMaskBits(pDemod, 0x1f, 5, 0, 0x3f)
ret = rtl2836_wr_regs(priv, 0x23, 2, "\x1f", 1); // generated <--
rtl2836_func2_Update():SetRegMaskBits(pDemod, 0x23, 4, 0, 0x1f)
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x00", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x0)
ret = rtl2836_wr_regs(priv, 0x04, 0, "\x01", 1); // generated <--
rtl2836_SoftwareReset():SetRegBitsWithPage(pDemod, DTMB_SOFT_RST_N,
0x1)
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = fc0013_writereg(priv, 0x13, 0x10); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3001, "\xc8", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3004, "\x02", 1); // generated
ret = rtl28xx_wr_regs(d, 0x3003, "\xfd", 1); // generated
