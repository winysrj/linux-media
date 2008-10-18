Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9I3F6BN018055
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 23:15:06 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9I3EtKW021912
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 23:14:55 -0400
Received: by fg-out-1718.google.com with SMTP id e21so647432fga.7
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 20:14:54 -0700 (PDT)
Message-ID: <30353c3d0810172014g486d044ciba0df9784fa89dd4@mail.gmail.com>
Date: Fri, 17 Oct 2008 23:14:54 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <30353c3d0810171920y154a8bc4w584751acac95ac7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0810171920y154a8bc4w584751acac95ac7b@mail.gmail.com>
Cc: 
Subject: Re: ibmcam oops
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, Oct 17, 2008 at 10:20 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> I'm not sure if it matters or not, but the ibmcam driver in the
> Mauro's linux-2.6 git tree in the for_linus branch is currently
> broken. I haven't ever gotten this driver to work with my camera and
> am thus not interested in fixing it. The crash occurred immediately
> after plugging in the camera. Below is the resulting dmesg info.
>
> Regards,
>
> David Ellingsworth
>
> P.S. If anyone is interested in creating a working driver for this
> camera, I have begun a rewrite from scratch based on the new v4l2
> interface and would appreciate the help.
>
> usb 1-2: new full speed USB device using ohci_hcd and address 2
> usb 1-2: configuration #1 chosen from 1 choice
> Linux video capture interface: v2.00
> BUG: unable to handle kernel NULL pointer dereference at 000001c4
> IP: [<dcef1e02>] ibmcam_probe+0x121/0x8ef [ibmcam]
> *pde = 00000000
> Oops: 0000 [#1]
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:02.0/usb1/1-2/1-2:1.0/bInterfaceClass
> Modules linked in: ibmcam(+) usbvideo videodev v4l1_compat radeon drm
> binfmt_misc ppdev lp dm_snapshot dm_mirror dm_log dm_mod b43legacy
> mac80211 cfg80211 led_class i2c_ali1535 snd_ali5451 snd_ac97_codec
> ac97_bus ssb snd_pcm_oss snd_mixer_oss snd_pcm ati_agp i2c_ali15x3
> pcmcia snd_timer container battery ac pcspkr evdev psmouse serio_raw
> video output button agpgart i2c_core yenta_socket rsrc_nonstatic
> pcmcia_core parport_pc parport snd soundcore snd_page_alloc reiserfs
> ide_cd_mod cdrom ide_disk_mod alim15x3 ide_pci_generic natsemi
> ide_core ohci_hcd usbcore thermal processor fan
>
> Pid: 3069, comm: modprobe Not tainted (2.6.27 #1) Presario 2100 (PF181UA)
> EIP: 0060:[<dcef1e02>] EFLAGS: 00010216 CPU: 0
> EIP is at ibmcam_probe+0x121/0x8ef [ibmcam]
> EAX: dcef378f EBX: d7df2600 ECX: d7e40800 EDX: d7df2600
> ESI: dcef37b1 EDI: 01000301 EBP: d7df261c ESP: d7e4be00
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 3069, ti=d7e4a000 task=dac77190 task.ti=d7e4a000)
> Stack:
>  fffffffe d7df2600 d7e40800 00000003 dcef50c4 dc757c12 dcef50c4 dc0080c5
>  d7df2600 00000000 dcef50c4 d7df261c dc7585a2 d7f2e004 d7e40800 00000001
>  d7df261c 00000000 d7f2e034 d7f2e034 c01f9a21 d7df261c d7f2e034 d7df26c8
> Call Trace:
>  [<dc757c12>] usb_match_one_id+0x1c/0x71 [usbcore]
>  [<dc7585a2>] usb_probe_interface+0x101/0x135 [usbcore]
>  [<c01f9a21>] driver_probe_device+0x9c/0x12d
>  [<c01f9afb>] __driver_attach+0x49/0x67
>  [<c01f94bc>] bus_for_each_dev+0x35/0x5b
>  [<c01f98d5>] driver_attach+0x11/0x13
>  [<c01f9ab2>] __driver_attach+0x0/0x67
>  [<c01f8f41>] bus_add_driver+0x91/0x1a7
>  [<c01f9c61>] driver_register+0x7d/0xd6
>  [<dc758752>] usb_register_driver+0x56/0xad [usbcore]
>  [<dcdfa841>] usbvideo_register+0x1f8/0x232 [usbvideo]
>  [<dcd4e000>] ibmcam_init+0x0/0x7a [ibmcam]
>  [<dcd4e074>] ibmcam_init+0x74/0x7a [ibmcam]
>  [<dcef1ce1>] ibmcam_probe+0x0/0x8ef [ibmcam]
>  [<dceec6be>] ibmcam_setup_on_open+0x0/0xcd6 [ibmcam]
>  [<dcef0a8d>] ibmcam_video_start+0x0/0x253 [ibmcam]
>  [<dceec418>] ibmcam_video_stop+0x0/0x22e [ibmcam]
>  [<dcef13fa>] ibmcam_ProcessIsocData+0x0/0x8e7 [ibmcam]
>  [<dcdf95c6>] usbvideo_DeinterlaceFrame+0x0/0x103 [usbvideo]
>  [<dceed394>] ibmcam_adjust_picture+0x0/0x542 [ibmcam]
>  [<dceec000>] ibmcam_calculate_fps+0x0/0x1b [ibmcam]
>  [<c010112b>] _stext+0x43/0x107
>  [<c012f52b>] sys_init_module+0x87/0x174
>  [<c010379e>] syscall_call+0x7/0xb
> Code: ef dc 66 8b 81 96 01 00 00 66 3d 0c 80 74 1c 66 3d 0d 80 be 9d
> 37 ef dc 74 11 66 3d 02 80 be b1 37 ef dc b8 8f 37 ef dc 0f 44 f0 <8b>
> 1d c4 01 00 00 8d 43 5c 81 c3 e8 00 00 00 e8 2a 56 30 e3 0f
> EIP: [<dcef1e02>] ibmcam_probe+0x121/0x8ef [ibmcam] SS:ESP 0068:d7e4be00
> ---[ end trace 9993ea74c2bfa7fe ]---
>

Just a small follow-up on this... The driver doesn't oops in 2.6.26.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
