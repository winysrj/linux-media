Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n27.bullet.mail.ukl.yahoo.com ([87.248.110.144])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <btanastasov@yahoo.co.uk>) id 1Kmqez-0008NV-NN
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 16:02:08 +0200
Message-ID: <48EA1A38.3080006@yahoo.co.uk>
Date: Mon, 06 Oct 2008 17:01:28 +0300
From: Boyan <btanastasov@yahoo.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Oops with mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>



Hi,

I'm not sure this is the correct mailing list for Mantis driver, ignore 
my message if it's not.

I'm hitting an Oops with the latest Mantis driver 303b1d29d735.


Modules linked in: mantis lnbp21 mb86a16 stb6100 stb0899 stv0299 
dvb_core i2c_core
CPU:    0
EIP:    0060:[<c0481343>]    Not tainted VLI
EFLAGS: 00010082   (2.6.23.16 #8)
EIP is at _spin_lock_irqsave+0x3/0x30
eax: 00000068   ebx: 00000068   ecx: 00000001   edx: 00000282
esi: 00000000   edi: 00000001   ebp: c05cff2c   esp: c05cff0c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c05ce000 task=c0573be0 task.ti=c05ce000)

Stack:
c011977e c13f5e00 00000068 04080401 00000003 00000030 04080401 df4a8000
00000000 e00d9e52 00000000 00000000 00000068 d7bd7f00 00000000 00000017
00000000 c0141405 c05c2900 00000017 00000000 c05c2930 c0142801 00000000

Call Trace:
  [<c011977e>] __wake_up+0x1e/0x50
  [<e00d9e52>] mantis_pci_irq+0xc2/0x330 [mantis]
  [<c0141405>] handle_IRQ_event+0x25/0x60
  [<c0142801>] handle_fasteoi_irq+0x71/0xe0
  [<c0105899>] do_IRQ+0x39/0x70
  [<c0103b43>] common_interrupt+0x23/0x30
  [<c01600d8>] kmem_cache_destroy+0x58/0xc0
  [<c0100bfe>] mwait_idle_with_hints+0x3e/0x50
  [<c0100a62>] cpu_idle+0x32/0x80
  [<c05d4a7b>] start_kernel+0x1bb/0x220
  [<c05d4460>] unknown_bootoption+0x0/0x130
  =======================
Code: 00 00 00 01 31 c9 89 c8 c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 
90 90 f0 83 28 01 79 05 e8 55 fd ff ff c3 8d 74 26 00 9c 5a fa f0> fe 08 
79 1c f7 c2 00 02 00 00 74 0b fb f3 90 80 38 00 7e f9

EIP: [<c0481343>] _spin_lock_irqsave+0x3/0x30
SS:ESP 0068:c05cff0c
Kernel panic - not syncing: Fatal exception in interrupt



The machine have two cards - first is SkyStar 2 rev2.6, the second is
SkyStar HD2 for which I'm testing the mantis driver. The machine is SMP,
but no difrerence if command line option max_cpus=1 is used.

The oops is happening right after loading the driver for the second or 
more times. I don't know the source well but poked around a bit and I
think that it migth be because the interrupts are enabled too early
before initialization of mantis_ca in the mantis_pci structure.

In linux/drivers/media/dvb/mantis/mantis_pci.c
there is a function:
static irqreturn_t mantis_pci_irq(int irq, void *dev_id)

which do:

.......
        ca = mantis->mantis_ca;
.......
and then:

         if (stat & MANTIS_INT_IRQ0) {
                 dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-0 *");
                 mantis->gpif_status = rst_stat;
                 wake_up(&ca->hif_write_wq);
                 schedule_work(&ca->hif_evm_work);
         }

which appears to be NULL in the moment of initialization of the driver.

In function:

static int __devinit mantis_pci_probe(struct pci_dev *pdev,
                                       const struct pci_device_id 
*mantis_pci_table)


mantis->mantis_ca is initialized too late:

............
        if (request_irq(pdev->irq,
                         mantis_pci_irq,
                         IRQF_SHARED,
                         DRIVER_NAME,
                         mantis) < 0) {

                 dprintk(verbose, MANTIS_ERROR, 1, "Mantis IRQ reg failed");
                 ret = -ENODEV;
                 goto err2;
         }
...........
        // No more PCI specific stuff !
         if (mantis_core_init(mantis) < 0) {
                 dprintk(verbose, MANTIS_ERROR, 1, "Mantis core init 
failed");
                 ret = -ENODEV;
                 goto err2;
         }

mantis_core_init is from mantis_core.c, which is calling mantis_dvb_init
from mantis_dvb.c, which is calling mantis_ca_init from mantis_ca.c 
where mantis_ca is initialized:

         if (!(ca = kzalloc(sizeof (struct mantis_ca), GFP_KERNEL))) {
                 dprintk(verbose, MANTIS_ERROR, 1, "Out of memory!, 
exiting ..");
                 result = -ENOMEM;
                 goto err;
         }

         ca->ca_priv = mantis;
         mantis->mantis_ca = ca;



So it looks like there is a time interval between enabling interrupts
and actually allocating the mantis_ca, which then is dereferenced in the
mantis_pci_irq.

The strange thing is that this is not happening when loading the driver
for the first time. After that if the driver is removed and then
reloaded it hits the checks in mantis_pci_irq but only once:

        if (stat & MANTIS_INT_IRQ0) {
                 dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-0 *");
                 mantis->gpif_status = rst_stat;
                 wake_up(&ca->hif_write_wq);
                 schedule_work(&ca->hif_evm_work);
         }

(tested with enabling the debug message):


first loading:

ACPI: PCI Interrupt 0000:06:00.0[A] ->
GSI 21 (level, low) -> IRQ 23
irq: 23, latency: 32
  memory: 0x30000000, mmio: 0xe0090000
found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (06:00.0),
     Mantis Rev 1 [1ae4:0001],
irq: 23, latency: 32
     memory: 0x30000000, mmio: 0xe0090000
     MAC Address=[00:08:c9:e0:11:a1]
mantis_alloc_buffers (0): DMA=0x2260000 cpu=0xc2260000 size=65536
mantis_alloc_buffers (0): RISC=0x3dcb000 cpu=0xc3dcb000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
stb0899_attach: Attaching STB0899
mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

second loading:
ACPI: PCI Interrupt 0000:06:00.0[A] ->
GSI 21 (level, low) -> IRQ 23
irq: 23, latency: 32
  memory: 0x30000000, mmio: 0xe0092000
found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (06:00.0),
     Mantis Rev 1 [1ae4:0001],
irq: 23, latency: 32
     memory: 0x30000000, mmio: 0xe0092000
     MAC Address=[00:08:c9:e0:11:a1]
mantis_alloc_buffers (0): DMA=0x1930000 cpu=0xc1930000 size=65536
mantis_alloc_buffers (0): RISC=0x1d9b000 cpu=0xc1d9b000 size=1000
DVB: registering new adapter (Mantis dvb adapter)

* INT IRQ-0 *
^^^^^^^^^^^^^

stb0899_attach: Attaching STB0899
mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface


The other thing I've tested is adding IRQF_DISABLED flag to request_irq,
but no difference - in mantis_pci_irq stat has MANTIS_INT_IRQ0 bit set.

I don't know if mantis_core_init can be called before request_irq, but
if it can't because of some dependencies, there should be check
if ca not NULL in mantis_pci_irq:

before:
         if (stat & MANTIS_INT_IRQ0) {
                 dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-0 *");
                 mantis->gpif_status = rst_stat;
                 wake_up(&ca->hif_write_wq);
                 schedule_work(&ca->hif_evm_work);
         }

after:
         if (ca && stat & MANTIS_INT_IRQ0) {
                 dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-0 *");
                 mantis->gpif_status = rst_stat;
                 wake_up(&ca->hif_write_wq);
                 schedule_work(&ca->hif_evm_work);
         }


-- 
Boyan






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
