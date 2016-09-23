Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:51810 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbcIWHuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 03:50:14 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Bin Liu <b-liu@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        nh26223@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <20160922201131.GD31827@uda0271908>
References: <20160920170441.GA10705@uda0271908> <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908> <87oa3go065.fsf@linux.intel.com> <87lgyknyp7.fsf@linux.intel.com> <87d1jw6yfd.fsf@linux.intel.com> <20160922133327.GA31827@uda0271908> <87a8ezn2av.fsf@linux.intel.com> <20160922201131.GD31827@uda0271908>
Date: Fri, 23 Sep 2016 10:49:57 +0300
Message-ID: <87shsr5a3e.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Bin Liu <b-liu@ti.com> writes:
> +Fengwei Yin per his request.
>
> On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
>>=20
>> Hi,
>>=20
>> Bin Liu <b-liu@ti.com> writes:
>>=20
>> [...]
>>=20
>> >> Here's one that actually compiles, sorry about that.
>> >
>> > No worries, I was sleeping ;-)
>> >
>> > I will test it out early next week. Thanks.
>>=20
>> meanwhile, how about some instructions on how to test this out myself?
>> How are you using g_webcam and what are you running on host side? Got a
>> nice list of commands there I can use? I think I can get to bottom of
>> this much quicker if I can reproduce it locally ;-)
>
> On device side:
> - first patch g_webcam as in my first email in this thread to enable
>   640x480@30fps;
> - # modprobe g_webcam streaming_maxpacket=3D3072
> - then run uvc-gadget to feed the YUV frames;
> 	http://git.ideasonboard.org/uvc-gadget.git

as is, g_webcam never enumerates to the host. It's calls to
usb_function_active() and usb_function_deactivate() are unbalanced. Do
you have any other changes to g_webcam?

Also, uvc-gadget.git doesn't compile, had to modify it a bit:

=2D#include "../drivers/usb/gadget/uvc.h"
+#include "../drivers/usb/gadget/function/uvc.h"

Also fixed a build warning:

@@ -732,6 +732,8 @@ int main(int argc, char *argv[])
                fd_set wfds =3D fds;
=20
                ret =3D select(dev->fd + 1, NULL, &wfds, &efds, NULL);
+               if (ret < 0)
+                       return ret;
                if (FD_ISSET(dev->fd, &efds))
                        uvc_events_process(dev);
                if (FD_ISSET(dev->fd, &wfds))

Laurent, have you tested g_webcam recently? What's the magic to get it
working?

Here's what I get out of dmesg:

[   58.568380] usb 1-9: new high-speed USB device number 5 using xhci_hcd
[   58.738680] usb 1-9: New USB device found, idVendor=3D1d6b, idProduct=3D=
0102
[   58.738683] usb 1-9: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   58.738685] usb 1-9: Product: Webcam gadget
[   58.738687] usb 1-9: Manufacturer: Linux Foundation
[   58.739133] g_webcam gadget: high-speed config #1: Video
[   58.739138] g_webcam gadget: uvc_function_set_alt(0, 0)
[   58.739139] g_webcam gadget: reset UVC Control
[   58.739149] g_webcam gadget: uvc_function_set_alt(1, 0)
[   58.804369] uvcvideo: Found UVC 1.00 device Webcam gadget (1d6b:0102)
[   58.804479] g_webcam gadget: uvc_function_set_alt(1, 0)
[   64.188459] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported.=
 Enabling workaround.
[   69.307458] uvcvideo: Failed to query (129) UVC probe control : -110 (ex=
p. 26).
[   69.307459] uvcvideo: Failed to initialize the device (-5).
[   69.307505] usbcore: registered new interface driver uvcvideo
[   69.307506] USB Video Class driver (1.1.1)
[  146.646012] ------------[ cut here ]------------
[  146.646023] WARNING: CPU: 0 PID: 2616 at drivers/usb/gadget/composite.c:=
371 usb_function_activate+0x77/0x80 [libcomposite]
[  146.646024] Modules linked in: uvcvideo g_webcam usb_f_uvc videobuf2_vma=
lloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev libcomposite k=
vm_intel kvm psmouse e1000e input_leds hid_generic usbhid atkbd irqbypass e=
vdev
[  146.646054] CPU: 0 PID: 2616 Comm: gst-launch-1.0 Not tainted 4.8.0-rc7-=
next-20160922-00004-gc71031593917-dirty #20
[  146.646055] Hardware name: Intel Corporation Skylake Client platform/Sky=
lake Y LPDDR3 RVP3, BIOS SKLSE2R1.R00.B097.B02.1509020030 09/02/2015
[  146.646058]  ffffc9000769bb70
[  146.646059]  ffffffff8132d415
[  146.646060]  0000000000000000
[  146.646061]  0000000000000000

[  146.646063]  ffffc9000769bbb0
[  146.646063]  ffffffff8105ec1b
[  146.646064]  000001730769bb90
[  146.646066]  00000000ffffffea
[  146.646070]  ffff88016c03a150
[  146.646072]  0000000000000282 ffff88016d793000 ffffc9000769befc
[  146.646077] Call Trace:
[  146.646086]  [<ffffffff8132d415>] dump_stack+0x68/0x93
[  146.646090]  [<ffffffff8105ec1b>] __warn+0xcb/0xf0
[  146.646095]  [<ffffffff8105ed0d>] warn_slowpath_null+0x1d/0x20
[  146.646099]  [<ffffffffa03f1ea7>] usb_function_activate+0x77/0x80 [libco=
mposite]
[  146.646105]  [<ffffffffa044a6de>] uvc_function_connect+0x1e/0x40 [usb_f_=
uvc]
[  146.646110]  [<ffffffffa044b2ae>] uvc_v4l2_open+0x6e/0x80 [usb_f_uvc]
[  146.646116]  [<ffffffffa04014f0>] v4l2_open+0xa0/0x100 [videodev]
[  146.646121]  [<ffffffff811a5431>] chrdev_open+0xa1/0x1d0
[  146.646125]  [<ffffffff811a5390>] ? cdev_put+0x30/0x30
[  146.646129]  [<ffffffff8119dd60>] do_dentry_open.isra.17+0x150/0x2e0
[  146.646133]  [<ffffffff8119f115>] vfs_open+0x45/0x60
[  146.646137]  [<ffffffff811af1ed>] path_openat+0x62d/0x1370
[  146.646141]  [<ffffffff811b0094>] ? putname+0x54/0x60
[  146.646146]  [<ffffffff811b10ce>] do_filp_open+0x7e/0xe0
[  146.646150]  [<ffffffff81083868>] ? preempt_count_sub+0x48/0x70
[  146.646154]  [<ffffffff816f07d6>] ? _raw_spin_unlock+0x16/0x30
[  146.646160]  [<ffffffff811bf009>] ? __alloc_fd+0xc9/0x180
[  146.646164]  [<ffffffff8119f4e3>] do_sys_open+0x123/0x200
[  146.646170]  [<ffffffff8119f5de>] SyS_open+0x1e/0x20
[  146.646174]  [<ffffffff816f0e2a>] entry_SYSCALL_64_fastpath+0x18/0xa8
[  146.646177] ---[ end trace 1a4f7b9817d19b04 ]---
[  146.646180] g_webcam gadget: UVC connect failed with -22
[  146.653808] usb 1-9: USB disconnect, device number 5
[  146.653986] g_webcam gadget: UVC disconnect failed with -110


And dwc3 trace:

# tracer: nop
#
# entries-in-buffer/entries-written: 445/445   #P:4
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        modprobe-2560  [001] ....    35.602546: dwc3_alloc_request: ep0out:=
 req ffff88016c03ad80 length 0/0 zsI =3D=3D> 0
        modprobe-2560  [001] ....    35.602566: dwc3_alloc_request: ep0out:=
 req ffff88016c03acc0 length 0/0 zsI =3D=3D> 0
        modprobe-2560  [001] d..1    35.602725: dwc3_gadget: Enabling ep0out
        modprobe-2560  [001] d..1    35.602730: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start New Configuration' [1033] params 00000000 00000000 00000000 -->=
 status: Successful
        modprobe-2560  [001] d..1    35.602829: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.602920: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603012: dwc3_gadget_ep_cmd: ep1out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.603104: dwc3_gadget_ep_cmd: ep1in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603195: dwc3_gadget_ep_cmd: ep2out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.603286: dwc3_gadget_ep_cmd: ep2in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603378: dwc3_gadget_ep_cmd: ep3out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.603470: dwc3_gadget_ep_cmd: ep3in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603561: dwc3_gadget_ep_cmd: ep4out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.603652: dwc3_gadget_ep_cmd: ep4in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603744: dwc3_gadget_ep_cmd: ep5out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.603836: dwc3_gadget_ep_cmd: ep5in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.603927: dwc3_gadget_ep_cmd: ep6out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.604018: dwc3_gadget_ep_cmd: ep6in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.604110: dwc3_gadget_ep_cmd: ep7out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.604202: dwc3_gadget_ep_cmd: ep7in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.604294: dwc3_gadget_ep_cmd: ep8out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.604386: dwc3_gadget_ep_cmd: ep8in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.604477: dwc3_gadget_ep_cmd: ep9out:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.604568: dwc3_gadget_ep_cmd: ep9in: =
cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 000000=
00 --> status: Successful
        modprobe-2560  [001] d..1    35.604660: dwc3_gadget_ep_cmd: ep10out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.604751: dwc3_gadget_ep_cmd: ep10in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.604843: dwc3_gadget_ep_cmd: ep11out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.604934: dwc3_gadget_ep_cmd: ep11in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.605026: dwc3_gadget_ep_cmd: ep12out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.605117: dwc3_gadget_ep_cmd: ep12in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.605209: dwc3_gadget_ep_cmd: ep13out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.605301: dwc3_gadget_ep_cmd: ep13in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.605392: dwc3_gadget_ep_cmd: ep14out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.605483: dwc3_gadget_ep_cmd: ep14in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.605575: dwc3_gadget_ep_cmd: ep15out=
: cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 0000=
0000 --> status: Successful
        modprobe-2560  [001] d..1    35.605667: dwc3_gadget_ep_cmd: ep15in:=
 cmd 'Set Endpoint Transfer Resource' [1026] params 00000001 00000000 00000=
000 --> status: Successful
        modprobe-2560  [001] d..1    35.605941: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Set Endpoint Configuration' [1025] params 00001000 00000500 00000000 =
--> status: Successful
        modprobe-2560  [001] d..1    35.605944: dwc3_gadget: Enabling ep0in
        modprobe-2560  [001] d..1    35.606216: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Set Endpoint Configuration' [1025] params 00001000 02000500 00000000 -=
-> status: Successful
        modprobe-2560  [001] d..1    35.606219: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
        modprobe-2560  [001] d..1    35.606222: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
          v4l_id-2582  [001] d..2    35.607976: dwc3_gadget: gadget g_webca=
m data soft-connect
          v4l_id-2582  [001] d..2    35.608042: dwc3_gadget: gadget g_webca=
m data soft-disconnect
      uvc-gadget-2598  [003] d..2    58.206076: dwc3_gadget: gadget g_webca=
m data soft-connect
     irq/17-dwc3-2578  [001] d..1    58.412564: dwc3_event: event (00000101=
): Reset [U0]
     irq/17-dwc3-2578  [001] d..1    58.469611: dwc3_event: event (00000201=
): Connection Done [U0]
     irq/17-dwc3-2578  [001] d..1    58.469622: dwc3_gadget: Enabling ep0out
     irq/17-dwc3-2578  [001] d..1    58.469626: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Set Endpoint Configuration' [1025] params 80000200 00000500 00000000 =
--> status: Successful
     irq/17-dwc3-2578  [001] d..1    58.469628: dwc3_gadget: Enabling ep0in
     irq/17-dwc3-2578  [001] d..1    58.469632: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Set Endpoint Configuration' [1025] params 80000200 02000500 00000000 -=
-> status: Successful
     irq/17-dwc3-2578  [001] d..1    58.568509: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.568512: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.568513: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.568514: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0100 wIndex 0000 wLength 64
     irq/17-dwc3-2578  [001] d..1    58.568515: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.568518: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 18 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.568521: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 000000008025e000 size 18 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.568531: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.568534: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.568535: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.568536: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.568641: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.568642: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.568642: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.568643: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 000000008025e000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.568644: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 18/18 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.568645: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.568645: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.568646: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.568646: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.568653: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.568790: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.568792: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.568793: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.568793: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.568794: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.568798: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.572389: dwc3_event: event (00000101=
): Reset [U0]
     irq/17-dwc3-2578  [001] d..1    58.625961: dwc3_event: event (00000201=
): Connection Done [U0]
     irq/17-dwc3-2578  [001] d..1    58.625970: dwc3_gadget: Enabling ep0out
     irq/17-dwc3-2578  [001] d..1    58.625975: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Set Endpoint Configuration' [1025] params 80000200 00000500 00000000 =
--> status: Successful
     irq/17-dwc3-2578  [001] d..1    58.625976: dwc3_gadget: Enabling ep0in
     irq/17-dwc3-2578  [001] d..1    58.625980: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Set Endpoint Configuration' [1025] params 80000200 02000500 00000000 -=
-> status: Successful
     irq/17-dwc3-2578  [001] d..1    58.724491: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.724495: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.724495: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.724496: dwc3_ctrl_req: bRequestType=
 00 bRequest 05 wValue 0004 wIndex 0000 wLength 0
     irq/17-dwc3-2578  [001] d..1    58.724497: dwc3_ep0: USB_REQ_SET_ADDRE=
SS
     irq/17-dwc3-2578  [001] d..1    58.724501: dwc3_event: event (000020c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.724502: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.724503: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.724504: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c33 (HLcs:SC:s=
tatus2)
     irq/17-dwc3-2578  [001] d..1    58.724508: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.724622: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.724624: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.724625: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.724625: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c32 (hLcs:SC=
:status2)
     irq/17-dwc3-2578  [001] d..1    58.724626: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.724630: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.736479: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.736481: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.736481: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.736482: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0100 wIndex 0000 wLength 18
     irq/17-dwc3-2578  [001] d..1    58.736482: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.736484: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 18 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.736487: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 000000008025e800 size 18 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.736498: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.736500: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.736501: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736502: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.736606: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.736608: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736608: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.736609: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 000000008025e800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.736610: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 18/18 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.736611: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.736611: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736612: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.736612: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.736620: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.736750: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.736751: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.736752: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.736752: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.736753: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.736757: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.736851: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.736853: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.736854: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.736854: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0f00 wIndex 0000 wLength 5
     irq/17-dwc3-2578  [001] d..1    58.736855: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.736856: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 5 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.736858: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 000000008025f000 size 5 ctrl 00000c53 (HLcs:SC:d=
ata)
     irq/17-dwc3-2578  [001] d..1    58.736867: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.736870: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.736870: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736871: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.736979: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.736980: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736981: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.736981: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 000000008025f000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.736982: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 5/5 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.736983: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.736983: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.736984: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.736985: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.736992: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737131: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737133: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.737134: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.737134: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.737135: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.737142: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737208: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737208: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737209: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.737209: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0f00 wIndex 0000 wLength 22
     irq/17-dwc3-2578  [001] d..1    58.737210: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.737211: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 22 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737213: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 000000008025f800 size 22 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.737221: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.737223: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737224: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737225: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.737299: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737299: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737300: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.737300: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 000000008025f800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.737301: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 22/22 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.737301: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737302: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737302: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.737303: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.737306: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737411: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737412: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.737412: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.737412: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.737413: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.737416: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737501: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737502: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737502: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.737502: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0200 wIndex 0000 wLength 9
     irq/17-dwc3-2578  [001] d..1    58.737502: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.737504: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 9 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737505: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080260000 size 9 ctrl 00000c53 (HLcs:SC:d=
ata)
     irq/17-dwc3-2578  [001] d..1    58.737514: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.737516: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737516: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737517: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.737589: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737589: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737590: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.737590: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080260000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.737590: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 9/9 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.737591: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737591: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737591: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.737592: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.737596: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737682: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737683: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.737683: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.737683: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.737684: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.737688: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737750: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737751: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737751: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.737751: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0200 wIndex 0000 wLength 309
     irq/17-dwc3-2578  [001] d..1    58.737751: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.737752: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 309 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737753: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080260800 size 309 ctrl 00000c53 (HLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.737763: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.737765: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737765: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737766: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.737846: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737846: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737846: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.737846: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080260800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.737847: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 309/309 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.737847: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737848: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737848: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.737848: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.737852: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737917: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737917: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.737917: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.737918: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.737918: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.737922: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.737985: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.737985: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737986: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.737986: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0300 wIndex 0000 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.737986: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.737986: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 4 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.737987: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080261000 size 4 ctrl 00000c53 (HLcs:SC:d=
ata)
     irq/17-dwc3-2578  [001] d..1    58.737991: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.737993: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.737994: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.737994: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.738069: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738069: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738069: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.738070: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080261000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.738070: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 4/4 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.738071: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.738071: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738071: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.738072: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.738075: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.738180: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738181: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.738181: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.738181: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.738181: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.738185: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.738248: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738248: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.738249: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.738249: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0302 wIndex 0409 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.738249: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.738250: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 28 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.738251: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080261800 size 28 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.738255: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.738257: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.738257: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738258: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.738335: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738336: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738336: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.738336: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080261800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.738337: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 28/28 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.738337: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.738338: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738338: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.738338: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.738342: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.738423: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738423: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.738424: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.738424: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.738425: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.738428: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.738491: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738491: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.738492: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.738492: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0301 wIndex 0409 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.738492: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.738493: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 34 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.738494: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080262000 size 34 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.738498: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.738500: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.738500: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738501: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.738561: dwc3_event: event (000090c2=
): ep0in: Transfer Not Ready (Active)
     irq/17-dwc3-2578  [001] d..1    58.738562: dwc3_ep0: ep0in: Transfer N=
ot Ready (Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738562: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738563: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738563: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.738563: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080262000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.738564: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 34/34 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.738564: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.738564: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.738565: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.738565: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.738569: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.738674: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.738675: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.738675: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.738676: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.738676: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.738680: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739128: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739129: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739130: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.739130: dwc3_ctrl_req: bRequestType=
 00 bRequest 09 wValue 0001 wIndex 0000 wLength 0
     irq/17-dwc3-2578  [001] d..1    58.739131: dwc3_ep0: USB_REQ_SET_CONFI=
GURATION
     irq/17-dwc3-2578  [001] d..2    58.739141: dwc3_gadget: Enabling ep1in
     irq/17-dwc3-2578  [001] d..2    58.739145: dwc3_gadget_ep_cmd: ep1in: =
cmd 'Set Endpoint Configuration' [1025] params 00020086 06070200 00000000 -=
-> status: Successful
     irq/17-dwc3-2578  [001] d..1    58.739150: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 0 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739159: dwc3_event: event (000020c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.739160: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739160: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.739161: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c33 (HLcs:SC:s=
tatus2)
     irq/17-dwc3-2578  [001] d..1    58.739165: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.739241: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739242: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.739242: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.739243: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c32 (hLcs:SC=
:status2)
     irq/17-dwc3-2578  [001] d..1    58.739244: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 0/0 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.739245: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.739248: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739313: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739314: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739314: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.739315: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0304 wIndex 0409 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.739315: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.739316: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 12 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739318: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080262800 size 12 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.739326: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.739329: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.739330: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739330: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.739400: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739401: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739402: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.739402: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080262800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.739403: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 12/12 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.739404: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.739405: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739405: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.739406: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.739412: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739509: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739510: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.739511: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.739512: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.739512: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.739516: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739660: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739661: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739661: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.739662: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0305 wIndex 0409 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.739662: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.739664: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 22 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739666: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080263000 size 22 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.739672: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.739674: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.739675: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739676: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.739753: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739754: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739754: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.739755: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080263000 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.739756: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 22/22 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.739757: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.739757: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.739758: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.739758: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.739765: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739863: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739864: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.739864: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.739865: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.739866: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.739870: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.739976: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.739981: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739981: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.739984: dwc3_ctrl_req: bRequestType=
 80 bRequest 06 wValue 0306 wIndex 0409 wLength 255
     irq/17-dwc3-2578  [001] d..1    58.739986: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.739987: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 32 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.739989: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000080263800 size 32 ctrl 00000c53 (HLcs:SC:=
data)
     irq/17-dwc3-2578  [001] d..1    58.740000: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.740002: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.740003: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.740004: dwc3_ep0: Control Data
     irq/17-dwc3-2578  [001] d..1    58.740066: dwc3_event: event (000090c2=
): ep0in: Transfer Not Ready (Active)
     irq/17-dwc3-2578  [001] d..1    58.740067: dwc3_ep0: ep0in: Transfer N=
ot Ready (Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.740068: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.740069: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.740069: dwc3_ep0: Data Phase
     irq/17-dwc3-2578  [001] d..1    58.740070: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000080263800 size 0 ctrl 00000c52 (hLcs:SC=
:data)
     irq/17-dwc3-2578  [001] d..1    58.740071: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 32/32 ZsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.740071: dwc3_event: event (000020c0=
): ep0out: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.740072: dwc3_ep0: ep0out: Transfer =
Not Ready (Not Active): state 'Data Phase'
     irq/17-dwc3-2578  [001] d..1    58.740072: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.740073: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c43 (HLcs:SC:=
status3)
     irq/17-dwc3-2578  [001] d..1    58.740077: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.740177: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.740178: dwc3_ep0: ep0out: Transfer =
Complete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.740179: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.740180: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c42 (hLcs:SC=
:status3)
     irq/17-dwc3-2578  [001] d..1    58.740180: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.740189: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.804470: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.804473: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.804475: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.804475: dwc3_ctrl_req: bRequestType=
 01 bRequest 0b wValue 0000 wIndex 0001 wLength 0
     irq/17-dwc3-2578  [001] d..1    58.804476: dwc3_ep0: Forwarding to gad=
get driver
     irq/17-dwc3-2578  [001] d..1    58.804482: dwc3_ep0: queueing request =
ffff88016c03ad80 to ep0out length 0 state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.804486: dwc3_event: event (000020c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.804487: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.804488: dwc3_ep0: Control Status
     irq/17-dwc3-2578  [001] d..1    58.804489: dwc3_prepare_trb: ep0in: 0/=
0 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c33 (HLcs:SC:s=
tatus2)
     irq/17-dwc3-2578  [001] d..1    58.804495: dwc3_gadget_ep_cmd: ep0in: =
cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: S=
uccessful
     irq/17-dwc3-2578  [001] d..1    58.804583: dwc3_event: event (0000c042=
): ep0in: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.804584: dwc3_ep0: ep0in: Transfer C=
omplete: state 'Status Phase'
     irq/17-dwc3-2578  [001] d..1    58.804584: dwc3_ep0: Status Phase
     irq/17-dwc3-2578  [001] d..1    58.804585: dwc3_complete_trb: ep0out: =
0/2 trb ffff880084c02000 buf 0000000084c01000 size 0 ctrl 00000c32 (hLcs:SC=
:status2)
     irq/17-dwc3-2578  [001] d..1    58.804586: dwc3_gadget_giveback: ep0ou=
t: req ffff88016c03ad80 length 0/0 zsI =3D=3D> 0
     irq/17-dwc3-2578  [001] d..1    58.804587: dwc3_prepare_trb: ep0out: 0=
/2 trb ffff880084c02000 buf 0000000084c01000 size 8 ctrl 00000c23 (HLcs:SC:=
setup)
     irq/17-dwc3-2578  [001] d..1    58.804596: dwc3_gadget_ep_cmd: ep0out:=
 cmd 'Start Transfer' [1030] params 00000000 84c02000 00000000 --> status: =
Successful
     irq/17-dwc3-2578  [001] d..1    58.804660: dwc3_event: event (0000c040=
): ep0out: Transfer Complete
     irq/17-dwc3-2578  [001] d..1    58.804661: dwc3_ep0: ep0out: Transfer =
Complete: state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.804661: dwc3_ep0: Setup Phase
     irq/17-dwc3-2578  [001] d..1    58.804661: dwc3_ctrl_req: bRequestType=
 a1 bRequest 87 wValue 0100 wIndex 0001 wLength 26
     irq/17-dwc3-2578  [001] d..1    58.804663: dwc3_event: event (000010c2=
): ep0in: Transfer Not Ready (Not Active)
     irq/17-dwc3-2578  [001] d..1    58.804663: dwc3_ep0: ep0in: Transfer N=
ot Ready (Not Active): state 'Setup Phase'
     irq/17-dwc3-2578  [001] d..1    58.804664: dwc3_ep0: Control Data

uvc-gadget keeps printing this error message:

 159         if ((ret =3D ioctl(dev->fd, VIDIOC_DQBUF, &buf)) < 0) {
 160                 printf("Unable to dequeue buffer: %s (%d).\n", strerro=
r(errno),
 161                         errno);
 162                 return ret;
 163         }

Any ideas?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX5N6lAAoJEMy+uJnhGpkG/Q0QAIL4kjM6WLQzpN6rtGacd3GI
YF/9THyqpB/dxZjw7L42bgvC/ePlp8aW4rWkosOejiaX3pOL/mK+hOPGzDtUkk1M
MlONW8sJDHjynkOh39XlnqTkhKEo/HF46apX1kENcaCU3nUX5INTL8aLY0c0957k
oxZHWzh+x83eolkThgIabw6I+fbXOolpIgpPq9GB8RfdasG1Osm/QTiAkhDGhMs9
zQ3EoLClVE3CCdUdGNB73c41Ut23AoCqlypmwFWciVitjDGUiulJfn4QX8jXTppr
vTKAexHSs74HntJDSDifwqa5N5QKkZmzMrz0k980OyOhIqFmQZC6UjwVmw0374cS
mRRoF5obK8M8b/BiB/nxPZWJCz+6huu0kZUqoGaQI497YmjoChyqhNxrcp/ZCIHa
Ng1ipdF190QMJ16FnSOGeS3eTm+5vt+adbMBqlv2auvostVIH9Wr/PjphBFoOpuA
WpcgadU8UZppC4LaY6cPrNp68vFALqzoGUS5L1act7xl7PIiMOdOyKRl0hNrHxl7
aKWRk+xa0KfToIXpt6DmtW2V7aFwlsAyTGsZPez/lqTqZ9Bn2URkQjWgpizugvE9
Ku0t9lMx7KstJk1OI5a0EYiazSDP5mlPtAY8taOe3KWZc/MYQdFnxYHC0vWi5CYc
srRw5DY3atBeO8nbfuSW
=XcxS
-----END PGP SIGNATURE-----
--=-=-=--
