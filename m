Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42278 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250AbZKYXGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 18:06:35 -0500
Received: by fxm5 with SMTP id 5so236715fxm.28
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 15:06:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911181354.06529.laurent.pinchart@ideasonboard.com>
References: <200911181354.06529.laurent.pinchart@ideasonboard.com>
Date: Wed, 25 Nov 2009 18:06:40 -0500
Message-ID: <829197380911251506g4af4d72v85c6dfb55cb88d0a@mail.gmail.com>
Subject: Re: [PATCH/RFC v2] V4L core cleanups HG tree
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2009 at 7:54 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi everybody,
>
> the V4L cleanup patches are now available from
>
> http://linuxtv.org/hg/~pinchartl/v4l-dvb-cleanup
>
> The tree will be rebased if needed (or rather dropped and recreated as hg
> doesn't provide a rebase operation), so please don't pull from it yet if you
> don't want to have to throw the patches away manually later.
>
> I've incorporated the comments received so far and went through all the
> patches to spot bugs that could have sneaked in.
>
> Please test the code against the driver(s) you maintain. The changes are
> small, *should* not create any issue, but the usual bug can still sneak in.
>
> I can't wait for an explicit ack from all maintainers (mostly because I don't
> know you all), so I'll send a pull request in a week if there's no blocking
> issue. I'd like this to get in 2.6.33 if possible.
>
> --
> Regards,
>
> Laurent Pinchart

Hi Laurent,

Well, I don't know what is wrong yet, but the au0828 driver now hits
an OOPS with this tree whenever the device is disconnected, whereas
with last night's v4l-dvb tip it was working fine.

I'll dig into it now...

[  254.972480] usb 1-3: USB disconnect, address 8
[  254.973073] BUG: unable to handle kernel NULL pointer dereference at 00000004
[  254.973083] IP: [<f8dc0142>] au0828_analog_unregister+0x32/0x90 [au0828]
[  254.973101] *pde = 00000000
[  254.973107] Oops: 0002 [#1] SMP
[  254.973113] last sysfs file: /sys/devices/system/cpu/cpu1/topology/core_id
[  254.973120] Modules linked in: xc5000 tuner au8522 au0828 dvb_core
v4l2_common videodev v4l1_compat videobuf_vmalloc videobuf_core
tveeprom snd_usb_audio snd_usb_lib binfmt_misc ppdev bridge stp bnep
btusb arc4 ecb snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy joydev snd_seq_oss
snd_seq_midi iptable_filter ath9k mac80211 ath appletouch ip_tables
applesmc x_tables snd_rawmidi isight_firmware snd_seq_midi_event
snd_seq snd_timer snd_seq_device led_class input_polldev cfg80211 snd
soundcore snd_page_alloc sbp2 lp parport fbcon tileblit font bitblit
softcursor hid_apple usbhid ohci1394 ieee1394 i915 drm i2c_algo_bit
video output sky2 intel_agp agpgart [last unloaded: tveeprom]
[  254.973243]
[  254.973250] Pid: 26, comm: khubd Not tainted (2.6.31-15-generic
#50-Ubuntu) MacBook2,1
[  254.973256] EIP: 0060:[<f8dc0142>] EFLAGS: 00010286 CPU: 0
[  254.973266] EIP is at au0828_analog_unregister+0x32/0x90 [au0828]
[  254.973271] EAX: 00000000 EBX: ecf04800 ECX: ed8e4a00 EDX: 00000000
[  254.973276] ESI: ee76a000 EDI: f8dc53c0 EBP: f7119e08 ESP: f7119e00
[  254.973281]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  254.973286] Process khubd (pid: 26, ti=f7118000 task=f70bcb60
task.ti=f7118000)
[  254.973290] Stack:
[  254.973293]  ecf04800 ecf04800 f7119e20 f8dbd02b ecfe6800 ee76a000
ee76a000 ee76a01c
[  254.973307] <0> f7119e3c c0414d89 00000000 ecfe6800 ee76a01c
f8dc53f4 c0778120 f7119e4c
[  254.973322] <0> c03a2b9e ee76a050 ee76a01c f7119e5c c03a2cb0
c0778120 ee76a01c f7119e70
[  254.973337] Call Trace:
[  254.973348]  [<f8dbd02b>] ? au0828_usb_disconnect+0x2b/0x80 [au0828]
[  254.973362]  [<c0414d89>] ? usb_unbind_interface+0xe9/0x120
[  254.973371]  [<c03a2b9e>] ? __device_release_driver+0x3e/0x90
[  254.973379]  [<c03a2cb0>] ? device_release_driver+0x20/0x40
[  254.973386]  [<c03a1ff3>] ? bus_remove_device+0x73/0x90
[  254.973393]  [<c03a075f>] ? device_del+0xef/0x150
.....



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
