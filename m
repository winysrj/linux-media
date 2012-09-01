Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47120 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2IANdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 09:33:18 -0400
Received: by bkwj10 with SMTP id j10so1629019bkw.19
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2012 06:33:17 -0700 (PDT)
Message-ID: <50420E9A.6000800@gmail.com>
Date: Sat, 01 Sep 2012 15:33:14 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rtl28xxu: stream did not start after stop on USB3.0
References: <1345593382-11367-1-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2012 01:56 AM, Antti Palosaari wrote:
> Stream did not start anymore after stream was stopped once.
> 
> Following error can be seen, xhci_hcd
> WARN Set TR Deq Ptr cmd failed due to incorrect slot or ep state.
> 
> usb_clear_halt for streaming endpoint helps.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index d2b1505..1ccb99b 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -834,6 +834,7 @@ static int rtl28xxu_streaming_ctrl(struct dvb_frontend *fe , int onoff)
>  	if (onoff) {
>  		buf[0] = 0x00;
>  		buf[1] = 0x00;
> +		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x81));
>  	} else {
>  		buf[0] = 0x10; /* stall EPA */
>  		buf[1] = 0x02; /* reset EPA */
> 

After every soft/warm [re]boot only after first scandvb:
------------[ cut here ]------------
WARNING: at drivers/usb/host/ehci-hcd.c:1226
ehci_endpoint_reset+0x111/0x120()
Hardware name: M720-US3
clear_halt for a busy endpoint
Modules linked in: fc0012(O) rtl2832(O) dvb_usb_rtl28xxu(O) rtl2830(O)
dvb_usbv2(O) dvb_core(O) nvidia(PO) tvaudio(O) tda7432(O) msp3400(O)
tuner_simple(O) tuner_types(O) wm8775(O) snd_hda_codec_realtek
tda9887(O) tda8290(O) tuner(O) cx25840(O) snd_hda_intel snd_bt87x
bttv(O) ivtv(O) snd_hda_codec snd_hwdep tveeprom(O) cx2341x(O)
btcx_risc(O) snd_pcm snd_page_alloc snd_timer snd soundcore ppdev
videobuf_dma_sg(O) videobuf_core(O) v4l2_common(O) parport_serial
parport_pc parport videodev(O) edac_core media(O) i2c_nforce2 rc_core(O)
i2c_algo_bit microcode i2c_core edac_mce_amd vhost_net tun macvtap
macvlan kvm_amd kvm uinput binfmt_misc raid1 r8169 ata_generic pata_acpi
mii usb_storage skge pata_amd wmi sunrpc be2iscsi bnx2i cnic uio cxgb4i
cxgb4 cxgb3i cxgb3 mdio libcxgbi libiscsi_tcp qla4xxx iscsi_boot_sysfs
libiscsi scsi_transport_iscsi [last unloaded: scsi_wait_scan]
Pid: 1170, comm: scandvb Tainted: P           O 3.5.2-3.fc17.x86_64 #1
Call Trace:
 [<ffffffff810584bf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810585b6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81444a31>] ehci_endpoint_reset+0x111/0x120
 [<ffffffff8142c135>] usb_hcd_reset_endpoint+0x25/0x70
 [<ffffffff8142d468>] usb_reset_endpoint+0x28/0x40
 [<ffffffff8142e06e>] usb_clear_halt+0x6e/0x80
 [<ffffffffa0f2baed>] rtl28xxu_streaming_ctrl+0xad/0x110 [dvb_usb_rtl28xxu]
 [<ffffffffa0f50375>] dvb_usb_start_feed+0x235/0x440 [dvb_usbv2]
 [<ffffffff8115ca5d>] ? __vmalloc_node_range+0x17d/0x240
 [<ffffffffa0f111b9>] ? dvb_dmxdev_filter_start+0x2c9/0x3e0 [dvb_core]
 [<ffffffffa0f12b00>] dmx_section_feed_start_filtering+0xe0/0x180 [dvb_core]
 [<ffffffffa0f110fe>] dvb_dmxdev_filter_start+0x20e/0x3e0 [dvb_core]
 [<ffffffffa0f11945>] dvb_demux_do_ioctl+0x405/0x640 [dvb_core]
 [<ffffffffa0f11540>] ? dvb_dvr_do_ioctl+0x130/0x130 [dvb_core]
 [<ffffffffa0f0fa36>] dvb_usercopy+0x86/0x1d0 [dvb_core]
 [<ffffffff811976d1>] ? do_filp_open+0x41/0xa0
 [<ffffffffa0f0ffa5>] dvb_demux_ioctl+0x15/0x20 [dvb_core]
 [<ffffffff811996c9>] do_vfs_ioctl+0x99/0x580
 [<ffffffff812793da>] ? inode_has_perm.isra.31.constprop.61+0x2a/0x30
 [<ffffffff8127a9b7>] ? file_has_perm+0x97/0xb0
 [<ffffffff81199c49>] sys_ioctl+0x99/0xa0
 [<ffffffff81614969>] system_call_fastpath+0x16/0x1b
---[ end trace cce2913a24da6585 ]---

media_build
commit 420335f564c32517a791ecea3909af233925634d

Cheers,
poma

