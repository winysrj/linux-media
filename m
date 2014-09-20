Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3816 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaITJTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 05:19:47 -0400
Message-ID: <541D469B.4000306@xs4all.nl>
Date: Sat, 20 Sep 2014 11:19:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@maxsum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com>
In-Reply-To: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2014 05:32 AM, James Harper wrote:
> 
> My cx23885 based DViCO FusionHDTV DVB-T Dual Express2 (I submitted a
> patch for this a little while ago) has been working great but over
> the last few months it has started playing up. Nothing has really
> changed that I can put my finger on. Basically mythtv stops recording
> after a few minutes sometimes. Rarely when this happens I see some
> i2c errors but mostly not.
> 
> With cx23885 debug options turned on (debug=9 vbi_debug=9 v4l_debug=9
> video_debug=9 irq_debug=9 ci_dbg=9) it seems like the card just stops
> delivering buffers (see dmesg output following). If I stop mythtv,
> all the buffers are cancelled (cx23885_stop_dma()) etc, and then
> restarting mythtv will get the recording going again, for a short
> time (minutes).
> 
> Any suggestions to where I could start looking? Is it possible that
> my card itself is broken? (apart from this it's flawless).

I see nothing wrong in the log, but you can try to use the current media_tree
code. The cx23885's DMA engine has effectively been rewritten there, simplifying
the control flow.

See here for instructions on how to get and install that code:

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Regards,

	Hans

> 
> James
> 
> root@server:~# dmesg
> [ 3552.057910] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.057912] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.057913] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.057915] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc7f
> [ 3552.057948] cx23885[0]: cx23885_buf_prepare: ffff880052abd800
> [ 3552.057954] cx23885[0]: [ffff880052abd800/30] cx23885_buf_queue - append to active
> [ 3552.066217] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.066220] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.066222] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.066223] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.066225] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc80
> [ 3552.066227] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.066228] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.066232] cx23885[0]: [ffff8800c29a9000/31] wakeup reg=3200 buf=3200
> [ 3552.066260] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.066262] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.066264] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.066266] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.066268] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc80
> [ 3552.066270] cx23885[0]: cx23885_buf_prepare: ffff8800c29a9000
> [ 3552.066274] cx23885[0]: [ffff8800c29a9000/31] cx23885_buf_queue - append to active
> [ 3552.074568] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.074570] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.074572] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.074574] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.074576] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc81
> [ 3552.074577] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.074579] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.074582] cx23885[0]: [ffff88004c829c00/0] wakeup reg=3201 buf=3201
> [ 3552.074609] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.074611] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.074613] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.074615] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.074617] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc81
> [ 3552.074649] cx23885[0]: cx23885_buf_prepare: ffff88004c829c00
> [ 3552.074653] cx23885[0]: [ffff88004c829c00/0] cx23885_buf_queue - append to active
> [ 3552.082919] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.082922] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.082924] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.082925] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.082927] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc82
> [ 3552.082929] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.082930] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.082934] cx23885[0]: [ffff88004282a800/1] wakeup reg=3202 buf=3202
> [ 3552.082962] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.082965] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.082967] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.082969] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.082971] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc82
> [ 3552.082972] cx23885[0]: cx23885_buf_prepare: ffff88004282a800
> [ 3552.082976] cx23885[0]: [ffff88004282a800/1] cx23885_buf_queue - append to active
> [ 3552.091269] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.091272] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.091274] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.091276] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.091278] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc83
> [ 3552.091279] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.091281] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.091284] cx23885[0]: [ffff88004c9b8c00/2] wakeup reg=3203 buf=3203
> [ 3552.091318] cx23885[0]: cx23885_buf_prepare: ffff88004c9b8c00
> [ 3552.091322] cx23885[0]: [ffff88004c9b8c00/2] cx23885_buf_queue - append to active
> [ 3552.099619] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.099622] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.099624] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.099626] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.099627] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc84
> [ 3552.099629] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.099630] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.099634] cx23885[0]: [ffff88004c93c400/3] wakeup reg=3204 buf=3204
> [ 3552.099662] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.099665] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.099670] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.099673] cx23885[0]: cx23885_buf_prepare: ffff88004c93c400
> [ 3552.099678] cx23885[0]: [ffff88004c93c400/3] cx23885_buf_queue - append to active
> [ 3552.099683] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.099685] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc84
> [ 3552.107971] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.107974] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.107976] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.107978] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.107980] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc85
> [ 3552.107981] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.107983] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.107987] cx23885[0]: [ffff8800e0353c00/4] wakeup reg=3205 buf=3205
> [ 3552.108016] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.108019] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.108021] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.108023] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.108025] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc85
> [ 3552.108062] cx23885[0]: cx23885_buf_prepare: ffff8800e0353c00
> [ 3552.108067] cx23885[0]: [ffff8800e0353c00/4] cx23885_buf_queue - append to active
> [ 3552.116323] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.116325] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.116327] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.116329] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.116331] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc86
> [ 3552.116332] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.116334] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.116337] cx23885[0]: [ffff88001d534c00/5] wakeup reg=3206 buf=3206
> [ 3552.116367] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.116370] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.116372] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.116374] cx23885[0]: cx23885_buf_prepare: ffff88001d534c00
> [ 3552.116377] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.116378] cx23885[0]: [ffff88001d534c00/5] cx23885_buf_queue - append to active
> [ 3552.116382] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc86
> [ 3552.124673] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.124676] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.124678] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.124680] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.124682] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc87
> [ 3552.124684] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.124685] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.124689] cx23885[0]: [ffff8800e20c1400/6] wakeup reg=3207 buf=3207
> [ 3552.124728] cx23885[0]: cx23885_buf_prepare: ffff8800e20c1400
> [ 3552.124733] cx23885[0]: [ffff8800e20c1400/6] cx23885_buf_queue - append to active
> [ 3552.133024] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.133027] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.133029] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.133030] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.133032] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc88
> [ 3552.133034] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.133035] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.133039] cx23885[0]: [ffff8800e2011800/7] wakeup reg=3208 buf=3208
> [ 3552.133065] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.133068] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.133069] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.133071] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.133073] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc88
> [ 3552.133106] cx23885[0]: cx23885_buf_prepare: ffff8800e2011800
> [ 3552.133111] cx23885[0]: [ffff8800e2011800/7] cx23885_buf_queue - append to active
> [ 3552.141376] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.141379] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.141381] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.141383] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.141384] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc89
> [ 3552.141386] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.141388] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.141391] cx23885[0]: [ffff8800e08e8800/8] wakeup reg=3209 buf=3209
> [ 3552.141428] cx23885[0]: cx23885_buf_prepare: ffff8800e08e8800
> [ 3552.141432] cx23885[0]: [ffff8800e08e8800/8] cx23885_buf_queue - append to active
> [ 3552.149727] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.149730] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.149732] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.149733] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.149735] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8a
> [ 3552.149737] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.149738] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.149742] cx23885[0]: [ffff8800e1063400/9] wakeup reg=3210 buf=3210
> [ 3552.149772] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.149780] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.149782] cx23885[0]: cx23885_buf_prepare: ffff8800e1063400
> [ 3552.149787] cx23885[0]: [ffff8800e1063400/9] cx23885_buf_queue - append to active
> [ 3552.149795] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.149797] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.149799] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc8a
> [ 3552.158077] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.158080] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.158082] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.158083] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.158085] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8b
> [ 3552.158087] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.158088] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.158092] cx23885[0]: [ffff8800c2977800/10] wakeup reg=3211 buf=3211
> [ 3552.158131] cx23885[0]: cx23885_buf_prepare: ffff8800c2977800
> [ 3552.158135] cx23885[0]: [ffff8800c2977800/10] cx23885_buf_queue - append to active
> [ 3552.166429] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.166432] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.166434] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.166435] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.166437] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8c
> [ 3552.166439] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.166440] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.166444] cx23885[0]: [ffff8800c2b34000/11] wakeup reg=3212 buf=3212
> [ 3552.166482] cx23885[0]: cx23885_buf_prepare: ffff8800c2b34000
> [ 3552.166486] cx23885[0]: [ffff8800c2b34000/11] cx23885_buf_queue - append to active
> [ 3552.174780] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.174782] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.174784] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.174786] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.174788] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8d
> [ 3552.174790] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.174791] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.174795] cx23885[0]: [ffff8800e3a85c00/12] wakeup reg=3213 buf=3213
> [ 3552.174832] cx23885[0]: cx23885_buf_prepare: ffff8800e3a85c00
> [ 3552.174839] cx23885[0]: [ffff8800e3a85c00/12] cx23885_buf_queue - append to active
> [ 3552.183131] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.183133] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.183135] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.183137] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.183139] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8e
> [ 3552.183141] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.183142] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.183146] cx23885[0]: [ffff8800e2441000/13] wakeup reg=3214 buf=3214
> [ 3552.183182] cx23885[0]: cx23885_buf_prepare: ffff8800e2441000
> [ 3552.183186] cx23885[0]: [ffff8800e2441000/13] cx23885_buf_queue - append to active
> [ 3552.191480] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.191482] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.191484] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.191485] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.191487] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc8f
> [ 3552.191489] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.191490] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.191494] cx23885[0]: [ffff8800c25c2800/14] wakeup reg=3215 buf=3215
> [ 3552.191531] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2800
> [ 3552.191535] cx23885[0]: [ffff8800c25c2800/14] cx23885_buf_queue - append to active
> [ 3552.199832] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.199835] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.199837] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.199839] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.199841] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc90
> [ 3552.199843] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.199844] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.199848] cx23885[0]: [ffff8800e2b76c00/15] wakeup reg=3216 buf=3216
> [ 3552.199875] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.199878] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.199880] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.199882] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.199884] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc90
> [ 3552.199885] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76c00
> [ 3552.199889] cx23885[0]: [ffff8800e2b76c00/15] cx23885_buf_queue - append to active
> [ 3552.208182] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.208185] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.208187] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.208189] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.208191] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc91
> [ 3552.208192] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.208194] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.208197] cx23885[0]: [ffff8800e094a800/16] wakeup reg=3217 buf=3217
> [ 3552.208233] cx23885[0]: cx23885_buf_prepare: ffff8800e094a800
> [ 3552.208237] cx23885[0]: [ffff8800e094a800/16] cx23885_buf_queue - append to active
> [ 3552.216533] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.216536] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.216537] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.216539] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.216541] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc92
> [ 3552.216543] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.216544] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.216548] cx23885[0]: [ffff8800c25c2000/17] wakeup reg=3218 buf=3218
> [ 3552.216589] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2000
> [ 3552.216593] cx23885[0]: [ffff8800c25c2000/17] cx23885_buf_queue - append to active
> [ 3552.224885] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.224888] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.224890] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.224892] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.224894] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc93
> [ 3552.224896] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.224897] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.224901] cx23885[0]: [ffff8800e0278400/18] wakeup reg=3219 buf=3219
> [ 3552.224929] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.224932] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.224933] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.224935] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.224937] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc93
> [ 3552.224941] cx23885[0]: cx23885_buf_prepare: ffff8800e0278400
> [ 3552.224946] cx23885[0]: [ffff8800e0278400/18] cx23885_buf_queue - append to active
> [ 3552.233235] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.233238] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.233240] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.233241] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.233244] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc94
> [ 3552.233245] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.233247] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.233250] cx23885[0]: [ffff8800c2945000/19] wakeup reg=3220 buf=3220
> [ 3552.233286] cx23885[0]: cx23885_buf_prepare: ffff8800c2945000
> [ 3552.233292] cx23885[0]: [ffff8800c2945000/19] cx23885_buf_queue - append to active
> [ 3552.241586] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.241589] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.241590] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.241592] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.241594] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc95
> [ 3552.241596] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.241597] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.241600] cx23885[0]: [ffff8800e1091400/20] wakeup reg=3221 buf=3221
> [ 3552.241631] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.241637] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.241642] cx23885[0]: cx23885_buf_prepare: ffff8800e1091400
> [ 3552.241645] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.241647] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.241651] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc95
> [ 3552.241657] cx23885[0]: [ffff8800e1091400/20] cx23885_buf_queue - append to active
> [ 3552.249937] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.249940] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.249942] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.249943] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.249945] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc96
> [ 3552.249947] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.249949] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.249953] cx23885[0]: [ffff88010a91c400/21] wakeup reg=3222 buf=3222
> [ 3552.249981] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.249984] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.249985] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.249987] cx23885[0]: cx23885_buf_prepare: ffff88010a91c400
> [ 3552.249989] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.249990] cx23885[0]: [ffff88010a91c400/21] cx23885_buf_queue - append to active
> [ 3552.249993] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc96
> [ 3552.258288] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.258290] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.258292] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.258294] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.258296] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc97
> [ 3552.258297] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.258299] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.258302] cx23885[0]: [ffff8800e09a5000/22] wakeup reg=3223 buf=3223
> [ 3552.258342] cx23885[0]: cx23885_buf_prepare: ffff8800e09a5000
> [ 3552.258345] cx23885[0]: [ffff8800e09a5000/22] cx23885_buf_queue - append to active
> [ 3552.266641] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.266644] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.266646] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.266648] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.266649] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc98
> [ 3552.266651] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.266653] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.266657] cx23885[0]: [ffff8800e2b76400/23] wakeup reg=3224 buf=3224
> [ 3552.266694] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76400
> [ 3552.266698] cx23885[0]: [ffff8800e2b76400/23] cx23885_buf_queue - append to active
> [ 3552.274991] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.274993] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.274995] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.274997] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.274999] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc99
> [ 3552.275001] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.275002] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.275006] cx23885[0]: [ffff88001d534800/24] wakeup reg=3225 buf=3225
> [ 3552.275045] cx23885[0]: cx23885_buf_prepare: ffff88001d534800
> [ 3552.275050] cx23885[0]: [ffff88001d534800/24] cx23885_buf_queue - append to active
> [ 3552.283342] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.283345] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.283347] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.283348] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.283350] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9a
> [ 3552.283352] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.283353] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.283357] cx23885[0]: [ffff8800e00f8800/25] wakeup reg=3226 buf=3226
> [ 3552.283384] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.283387] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.283388] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.283390] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.283392] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc9a
> [ 3552.283425] cx23885[0]: cx23885_buf_prepare: ffff8800e00f8800
> [ 3552.283428] cx23885[0]: [ffff8800e00f8800/25] cx23885_buf_queue - append to active
> [ 3552.291693] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.291695] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.291697] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.291699] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.291701] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9b
> [ 3552.291703] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.291704] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.291708] cx23885[0]: [ffff8800e2917000/26] wakeup reg=3227 buf=3227
> [ 3552.291745] cx23885[0]: cx23885_buf_prepare: ffff8800e2917000
> [ 3552.291750] cx23885[0]: [ffff8800e2917000/26] cx23885_buf_queue - append to active
> [ 3552.300043] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.300046] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.300048] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.300050] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.300051] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9c
> [ 3552.300053] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.300054] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.300058] cx23885[0]: [ffff8800529e6c00/27] wakeup reg=3228 buf=3228
> [ 3552.300094] cx23885[0]: cx23885_buf_prepare: ffff8800529e6c00
> [ 3552.300100] cx23885[0]: [ffff8800529e6c00/27] cx23885_buf_queue - append to active
> [ 3552.308394] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.308397] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.308398] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.308400] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.308402] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9d
> [ 3552.308404] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.308405] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.308409] cx23885[0]: [ffff880052a44400/28] wakeup reg=3229 buf=3229
> [ 3552.308445] cx23885[0]: cx23885_buf_prepare: ffff880052a44400
> [ 3552.308449] cx23885[0]: [ffff880052a44400/28] cx23885_buf_queue - append to active
> [ 3552.316745] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.316747] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.316749] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.316751] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.316753] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9e
> [ 3552.316754] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.316756] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.316759] cx23885[0]: [ffff8800e2917400/29] wakeup reg=3230 buf=3230
> [ 3552.316788] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.316794] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.316797] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.316798] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.316801] cx23885[0]: cx23885_buf_prepare: ffff8800e2917400
> [ 3552.316804] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xc9e
> [ 3552.316805] cx23885[0]: [ffff8800e2917400/29] cx23885_buf_queue - append to active
> [ 3552.325096] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.325098] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.325100] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.325102] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.325104] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xc9f
> [ 3552.325106] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.325107] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.325111] cx23885[0]: [ffff880052abd800/30] wakeup reg=3231 buf=3231
> [ 3552.325149] cx23885[0]: cx23885_buf_prepare: ffff880052abd800
> [ 3552.325154] cx23885[0]: [ffff880052abd800/30] cx23885_buf_queue - append to active
> [ 3552.333447] cx23885[0]: pci_status: 0x000cc004  pci_mask: 0x00001f06
> [ 3552.333449] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.333451] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.333453] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.333455] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca0
> [ 3552.333456] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.333458] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.333461] cx23885[0]: [ffff8800c29a9000/31] wakeup reg=3232 buf=3232
> [ 3552.333488] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.333491] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.333492] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.333494] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.333496] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xca0
> [ 3552.333501] cx23885[0]: cx23885_buf_prepare: ffff8800c29a9000
> [ 3552.333505] cx23885[0]: [ffff8800c29a9000/31] cx23885_buf_queue - append to active
> [ 3552.335371] DiB7000P: Next all layers stats available in 968424 us.
> [ 3552.341798] cx23885[0]: pci_status: 0x000cc004  pci_mask: 0x00001f06
> [ 3552.341801] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.341803] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.341805] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.341807] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca1
> [ 3552.341809] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.341810] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.341814] cx23885[0]: [ffff88004c829c00/0] wakeup reg=3233 buf=3233
> [ 3552.341853] cx23885[0]: cx23885_buf_prepare: ffff88004c829c00
> [ 3552.341857] cx23885[0]: [ffff88004c829c00/0] cx23885_buf_queue - append to active
> [ 3552.350149] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.350152] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.350154] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.350156] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.350158] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca2
> [ 3552.350159] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.350161] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.350164] cx23885[0]: [ffff88004282a800/1] wakeup reg=3234 buf=3234
> [ 3552.350204] cx23885[0]: cx23885_buf_prepare: ffff88004282a800
> [ 3552.350208] cx23885[0]: [ffff88004282a800/1] cx23885_buf_queue - append to active
> [ 3552.358500] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.358502] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.358504] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.358506] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.358508] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca3
> [ 3552.358509] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.358511] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.358514] cx23885[0]: [ffff88004c9b8c00/2] wakeup reg=3235 buf=3235
> [ 3552.358541] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.358544] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.358546] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.358548] cx23885[0]: cx23885_buf_prepare: ffff88004c9b8c00
> [ 3552.358550] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.358551] cx23885[0]: [ffff88004c9b8c00/2] cx23885_buf_queue - append to active
> [ 3552.358554] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xca3
> [ 3552.366851] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.366854] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.366856] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.366857] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.366859] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca4
> [ 3552.366861] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.366862] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.366866] cx23885[0]: [ffff88004c93c400/3] wakeup reg=3236 buf=3236
> [ 3552.366904] cx23885[0]: cx23885_buf_prepare: ffff88004c93c400
> [ 3552.366909] cx23885[0]: [ffff88004c93c400/3] cx23885_buf_queue - append to active
> [ 3552.375201] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.375204] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.375206] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.375208] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.375210] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca5
> [ 3552.375211] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.375213] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.375216] cx23885[0]: [ffff8800e0353c00/4] wakeup reg=3237 buf=3237
> [ 3552.375244] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.375247] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.375249] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.375250] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.375252] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xca5
> [ 3552.375290] cx23885[0]: cx23885_buf_prepare: ffff8800e0353c00
> [ 3552.375298] cx23885[0]: [ffff8800e0353c00/4] cx23885_buf_queue - append to active
> [ 3552.383553] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.383556] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.383557] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.383559] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.383561] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca6
> [ 3552.383562] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.383564] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.383568] cx23885[0]: [ffff88001d534c00/5] wakeup reg=3238 buf=3238
> [ 3552.383603] cx23885[0]: cx23885_buf_prepare: ffff88001d534c00
> [ 3552.383607] cx23885[0]: [ffff88001d534c00/5] cx23885_buf_queue - append to active
> [ 3552.391904] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.391907] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.391909] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.391910] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.391912] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca7
> [ 3552.391914] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.391915] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.391919] cx23885[0]: [ffff8800e20c1400/6] wakeup reg=3239 buf=3239
> [ 3552.391957] cx23885[0]: cx23885_buf_prepare: ffff8800e20c1400
> [ 3552.391962] cx23885[0]: [ffff8800e20c1400/6] cx23885_buf_queue - append to active
> [ 3552.400255] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.400258] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.400260] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.400262] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.400264] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca8
> [ 3552.400265] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.400267] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.400270] cx23885[0]: [ffff8800e2011800/7] wakeup reg=3240 buf=3240
> [ 3552.400297] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.400300] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.400302] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.400304] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.400306] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xca8
> [ 3552.400342] cx23885[0]: cx23885_buf_prepare: ffff8800e2011800
> [ 3552.400351] cx23885[0]: [ffff8800e2011800/7] cx23885_buf_queue - append to active
> [ 3552.408605] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.408608] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.408610] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.408612] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.408614] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xca9
> [ 3552.408615] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.408617] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.408620] cx23885[0]: [ffff8800e08e8800/8] wakeup reg=3241 buf=3241
> [ 3552.408654] cx23885[0]: cx23885_buf_prepare: ffff8800e08e8800
> [ 3552.408658] cx23885[0]: [ffff8800e08e8800/8] cx23885_buf_queue - append to active
> [ 3552.416957] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.416961] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.416962] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.416964] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.416966] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcaa
> [ 3552.416968] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.416970] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.416973] cx23885[0]: [ffff8800e1063400/9] wakeup reg=3242 buf=3242
> [ 3552.417011] cx23885[0]: cx23885_buf_prepare: ffff8800e1063400
> [ 3552.417016] cx23885[0]: [ffff8800e1063400/9] cx23885_buf_queue - append to active
> [ 3552.425307] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.425309] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.425311] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.425313] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.425315] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcab
> [ 3552.425316] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.425318] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.425321] cx23885[0]: [ffff8800c2977800/10] wakeup reg=3243 buf=3243
> [ 3552.425348] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.425351] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.425353] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.425355] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.425357] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcab
> [ 3552.425360] cx23885[0]: cx23885_buf_prepare: ffff8800c2977800
> [ 3552.425363] cx23885[0]: [ffff8800c2977800/10] cx23885_buf_queue - append to active
> [ 3552.433657] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.433659] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.433661] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.433663] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.433665] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcac
> [ 3552.433666] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.433668] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.433671] cx23885[0]: [ffff8800c2b34000/11] wakeup reg=3244 buf=3244
> [ 3552.433706] cx23885[0]: cx23885_buf_prepare: ffff8800c2b34000
> [ 3552.433710] cx23885[0]: [ffff8800c2b34000/11] cx23885_buf_queue - append to active
> [ 3552.442010] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.442013] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.442015] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.442016] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.442018] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcad
> [ 3552.442020] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.442021] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.442025] cx23885[0]: [ffff8800e3a85c00/12] wakeup reg=3245 buf=3245
> [ 3552.442066] cx23885[0]: cx23885_buf_prepare: ffff8800e3a85c00
> [ 3552.442071] cx23885[0]: [ffff8800e3a85c00/12] cx23885_buf_queue - append to active
> [ 3552.450360] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.450364] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.450366] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.450368] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.450369] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcae
> [ 3552.450371] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.450373] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.450376] cx23885[0]: [ffff8800e2441000/13] wakeup reg=3246 buf=3246
> [ 3552.450404] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.450406] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.450408] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.450410] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.450412] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcae
> [ 3552.450447] cx23885[0]: cx23885_buf_prepare: ffff8800e2441000
> [ 3552.450451] cx23885[0]: [ffff8800e2441000/13] cx23885_buf_queue - append to active
> [ 3552.458712] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.458714] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.458716] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.458718] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.458720] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcaf
> [ 3552.458722] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.458723] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.458727] cx23885[0]: [ffff8800c25c2800/14] wakeup reg=3247 buf=3247
> [ 3552.458757] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.458761] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.458765] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2800
> [ 3552.458770] cx23885[0]: [ffff8800c25c2800/14] cx23885_buf_queue - append to active
> [ 3552.458773] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.458776] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.458780] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcaf
> [ 3552.467063] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.467065] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.467067] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.467069] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.467071] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb0
> [ 3552.467072] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.467074] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.467078] cx23885[0]: [ffff8800e2b76c00/15] wakeup reg=3248 buf=3248
> [ 3552.467121] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76c00
> [ 3552.467127] cx23885[0]: [ffff8800e2b76c00/15] cx23885_buf_queue - append to active
> [ 3552.475415] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.475417] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.475419] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.475421] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.475423] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb1
> [ 3552.475425] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.475426] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.475430] cx23885[0]: [ffff8800e094a800/16] wakeup reg=3249 buf=3249
> [ 3552.475458] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.475460] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.475462] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.475465] cx23885[0]: cx23885_buf_prepare: ffff8800e094a800
> [ 3552.475469] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.475472] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb1
> [ 3552.475477] cx23885[0]: [ffff8800e094a800/16] cx23885_buf_queue - append to active
> [ 3552.483764] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.483767] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.483768] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.483770] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.483772] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb2
> [ 3552.483774] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.483775] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.483779] cx23885[0]: [ffff8800c25c2000/17] wakeup reg=3250 buf=3250
> [ 3552.483818] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2000
> [ 3552.483822] cx23885[0]: [ffff8800c25c2000/17] cx23885_buf_queue - append to active
> [ 3552.492115] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.492118] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.492120] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.492122] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.492123] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb3
> [ 3552.492125] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.492126] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.492130] cx23885[0]: [ffff8800e0278400/18] wakeup reg=3251 buf=3251
> [ 3552.492159] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.492163] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.492165] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.492167] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.492168] cx23885[0]: cx23885_buf_prepare: ffff8800e0278400
> [ 3552.492172] cx23885[0]: [ffff8800e0278400/18] cx23885_buf_queue - append to active
> [ 3552.492175] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb3
> [ 3552.500465] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.500468] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.500470] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.500472] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.500474] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb4
> [ 3552.500476] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.500477] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.500481] cx23885[0]: [ffff8800c2945000/19] wakeup reg=3252 buf=3252
> [ 3552.500509] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.500511] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.500513] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.500515] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.500521] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb4
> [ 3552.500561] cx23885[0]: cx23885_buf_prepare: ffff8800c2945000
> [ 3552.500565] cx23885[0]: [ffff8800c2945000/19] cx23885_buf_queue - append to active
> [ 3552.508817] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.508820] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.508822] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.508824] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.508825] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb5
> [ 3552.508827] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.508829] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.508832] cx23885[0]: [ffff8800e1091400/20] wakeup reg=3253 buf=3253
> [ 3552.508866] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.508869] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.508871] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.508872] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.508873] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb5
> [ 3552.508876] cx23885[0]: cx23885_buf_prepare: ffff8800e1091400
> [ 3552.508879] cx23885[0]: [ffff8800e1091400/20] cx23885_buf_queue - append to active
> [ 3552.517167] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.517170] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.517172] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.517174] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.517176] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb6
> [ 3552.517178] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.517179] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.517183] cx23885[0]: [ffff88010a91c400/21] wakeup reg=3254 buf=3254
> [ 3552.517220] cx23885[0]: cx23885_buf_prepare: ffff88010a91c400
> [ 3552.517224] cx23885[0]: [ffff88010a91c400/21] cx23885_buf_queue - append to active
> [ 3552.525518] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.525521] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.525523] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.525524] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.525526] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb7
> [ 3552.525528] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.525529] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.525533] cx23885[0]: [ffff8800e09a5000/22] wakeup reg=3255 buf=3255
> [ 3552.525560] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.525563] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.525565] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.525567] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.525571] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb7
> [ 3552.525573] cx23885[0]: cx23885_buf_prepare: ffff8800e09a5000
> [ 3552.525576] cx23885[0]: [ffff8800e09a5000/22] cx23885_buf_queue - append to active
> [ 3552.533870] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.533873] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.533875] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.533877] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.533879] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb8
> [ 3552.533881] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.533882] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.533886] cx23885[0]: [ffff8800e2b76400/23] wakeup reg=3256 buf=3256
> [ 3552.533925] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76400
> [ 3552.533929] cx23885[0]: [ffff8800e2b76400/23] cx23885_buf_queue - append to active
> [ 3552.542221] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.542224] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.542226] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.542228] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.542230] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcb9
> [ 3552.542231] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.542233] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.542237] cx23885[0]: [ffff88001d534800/24] wakeup reg=3257 buf=3257
> [ 3552.542264] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.542267] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.542269] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.542271] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.542273] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcb9
> [ 3552.542314] cx23885[0]: cx23885_buf_prepare: ffff88001d534800
> [ 3552.542318] cx23885[0]: [ffff88001d534800/24] cx23885_buf_queue - append to active
> [ 3552.550571] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.550573] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.550575] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.550577] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.550579] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcba
> [ 3552.550580] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.550582] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.550585] cx23885[0]: [ffff8800e00f8800/25] wakeup reg=3258 buf=3258
> [ 3552.550622] cx23885[0]: cx23885_buf_prepare: ffff8800e00f8800
> [ 3552.550626] cx23885[0]: [ffff8800e00f8800/25] cx23885_buf_queue - append to active
> [ 3552.558923] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.558926] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.558928] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.558930] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.558932] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcbb
> [ 3552.558934] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.558935] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.558939] cx23885[0]: [ffff8800e2917000/26] wakeup reg=3259 buf=3259
> [ 3552.558967] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.558972] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.558978] cx23885[0]: cx23885_buf_prepare: ffff8800e2917000
> [ 3552.558980] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.558983] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.558987] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcbb
> [ 3552.558998] cx23885[0]: [ffff8800e2917000/26] cx23885_buf_queue - append to active
> [ 3552.567274] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.567277] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.567278] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.567280] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.567282] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcbc
> [ 3552.567283] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.567285] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.567288] cx23885[0]: [ffff8800529e6c00/27] wakeup reg=3260 buf=3260
> [ 3552.567328] cx23885[0]: cx23885_buf_prepare: ffff8800529e6c00
> [ 3552.567332] cx23885[0]: [ffff8800529e6c00/27] cx23885_buf_queue - append to active
> [ 3552.575624] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.575627] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.575628] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.575630] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.575632] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcbd
> [ 3552.575634] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.575635] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.575638] cx23885[0]: [ffff880052a44400/28] wakeup reg=3261 buf=3261
> [ 3552.575676] cx23885[0]: cx23885_buf_prepare: ffff880052a44400
> [ 3552.575681] cx23885[0]: [ffff880052a44400/28] cx23885_buf_queue - append to active
> [ 3552.583976] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.583979] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.583981] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.583983] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.583985] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcbe
> [ 3552.583986] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.583988] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.583991] cx23885[0]: [ffff8800e2917400/29] wakeup reg=3262 buf=3262
> [ 3552.584034] cx23885[0]: cx23885_buf_prepare: ffff8800e2917400
> [ 3552.584038] cx23885[0]: [ffff8800e2917400/29] cx23885_buf_queue - append to active
> [ 3552.592326] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.592329] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.592331] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.592332] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.592334] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcbf
> [ 3552.592336] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.592338] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.592341] cx23885[0]: [ffff880052abd800/30] wakeup reg=3263 buf=3263
> [ 3552.592380] cx23885[0]: cx23885_buf_prepare: ffff880052abd800
> [ 3552.592385] cx23885[0]: [ffff880052abd800/30] cx23885_buf_queue - append to active
> [ 3552.600678] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.600681] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.600683] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.600685] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.600687] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc0
> [ 3552.600688] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.600690] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.600693] cx23885[0]: [ffff8800c29a9000/31] wakeup reg=3264 buf=3264
> [ 3552.600737] cx23885[0]: cx23885_buf_prepare: ffff8800c29a9000
> [ 3552.600741] cx23885[0]: [ffff8800c29a9000/31] cx23885_buf_queue - append to active
> [ 3552.609028] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.609031] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.609033] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.609035] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.609037] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc1
> [ 3552.609038] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.609040] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.609043] cx23885[0]: [ffff88004c829c00/0] wakeup reg=3265 buf=3265
> [ 3552.609072] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.609075] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.609077] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.609080] cx23885[0]: cx23885_buf_prepare: ffff88004c829c00
> [ 3552.609082] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.609084] cx23885[0]: [ffff88004c829c00/0] cx23885_buf_queue - append to active
> [ 3552.609087] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcc1
> [ 3552.617379] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.617382] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.617384] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.617386] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.617388] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc2
> [ 3552.617389] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.617391] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.617395] cx23885[0]: [ffff88004282a800/1] wakeup reg=3266 buf=3266
> [ 3552.617422] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.617425] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.617427] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.617429] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.617436] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcc2
> [ 3552.617475] cx23885[0]: cx23885_buf_prepare: ffff88004282a800
> [ 3552.617479] cx23885[0]: [ffff88004282a800/1] cx23885_buf_queue - append to active
> [ 3552.625730] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.625732] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.625734] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.625735] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.625737] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc3
> [ 3552.625739] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.625740] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.625744] cx23885[0]: [ffff88004c9b8c00/2] wakeup reg=3267 buf=3267
> [ 3552.625772] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.625776] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.625778] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.625780] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.625782] cx23885[0]: cx23885_buf_prepare: ffff88004c9b8c00
> [ 3552.625785] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcc3
> [ 3552.625786] cx23885[0]: [ffff88004c9b8c00/2] cx23885_buf_queue - append to active
> [ 3552.634081] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.634084] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.634086] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.634087] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.634089] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc4
> [ 3552.634091] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.634092] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.634096] cx23885[0]: [ffff88004c93c400/3] wakeup reg=3268 buf=3268
> [ 3552.634135] cx23885[0]: cx23885_buf_prepare: ffff88004c93c400
> [ 3552.634139] cx23885[0]: [ffff88004c93c400/3] cx23885_buf_queue - append to active
> [ 3552.642432] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.642435] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.642436] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.642438] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.642440] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc5
> [ 3552.642441] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.642443] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.642446] cx23885[0]: [ffff8800e0353c00/4] wakeup reg=3269 buf=3269
> [ 3552.642474] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.642477] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.642479] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.642482] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.642485] cx23885[0]: cx23885_buf_prepare: ffff8800e0353c00
> [ 3552.642486] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcc5
> [ 3552.642488] cx23885[0]: [ffff8800e0353c00/4] cx23885_buf_queue - append to active
> [ 3552.650783] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.650786] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.650788] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.650789] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.650791] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc6
> [ 3552.650793] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.650794] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.650798] cx23885[0]: [ffff88001d534c00/5] wakeup reg=3270 buf=3270
> [ 3552.650842] cx23885[0]: cx23885_buf_prepare: ffff88001d534c00
> [ 3552.650846] cx23885[0]: [ffff88001d534c00/5] cx23885_buf_queue - append to active
> [ 3552.659134] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.659137] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.659139] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.659141] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.659143] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc7
> [ 3552.659144] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.659146] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.659149] cx23885[0]: [ffff8800e20c1400/6] wakeup reg=3271 buf=3271
> [ 3552.659188] cx23885[0]: cx23885_buf_prepare: ffff8800e20c1400
> [ 3552.659194] cx23885[0]: [ffff8800e20c1400/6] cx23885_buf_queue - append to active
> [ 3552.667485] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.667488] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.667490] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.667491] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.667493] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc8
> [ 3552.667495] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.667496] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.667500] cx23885[0]: [ffff8800e2011800/7] wakeup reg=3272 buf=3272
> [ 3552.667540] cx23885[0]: cx23885_buf_prepare: ffff8800e2011800
> [ 3552.667546] cx23885[0]: [ffff8800e2011800/7] cx23885_buf_queue - append to active
> [ 3552.675836] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.675839] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.675840] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.675842] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.675844] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcc9
> [ 3552.675846] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.675847] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.675851] cx23885[0]: [ffff8800e08e8800/8] wakeup reg=3273 buf=3273
> [ 3552.675880] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.675883] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.675885] cx23885[0]: cx23885_buf_prepare: ffff8800e08e8800
> [ 3552.675888] cx23885[0]: [ffff8800e08e8800/8] cx23885_buf_queue - append to active
> [ 3552.675891] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.675895] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.675898] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcc9
> [ 3552.684187] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.684190] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.684192] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.684194] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.684196] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcca
> [ 3552.684198] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.684199] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.684203] cx23885[0]: [ffff8800e1063400/9] wakeup reg=3274 buf=3274
> [ 3552.684242] cx23885[0]: cx23885_buf_prepare: ffff8800e1063400
> [ 3552.684247] cx23885[0]: [ffff8800e1063400/9] cx23885_buf_queue - append to active
> [ 3552.692538] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.692541] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.692543] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.692545] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.692547] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xccb
> [ 3552.692549] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.692550] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.692554] cx23885[0]: [ffff8800c2977800/10] wakeup reg=3275 buf=3275
> [ 3552.692582] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.692584] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.692586] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.692588] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.692590] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xccb
> [ 3552.692593] cx23885[0]: cx23885_buf_prepare: ffff8800c2977800
> [ 3552.692605] cx23885[0]: [ffff8800c2977800/10] cx23885_buf_queue - append to active
> [ 3552.700889] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.700892] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.700894] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.700896] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.700898] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xccc
> [ 3552.700899] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.700901] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.700904] cx23885[0]: [ffff8800c2b34000/11] wakeup reg=3276 buf=3276
> [ 3552.700942] cx23885[0]: cx23885_buf_prepare: ffff8800c2b34000
> [ 3552.700946] cx23885[0]: [ffff8800c2b34000/11] cx23885_buf_queue - append to active
> [ 3552.709239] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.709242] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.709244] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.709246] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.709248] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xccd
> [ 3552.709250] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.709251] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.709255] cx23885[0]: [ffff8800e3a85c00/12] wakeup reg=3277 buf=3277
> [ 3552.709292] cx23885[0]: cx23885_buf_prepare: ffff8800e3a85c00
> [ 3552.709297] cx23885[0]: [ffff8800e3a85c00/12] cx23885_buf_queue - append to active
> [ 3552.717590] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.717592] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.717594] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.717595] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.717597] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcce
> [ 3552.717599] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.717600] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.717604] cx23885[0]: [ffff8800e2441000/13] wakeup reg=3278 buf=3278
> [ 3552.717634] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.717638] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.717640] cx23885[0]: cx23885_buf_prepare: ffff8800e2441000
> [ 3552.717645] cx23885[0]: [ffff8800e2441000/13] cx23885_buf_queue - append to active
> [ 3552.717651] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.717653] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.717655] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcce
> [ 3552.725942] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.725945] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.725947] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.725948] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.725950] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xccf
> [ 3552.725952] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.725954] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.725958] cx23885[0]: [ffff8800c25c2800/14] wakeup reg=3279 buf=3279
> [ 3552.725986] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.725989] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.725991] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.725993] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.725995] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xccf
> [ 3552.726032] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2800
> [ 3552.726044] cx23885[0]: [ffff8800c25c2800/14] cx23885_buf_queue - append to active
> [ 3552.734292] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.734295] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.734297] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.734299] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.734301] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd0
> [ 3552.734303] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.734305] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.734308] cx23885[0]: [ffff8800e2b76c00/15] wakeup reg=3280 buf=3280
> [ 3552.734344] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76c00
> [ 3552.734348] cx23885[0]: [ffff8800e2b76c00/15] cx23885_buf_queue - append to active
> [ 3552.742643] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.742646] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.742648] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.742650] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.742652] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd1
> [ 3552.742654] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.742655] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.742659] cx23885[0]: [ffff8800e094a800/16] wakeup reg=3281 buf=3281
> [ 3552.742687] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.742689] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.742691] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.742693] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.742695] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd1
> [ 3552.742698] cx23885[0]: cx23885_buf_prepare: ffff8800e094a800
> [ 3552.742701] cx23885[0]: [ffff8800e094a800/16] cx23885_buf_queue - append to active
> [ 3552.750994] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.750997] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.750999] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.751000] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.751002] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd2
> [ 3552.751004] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.751005] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.751009] cx23885[0]: [ffff8800c25c2000/17] wakeup reg=3282 buf=3282
> [ 3552.751049] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2000
> [ 3552.751053] cx23885[0]: [ffff8800c25c2000/17] cx23885_buf_queue - append to active
> [ 3552.759347] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.759350] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.759352] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.759354] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.759356] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd3
> [ 3552.759357] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.759359] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.759363] cx23885[0]: [ffff8800e0278400/18] wakeup reg=3283 buf=3283
> [ 3552.759401] cx23885[0]: cx23885_buf_prepare: ffff8800e0278400
> [ 3552.759406] cx23885[0]: [ffff8800e0278400/18] cx23885_buf_queue - append to active
> [ 3552.767696] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.767698] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.767700] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.767702] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.767704] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd4
> [ 3552.767705] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.767707] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.767710] cx23885[0]: [ffff8800c2945000/19] wakeup reg=3284 buf=3284
> [ 3552.767737] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.767740] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.767743] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.767747] cx23885[0]: cx23885_buf_prepare: ffff8800c2945000
> [ 3552.767748] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.767750] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd4
> [ 3552.767754] cx23885[0]: [ffff8800c2945000/19] cx23885_buf_queue - append to active
> [ 3552.776048] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.776051] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.776053] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.776055] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.776057] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd5
> [ 3552.776058] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.776060] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.776064] cx23885[0]: [ffff8800e1091400/20] wakeup reg=3285 buf=3285
> [ 3552.776093] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.776095] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.776097] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.776099] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.776101] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd5
> [ 3552.776103] cx23885[0]: cx23885_buf_prepare: ffff8800e1091400
> [ 3552.776107] cx23885[0]: [ffff8800e1091400/20] cx23885_buf_queue - append to active
> [ 3552.784399] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.784402] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.784403] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.784405] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.784407] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd6
> [ 3552.784409] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.784410] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.784414] cx23885[0]: [ffff88010a91c400/21] wakeup reg=3286 buf=3286
> [ 3552.784441] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.784444] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.784446] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.784448] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.784450] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd6
> [ 3552.784453] cx23885[0]: cx23885_buf_prepare: ffff88010a91c400
> [ 3552.784457] cx23885[0]: [ffff88010a91c400/21] cx23885_buf_queue - append to active
> [ 3552.792750] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.792752] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.792754] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.792756] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.792758] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd7
> [ 3552.792759] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.792761] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.792764] cx23885[0]: [ffff8800e09a5000/22] wakeup reg=3287 buf=3287
> [ 3552.792791] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.792794] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.792796] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.792798] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.792800] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd7
> [ 3552.792803] cx23885[0]: cx23885_buf_prepare: ffff8800e09a5000
> [ 3552.792807] cx23885[0]: [ffff8800e09a5000/22] cx23885_buf_queue - append to active
> [ 3552.801100] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.801102] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.801104] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.801105] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.801107] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd8
> [ 3552.801109] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.801110] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.801114] cx23885[0]: [ffff8800e2b76400/23] wakeup reg=3288 buf=3288
> [ 3552.801141] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.801143] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.801145] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.801147] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.801149] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcd8
> [ 3552.801151] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76400
> [ 3552.801155] cx23885[0]: [ffff8800e2b76400/23] cx23885_buf_queue - append to active
> [ 3552.809451] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.809453] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.809455] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.809457] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.809459] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcd9
> [ 3552.809460] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.809462] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.809465] cx23885[0]: [ffff88001d534800/24] wakeup reg=3289 buf=3289
> [ 3552.809505] cx23885[0]: cx23885_buf_prepare: ffff88001d534800
> [ 3552.809511] cx23885[0]: [ffff88001d534800/24] cx23885_buf_queue - append to active
> [ 3552.817802] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.817805] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.817807] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.817808] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.817810] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcda
> [ 3552.817812] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.817813] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.817817] cx23885[0]: [ffff8800e00f8800/25] wakeup reg=3290 buf=3290
> [ 3552.817852] cx23885[0]: cx23885_buf_prepare: ffff8800e00f8800
> [ 3552.817857] cx23885[0]: [ffff8800e00f8800/25] cx23885_buf_queue - append to active
> [ 3552.826152] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.826155] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.826156] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.826158] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.826160] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcdb
> [ 3552.826162] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.826163] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.826167] cx23885[0]: [ffff8800e2917000/26] wakeup reg=3291 buf=3291
> [ 3552.826206] cx23885[0]: cx23885_buf_prepare: ffff8800e2917000
> [ 3552.826209] cx23885[0]: [ffff8800e2917000/26] cx23885_buf_queue - append to active
> [ 3552.834504] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.834506] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.834508] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.834510] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.834512] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcdc
> [ 3552.834513] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.834515] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.834519] cx23885[0]: [ffff8800529e6c00/27] wakeup reg=3292 buf=3292
> [ 3552.834547] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.834551] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.834555] cx23885[0]: cx23885_buf_prepare: ffff8800529e6c00
> [ 3552.834560] cx23885[0]: [ffff8800529e6c00/27] cx23885_buf_queue - append to active
> [ 3552.834566] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.834567] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.834569] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcdc
> [ 3552.842854] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.842856] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.842858] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.842860] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.842862] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcdd
> [ 3552.842863] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.842865] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.842868] cx23885[0]: [ffff880052a44400/28] wakeup reg=3293 buf=3293
> [ 3552.842903] cx23885[0]: cx23885_buf_prepare: ffff880052a44400
> [ 3552.842907] cx23885[0]: [ffff880052a44400/28] cx23885_buf_queue - append to active
> [ 3552.851206] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.851209] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.851210] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.851212] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.851214] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcde
> [ 3552.851216] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.851217] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.851221] cx23885[0]: [ffff8800e2917400/29] wakeup reg=3294 buf=3294
> [ 3552.851257] cx23885[0]: cx23885_buf_prepare: ffff8800e2917400
> [ 3552.851261] cx23885[0]: [ffff8800e2917400/29] cx23885_buf_queue - append to active
> [ 3552.859557] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.859560] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.859562] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.859564] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.859566] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcdf
> [ 3552.859568] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.859569] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.859573] cx23885[0]: [ffff880052abd800/30] wakeup reg=3295 buf=3295
> [ 3552.859610] cx23885[0]: cx23885_buf_prepare: ffff880052abd800
> [ 3552.859614] cx23885[0]: [ffff880052abd800/30] cx23885_buf_queue - append to active
> [ 3552.867908] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.867910] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.867912] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.867914] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.867916] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce0
> [ 3552.867917] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.867919] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.867923] cx23885[0]: [ffff8800c29a9000/31] wakeup reg=3296 buf=3296
> [ 3552.867949] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.867952] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.867953] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.867955] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.867957] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xce0
> [ 3552.867961] cx23885[0]: cx23885_buf_prepare: ffff8800c29a9000
> [ 3552.867968] cx23885[0]: [ffff8800c29a9000/31] cx23885_buf_queue - append to active
> [ 3552.876260] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.876263] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.876265] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.876267] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.876269] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce1
> [ 3552.876270] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.876272] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.876276] cx23885[0]: [ffff88004c829c00/0] wakeup reg=3297 buf=3297
> [ 3552.876303] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.876306] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.876308] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.876310] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.876311] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xce1
> [ 3552.876314] cx23885[0]: cx23885_buf_prepare: ffff88004c829c00
> [ 3552.876318] cx23885[0]: [ffff88004c829c00/0] cx23885_buf_queue - append to active
> [ 3552.884610] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.884613] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.884615] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.884617] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.884618] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce2
> [ 3552.884620] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.884622] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.884625] cx23885[0]: [ffff88004282a800/1] wakeup reg=3298 buf=3298
> [ 3552.884666] cx23885[0]: cx23885_buf_prepare: ffff88004282a800
> [ 3552.884670] cx23885[0]: [ffff88004282a800/1] cx23885_buf_queue - append to active
> [ 3552.892960] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.892963] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.892965] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.892967] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.892969] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce3
> [ 3552.892970] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.892972] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.892976] cx23885[0]: [ffff88004c9b8c00/2] wakeup reg=3299 buf=3299
> [ 3552.893010] cx23885[0]: cx23885_buf_prepare: ffff88004c9b8c00
> [ 3552.893015] cx23885[0]: [ffff88004c9b8c00/2] cx23885_buf_queue - append to active
> [ 3552.901312] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.901314] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.901316] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.901318] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.901320] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce4
> [ 3552.901321] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.901323] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.901326] cx23885[0]: [ffff88004c93c400/3] wakeup reg=3300 buf=3300
> [ 3552.901362] cx23885[0]: cx23885_buf_prepare: ffff88004c93c400
> [ 3552.901366] cx23885[0]: [ffff88004c93c400/3] cx23885_buf_queue - append to active
> [ 3552.909662] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.909665] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.909667] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.909669] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.909671] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce5
> [ 3552.909672] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.909674] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.909678] cx23885[0]: [ffff8800e0353c00/4] wakeup reg=3301 buf=3301
> [ 3552.909717] cx23885[0]: cx23885_buf_prepare: ffff8800e0353c00
> [ 3552.909721] cx23885[0]: [ffff8800e0353c00/4] cx23885_buf_queue - append to active
> [ 3552.918013] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.918016] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.918018] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.918019] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.918021] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce6
> [ 3552.918023] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.918024] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.918028] cx23885[0]: [ffff88001d534c00/5] wakeup reg=3302 buf=3302
> [ 3552.918063] cx23885[0]: cx23885_buf_prepare: ffff88001d534c00
> [ 3552.918067] cx23885[0]: [ffff88001d534c00/5] cx23885_buf_queue - append to active
> [ 3552.926364] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3552.926367] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.926369] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.926370] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.926372] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce7
> [ 3552.926374] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.926375] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.926379] cx23885[0]: [ffff8800e20c1400/6] wakeup reg=3303 buf=3303
> [ 3552.926408] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.926411] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.926413] cx23885[0]: cx23885_buf_prepare: ffff8800e20c1400
> [ 3552.926414] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.926417] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.926419] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xce7
> [ 3552.926424] cx23885[0]: [ffff8800e20c1400/6] cx23885_buf_queue - append to active
> [ 3552.934715] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.934718] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.934720] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.934721] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.934723] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce8
> [ 3552.934725] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.934726] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.934730] cx23885[0]: [ffff8800e2011800/7] wakeup reg=3304 buf=3304
> [ 3552.934768] cx23885[0]: cx23885_buf_prepare: ffff8800e2011800
> [ 3552.934774] cx23885[0]: [ffff8800e2011800/7] cx23885_buf_queue - append to active
> [ 3552.943066] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.943068] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.943070] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.943072] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.943073] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xce9
> [ 3552.943075] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.943076] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.943080] cx23885[0]: [ffff8800e08e8800/8] wakeup reg=3305 buf=3305
> [ 3552.943107] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.943109] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.943111] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.943113] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.943115] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xce9
> [ 3552.943117] cx23885[0]: cx23885_buf_prepare: ffff8800e08e8800
> [ 3552.943121] cx23885[0]: [ffff8800e08e8800/8] cx23885_buf_queue - append to active
> [ 3552.951417] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.951419] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.951421] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.951423] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.951425] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcea
> [ 3552.951426] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.951428] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.951432] cx23885[0]: [ffff8800e1063400/9] wakeup reg=3306 buf=3306
> [ 3552.951470] cx23885[0]: cx23885_buf_prepare: ffff8800e1063400
> [ 3552.951474] cx23885[0]: [ffff8800e1063400/9] cx23885_buf_queue - append to active
> [ 3552.959767] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.959770] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.959772] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.959774] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.959775] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xceb
> [ 3552.959777] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.959779] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.959782] cx23885[0]: [ffff8800c2977800/10] wakeup reg=3307 buf=3307
> [ 3552.959820] cx23885[0]: cx23885_buf_prepare: ffff8800c2977800
> [ 3552.959825] cx23885[0]: [ffff8800c2977800/10] cx23885_buf_queue - append to active
> [ 3552.968119] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.968121] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.968123] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.968124] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.968126] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcec
> [ 3552.968128] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.968129] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.968133] cx23885[0]: [ffff8800c2b34000/11] wakeup reg=3308 buf=3308
> [ 3552.968168] cx23885[0]: cx23885_buf_prepare: ffff8800c2b34000
> [ 3552.968172] cx23885[0]: [ffff8800c2b34000/11] cx23885_buf_queue - append to active
> [ 3552.976470] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.976473] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.976474] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.976476] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.976478] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xced
> [ 3552.976480] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.976481] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.976485] cx23885[0]: [ffff8800e3a85c00/12] wakeup reg=3309 buf=3309
> [ 3552.976520] cx23885[0]: cx23885_buf_prepare: ffff8800e3a85c00
> [ 3552.976525] cx23885[0]: [ffff8800e3a85c00/12] cx23885_buf_queue - append to active
> [ 3552.984821] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.984824] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.984825] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.984827] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.984829] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcee
> [ 3552.984831] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.984832] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.984836] cx23885[0]: [ffff8800e2441000/13] wakeup reg=3310 buf=3310
> [ 3552.984872] cx23885[0]: cx23885_buf_prepare: ffff8800e2441000
> [ 3552.984877] cx23885[0]: [ffff8800e2441000/13] cx23885_buf_queue - append to active
> [ 3552.993172] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3552.993175] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.993177] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.993178] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.993180] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcef
> [ 3552.993182] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3552.993183] cx23885[0]:  (RISCI1            0x00000001)
> [ 3552.993187] cx23885[0]: [ffff8800c25c2800/14] wakeup reg=3311 buf=3311
> [ 3552.993215] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3552.993217] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3552.993219] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3552.993221] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3552.993223] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcef
> [ 3552.993256] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2800
> [ 3552.993260] cx23885[0]: [ffff8800c25c2800/14] cx23885_buf_queue - append to active
> [ 3553.001522] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.001524] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.001526] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.001528] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.001530] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf0
> [ 3553.001531] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.001532] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.001536] cx23885[0]: [ffff8800e2b76c00/15] wakeup reg=3312 buf=3312
> [ 3553.001565] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.001568] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.001569] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.001571] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76c00
> [ 3553.001575] cx23885[0]: [ffff8800e2b76c00/15] cx23885_buf_queue - append to active
> [ 3553.001578] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.001580] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcf0
> [ 3553.009874] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.009877] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.009878] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.009880] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.009882] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf1
> [ 3553.009884] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.009885] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.009889] cx23885[0]: [ffff8800e094a800/16] wakeup reg=3313 buf=3313
> [ 3553.009916] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.009919] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.009920] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.009922] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.009924] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcf1
> [ 3553.009957] cx23885[0]: cx23885_buf_prepare: ffff8800e094a800
> [ 3553.009961] cx23885[0]: [ffff8800e094a800/16] cx23885_buf_queue - append to active
> [ 3553.018224] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.018227] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.018229] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.018230] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.018232] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf2
> [ 3553.018234] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.018235] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.018239] cx23885[0]: [ffff8800c25c2000/17] wakeup reg=3314 buf=3314
> [ 3553.018276] cx23885[0]: cx23885_buf_prepare: ffff8800c25c2000
> [ 3553.018280] cx23885[0]: [ffff8800c25c2000/17] cx23885_buf_queue - append to active
> [ 3553.026576] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3553.026579] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.026581] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.026583] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.026585] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf3
> [ 3553.026586] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.026588] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.026592] cx23885[0]: [ffff8800e0278400/18] wakeup reg=3315 buf=3315
> [ 3553.026630] cx23885[0]: cx23885_buf_prepare: ffff8800e0278400
> [ 3553.026635] cx23885[0]: [ffff8800e0278400/18] cx23885_buf_queue - append to active
> [ 3553.034926] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.034929] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.034931] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.034933] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.034935] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf4
> [ 3553.034936] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.034938] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.034942] cx23885[0]: [ffff8800c2945000/19] wakeup reg=3316 buf=3316
> [ 3553.034978] cx23885[0]: cx23885_buf_prepare: ffff8800c2945000
> [ 3553.034983] cx23885[0]: [ffff8800c2945000/19] cx23885_buf_queue - append to active
> [ 3553.043277] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.043279] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.043281] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.043283] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.043285] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf5
> [ 3553.043286] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.043288] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.043291] cx23885[0]: [ffff8800e1091400/20] wakeup reg=3317 buf=3317
> [ 3553.043319] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.043321] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.043323] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.043325] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.043326] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcf5
> [ 3553.043328] cx23885[0]: cx23885_buf_prepare: ffff8800e1091400
> [ 3553.043332] cx23885[0]: [ffff8800e1091400/20] cx23885_buf_queue - append to active
> [ 3553.051629] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.051632] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.051634] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.051636] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.051637] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf6
> [ 3553.051639] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.051640] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.051644] cx23885[0]: [ffff88010a91c400/21] wakeup reg=3318 buf=3318
> [ 3553.051680] cx23885[0]: cx23885_buf_prepare: ffff88010a91c400
> [ 3553.051685] cx23885[0]: [ffff88010a91c400/21] cx23885_buf_queue - append to active
> [ 3553.059980] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.059982] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.059984] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.059986] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.059988] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf7
> [ 3553.059989] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.059991] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.059994] cx23885[0]: [ffff8800e09a5000/22] wakeup reg=3319 buf=3319
> [ 3553.060022] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.060024] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.060026] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.060028] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.060030] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcf7
> [ 3553.060064] cx23885[0]: cx23885_buf_prepare: ffff8800e09a5000
> [ 3553.060068] cx23885[0]: [ffff8800e09a5000/22] cx23885_buf_queue - append to active
> [ 3553.068331] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.068334] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.068335] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.068337] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.068339] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf8
> [ 3553.068341] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.068342] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.068346] cx23885[0]: [ffff8800e2b76400/23] wakeup reg=3320 buf=3320
> [ 3553.068382] cx23885[0]: cx23885_buf_prepare: ffff8800e2b76400
> [ 3553.068386] cx23885[0]: [ffff8800e2b76400/23] cx23885_buf_queue - append to active
> [ 3553.076681] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.076683] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.076685] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.076687] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.076689] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcf9
> [ 3553.076690] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.076692] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.076695] cx23885[0]: [ffff88001d534800/24] wakeup reg=3321 buf=3321
> [ 3553.076722] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.076725] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.076727] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.076728] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.076737] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcf9
> [ 3553.076773] cx23885[0]: cx23885_buf_prepare: ffff88001d534800
> [ 3553.076778] cx23885[0]: [ffff88001d534800/24] cx23885_buf_queue - append to active
> [ 3553.085031] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.085034] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.085036] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.085037] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.085039] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcfa
> [ 3553.085041] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.085042] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.085046] cx23885[0]: [ffff8800e00f8800/25] wakeup reg=3322 buf=3322
> [ 3553.085081] cx23885[0]: cx23885_buf_prepare: ffff8800e00f8800
> [ 3553.085087] cx23885[0]: [ffff8800e00f8800/25] cx23885_buf_queue - append to active
> [ 3553.093384] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.093387] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.093389] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.093391] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.093393] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcfb
> [ 3553.093395] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.093396] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.093400] cx23885[0]: [ffff8800e2917000/26] wakeup reg=3323 buf=3323
> [ 3553.093439] cx23885[0]: cx23885_buf_prepare: ffff8800e2917000
> [ 3553.093444] cx23885[0]: [ffff8800e2917000/26] cx23885_buf_queue - append to active
> [ 3553.101734] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.101737] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.101738] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.101740] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.101742] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcfc
> [ 3553.101744] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.101745] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.101749] cx23885[0]: [ffff8800529e6c00/27] wakeup reg=3324 buf=3324
> [ 3553.101776] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.101778] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.101780] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.101782] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.101789] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcfc
> [ 3553.101827] cx23885[0]: cx23885_buf_prepare: ffff8800529e6c00
> [ 3553.101832] cx23885[0]: [ffff8800529e6c00/27] cx23885_buf_queue - append to active
> [ 3553.110084] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.110087] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.110089] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.110091] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.110092] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcfd
> [ 3553.110094] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.110095] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.110099] cx23885[0]: [ffff880052a44400/28] wakeup reg=3325 buf=3325
> [ 3553.110135] cx23885[0]: cx23885_buf_prepare: ffff880052a44400
> [ 3553.110138] cx23885[0]: [ffff880052a44400/28] cx23885_buf_queue - append to active
> [ 3553.118437] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.118440] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.118442] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.118444] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.118446] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcfe
> [ 3553.118447] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.118449] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.118452] cx23885[0]: [ffff8800e2917400/29] wakeup reg=3326 buf=3326
> [ 3553.118489] cx23885[0]: cx23885_buf_prepare: ffff8800e2917400
> [ 3553.118494] cx23885[0]: [ffff8800e2917400/29] cx23885_buf_queue - append to active
> [ 3553.126787] cx23885[0]: pci_status: 0x0003c004  pci_mask: 0x00001f06
> [ 3553.126790] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.126792] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.126794] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.126796] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xcff
> [ 3553.126798] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.126799] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.126803] cx23885[0]: [ffff880052abd800/30] wakeup reg=3327 buf=3327
> [ 3553.126831] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.126833] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.126835] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.126837] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.126838] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xcff
> [ 3553.126875] cx23885[0]: cx23885_buf_prepare: ffff880052abd800
> [ 3553.126878] cx23885[0]: [ffff880052abd800/30] cx23885_buf_queue - append to active
> [ 3553.135137] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.135139] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.135141] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.135143] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.135145] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd00
> [ 3553.135146] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.135148] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.135151] cx23885[0]: [ffff8800c29a9000/31] wakeup reg=3328 buf=3328
> [ 3553.135180] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.135183] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.135185] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.135187] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.135189] cx23885[0]: cx23885_buf_prepare: ffff8800c29a9000
> [ 3553.135192] cx23885[0]: [ffff8800c29a9000/31] cx23885_buf_queue - append to active
> [ 3553.135195] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xd00
> [ 3553.143488] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.143491] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.143493] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.143495] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.143497] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd01
> [ 3553.143499] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.143500] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.143504] cx23885[0]: [ffff88004c829c00/0] wakeup reg=3329 buf=3329
> [ 3553.143531] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.143533] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.143535] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.143537] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.143539] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xd01
> [ 3553.143573] cx23885[0]: cx23885_buf_prepare: ffff88004c829c00
> [ 3553.143577] cx23885[0]: [ffff88004c829c00/0] cx23885_buf_queue - append to active
> [ 3553.151839] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.151841] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.151843] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.151845] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.151847] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd02
> [ 3553.151848] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.151849] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.151853] cx23885[0]: [ffff88004282a800/1] wakeup reg=3330 buf=3330
> [ 3553.151890] cx23885[0]: cx23885_buf_prepare: ffff88004282a800
> [ 3553.151893] cx23885[0]: [ffff88004282a800/1] cx23885_buf_queue - append to active
> [ 3553.160191] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.160194] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.160196] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.160198] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.160200] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd03
> [ 3553.160201] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.160203] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.160206] cx23885[0]: [ffff88004c9b8c00/2] wakeup reg=3331 buf=3331
> [ 3553.160244] cx23885[0]: cx23885_buf_prepare: ffff88004c9b8c00
> [ 3553.160248] cx23885[0]: [ffff88004c9b8c00/2] cx23885_buf_queue - append to active
> [ 3553.168541] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.168544] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.168546] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.168548] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.168550] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd04
> [ 3553.168552] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.168553] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.168557] cx23885[0]: [ffff88004c93c400/3] wakeup reg=3332 buf=3332
> [ 3553.168587] cx23885[0]: pci_status: 0x00004000  pci_mask: 0x00001f06
> [ 3553.168590] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.168592] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.168594] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.168596] cx23885[0]: ts2_status: 0x00000000  ts2_mask: 0x00001111 count: 0xd04
> [ 3553.168599] cx23885[0]: cx23885_buf_prepare: ffff88004c93c400
> [ 3553.168604] cx23885[0]: [ffff88004c93c400/3] cx23885_buf_queue - append to active
> [ 3553.176894] cx23885[0]: pci_status: 0x0000c004  pci_mask: 0x00001f06
> [ 3553.176896] cx23885[0]: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> [ 3553.176898] cx23885[0]: audint_status: 0x00000000 audint_mask: 0x00000000 count: 0x0
> [ 3553.176900] cx23885[0]: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x24ee
> [ 3553.176902] cx23885[0]: ts2_status: 0x00000001  ts2_mask: 0x00001111 count: 0xd05
> [ 3553.176903] cx23885[0]:  (PCI_MSK_VID_C     0x00000004)
> [ 3553.176905] cx23885[0]:  (RISCI1            0x00000001)
> [ 3553.176909] cx23885[0]: [ffff8800e0353c00/4] wakeup reg=3333 buf=3333
> [ 3553.176952] cx23885[0]: cx23885_buf_prepare: ffff8800e0353c00
> [ 3553.176958] cx23885[0]: [ffff8800e0353c00/4] cx23885_buf_queue - append to active
> 
> _____________________________________
> James Harper - Systems Technician
> Maxsum Solutions
> Bendigo: (03) 4433 9200  Melbourne: (03) 9098 0000
> Email: james@maxsum.com
> 
> This email is intended only for the use of the addressee. You must not edit this email or any attachments without my express consent. Maxsum Solutions is not liable for any failed, corrupted or incomplete transmission of this email or any attachments or for any viruses contained in them. By opening any attachments, you accept full responsibility for the consequences. If you are not the intended recipient, any dissemination, reliance upon or copying of this email or any attachments is strictly prohibited, and you must immediately erase them permanently from your system, notify Maxsum Solutions and destroy any hard copies.
> 
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

