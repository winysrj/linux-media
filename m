Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:52839 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1A1HqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 02:46:22 -0500
Date: Fri, 28 Jan 2011 08:46:55 +0100
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 0/2] Fix issues with frame reception from CSI on i.MX31
Message-ID: <20110128084655.0e6eddb5@wker>
In-Reply-To: <1296031789-1721-1-git-send-email-agust@denx.de>
References: <1296031789-1721-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 26 Jan 2011 09:49:47 +0100
Anatolij Gustschin <agust@denx.de> wrote:

> On some camera systems we do not tolerate the losing of
> captured frames. We observed losing of the first frame
> from CSI when double buffering is used (multiple buffers
> queued by the mx3-camera driver).
> 
> The patches provide fixes for the observed problem.
> 
> Anatolij Gustschin (2):
>   v4l: soc-camera: start stream after queueing the buffers
>   dma: ipu_idmac: do not lose valid received data in the irq handler
> 
>  drivers/dma/ipu/ipu_idmac.c      |   50 --------------------------------------
>  drivers/media/video/soc_camera.c |    4 +-
>  2 files changed, 2 insertions(+), 52 deletions(-)

Here I provide some more information on what has been done
to analyse the observed problem with one lost frame when
capturing an exact number of frames.

To be able to see whether some errors by hardware problems
or channel or image sensor parameters miss-configuration
appear or not and to catch such potential errors we added
new IRQ handlers for IPU error interrupts. The patch for these
handlers is inlined below, if someone is interested in it.
This extension requires setting CONFIG_MX3_IPU_IRQS=10 in the
kernel configuration. Also debug output has been activated in
the mx3_camera driver.

Two buffers are queued by the test application, so double buffering
will be used. To simplify matters the image sensor is triggered to
deliver only 3 frames.

Here is the resulting debug log from the drivers. It is quoted,
so I can add comments on related places:
...
> [   66.560000] mx3-camera mx3-camera.0: Set SENS_CONF to b00, rate 45314285
> [   66.560000] mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> [   66.560000] mx3-camera mx3-camera.0: Set format 960x243
> [   66.560000] ipu-core ipu-core: timeout = 0 * 10ms
> [   66.560000] ipu-core ipu-core: init channel = 7
> [   66.560000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x0
> [   66.560000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.560000] dma dma0chan7: Found channel 0x7, irq 177
> [   66.570000] Got SOF IRQ 179 on Channel 7
> [   66.570000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   66.570000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.570000] __________________________________________
> [   66.570000] mx3-camera mx3-camera.0: Sensor set 960x243
> [   66.570000] mx3-camera mx3-camera.0: requested bus width 10 bit: 0
> [   66.570000] mx3-camera mx3-camera.0: Flags cam: 0x7215 host: 0xf2fd common: 0x7215
> [   66.570000] mx3-camera mx3-camera.0: Set SENS_CONF to 700
> [   66.570000] mx3-camera mx3-camera.0: Set format 2056x1547
> [   66.580000] ipu-core ipu-core: timeout = 0 * 10ms
> [   66.580000] ipu-core ipu-core: init channel = 7
> [   66.580000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   66.580000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.580000] dma dma0chan7: Found channel 0x7, irq 177
> [   66.590000] mx3-camera mx3-camera.0: Sensor set 2056x1547
> [   66.590000] mx3-camera mx3-camera.0: requested bus width 10 bit: 0
> [   66.590000] mx3-camera mx3-camera.0: Flags cam: 0x7215 host: 0xf2fd common: 0x7215
> [   66.590000] mx3-camera mx3-camera.0: Set SENS_CONF to 700
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010070, data = 0x00000000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010071, data = 0x00004000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010072, data = 0x00000000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010073, data = 0x0A807000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010074, data = 0x00000006
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010078, data = 0x86800000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x00010079, data = 0x00000000
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x0001007A, data = 0x3E0E403B
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x0001007B, data = 0x00000002
> [   66.870000] ipu-core ipu-core: write param mem - addr = 0x0001007C, data = 0x00000000
> [   66.870000] dma dma0chan7: Submitting sg c798a7ac
> [   66.870000] dma dma0chan7: Updated sg c798a7ac on channel 0x7 buffer 0
> [   66.870000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   66.870000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.870000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   66.870000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.870000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   66.870000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   66.870000] mx3-camera mx3-camera.0: Submitted cookie 2 DMA 0x86800000
> [   66.890000] dma dma0chan7: Submitting sg c798a4ac
> [   66.890000] dma dma0chan7: Updated sg c798a4ac on channel 0x7 buffer 1
> [   66.890000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   66.890000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x3
> [   66.890000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   66.890000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x3
> [   66.890000] mx3-camera mx3-camera.0: Submitted cookie 3 DMA 0x86c00000

So far, two buffers have been prepared. When double buffering is
activated, DMAIC_7_CUR_BUF flag will be set, DMAIC_7_BUF0_RDY and
DMAIC_7_BUF1_RDY are set by the driver, indicating that the both
buffers are ready for DMA transfers. Image sensor trigger sequence is
started now.

> [   66.940000] Got SOF IRQ 179 on Channel 7
> [   66.940000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   66.940000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   66.940000] __________________________________________
> [   66.940000] Got NF ACK IRQ 178 on Channel 7
> [   66.940000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   66.940000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   66.940000] __________________________________________
> [   67.020000] Got EOF IRQ 180 on Channel 7
> [   67.020000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.020000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.020000] __________________________________________

When CSI starts to deliver image data, CSI_NF and NF ACK interrupts
are triggered. At this time we see, that the DMAIC_7_CUR_BUF flag has
been flipped to point to the first buffer 0 and the DMAIC_7_BUSY flag is
set, indicating that IDMAC is writing to the buffer 0. When the frame
data has been received, CSI_EOF interrupt is generated. At this time
IDMAC has transmitted the data to the buffer 0 and is not busy any more:
the DMAIC_7_BUSY flag is not set. DMAIC_7_CUR_BUF flag is pointing to
the buffer 0. DMAIC_7_BUF0_RDY flag has been reset when CSI_NF interrupt
occurred, indicating that the buffer 0 is being written by the DMA.
We got EOF IRQ 180 (which is CSI_EOF), the DMA tranfer is done,
the data is sitting in the buffer 0. The buffer 1 is ready for DMA
transfers and will be used when the next image frame arrives.

> [   67.020000] dma dma0chan7: IDMAC irq 177, buf 0
> [   67.020000] dma dma0chan7: IRQ on active buffer on channel 7, active 0, ready 0, 80, current 0!

Now the DMAIC_7_EOF interrupt (end of frame on the DMA channel) is
triggered and the interrupt handler should (among other things) now
call the done callback of the mx3_camera driver.
But the handler waits here for DMAIC_7_CUR_BUF to flip, and after
the wait counter becomes zero, the handler returns (DMAIC_7_CUR_BUF won't
flip here, it will flip first when the new frame data is comming and some
buffer is found to be in the ready state). The frame arrived and is
sitting in the buffer 0, but the reporting of this reception is not
done here.

> [   67.180000] Got SOF IRQ 179 on Channel 7
> [   67.180000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   67.180000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.180000] __________________________________________
> [   67.180000] Got NF ACK IRQ 178 on Channel 7
> [   67.180000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   67.180000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.180000] __________________________________________

Here we see it. CSI_NF and NF ACK interrupts occurred as the next
frame from the camera sensor is being received. The buffer 1 was
previously ready, so FSU flipped the DMAIC_7_CUR_BUF flag to point
to the buffer 1. DMAIC_7_BUF1_RDY flag is reset, the new frame data
is being written to the buffer 1, DMAIC_7_BUSY flag indicates
channel 7 DMA busy status.

> [   67.260000] Got EOF IRQ 180 on Channel 7
> [   67.260000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.260000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.260000] __________________________________________

CSI_EOF interrupt is triggered. The next frame data has been
received and is sitting in the buffer 1, DMAIC_7_BUSY is reset,
so the DMA transfer is completed. We have received two frames
so far.

> [   67.260000] dma dma0chan7: IDMAC irq 177, buf 0
> [   67.260000] dma dma0chan7: IDMAC irq 177, dma 0x86800000, next dma 0x86c00000, current 0, curbuf 0x00000080
> [   67.260000] ipu-core ipu-core: callback cookie 2, active DMA 0x86800000
> [   67.330000] dma dma0chan7: Submitting sg c798a7ac
> [   67.330000] dma dma0chan7: Updated sg c798a7ac on channel 0x7 buffer 0
> [   67.330000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.330000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.330000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.330000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.330000] mx3-camera mx3-camera.0: Submitted cookie 4 DMA 0x86800000

DMAIC_7_EOF interrupt for the second frame occured and the channels
active_buffer software flag 'ichan->active_buffer' is pointing to
the buffer 0, so the interrupt handler reported the reception of the
first frame in buffer 0 to the user space, the buffer 0 has been dequeued
and then enqueued again and is now ready for frame data reception.
DMAIC_7_BUF0_RDY flag is now set, indicating that the buffer 0 is ready.
The buffer 0 is prepared for reception of the third frame. The second
frame is still sitting in the buffer 1. The driver's software flag
'ichan->active_buffer' is flipped to 1.

> [   67.430000] Got SOF IRQ 179 on Channel 7
> [   67.430000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   67.430000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.430000] __________________________________________
> [   67.430000] Got NF ACK IRQ 178 on Channel 7
> [   67.430000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   67.430000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.430000] __________________________________________

CSI starts to deliver image data of the third frame , CSI_NF and NF ACK
interrupts are triggered. The buffer 0 was previously ready, so it became
current buffer: DMAIC_7_BUSY flag is set, DMAIC_7_CUR_BUF flag is pointing
to the buffer 0.

> [   67.510000] Got EOF IRQ 180 on Channel 7
> [   67.510000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.510000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.510000] __________________________________________

End of frame for the third frame is signalled, DMAIC_7_BUSY flag is
cleared, so reception is completed, the data of the third frame is
in buffer 0 now. The data of the second frame is still in the buffer 1.

> [   67.510000] dma dma0chan7: IDMAC irq 177, buf 1
> [   67.510000] dma dma0chan7: IDMAC irq 177, dma 0x86c00000, next dma 0x86800000, current 1, curbuf 0x00000000
> [   67.510000] ipu-core ipu-core: callback cookie 3, active DMA 0x86c00000
> [   67.570000] dma dma0chan7: Submitting sg c798a4ac
> [   67.570000] dma dma0chan7: Updated sg c798a4ac on channel 0x7 buffer 1
> [   67.570000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.570000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.570000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   67.570000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   67.570000] mx3-camera mx3-camera.0: Submitted cookie 5 DMA 0x86c00000

DMAIC_7_EOF interrupt for the third frame occured. The driver's software
flag 'ichan->active_buffer' was pointing to buffer 1, so the interrupt
handler reports the reception of the second frame. The buffer 1 is dequeued
and then enqueued again, second frame is arrived in user space. Since we
requested only three frames from the image sensor, no more frames will be
delivered and no interrupts from the CSI or DMAIC_7_EOF will occure. The
third frame has been received and is sitting in the buffer 0, but this won't
be reported. Instead of requested three frames we got only two frames.
So we can see that in order ot get N frames we have to request N + 1 frames
from the image sensor. In camera applications with continuous image stream
such behaviour might be acceptable. But in our use case we _must_ be able
to receive exact the same number of frames as we have requested.

> [   70.580000] mx3-camera mx3-camera.0: Release active DMA 0x86800000 (state 3), queue not empty
> [   70.580000] mx3-camera mx3-camera.0: free_buffer (vb=0xc798a740) 0x4138c000 3180632
> [   70.580000] mx3-camera mx3-camera.0: Release DMA 0x86c00000 (state 5), queue not empty
> [   70.580000] mx3-camera mx3-camera.0: free_buffer (vb=0xc798a440) 0x41695000 3180632


No IPU error interrupts appeared in the log, no IPU error interrupts
have been signalled:

grep ipu_irq /proc/interrupts 
176:          2     ipu_irq  IDMAC EOF 14
177:          3     ipu_irq  IDMAC EOF 7
178:          3     ipu_irq  DMAIC NF ACK
179:          4     ipu_irq  IC SOF
180:          3     ipu_irq  IC EOF
181:          0     ipu_irq  IC NFB4EOF ERR
182:          0     ipu_irq  BAYER BUF OVF ERR
183:          0     ipu_irq  ENC BUF OVF ERR
184:          0     ipu_irq  BAYER FRM LOST ERR
185:          0     ipu_irq  ENC FRM LOST ERR

PATCH '2/2 dma: ipu_idmac: do not lose valid received data in the irq handler'
fixes this problem. Using it we are able to receive exact number of
requested frames when using double buffering. The problem doesn't
appear when only one buffer is queued.

Here is the log how things look like with the patch 2/2 applied:

> [   71.800000] mx3-camera mx3-camera.0: Set SENS_CONF to b00, rate 45314285
> [   71.800000] mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> [   71.800000] mx3-camera mx3-camera.0: Set format 960x243
> [   71.800000] ipu-core ipu-core: timeout = 0 * 10ms
> [   71.800000] ipu-core ipu-core: init channel = 7
> [   71.800000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   71.800000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   71.800000] dma dma0chan7: Found channel 0x7, irq 177
> [   71.810000] Got SOF IRQ 179 on Channel 7
> [   71.810000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   71.810000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   71.810000] __________________________________________
> [   71.810000] mx3-camera mx3-camera.0: Sensor set 960x243
> [   71.810000] mx3-camera mx3-camera.0: requested bus width 10 bit: 0
> [   71.810000] mx3-camera mx3-camera.0: Flags cam: 0x7215 host: 0xf2fd common: 0x7215
> [   71.810000] mx3-camera mx3-camera.0: Set SENS_CONF to 700
> [   71.810000] mx3-camera mx3-camera.0: Set format 2056x1547
> [   71.810000] ipu-core ipu-core: timeout = 0 * 10ms
> [   71.810000] ipu-core ipu-core: init channel = 7
> [   71.810000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   71.810000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   71.810000] dma dma0chan7: Found channel 0x7, irq 177
> [   71.830000] mx3-camera mx3-camera.0: Sensor set 2056x1547
> [   71.830000] mx3-camera mx3-camera.0: requested bus width 10 bit: 0
> [   71.830000] mx3-camera mx3-camera.0: Flags cam: 0x7215 host: 0xf2fd common: 0x7215
> [   71.830000] mx3-camera mx3-camera.0: Set SENS_CONF to 700
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010070, data = 0x00000000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010071, data = 0x00004000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010072, data = 0x00000000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010073, data = 0x0A807000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010074, data = 0x00000006
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010078, data = 0x86800000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x00010079, data = 0x00000000
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x0001007A, data = 0x3E0E403B
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x0001007B, data = 0x00000002
> [   72.100000] ipu-core ipu-core: write param mem - addr = 0x0001007C, data = 0x00000000
> [   72.100000] dma dma0chan7: Submitting sg c798a32c
> [   72.100000] dma dma0chan7: Updated sg c798a32c on channel 0x7 buffer 0
> [   72.100000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4000, IDMAC_CHA_BUSY 0x4000
> [   72.100000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   72.100000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x0, IDMAC_CHA_EN 0x4000, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.100000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   72.100000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.100000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x0, DB_MODE 0x0, TASKS_STAT 0x3
> [   72.100000] mx3-camera mx3-camera.0: Submitted cookie 2 DMA 0x86800000
> [   72.120000] dma dma0chan7: Submitting sg c798a0ec
> [   72.120000] dma dma0chan7: Updated sg c798a0ec on channel 0x7 buffer 1
> [   72.120000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.120000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x3
> [   72.120000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.120000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x3
> [   72.120000] mx3-camera mx3-camera.0: Submitted cookie 3 DMA 0x86c00000
> [   72.170000] Got SOF IRQ 179 on Channel 7
> [   72.170000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.170000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.170000] __________________________________________
> [   72.170000] Got NF ACK IRQ 178 on Channel 7
> [   72.170000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.170000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.170000] __________________________________________
> [   72.250000] Got EOF IRQ 180 on Channel 7
> [   72.250000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.250000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.250000] __________________________________________
> [   72.250000] dma dma0chan7: IDMAC irq 177, buf 0
> [   72.250000] dma dma0chan7: IDMAC irq 177, dma 0x86800000, next dma 0x86c00000, current 0, curbuf 0x00000000
> [   72.250000] ipu-core ipu-core: callback cookie 2, active DMA 0x86800000
> [   72.300000] dma dma0chan7: Submitting sg c798a32c
> [   72.300000] dma dma0chan7: Updated sg c798a32c on channel 0x7 buffer 0
> [   72.300000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.300000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.300000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.300000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.300000] mx3-camera mx3-camera.0: Submitted cookie 4 DMA 0x86800000
> [   72.420000] Got SOF IRQ 179 on Channel 7
> [   72.420000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.420000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.420000] __________________________________________
> [   72.420000] Got NF ACK IRQ 178 on Channel 7
> [   72.420000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.420000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.420000] __________________________________________
> [   72.500000] Got EOF IRQ 180 on Channel 7
> [   72.500000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.500000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x0, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.500000] __________________________________________
> [   72.500000] dma dma0chan7: IDMAC irq 177, buf 1
> [   72.500000] dma dma0chan7: IDMAC irq 177, dma 0x86c00000, next dma 0x86800000, current 1, curbuf 0x00000080
> [   72.500000] ipu-core ipu-core: callback cookie 3, active DMA 0x86c00000
> [   72.550000] dma dma0chan7: Submitting sg c798a0ec
> [   72.550000] dma dma0chan7: Updated sg c798a0ec on channel 0x7 buffer 1
> [   72.550000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.550000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.550000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.550000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x80, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.550000] mx3-camera mx3-camera.0: Submitted cookie 5 DMA 0x86c00000
> [   72.660000] Got SOF IRQ 179 on Channel 7
> [   72.660000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.660000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.660000] __________________________________________
> [   72.660000] Got NF ACK IRQ 178 on Channel 7
> [   72.660000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4080
> [   72.660000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.660000] __________________________________________
> [   72.740000] Got EOF IRQ 180 on Channel 7
> [   72.740000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.740000] ipu-core ipu-core: BUF0_RDY 0x0, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.740000] __________________________________________
> [   72.740000] dma dma0chan7: IDMAC irq 177, buf 0
> [   72.740000] dma dma0chan7: IDMAC irq 177, dma 0x86800000, next dma 0x86c00000, current 0, curbuf 0x00000000
> [   72.740000] ipu-core ipu-core: callback cookie 4, active DMA 0x86800000
> [   72.790000] dma dma0chan7: Submitting sg c798a32c
> [   72.790000] dma dma0chan7: Updated sg c798a32c on channel 0x7 buffer 0
> [   72.790000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.790000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.790000] ipu-core ipu-core: IDMAC_CONF 0x70, IC_CONF 0x40000001, IDMAC_CHA_EN 0x4080, IDMAC_CHA_PRI 0x4080, IDMAC_CHA_BUSY 0x4000
> [   72.790000] ipu-core ipu-core: BUF0_RDY 0x80, BUF1_RDY 0x80, CUR_BUF 0x0, DB_MODE 0x80, TASKS_STAT 0x7
> [   72.790000] mx3-camera mx3-camera.0: Submitted cookie 6 DMA 0x86800000
> [   72.790000] mx3-camera mx3-camera.0: Release DMA 0x86800000 (state 5), queue not empty
> [   72.790000] mx3-camera mx3-camera.0: free_buffer (vb=0xc798a2c0) 0x4138c000 3180632
> [   72.790000] mx3-camera mx3-camera.0: Release active DMA 0x86c00000 (state 3), queue not empty
> [   72.790000] mx3-camera mx3-camera.0: free_buffer (vb=0xc798a080) 0x41695000 3180632

We can see here that alls three frames could be received and read out
by the test application.

Here is the used debug patch for interested parties:

 drivers/dma/ipu/ipu_idmac.c      |  143 +++++++++++++++++++++++++++++++++++++-
 drivers/media/video/mx3_camera.c |    2 +-
 2 files changed, 141 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index d696915..f9fa0b3 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -8,7 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#define DEBUG
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
@@ -910,6 +910,8 @@ static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
 		goto dequeue;
 	}
 
+	dump_idmac_reg(ipu);
+
 	if (ichan->status < IPU_CHANNEL_ENABLED) {
 		ret = ipu_enable_channel(idmac, ichan);
 		if (ret < 0) {
@@ -1472,22 +1474,106 @@ static void idmac_terminate_all(struct dma_chan *chan)
 static irqreturn_t ic_sof_irq(int irq, void *dev_id)
 {
 	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
 	printk(KERN_DEBUG "Got SOF IRQ %d on Channel %d\n",
 	       irq, ichan->dma_chan.chan_id);
-	disable_irq_nosync(irq);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	/*disable_irq_nosync(irq);*/
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t ic_eof_irq(int irq, void *dev_id)
 {
 	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
 	printk(KERN_DEBUG "Got EOF IRQ %d on Channel %d\n",
 	       irq, ichan->dma_chan.chan_id);
-	disable_irq_nosync(irq);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	/*disable_irq_nosync(irq);*/
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_nf_ack_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got NF ACK IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_nfb4_eof_err_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got NF B4 EOF ERR IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_bay_ovf_err_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got BAYER BUF OVF ERR IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_enc_ovf_err_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got ENC BUF OVF ERR IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ic_bay_frm_lost_err_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got BAYER FRM LOST ERR IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ic_enc_frm_lost_err_irq(int irq, void *dev_id)
+{
+	struct idmac_channel *ichan = dev_id;
+	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
+	struct ipu *ipu = to_ipu(idmac);
+	printk(KERN_DEBUG "Got ENC FRM LOST ERR IRQ %d on Channel %d\n",
+	       irq, ichan->dma_chan.chan_id);
+	dump_idmac_reg(ipu);
+	printk(KERN_DEBUG "__________________________________________\n");
+	return IRQ_HANDLED;
+}
+
+
 static int ic_sof = -EINVAL, ic_eof = -EINVAL;
+static int ic_nf_ack = -EINVAL, ic_nfb4_eof_err = -EINVAL;
+static int ic_bay_ovf_err = -EINVAL, ic_enc_ovf_err = -EINVAL;
+static int ic_bay_frm_lost_err = -EINVAL, ic_enc_frm_lost_err = -EINVAL;
 #endif
 
 static int idmac_alloc_chan_resources(struct dma_chan *chan)
@@ -1526,12 +1612,33 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan)
 
 #ifdef DEBUG
 	if (chan->chan_id == IDMAC_IC_7) {
+		ic_nf_ack = ipu_irq_map(39);
+		if (ic_nf_ack > 0)
+			request_irq(ic_nf_ack, ic_nf_ack_irq, 0, "DMAIC NF ACK", ichan);
 		ic_sof = ipu_irq_map(69);
 		if (ic_sof > 0)
 			request_irq(ic_sof, ic_sof_irq, 0, "IC SOF", ichan);
 		ic_eof = ipu_irq_map(70);
 		if (ic_eof > 0)
 			request_irq(ic_eof, ic_eof_irq, 0, "IC EOF", ichan);
+		ic_nfb4_eof_err = ipu_irq_map(103);
+		if (ic_nfb4_eof_err > 0)
+			request_irq(ic_nfb4_eof_err, ic_nfb4_eof_err_irq, 0, "IC NFB4EOF ERR", ichan);
+
+		ic_bay_ovf_err = ipu_irq_map(128);
+		if (ic_bay_ovf_err > 0)
+			request_irq(ic_bay_ovf_err, ic_bay_ovf_err_irq, 0, "BAYER BUF OVF ERR", ichan);
+		ic_enc_ovf_err = ipu_irq_map(129);
+		if (ic_enc_ovf_err > 0)
+			request_irq(ic_enc_ovf_err, ic_enc_ovf_err_irq, 0, "ENC BUF OVF ERR", ichan);
+
+		ic_bay_frm_lost_err = ipu_irq_map(139);
+		if (ic_bay_frm_lost_err > 0)
+			request_irq(ic_bay_frm_lost_err, ic_bay_frm_lost_err_irq, 0, "BAYER FRM LOST ERR", ichan);
+
+		ic_enc_frm_lost_err = ipu_irq_map(140);
+		if (ic_enc_frm_lost_err > 0)
+			request_irq(ic_enc_frm_lost_err, ic_enc_frm_lost_err_irq, 0, "ENC FRM LOST ERR", ichan);
 	}
 #endif
 
@@ -1562,6 +1669,11 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 	if (ichan->status > IPU_CHANNEL_FREE) {
 #ifdef DEBUG
 		if (chan->chan_id == IDMAC_IC_7) {
+			if (ic_nf_ack > 0) {
+				free_irq(ic_nf_ack, ichan);
+				ipu_irq_unmap(39);
+				ic_nf_ack = -EINVAL;
+			}
 			if (ic_sof > 0) {
 				free_irq(ic_sof, ichan);
 				ipu_irq_unmap(69);
@@ -1572,6 +1684,31 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 				ipu_irq_unmap(70);
 				ic_eof = -EINVAL;
 			}
+			if (ic_nfb4_eof_err > 0) {
+				free_irq(ic_nfb4_eof_err, ichan);
+				ipu_irq_unmap(103);
+				ic_nfb4_eof_err = -EINVAL;
+			}
+			if (ic_bay_ovf_err > 0) {
+				free_irq(ic_bay_ovf_err, ichan);
+				ipu_irq_unmap(128);
+				ic_bay_ovf_err = -EINVAL;
+			}
+			if (ic_enc_ovf_err > 0) {
+				free_irq(ic_enc_ovf_err, ichan);
+				ipu_irq_unmap(129);
+				ic_enc_ovf_err = -EINVAL;
+			}
+			if (ic_bay_frm_lost_err > 0) {
+				free_irq(ic_bay_frm_lost_err, ichan);
+				ipu_irq_unmap(139);
+				ic_bay_frm_lost_err = -EINVAL;
+			}
+			if (ic_enc_frm_lost_err > 0) {
+				free_irq(ic_enc_frm_lost_err, ichan);
+				ipu_irq_unmap(140);
+				ic_enc_frm_lost_err = -EINVAL;
+			}
 		}
 #endif
 		free_irq(ichan->eof_irq, ichan);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 2322798..9e566dd 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -8,7 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#define DEBUG
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/version.h>
-- 
1.7.1

