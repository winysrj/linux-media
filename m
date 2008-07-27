Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KN9vG-00015f-VS
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 19:20:44 +0200
Message-ID: <488CAE63.9070204@kolumbus.fi>
Date: Sun, 27 Jul 2008 20:20:35 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Leif Oberste-Berghaus <leif@oberste-berghaus.de>
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
	<4879FA31.2080803@kolumbus.fi>
	<4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>
	<487BB17D.8080707@kolumbus.fi>
	<D5C41D41-A72D-4603-9AD1-67A8C5E73289@oberste-berghaus.de>
In-Reply-To: <D5C41D41-A72D-4603-9AD1-67A8C5E73289@oberste-berghaus.de>
Content-Type: multipart/mixed; boundary="------------040903070307040903060007"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
 (VP-2040) &	mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040903070307040903060007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,

Unfortunately I have been busy.

The patch you tried was against jusst.de Mantis Mercurial branch head.
Your version of mantis_dma.c is not the latest version and thus the 
patch didn't
apply cleanly.

Here is the version that I use currently. It doesn't compile straight 
against jusst.de/mantis head.
It might work for you because MANTIS_GPIF_RDWRN is not renamed as 
MANTIS_GPIF_HIFRDWRN.

If it doesn't compile please rename MANTIS_GPIF_RDWRN occurrences into 
MANTIS_GPIF_HIFRDWRN on that file.
Otherwise the file should work as it is.

Best regards,
Marko Ristola

Leif Oberste-Berghaus kirjoitti:
> Hi Marko,
>
> I tried to patch the driver but I'm getting an error message:
>
> root@mediapc:/usr/local/src/test/mantis-0b04be0c088a# patch -p1 < 
> mantis_dma.c.aligned_dma_trs.patch
> patching file linux/drivers/media/dvb/mantis/mantis_dma.c
> patch: **** malformed patch at line 22: int mantis_dma_exit(struct 
> mantis_pci *mantis)
>
> Any ideas?
>
> Regards
> Leif
>
>
> Am 14.07.2008 um 22:05 schrieb Marko Ristola:
>
>> Hi Leif,
>>
>> Here is a patch that implements the mentioned DMA transfer improvements.
>> I hope that these contain also the needed fix for you.
>> You can apply it into jusst.de/mantis Mercurial branch.
>> It modifies linux/drivers/media/dvb/mantis/mantis_dma.c only.
>> I have compiled the patch against 2.6.25.9-76.fc9.x86_64.
>>
>> cd mantis
>> patch -p1 < mantis_dma.c.aligned_dma_trs.patch
>>
>> Please tell us whether my patch helps you or not: if it helps, some 
>> of my patch might get into jusst.de as
>> a fix for your problem.
>>
>> Best Regards,
>> Marko
>
>


--------------040903070307040903060007
Content-Type: text/x-csrc;
 name="mantis_dma.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mantis_dma.c"

/*
	Mantis PCI bridge driver

	Copyright (C) 2005, 2006 Manu Abraham (abraham.manu@gmail.com)

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <asm/page.h>
#include <linux/vmalloc.h>
#include "mantis_common.h"

#define RISC_WRITE		(0x01 << 28)
#define RISC_JUMP		(0x07 << 28)
#define RISC_SYNC		(0x08 << 28)
#define RISC_IRQ		(0x01 << 24)

#define RISC_STATUS(status)	((((~status) & 0x0f) << 20) | ((status & 0x0f) << 16))
#define RISC_FLUSH()		mantis->risc_pos = 0
#define RISC_INSTR(opcode)	mantis->risc_cpu[mantis->risc_pos++] = cpu_to_le32(opcode)

/* (16 * 188) = 3008. (16 * 204) = 3264. x % 64 == 0, x <= 4095 */
#define RISC_DMA_TR_UNIT(m)     (((m->hwconfig->ts_size == MANTIS_TS_204)? 204:188) * 16)
#define DMA_TRANSFERS_PER_BLOCK (9)
#define MANTIS_BLOCK_BYTES(m)   (RISC_DMA_TR_UNIT(m) * DMA_TRANSFERS_PER_BLOCK)
#define MANTIS_BLOCK_COUNT	(4)
#define MANTIS_RISC_SIZE	PAGE_SIZE

#define MANTIS_DMA_BUFSZ(m)     (m->line_bytes * m->line_count)

int mantis_dma_exit(struct mantis_pci *mantis)
{
	if (mantis->buf_cpu) {
		dprintk(verbose, MANTIS_ERROR, 1,
			"DMA=0x%lx cpu=0x%p size=%d",
			(unsigned long) mantis->buf_dma,
			 mantis->buf_cpu,
			 MANTIS_DMA_BUFSZ(mantis));

		pci_free_consistent(mantis->pdev, 
				MANTIS_DMA_BUFSZ(mantis),
			mantis->buf_cpu, mantis->buf_dma);

		mantis->buf_cpu = NULL;
	}
	if (mantis->risc_cpu) {
		dprintk(verbose, MANTIS_ERROR, 1,
			"RISC=0x%lx cpu=0x%p size=%lx",
			(unsigned long) mantis->risc_dma,
			mantis->risc_cpu,
			MANTIS_RISC_SIZE);

		pci_free_consistent(mantis->pdev, MANTIS_RISC_SIZE,
				    mantis->risc_cpu, mantis->risc_dma);

		mantis->risc_cpu = NULL;
	}

	return 0;
}

static inline int mantis_alloc_buffers(struct mantis_pci *mantis)
{
	if (!mantis->buf_cpu) {
		mantis->buf_cpu = pci_alloc_consistent(mantis->pdev,
				MANTIS_DMA_BUFSZ(mantis),
			&mantis->buf_dma);
		if (!mantis->buf_cpu) {
			dprintk(verbose, MANTIS_ERROR, 1,
				"DMA buffer allocation failed");

			goto err;
		}
		dprintk(verbose, MANTIS_ERROR, 1,
			"DMA=0x%lx cpu=0x%p size=%d",
			(unsigned long) mantis->buf_dma,
			mantis->buf_cpu, 
			MANTIS_DMA_BUFSZ(mantis));
	}
	if (!mantis->risc_cpu) {
		mantis->risc_cpu = pci_alloc_consistent(mantis->pdev,
							MANTIS_RISC_SIZE,
							&mantis->risc_dma);

		if (!mantis->risc_cpu) {
			dprintk(verbose, MANTIS_ERROR, 1,
				"RISC program allocation failed");

			mantis_dma_exit(mantis);

			goto err;
		}
		dprintk(verbose, MANTIS_ERROR, 1,
			"RISC=0x%lx cpu=0x%p size=%lx",
			(unsigned long) mantis->risc_dma,
			mantis->risc_cpu, MANTIS_RISC_SIZE);
	}

	return 0;
err:
	dprintk(verbose, MANTIS_ERROR, 1, "Out of memory (?) .....");
	return -ENOMEM;
}

static inline int mantis_calc_lines(struct mantis_pci *mantis)
{
	mantis->line_bytes = MANTIS_BLOCK_BYTES(mantis);
	mantis->line_count = MANTIS_BLOCK_COUNT;

	dprintk(verbose, MANTIS_DEBUG, 1,
		"Mantis RISC line bytes=[%d], line count=[%d]",
		mantis->line_bytes, mantis->line_count);

	return 0;
}

int mantis_dma_init(struct mantis_pci *mantis)
{
	int err = 0;

	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis DMA init");

	if ((err = mantis_calc_lines(mantis)) < 0) {
		dprintk(verbose, MANTIS_ERROR, 1, "Mantis calc lines failed");

		goto err;
	}

	if (mantis_alloc_buffers(mantis) < 0) {
		dprintk(verbose, MANTIS_ERROR, 1, "Error allocating DMA buffer");

		// Stop RISC Engine
//		mmwrite(mmread(MANTIS_DMA_CTL) & ~MANTIS_RISC_EN, MANTIS_DMA_CTL);
		mmwrite(0, MANTIS_DMA_CTL);

		goto err;
	}

	return 0;
err:
	return err;
}

static inline void mantis_risc_program(struct mantis_pci *mantis)
{
	u32 buf_pos = 0;
	u32 line;
	u32 step_bytes;

	step_bytes = RISC_DMA_TR_UNIT(mantis);
	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis create RISC program");
	RISC_FLUSH();

	dprintk(verbose, MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u",
		mantis->line_count, mantis->line_bytes);

	for (line = 0; line < mantis->line_count; line++) {
		int risc_step;

		for (risc_step = 0; risc_step < DMA_TRANSFERS_PER_BLOCK; risc_step++) {
			dprintk(verbose, MANTIS_DEBUG, 1, "RISC PROG line=[%x] risc_step=[%x], step_bytes=[%x], buf_pos=[%x]", line, risc_step, step_bytes, buf_pos);
			/* First step: informs that the previous line has been completed (round robin). */
			RISC_INSTR(RISC_WRITE |
				   ((risc_step == 1)? (RISC_IRQ | RISC_STATUS(line)) : 0) |
				   step_bytes);
			RISC_INSTR(mantis->buf_dma + buf_pos);
			buf_pos += step_bytes;
		}
	}
	RISC_INSTR(RISC_JUMP);
	RISC_INSTR(mantis->risc_dma);
	dprintk(verbose, MANTIS_DEBUG, 1, "Final RISC PROG size=[%x/%x]", (u32)mantis->risc_pos, (u32)MANTIS_RISC_SIZE);
}

void mantis_dma_start(struct mantis_pci *mantis)
{
	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis Start DMA engine");

	memset(mantis->buf_cpu, 0, MANTIS_DMA_BUFSZ(mantis));
	mantis->last_block = mantis->finished_block = 0;
	mantis_risc_program(mantis);
	mmwrite(mantis->risc_dma, MANTIS_RISC_START);
	mmwrite(mmread(MANTIS_GPIF_ADDR) | MANTIS_GPIF_RDWRN, MANTIS_GPIF_ADDR);

	mmwrite(0, MANTIS_DMA_CTL);

	mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_RISCI, MANTIS_INT_MASK);

	mmwrite(MANTIS_FIFO_EN | MANTIS_DCAP_EN
			       | MANTIS_RISC_EN, MANTIS_DMA_CTL);

}

void mantis_dma_stop(struct mantis_pci *mantis)
{
	u32 stat = 0, mask = 0;

	stat = mmread(MANTIS_INT_STAT);
	mask = mmread(MANTIS_INT_MASK);
	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis Stop DMA engine");

	mmwrite((mmread(MANTIS_GPIF_ADDR) & (~(MANTIS_GPIF_RDWRN))), MANTIS_GPIF_ADDR);

	mmwrite((mmread(MANTIS_DMA_CTL) & ~(MANTIS_FIFO_EN |
					    MANTIS_DCAP_EN |
					    MANTIS_RISC_EN)), MANTIS_DMA_CTL);

	mmwrite(mmread(MANTIS_INT_STAT), MANTIS_INT_STAT);

	mmwrite(mmread(MANTIS_INT_MASK) & ~(MANTIS_INT_RISCI |
					    MANTIS_INT_RISCEN), MANTIS_INT_MASK);

	tasklet_kill(&mantis->tasklet);	
}


void mantis_dma_xfer(unsigned long data)
{
	struct mantis_pci *mantis = (struct mantis_pci *) data;
	
	while (mantis->last_block != mantis->finished_block) {

		dprintk(verbose, MANTIS_DEBUG, 1, "last block=[%d] finished block=[%d]",
			mantis->last_block, mantis->finished_block);

		(mantis->hwconfig->ts_size == MANTIS_TS_204 ? dvb_dmx_swfilter_204: dvb_dmx_swfilter)
		(&mantis->demux, &mantis->buf_cpu[mantis->last_block * mantis->line_bytes], mantis->line_bytes);
		mantis->last_block = (mantis->last_block + 1) % mantis->line_count;
	}
}

// suspend to standby, ram or disk.
int mantis_dma_suspend(struct mantis_pci *mantis, pm_message_t mesg, int has_dma)
{
	if (has_dma)
		mantis_dma_stop(mantis);

	return 0;
}

// resumes into state D0 always.
void mantis_dma_resume(struct mantis_pci *mantis, pm_message_t prevMesg, int has_dma)
{
	if (has_dma)
		mantis_dma_start(mantis);
}

--------------040903070307040903060007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040903070307040903060007--
