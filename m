Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.astim.si ([93.103.6.239]:38781 "EHLO mail.astim.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbcE1JrW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 05:47:22 -0400
Received: from PCSaso ([192.168.10.2])
	by mail.astim.si (8.14.4/8.14.4) with ESMTP id u4S9lKbX023488
	for <linux-media@vger.kernel.org>; Sat, 28 May 2016 11:47:20 +0200
From: "Saso Slavicic" <saso.linux@astim.si>
To: <linux-media@vger.kernel.org>
Subject: netup_unidvb CI problem
Date: Sat, 28 May 2016 11:47:12 +0200
Message-ID: <001001d1b8c5$e8d905a0$ba8b10e0$@astim.si>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: sl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a problem with CI slots on NetUP Dual DVB Universal CI card.  Running
kernel-ml 4.4 on Centos 7 produces the following error:

[765846.415719] netup_unidvb 0000:11:00.0: DVB init done, num=1
[765846.415721] dvb_ca_en50221_init
[765846.415804] DVB: register adapter0/ca0 @ minor: 24 (0x18)
[765846.415893] netup_unidvb 0000:11:00.0: netup_unidvb_ci_register(): CI
adapter 0 init done
[765846.415895] dvb_ca_en50221_thread
[765846.415901] dvb_ca_en50221_init
[765846.416081] DVB: register adapter1/ca0 @ minor: 25 (0x19)
[765846.417708] netup_unidvb 0000:11:00.0: netup_unidvb_ci_register(): CI
adapter 1 init done
[765846.417710] dvb_ca_en50221_thread
[765846.417719] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): starting
DMA0
[765846.417727] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): DMA0
buffer virt/phys 0xffff880073f00000/0x73f00000 size 192512
[765847.417870] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): starting
DMA1
[765847.417878] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): DMA1
buffer virt/phys 0xffff880073f2f000/0x73f2f000 size 192512
[765848.418819] netup_unidvb:netup_unidvb_dma_enable:190: netup_unidvb
0000:11:00.0: netup_unidvb_dma_enable(): DMA0 enable 0
[765848.418827] netup_unidvb:netup_unidvb_dma_enable:190: netup_unidvb
0000:11:00.0: netup_unidvb_dma_enable(): DMA1 enable 0
[765848.418831] netup_unidvb 0000:11:00.0: netup_unidvb: device has been
initialized
[765851.415671] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765851.415682] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765851.415691] netup_unidvb:netup_unidvb_ci_slot_reset:100: netup_unidvb
0000:11:00.0: netup_unidvb_ci_slot_reset(): CAM_CTRLSTAT_READ_SET=0x1a1a
[765851.415695] netup_unidvb:netup_unidvb_ci_slot_reset:105: netup_unidvb
0000:11:00.0: netup_unidvb_ci_slot_reset(): waiting for reset
[765851.416651] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a0e
[765851.416662] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a0e
[765851.416671] netup_unidvb:netup_unidvb_ci_slot_reset:100: netup_unidvb
0000:11:00.0: netup_unidvb_ci_slot_reset(): CAM_CTRLSTAT_READ_SET=0x1a0e
[765851.416675] netup_unidvb:netup_unidvb_ci_slot_reset:105: netup_unidvb
0000:11:00.0: netup_unidvb_ci_slot_reset(): waiting for reset
[765851.536622] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765851.536631] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x0
val=0x4
[765851.536636] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x2
val=0x0
[765851.536638] TUPLE type:0x4 length:0
[765851.536642] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765851.536645] dvb_ca adapter 1: Invalid PC card inserted :(
[765851.636603] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765851.736601] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765851.836599] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765851.936590] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765852.036583] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a8a
[765852.136611] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765852.210627] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765852.210635] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x0
val=0x1d
[765852.210640] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x2
val=0x0
[765852.210641] TUPLE type:0x1d length:0
[765852.210646] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x4
val=0x0
[765852.210650] netup_unidvb:netup_unidvb_ci_read_attribute_mem:153:
netup_unidvb 0000:11:00.0: netup_unidvb_ci_read_attribute_mem(): addr=0x6
val=0x0
[765852.210651] TUPLE type:0x0 length:0
[765852.210655] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765852.210658] dvb_ca adapter 0: Invalid PC card inserted :(
[765852.236601] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765852.310604] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
[765852.336609] netup_unidvb:netup_unidvb_poll_ci_slot_status:132:
netup_unidvb 0000:11:00.0: netup_unidvb_poll_ci_slot_status():
CAM_CTRLSTAT_READ_SET=0x1a1a
....

See how reading the first tuple from the first slot produces type = 0x4 and
length = 0x0. The first tuple from the second CI slots although produces
correct type 0x1d, the length is again 0 and the second tuple is all zeroes.

The same card, with the same CI modules detects modules correctly with the
Centos 3.10 kernel and netup driver from 2014.

[  242.051500] netup_unidvb 0000:11:00.0: netup_unidvb_ci_register(): CI
adapter 0 init done
[  242.051828] netup_unidvb 0000:11:00.0: netup_unidvb_ci_register(): CI
adapter 1 init done
[  242.051836] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): starting
DMA0
[  242.051946] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): DMA0
buffer virt/phys 0xffff8800b0600000/0xb0600000 size 192512
[  243.053415] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): starting
DMA1
[  243.053520] netup_unidvb 0000:11:00.0: netup_unidvb_dma_init(): DMA1
buffer virt/phys 0xffff8800b0640000/0xb0640000 size 192512
[  244.055276] netup_unidvb 0000:11:00.0: netup_unidvb: device has been
initialized
[  247.586204] dvb_ca adapter 1: DVB CAM detected and initialised
successfully
[  247.855427] dvb_ca adapter 0: DVB CAM detected and initialised
successfully

I have compared the drivers and I don't spot any obvious differences between
the 4.4 kernel driver and the netup 2014 driver.
The CI tuple reading seems like a simple operation of reading the correct
memory address...why would this fail? Other than the CI modules, the card
seems to be working with 4.4 kernel.
Is there some other debugging I could check, outside the netup module?

Regards,
Saso Slavicic

