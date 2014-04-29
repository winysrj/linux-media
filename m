Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45657 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbaD2UI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 16:08:56 -0400
Received: by mail-vc0-f175.google.com with SMTP id lh4so970593vcb.6
        for <linux-media@vger.kernel.org>; Tue, 29 Apr 2014 13:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1404291241000.26512@spider.phas.ubc.ca>
References: <alpine.LNX.2.00.1404291241000.26512@spider.phas.ubc.ca>
Date: Tue, 29 Apr 2014 17:08:55 -0300
Message-ID: <CAOMZO5DUGECOy8KTrrJzv5Aq2HW0LYtwP3VTwTmjQXLi5UXR7Q@mail.gmail.com>
Subject: Re: au0828 (950Q) kernel OOPS 3.10.30 imx6
From: Fabio Estevam <festevam@gmail.com>
To: Carl Michal <michal@physics.ubc.ca>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 29, 2014 at 4:50 PM, Carl Michal <michal@physics.ubc.ca> wrote:
> Hello,
>
> I'm trying to use a Hauppage HVR-950Q ATSC tv stick with a Cubox-i running
> geexbox.
>
> It works great, until it doesn't. After its been up and running for a few
> hours (sometimes minutes), I start to get kernel OOPs, example pasted in
> below. The 950Q generally doesn't work afterwards.
>
> This is a 3.10.30 kernel, that I believe the Cubox is somewhat tied to for
> other driver reasons.
>
> I haven't seen any such problems if the HVR-950Q is unplugged.
>
> Any advice on tracking this down would be appreciated.
>
> Carl
>
>
> ————[ cut here ]————
> WARNING: at mm/vmalloc.c:126 vmap_page_range_noflush+0×178/0x1c4()
> Modules linked in: au8522_dig tuner au8522_decoder au8522_common
> mxc_v4l2_capture au0828 ipu_bg_overlay_sdc snd_usb_audio ipu_still
> ipu_prp_enc snd_usbmidi_lib ipu_csi_enc tveeprom snd_rawmidi
> ipu_fg_overlay_sdc videobuf_vmalloc snd_hwdep brcmutil ir_lirc_codec
> lirc_dev ir_rc5_sz_decoder ir_sanyo_decoder ir_mce_kbd_decoder
> ir_sony_decoder ir_nec_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder
> uinput
> CPU: 0 PID: 700 Comm: xbmc.bin Not tainted 3.10.30 #1
> [<8001444c>] (unwind_backtrace) from [<800114ac>] (show_stack+0×10/0×14)
> [<800114ac>] (show_stack) from [<80025fd0>]
> (warn_slowpath_common+0x4c/0x6c)
> [<80025fd0>] (warn_slowpath_common) from [<8002600c>]
> (warn_slowpath_null+0x1c/0×24)
> [<8002600c>] (warn_slowpath_null) from [<800af188>]
> (vmap_page_range_noflush+0×178/0x1c4)
> [<800af188>] (vmap_page_range_noflush) from [<800b0228>]
> (map_vm_area+0x2c/0x7c)
> [<800b0228>] (map_vm_area) from [<800b0dd0>]
> (__vmalloc_node_range+0xfc/0x1dc)
> [<800b0dd0>] (__vmalloc_node_range) from [<800b0eec>]
> (__vmalloc_node+0x3c/0×44)
> [<800b0eec>] (__vmalloc_node) from [<800b0f24>] (vmalloc+0×30/0×38)
> [<800b0f24>] (vmalloc) from [<80438778>] (gckOS_AllocateMemory+0×40/0×54)
> [<80438778>] (gckOS_AllocateMemory) from [<804387c0>]

This comes from the Vivante GPU driver, which is not in mainline.

Please try a 3.14.2 or 3.15-rc3 kernel instead.
