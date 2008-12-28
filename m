Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mjenks1968@gmail.com>) id 1LH4TT-0005aS-0t
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 23:51:08 +0100
Received: by wf-out-1314.google.com with SMTP id 27so5413188wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 14:51:01 -0800 (PST)
Message-ID: <e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
Date: Sun, 28 Dec 2008 16:51:01 -0600
From: "Mark Jenks" <mjenks1968@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1230500176.3120.60.camel@palomino.walls.org>
MIME-Version: 1.0
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
	<1230500176.3120.60.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1903189953=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1903189953==
Content-Type: multipart/alternative;
	boundary="----=_Part_126429_18303849.1230504661355"

------=_Part_126429_18303849.1230504661355
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Dec 28, 2008 at 3:36 PM, Andy Walls <awalls@radix.net> wrote:

> On Sat, 2008-12-27 at 10:40 -0600, Mark Jenks wrote:
> > G'morning all!  (at least it's morning here.)
> >
> > I have a running Mythtv server that is running Suse 10.3 with a
> > hvr-1250 just fine on Kernel 2.6.24, and haven't had any problems at
> > all.
> >
> > I tried to install a hvr-1800 in it yesterday, and I get a kernel oops
> > on it and X won't start.   I compiled up a 2.6.27.10 kernel for it,
> > and moved to that, and I still get the oops.    Checked my vmalloc and
> > I am fine, but increased it anyways to 384 just for grins.
> >
> > I compiled v4l-dvb-cae6de452897 up against the 2.6.24, and the 2.6.27
> > kernels without any changes.   Server boots just fine without the
> > 1800, but with I get the oops.
> >
> > The only thing that I can see, is that the 1250 and the 1800 look to
> > be using the same interrupt.
> >
> > Here is more than enough debug info, I hope.  :)
> >
> > Thanks!
> >
> > -Mark
> >
> >
> > BUG: unable to handle kernel NULL pointer dereference at 000001a0
> > IP: [<f8e5a594>] :cx23885:video_open+0x2c/0x150
> > *pde = 00000000
> > Oops: 0000 [#1] SMP
> > Modules linked in: iptable_filter ip_tables ip6_tables x_tables
> > cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8
> > xfs loop dm_mod cx25840 mt2131 s5h1409 nvidia(P) cx23885
> > v4l2_compat_ioctl32 cx2341x videobuf_dma_sg button videobuf_dvb
> > dvb_core videobuf_core v4l2_common snd_hda_intel snd_usb_audio
> > snd_usb_lib snd_mpu401 snd_cs4232 snd_opl3_lib snd_cs4231_lib snd_pcm
> > ohci1394 videodev v4l1_compat osst agpgart btcx_risc rtc_cmos
> > i2c_nforce2 snd_timer ieee1394 snd_mpu401_uart tveeprom sr_mod
> > snd_hwdep i2c_core rtc_core rtc_lib parport_pc parport st lirc_mceusb2
> > snd_rawmidi snd_seq_device snd k8temp hwmon cdrom forcedeth soundcore
> > snd_page_alloc lirc_dev sg usbhid hid ff_memless ohci_hcd ehci_hcd
> > usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi
> > sata_nv pata_amd libata scsi_mod dock thermal processor thermal_sys
> >
> > Pid: 3178, comm: X Tainted: P          (2.6.27.10-default #3)
> > EIP: 0060:[<f8e5a594>] EFLAGS: 00013287 CPU: 1
> > EIP is at video_open+0x2c/0x150 [cx23885]
> > EAX: 00000000 EBX: 00000000 ECX: f7a9f000 EDX: f7a0e000
> > ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f764de90
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process X (pid: 3178, ti=f764c000 task=f7398c00 task.ti=f764c000)
> > Stack: f7a6e540 00000000 f7b16538 00000000 f7bc30a0 c016bee5 f7a6e540
> > 00000000
> >        f7a6e540 f7bc30a0 00000000 c016bdd9 c01683cd f701ebc0 f6d756c0
> > f764df14
> >        f7a6e540 f764df14 00000003 c01684d8 f7a6e540 00000000 00000000
> > f764df14
> > Call Trace:
> >  [<c016bee5>] chrdev_open+0x10c/0x122
> >  [<c016bdd9>] chrdev_open+0x0/0x122
> >  [<c01683cd>] __dentry_open+0x10d/0x1fc
> >  [<c01684d8>] nameidata_to_filp+0x1c/0x2c
> >  [<c0172986>] do_filp_open+0x33d/0x63e
> >  [<f9b7d8ce>] _nv004117rm+0x9/0x12 [nvidia]
> >  [<c01582f8>] handle_mm_fault+0x2b3/0x5dd
> >  [<c017ab2d>] alloc_fd+0x57/0xd3
> >  [<c01681e8>] do_sys_open+0x3f/0xb8
> >  [<c01682a5>] sys_open+0x1e/0x23
> >  [<c01037ad>] sysenter_do_call+0x12/0x21
> >  =======================
> > Code: 31 ed 57 31 ff 56 31 f6 53 83 ec 04 89 14 24 8b 58 34 e8 16 18
> > 46 c7 8b 15 d0 ad e6 f8 81 e3 ff ff 0f 00 eb 49 8b 82 84 0d 00 00 <39>
> > 98 a0 01 00 00 75 07 89 d6 bf 01 00 00 00 8b 82 88 0d 00 00
> > EIP: [<f8e5a594>] video_open+0x2c/0x150 [cx23885] SS:ESP 0068:f764de90
> > ---[ end trace c26ff07c077248e0 ]---
>
> Mark,
>
> Using the same interrupt isn't the problem.
>
> Here's the gory translation of the Ooops data:
>
>
> The problem is tripped in cx23885-video.c:video_open():
>
>  777 static int video_open(struct inode *inode, struct file *file)
>  778 {
>  779         int minor = iminor(inode);
>  780         struct cx23885_dev *h, *dev = NULL;
>  781         struct cx23885_fh *fh;
>  782         struct list_head *list;
>  783         enum v4l2_buf_type type = 0;
>  784         int radio = 0;
>  785
>  786         lock_kernel();
>  787         list_for_each(list, &cx23885_devlist) {
>  788                 h = list_entry(list, struct cx23885_dev, devlist);
>  789                 if (h->video_dev->minor == minor) {
>  790                         dev  = h;
>  791                         type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  792                 }
>  793                 if (h->vbi_dev &&
>  794                    h->vbi_dev->minor == minor) {
>  795                         dev  = h;
>  796                         type = V4L2_BUF_TYPE_VBI_CAPTURE;
>  797                 }
> [...]
>
> Also note the list_entry()  & list_for_each() macro definitions:
>
> 425 #define list_entry(ptr, type, member) \
> 426         container_of(ptr, type, member)
> [...]
> 444 #define list_for_each(pos, head) \
> 445         for (pos = (head)->next; prefetch(pos->next), pos != (head); \
> 446                 pos = pos->next)
>
>
>
> The code bytes dumped in the Oops disassemble to:
>
>   1:   31 ed                   xor    %ebp,%ebp
>   3:   57                      push   %edi
>   4:   31 ff                   xor    %edi,%edi
>   6:   56                      push   %esi
>   7:   31 f6                   xor    %esi,%esi
>   9:   53                      push   %ebx
>   a:   83 ec 04                sub    $0x4,%esp
>   d:   89 14 24                mov    %edx,(%esp)
>  10:   8b 58 34                mov    0x34(%eax),%ebx   <--- line 779:
> minor = iminor(inode);
>  13:   e8 16 18 46 c7          call   0xc746182e        <--- line 786:
> lock_kernel()
>  18:   8b 15 d0 ad e6 f8       mov    0xf8e6add0,%edx   <--- line 445: list
> = (&cx23885_devlist)->next;
>  1e:   81 e3 ff ff 0f 00       and    $0xfffff,%ebx     <--- line 779:
> minor = iminor(inode);
>  24:   eb 49                   jmp    0x6f              <--- jmp to for
> loop condition check: line 445: prefetch(list->next), list !=
> &cx23885_devlist;
>  26:   8b 82 84 0d 00 00       mov    0xd84(%edx),%eax  <--- line 426 &
> 789: h = container_of(list, struct cx23885_dev, devlist); if
> (h->video_dev...
>  2c:   39 98 a0 01 00 00       cmp    %ebx,0x1a0(%eax)  <--- Ooops occurs
> here: line 789: if (h->video_dev->minor == minor) {
>  32:   75 07                   jne    0x3b
>  34:   89 d6                   mov    %edx,%esi         <--- line 790: dev
> = h;
>  36:   bf 01 00 00 00          mov    $0x1,%edi         <--- line 791: type
> = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  3b:   8b 82 88 0d 00 00       mov    0xd88(%edx),%eax  <--- line 793: if
> (h->vbi_dev ...
>
>
> So "h->video_dev" (I think) was "NULL" in this call to video_open().
> This is a problem with the creation or manipulation of the "struct
> cx23885_dev" members of the "cx23885_devlist".
>
> This appears to be a problem with this list iteration in
> cx23885-video.c:video_open().
>
> If one of these devices only has DVB support and no analog V4L support,
> then it would make sense why one of them would have "h->video_dev" set
> to NULL.  The device shouldn't have a V4L2 "video_dev" if it doesn't
> support analog (V4L2) devices.  I believe the 1800 supports analog video
> but the 1250 does not (someone correct me on this if I'm wrong - I'm no
> expert on these devices).
>
> The iteration loop in video_open() needs to be careful about NULL
> pointer dereference of h->video_dev for DVB only devices.
>
> Try this patch:
>
> diff -r cae6de452897 linux/drivers/media/video/cx23885/cx23885-video.c
> --- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26 08:07:39
> 2008 -0200
> +++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28 16:34:04
> 2008 -0500
> @@ -786,7 +786,8 @@ static int video_open(struct inode *inod
>        lock_kernel();
>        list_for_each(list, &cx23885_devlist) {
>                h = list_entry(list, struct cx23885_dev, devlist);
> -               if (h->video_dev->minor == minor) {
> +               if (h->video_dev &&
> +                   h->video_dev->minor == minor) {
>                        dev  = h;
>                        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                }
>
>
>
> If it doesn't work you'll need to find someone with access to a HVR-1250
> and HVR-1800 in the same machine to do more interactive debugging (Andy
> Walls' thought experiments can only take one so far....).
>
> I can't help further since I don't have any CX23885 based cards.
>
> Regards,
> Andy
>

Andy,

You are correct.  They are both are cx23885 cards, and only one of them has
an analog input to it. The 1250 is a DVB and the 1800 is DVB, but is a MCE
card with analog(svideo, etc), in.

I will give your patch a try tomorrow.   I'm kind of tired of pulling my
media computer, putting in and replacing the card 20 times in one day trying
to figure this out.

Thanks!

-Mark

------=_Part_126429_18303849.1230504661355
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Sun, Dec 28, 2008 at 3:36 PM, Andy Walls <span dir="ltr">&lt;<a href="mailto:awalls@radix.net">awalls@radix.net</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c">On Sat, 2008-12-27 at 10:40 -0600, Mark Jenks wrote:<br>
&gt; G&#39;morning all! &nbsp;(at least it&#39;s morning here.)<br>
&gt;<br>
&gt; I have a running Mythtv server that is running Suse 10.3 with a<br>
&gt; hvr-1250 just fine on Kernel 2.6.24, and haven&#39;t had any problems at<br>
&gt; all.<br>
&gt;<br>
&gt; I tried to install a hvr-1800 in it yesterday, and I get a kernel oops<br>
&gt; on it and X won&#39;t start. &nbsp; I compiled up a 2.6.27.10 kernel for it,<br>
&gt; and moved to that, and I still get the oops. &nbsp; &nbsp;Checked my vmalloc and<br>
&gt; I am fine, but increased it anyways to 384 just for grins.<br>
&gt;<br>
&gt; I compiled v4l-dvb-cae6de452897 up against the 2.6.24, and the 2.6.27<br>
&gt; kernels without any changes. &nbsp; Server boots just fine without the<br>
&gt; 1800, but with I get the oops.<br>
&gt;<br>
&gt; The only thing that I can see, is that the 1250 and the 1800 look to<br>
&gt; be using the same interrupt.<br>
&gt;<br>
&gt; Here is more than enough debug info, I hope. &nbsp;:)<br>
&gt;<br>
&gt; Thanks!<br>
&gt;<br>
&gt; -Mark<br>
&gt;<br>
&gt;<br>
&gt; BUG: unable to handle kernel NULL pointer dereference at 000001a0<br>
&gt; IP: [&lt;f8e5a594&gt;] :cx23885:video_open+0x2c/0x150<br>
&gt; *pde = 00000000<br>
&gt; Oops: 0000 [#1] SMP<br>
&gt; Modules linked in: iptable_filter ip_tables ip6_tables x_tables<br>
&gt; cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8<br>
&gt; xfs loop dm_mod cx25840 mt2131 s5h1409 nvidia(P) cx23885<br>
&gt; v4l2_compat_ioctl32 cx2341x videobuf_dma_sg button videobuf_dvb<br>
&gt; dvb_core videobuf_core v4l2_common snd_hda_intel snd_usb_audio<br>
&gt; snd_usb_lib snd_mpu401 snd_cs4232 snd_opl3_lib snd_cs4231_lib snd_pcm<br>
&gt; ohci1394 videodev v4l1_compat osst agpgart btcx_risc rtc_cmos<br>
&gt; i2c_nforce2 snd_timer ieee1394 snd_mpu401_uart tveeprom sr_mod<br>
&gt; snd_hwdep i2c_core rtc_core rtc_lib parport_pc parport st lirc_mceusb2<br>
&gt; snd_rawmidi snd_seq_device snd k8temp hwmon cdrom forcedeth soundcore<br>
&gt; snd_page_alloc lirc_dev sg usbhid hid ff_memless ohci_hcd ehci_hcd<br>
&gt; usbcore sd_mod edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi<br>
&gt; sata_nv pata_amd libata scsi_mod dock thermal processor thermal_sys<br>
&gt;<br>
&gt; Pid: 3178, comm: X Tainted: P &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(2.6.27.10-default #3)<br>
&gt; EIP: 0060:[&lt;f8e5a594&gt;] EFLAGS: 00013287 CPU: 1<br>
&gt; EIP is at video_open+0x2c/0x150 [cx23885]<br>
&gt; EAX: 00000000 EBX: 00000000 ECX: f7a9f000 EDX: f7a0e000<br>
&gt; ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f764de90<br>
&gt; &nbsp;DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068<br>
&gt; Process X (pid: 3178, ti=f764c000 task=f7398c00 task.ti=f764c000)<br>
&gt; Stack: f7a6e540 00000000 f7b16538 00000000 f7bc30a0 c016bee5 f7a6e540<br>
&gt; 00000000<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;f7a6e540 f7bc30a0 00000000 c016bdd9 c01683cd f701ebc0 f6d756c0<br>
&gt; f764df14<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;f7a6e540 f764df14 00000003 c01684d8 f7a6e540 00000000 00000000<br>
&gt; f764df14<br>
&gt; Call Trace:<br>
&gt; &nbsp;[&lt;c016bee5&gt;] chrdev_open+0x10c/0x122<br>
&gt; &nbsp;[&lt;c016bdd9&gt;] chrdev_open+0x0/0x122<br>
&gt; &nbsp;[&lt;c01683cd&gt;] __dentry_open+0x10d/0x1fc<br>
&gt; &nbsp;[&lt;c01684d8&gt;] nameidata_to_filp+0x1c/0x2c<br>
&gt; &nbsp;[&lt;c0172986&gt;] do_filp_open+0x33d/0x63e<br>
&gt; &nbsp;[&lt;f9b7d8ce&gt;] _nv004117rm+0x9/0x12 [nvidia]<br>
&gt; &nbsp;[&lt;c01582f8&gt;] handle_mm_fault+0x2b3/0x5dd<br>
&gt; &nbsp;[&lt;c017ab2d&gt;] alloc_fd+0x57/0xd3<br>
&gt; &nbsp;[&lt;c01681e8&gt;] do_sys_open+0x3f/0xb8<br>
&gt; &nbsp;[&lt;c01682a5&gt;] sys_open+0x1e/0x23<br>
&gt; &nbsp;[&lt;c01037ad&gt;] sysenter_do_call+0x12/0x21<br>
&gt; &nbsp;=======================<br>
&gt; Code: 31 ed 57 31 ff 56 31 f6 53 83 ec 04 89 14 24 8b 58 34 e8 16 18<br>
&gt; 46 c7 8b 15 d0 ad e6 f8 81 e3 ff ff 0f 00 eb 49 8b 82 84 0d 00 00 &lt;39&gt;<br>
&gt; 98 a0 01 00 00 75 07 89 d6 bf 01 00 00 00 8b 82 88 0d 00 00<br>
&gt; EIP: [&lt;f8e5a594&gt;] video_open+0x2c/0x150 [cx23885] SS:ESP 0068:f764de90<br>
&gt; ---[ end trace c26ff07c077248e0 ]---<br>
<br>
</div></div>Mark,<br>
<br>
Using the same interrupt isn&#39;t the problem.<br>
<br>
Here&#39;s the gory translation of the Ooops data:<br>
<br>
<br>
The problem is tripped in cx23885-video.c:video_open():<br>
<br>
&nbsp;777 static int video_open(struct inode *inode, struct file *file)<br>
&nbsp;778 {<br>
&nbsp;779 &nbsp; &nbsp; &nbsp; &nbsp; int minor = iminor(inode);<br>
&nbsp;780 &nbsp; &nbsp; &nbsp; &nbsp; struct cx23885_dev *h, *dev = NULL;<br>
&nbsp;781 &nbsp; &nbsp; &nbsp; &nbsp; struct cx23885_fh *fh;<br>
&nbsp;782 &nbsp; &nbsp; &nbsp; &nbsp; struct list_head *list;<br>
&nbsp;783 &nbsp; &nbsp; &nbsp; &nbsp; enum v4l2_buf_type type = 0;<br>
&nbsp;784 &nbsp; &nbsp; &nbsp; &nbsp; int radio = 0;<br>
&nbsp;785<br>
&nbsp;786 &nbsp; &nbsp; &nbsp; &nbsp; lock_kernel();<br>
&nbsp;787 &nbsp; &nbsp; &nbsp; &nbsp; list_for_each(list, &amp;cx23885_devlist) {<br>
&nbsp;788 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; h = list_entry(list, struct cx23885_dev, devlist);<br>
&nbsp;789 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (h-&gt;video_dev-&gt;minor == minor) {<br>
&nbsp;790 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dev &nbsp;= h;<br>
&nbsp;791 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; type = V4L2_BUF_TYPE_VIDEO_CAPTURE;<br>
&nbsp;792 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
&nbsp;793 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (h-&gt;vbi_dev &amp;&amp;<br>
&nbsp;794 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;h-&gt;vbi_dev-&gt;minor == minor) {<br>
&nbsp;795 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dev &nbsp;= h;<br>
&nbsp;796 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; type = V4L2_BUF_TYPE_VBI_CAPTURE;<br>
&nbsp;797 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>
[...]<br>
<br>
Also note the list_entry() &nbsp;&amp; list_for_each() macro definitions:<br>
<br>
425 #define list_entry(ptr, type, member) \<br>
426 &nbsp; &nbsp; &nbsp; &nbsp; container_of(ptr, type, member)<br>
[...]<br>
444 #define list_for_each(pos, head) \<br>
445 &nbsp; &nbsp; &nbsp; &nbsp; for (pos = (head)-&gt;next; prefetch(pos-&gt;next), pos != (head); \<br>
446 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pos = pos-&gt;next)<br>
<br>
<br>
<br>
The code bytes dumped in the Oops disassemble to:<br>
<br>
 &nbsp; 1: &nbsp; 31 ed &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xor &nbsp; &nbsp;%ebp,%ebp<br>
 &nbsp; 3: &nbsp; 57 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;push &nbsp; %edi<br>
 &nbsp; 4: &nbsp; 31 ff &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xor &nbsp; &nbsp;%edi,%edi<br>
 &nbsp; 6: &nbsp; 56 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;push &nbsp; %esi<br>
 &nbsp; 7: &nbsp; 31 f6 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; xor &nbsp; &nbsp;%esi,%esi<br>
 &nbsp; 9: &nbsp; 53 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;push &nbsp; %ebx<br>
 &nbsp; a: &nbsp; 83 ec 04 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sub &nbsp; &nbsp;$0x4,%esp<br>
 &nbsp; d: &nbsp; 89 14 24 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;mov &nbsp; &nbsp;%edx,(%esp)<br>
 &nbsp;10: &nbsp; 8b 58 34 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;mov &nbsp; &nbsp;0x34(%eax),%ebx &nbsp; &lt;--- line 779: minor = iminor(inode);<br>
 &nbsp;13: &nbsp; e8 16 18 46 c7 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;call &nbsp; 0xc746182e &nbsp; &nbsp; &nbsp; &nbsp;&lt;--- line 786: lock_kernel()<br>
 &nbsp;18: &nbsp; 8b 15 d0 ad e6 f8 &nbsp; &nbsp; &nbsp; mov &nbsp; &nbsp;0xf8e6add0,%edx &nbsp; &lt;--- line 445: list = (&amp;cx23885_devlist)-&gt;next;<br>
 &nbsp;1e: &nbsp; 81 e3 ff ff 0f 00 &nbsp; &nbsp; &nbsp; and &nbsp; &nbsp;$0xfffff,%ebx &nbsp; &nbsp; &lt;--- line 779: minor = iminor(inode);<br>
 &nbsp;24: &nbsp; eb 49 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; jmp &nbsp; &nbsp;0x6f &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&lt;--- jmp to for loop condition check: line 445: prefetch(list-&gt;next), list != &amp;cx23885_devlist;<br>
 &nbsp;26: &nbsp; 8b 82 84 0d 00 00 &nbsp; &nbsp; &nbsp; mov &nbsp; &nbsp;0xd84(%edx),%eax &nbsp;&lt;--- line 426 &amp; 789: h = container_of(list, struct cx23885_dev, devlist); if (h-&gt;video_dev...<br>
 &nbsp;2c: &nbsp; 39 98 a0 01 00 00 &nbsp; &nbsp; &nbsp; cmp &nbsp; &nbsp;%ebx,0x1a0(%eax) &nbsp;&lt;--- Ooops occurs here: line 789: if (h-&gt;video_dev-&gt;minor == minor) {<br>
 &nbsp;32: &nbsp; 75 07 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; jne &nbsp; &nbsp;0x3b<br>
 &nbsp;34: &nbsp; 89 d6 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; mov &nbsp; &nbsp;%edx,%esi &nbsp; &nbsp; &nbsp; &nbsp; &lt;--- line 790: dev = h;<br>
 &nbsp;36: &nbsp; bf 01 00 00 00 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;mov &nbsp; &nbsp;$0x1,%edi &nbsp; &nbsp; &nbsp; &nbsp; &lt;--- line 791: type = V4L2_BUF_TYPE_VIDEO_CAPTURE;<br>
 &nbsp;3b: &nbsp; 8b 82 88 0d 00 00 &nbsp; &nbsp; &nbsp; mov &nbsp; &nbsp;0xd88(%edx),%eax &nbsp;&lt;--- line 793: if (h-&gt;vbi_dev ...<br>
<br>
<br>
So &quot;h-&gt;video_dev&quot; (I think) was &quot;NULL&quot; in this call to video_open().<br>
This is a problem with the creation or manipulation of the &quot;struct<br>
cx23885_dev&quot; members of the &quot;cx23885_devlist&quot;.<br>
<br>
This appears to be a problem with this list iteration in<br>
cx23885-video.c:video_open().<br>
<br>
If one of these devices only has DVB support and no analog V4L support,<br>
then it would make sense why one of them would have &quot;h-&gt;video_dev&quot; set<br>
to NULL. &nbsp;The device shouldn&#39;t have a V4L2 &quot;video_dev&quot; if it doesn&#39;t<br>
support analog (V4L2) devices. &nbsp;I believe the 1800 supports analog video<br>
but the 1250 does not (someone correct me on this if I&#39;m wrong - I&#39;m no<br>
expert on these devices).<br>
<br>
The iteration loop in video_open() needs to be careful about NULL<br>
pointer dereference of h-&gt;video_dev for DVB only devices.<br>
<br>
Try this patch:<br>
<br>
diff -r cae6de452897 linux/drivers/media/video/cx23885/cx23885-video.c<br>
--- a/linux/drivers/media/video/cx23885/cx23885-video.c Fri Dec 26 08:07:39 2008 -0200<br>
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Dec 28 16:34:04 2008 -0500<br>
@@ -786,7 +786,8 @@ static int video_open(struct inode *inod<br>
 &nbsp; &nbsp; &nbsp; &nbsp;lock_kernel();<br>
 &nbsp; &nbsp; &nbsp; &nbsp;list_for_each(list, &amp;cx23885_devlist) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;h = list_entry(list, struct cx23885_dev, devlist);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (h-&gt;video_dev-&gt;minor == minor) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (h-&gt;video_dev &amp;&amp;<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; h-&gt;video_dev-&gt;minor == minor) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dev &nbsp;= h;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;type = V4L2_BUF_TYPE_VIDEO_CAPTURE;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br>
<br>
<br>
<br>
If it doesn&#39;t work you&#39;ll need to find someone with access to a HVR-1250<br>
and HVR-1800 in the same machine to do more interactive debugging (Andy<br>
Walls&#39; thought experiments can only take one so far....).<br>
<br>
I can&#39;t help further since I don&#39;t have any CX23885 based cards.<br>
<br>
Regards,<br>
Andy<br>
<div><div></div><div class="Wj3C7c"></div></div></blockquote><div><br>Andy,<br>&nbsp;</div><div>You are correct.&nbsp; They are both are cx23885 cards, and only one of them has an analog input to it. The 1250 is a DVB and the 1800 is DVB, but is a MCE card with analog(svideo, etc), in.<br>
<br>I will give your patch a try tomorrow. &nbsp; I&#39;m kind of tired of pulling my media computer, putting in and replacing the card 20 times in one day trying to figure this out.<br><br>Thanks!<br><br>-Mark <br></div></div>
<br>

------=_Part_126429_18303849.1230504661355--


--===============1903189953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1903189953==--
