Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LJYc0-0006fs-90
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 20:26:13 +0100
From: Andy Walls <awalls@radix.net>
To: Gregoire Favre <gregoire.favre@gmail.com>
In-Reply-To: <20090104113738.GD3551@gmail.com>
References: <20090104113738.GD3551@gmail.com>
Date: Sun, 04 Jan 2009 14:28:24 -0500
Message-Id: <1231097304.3125.64.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88)
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

On Sun, 2009-01-04 at 12:37 +0100, Gregoire Favre wrote:
> Hello,
> 
> in order to use S2API I compiled s2-lipliandvb with attached config and
> it ended with an oops which make me loose my USB keyboard...
> 
> What can I do in order to help this being fixed ?

The oops shows a failure happens in 

linux/drivers/media/video/cx88/cx88-vp3054-i2c.c:vp3054_i2c_probe()

Which in the source code I have lying around looks like:

int vp3054_i2c_probe(struct cx8802_dev *dev)
{
        struct cx88_core *core = dev->core;
        struct vp3054_i2c_state *vp3054_i2c;
        int rc;

        if (core->boardnr != CX88_BOARD_DNTV_LIVE_DVB_T_PRO)
                return 0;
	[...]

But the disassembed code in your oops doesn't quite match this source.

I can tell you this about the oops:


Code;  ffffffffa088f12f <_end+200a7ebf/7ee18d90>
0000000000000000 <_RIP>:
Code;  ffffffffa088f12f <_end+200a7ebf/7ee18d90>
   0:   a0 df 66 66 66 66 66      mov    0x2e666666666666df,%al
Code;  ffffffffa088f136 <_end+200a7ec6/7ee18d90>
   7:   66 2e 
Code;  ffffffffa088f138 <_end+200a7ec8/7ee18d90>
   9:   0f 1f 84 00 00 00 00      nopl   0x0(%rax,%rax,1)
Code;  ffffffffa088f13f <_end+200a7ecf/7ee18d90>
  10:   00 
Code;  ffffffffa088f140 <_end+200a7ed0/7ee18d90>
  11:   48 83 ec 28               sub    $0x28,%rsp
Code;  ffffffffa088f144 <_end+200a7ed4/7ee18d90>
  15:   48 89 5c 24 08            mov    %rbx,0x8(%rsp)
Code;  ffffffffa088f149 <_end+200a7ed9/7ee18d90>
  1a:   48 89 6c 24 10            mov    %rbp,0x10(%rsp)
Code;  ffffffffa088f14e <_end+200a7ede/7ee18d90>
  1f:   4c 89 64 24 18            mov    %r12,0x18(%rsp)
Code;  ffffffffa088f153 <_end+200a7ee3/7ee18d90>
  24:   4c 89 6c 24 20            mov    %r13,0x20(%rsp)
Code;  ffffffffa088f158 <_end+200a7ee8/7ee18d90>
  29:   31 db                     xor    %ebx,%ebx
Code;  ffffffffa088f15a <_end+200a7eea/7ee18d90>   <=====
  2b:   4c 8b 27                  mov    (%rdi),%r12   <=====
Code;  ffffffffa088f15d <_end+200a7eed/7ee18d90>
  2e:   48 89 fd                  mov    %rdi,%rbp
Code;  ffffffffa088f160 <_end+200a7ef0/7ee18d90>
  31:   41 83 bc 24 c0 06 00      cmpl   $0x2a,0x6c0(%r12)
                                         ^^^^^
This comparison -------------------------|
corresponds to 

	if (core->boardnr != CX88_BOARD_DNTV_LIVE_DVB_T_PRO)

as 0x2a equals 42 and

	#define CX88_BOARD_DNTV_LIVE_DVB_T_PRO     42

Since that's the case, %r12 would hold the "core" pointer.  Since "core"
is fetched from wherever %rdi points %rdi should be "dev".  Since the
oops happens when %rdi is dereferenced "dev" was equal to NULL.


So linux/drivers/media/video/cx88/cx88-dvb.c:cx8802_dvb_probe() called 
vp3054_i2c_probe() with "dev" equla to NULL.  Looking at that function:


static int cx8802_dvb_probe(struct cx8802_driver *drv)
{
        struct cx88_core *core = drv->core;
        struct cx8802_dev *dev = drv->core->dvbdev;
        int err;

        dprintk( 1, "%s\n", __func__);
        dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
                core->boardnr,
                core->name,
                core->pci_bus,
                core->pci_slot);

        err = -ENODEV;
        if (!(core->board.mpeg & CX88_MPEG_DVB))
                goto fail_core;

        /* If vp3054 isn't enabled, a stub will just return 0 */
        err = vp3054_i2c_probe(dev);
	[...]

drv->core->dvbdev must have been NULL, even though the check against
CX88_MPEG_DVB succeeded.

Backing up and looking at
linux/drivers/media/video/cx88/cx88-mpeg.c:cx8802_register_driver()
which is what registers the cx8802_dvb_probe() and calls it for each
device, core->dvbdev is never explicitly set.

Backing up even further
linux/drivers/media/video/cx88/cx88-dvb.c:dvb_init() never sets it
either.

So it must be the case, that dvbdev must be set to NULL, in a device in
the cx8802_devlist, when the cx88-dvb module is loaded.


I note that in 
linux/drivers/media/video/cx88/cx88-mpeg.c:cx8802_probe()
the cx8802 based device is added to the cx8802_devlist before the dvbdev
is set to something non-NULL.  Then a request to load modules happens.

That's probably OK for a single cx8802 device in a machine, but I think
it's a race condition if you have more than one of these cx8802 devices
in a machine.



I hope that helps someone.  I'm not and expert on the cx88 modules and
their inter-relationships.


Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
