Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.blueman@gmail.com>) id 1K5mq0-0005Yf-LK
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 21:15:30 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1714117wag.13
	for <linux-dvb@linuxtv.org>; Mon, 09 Jun 2008 12:15:24 -0700 (PDT)
Message-ID: <6278d2220806091215k45e96385g8255c67e2ead808c@mail.gmail.com>
Date: Mon, 9 Jun 2008 20:15:24 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <6278d2220806021305h7fa6571ctf553621355e02b62@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <6278d2220806021305h7fa6571ctf553621355e02b62@mail.gmail.com>
Subject: [linux-dvb] unplug oops from dvb_frontend_init...
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

[Let me know directly if you can suggest a better place to post this, please]

When inadvertently hot-unplugging a WT-220U USB DVB-T receiver with
2.6.24, I was met with an oops [1]. The problem is relevant to
2.6.25/26-rc also.

dvb_frontend_init() was called either from re-creation of the kdvb-fe0
thread - seems unlikely, or someone called
dvb_frontend_reinitialise(), causing this path in the thread - really
unlikely, as I can't find any call-site for it.

Either way, quite a number of drivers call dvb_usb_generic_rw() [2]
without checking the validity of the relevant member in the
dvb_usb_device struct - which had changed. Having dvb_usb_generic_rw()
sanity-check and fail (rather than loading from 0x120) seems
reasonable defensive programming [3], in light of it being called in
this way.

The problem with this, is that drivers don't check the return code of
the init call [4]. Does it make sense to cook a patch which allows the
failure to be propagated back up, or am I missing something else?

Thanks,
 Daniel

--- [1]

<whoops, hot unplug>

[83711.538485] dvb-usb: bulk message failed: -71 (1/0)
[83711.538875] dvb-usb: bulk message failed: -71 (1/0)
[83711.538899] usb 7-5: USB disconnect, address 3
[83711.538905] dvb-usb: bulk message failed: -22 (1/0)
[83711.538924] dvb-usb: bulk message failed: -22 (1/0)
[83711.538943] dvb-usb: bulk message failed: -22 (1/0)
[83711.588979] dvb-usb: bulk message failed: -22 (1/0)
[83711.589031] dvb-usb: bulk message failed: -22 (1/0)
[83711.589078] dvb-usb: bulk message failed: -22 (1/0)
[83711.589122] dvb-usb: bulk message failed: -22 (1/0)
[83711.589167] dvb-usb: bulk message failed: -22 (1/0)
[83711.639233] dvb-usb: bulk message failed: -22 (1/0)
[83711.639282] dvb-usb: bulk message failed: -22 (1/0)
[83711.639330] dvb-usb: bulk message failed: -22 (1/0)
[83711.639374] dvb-usb: bulk message failed: -22 (1/0)
[83711.639421] dvb-usb: bulk message failed: -22 (1/0)
[83711.658391] dvb-usb: bulk message failed: -22 (1/0)
[83768.174281] dvb-usb: bulk message failed: -22 (2/-32512)
[83768.174350] Unable to handle kernel NULL pointer
dereference<6>dvb-usb: WideView WT-220U PenType Receiver
(Typhoon/Freecom) successfully deinitialized and disconnected.
[83768.174459]  at 0000000000000120 RIP:
[83768.174459]  [<ffffffff88339b4f>] :dvb_usb:dvb_usb_generic_rw+0x2f/0x1a0
[83768.174580] PGD 0
[83768.174643] Oops: 0000 [1] SMP
[83768.174723] CPU 0
[83768.174782] Modules linked in: nfsd auth_rpcgss exportfs nfs lockd
nfs_acl sunrpc af_packet xt_length ipt_tos ipt_TOS xt_CLASSIFY sch_sfq
sch_htb ipt_MASQUERADE ipt_REDIRECT xt_limit xt_state xt_tcpudp
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle
iptable_filter ip_tables x_tables xfs sbp2 parport_pc lp parport loop
ftdi_sio usbserial evdev dvb_usb_dtt200u dvb_usb dvb_core i2c_core
sky2 iTCO_wdt iTCO_vendor_support snd_hda_intel shpchp snd_pcm
snd_timer snd_page_alloc snd_hwdep snd pci_hotplug soundcore ipv6
button intel_agp ext3 jbd mbcache sg sd_mod ata_generic pata_acpi ahci
ata_piix libata scsi_mod ohci1394 ieee1394 ehci_hcd uhci_hcd usbcore
e1000 thermal processor fan fbcon tileblit font bitblit softcursor
fuse
[83768.176968] Pid: 5732, comm: kdvb-fe-0 Not tainted 2.6.24-16-server #1
[83768.177009] RIP: 0010:[<ffffffff88339b4f>]  [<ffffffff88339b4f>]
:dvb_usb:dvb_usb_generic_rw+0x2f/0x1a0
[83768.177096] RSP: 0018:ffff810021939df0  EFLAGS: 00010286
[83768.177138] RAX: ffff81003bc7cc00 RBX: 0000000000000001 RCX: 0000000000000000
[83768.177181] RDX: 0000000000000001 RSI: ffff810021939e67 RDI: 0000000000000000
[83768.177223] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[83768.177267] R10: ffff810001009880 R11: 0000000000000001 R12: ffff81003c10b400
[83768.177311] R13: ffff81003c10b5b0 R14: ffff810021939ec0 R15: 0000000000000000
[83768.177354] FS:  0000000000000000(0000) GS:ffffffff805c3000(0000)
knlGS:0000000000000000
[83768.177409] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[83768.177449] CR2: 0000000000000120 CR3: 0000000000201000 CR4: 00000000000006e0
[83768.177491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[83768.177534] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[83768.177576] Process kdvb-fe-0 (pid: 5732, threadinfo
ffff810021938000, task ffff81003bd1b7a0)
[83768.177629] Stack:  ffff81003e9b6828 0000000000000000
ffff8100378369f8 0000000000000000
[83768.177800]  ffff81003bd1b7a0 ffff810037836d48 ffff81003bc7cc30
ffff81003c10b400
[83768.177943]  ffff81003c10b5b0 ffff810021939ec0 ffff81003c10b5e0
ffffffff88342452
[83768.178054] Call Trace:
[83768.178130]  [<ffffffff88342452>] :dvb_usb_dtt200u:dtt200u_fe_init+0x22/0x30
[83768.178178]  [<ffffffff88339f6a>] :dvb_usb:dvb_usb_fe_wakeup+0x3a/0x50
[83768.178229]  [<ffffffff88325c41>] :dvb_core:dvb_frontend_init+0x21/0x70
[83768.178278]  [<ffffffff8832746b>] :dvb_core:dvb_frontend_thread+0x8b/0x370
[83768.178329]  [<ffffffff883273e0>] :dvb_core:dvb_frontend_thread+0x0/0x370
[83768.178382]  [<ffffffff80253e3b>] kthread+0x4b/0x80
[83768.178427]  [<ffffffff8020d198>] child_rip+0xa/0x12
[83768.178473]  [<ffffffff80253df0>] kthread+0x0/0x80
[83768.178514]  [<ffffffff8020d18e>] child_rip+0x0/0x12
[83768.178557]
[83768.178594]
[83768.178594] Code: 44 8b 87 20 01 00 00 49 89 f4 45 89 ce 45 85 c0
0f 84 ad 00
[83768.179167] RIP  [<ffffffff88339b4f>] :dvb_usb:dvb_usb_generic_rw+0x2f/0x1a0
[83768.179234]  RSP <ffff810021939df0>
[83768.179271] CR2: 0000000000000120
[83768.179419] ---[ end trace dba8483163cb1700 ]---

---

0000000000000b20 <dvb_usb_generic_rw>:
dvb_usb_generic_rw():
    b20:       48 83 ec 58             sub    $0x58,%rsp
    b24:       48 89 5c 24 28          mov    %rbx,0x28(%rsp)
    b29:       48 89 6c 24 30          mov    %rbp,0x30(%rsp)
    b2e:       89 d3                   mov    %edx,%ebx
    b30:       4c 89 64 24 38          mov    %r12,0x38(%rsp)
    b35:       4c 89 74 24 48          mov    %r14,0x48(%rsp)
    b3a:       48 89 fd                mov    %rdi,%rbp
    b3d:       4c 89 7c 24 50          mov    %r15,0x50(%rsp)
    b42:       4c 89 6c 24 40          mov    %r13,0x40(%rsp)
    b47:       45 89 c7                mov    %r8d,%r15d
    b4a:       48 89 4c 24 08          mov    %rcx,0x8(%rsp)
    b4f:       44 8b 87 20 01 00 00    mov    0x120(%rdi),%r8d   <-------
    b56:       49 89 f4                mov    %rsi,%r12
    b59:       45 89 ce                mov    %r9d,%r14d
    b5c:       45 85 c0                test   %r8d,%r8d
    b5f:       0f 84 ad 00 00 00       je     c12 <dvb_usb_generic_rw+0xf2>
    b65:       48 85 f6                test   %rsi,%rsi
    b68:       74 05                   je     b6f <dvb_usb_generic_rw+0x4f>
    b6a:       66 85 d2                test   %dx,%dx

--- [2] drivers/media/dvb/dvb-usb/dvb-usb-urb.c

int dvb_usb_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
       u16 rlen, int delay_ms)
{
       int actlen,ret = -ENOMEM;

       if (d->props.generic_bulk_ctrl_endpoint == 0) {     <--- NULL deref
               err("endpoint for generic control not specified.");
               return -EINVAL;
       }


--- [3]

--- drivers/media/dvb/dvb-usb/dvb-usb-urb.c~    2008-06-02
20:35:48.412594249 +0100
+++ drivers/media/dvb/dvb-usb/dvb-usb-urb.c     2008-06-02
20:35:48.412594249 +0100
@@ -13,14 +13,14 @@
 {
       int actlen,ret = -ENOMEM;

+       if (!d || wbuf == NULL || wlen == 0)
+               return -EINVAL;
+
       if (d->props.generic_bulk_ctrl_endpoint == 0) {
               err("endpoint for generic control not specified.");
               return -EINVAL;
       }

-       if (wbuf == NULL || wlen == 0)
-               return -EINVAL;
-
       if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
               return ret;

--- [4] drivers/media/dvb/dvb-core/dvb_frontend.c

static void dvb_frontend_init(struct dvb_frontend *fe)
{
[snip]
       if (fe->ops.init)
               fe->ops.init(fe);
--
Daniel J Blueman

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
