Return-path: <linux-media-owner@vger.kernel.org>
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:44776 "EHLO
	homiemail-a88.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754872Ab2EIRwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 13:52:44 -0400
Received: from homiemail-a88.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a88.g.dreamhost.com (Postfix) with ESMTP id 6810A2642DF
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 10:31:48 -0700 (PDT)
Received: from [10.0.0.26] (a95-93-70-140.cpe.netcabo.pt [95.93.70.140])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: bruno@skorzen.net)
	by homiemail-a88.g.dreamhost.com (Postfix) with ESMTPSA id DCAA0264485
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 10:10:54 -0700 (PDT)
Message-ID: <4FAAA511.7070408@skorzen.net>
Date: Wed, 09 May 2012 18:10:41 +0100
From: Bruno Martins <lists@skorzen.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Dazzle DVC80 under FC16
References: <4FAA57A3.2030701@skorzen.net> <4FAA75A7.5030807@skorzen.net> <201205091732.18373.linux@rainbow-software.org> <4FAA9942.5050703@skorzen.net> <CALF0-+V7NW737+_AHdXF=DhOEpXMy+LBZRgrX+n0kjrTwMuXpA@mail.gmail.com>
In-Reply-To: <CALF0-+V7NW737+_AHdXF=DhOEpXMy+LBZRgrX+n0kjrTwMuXpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/2012 05:54 PM, Ezequiel Garcia wrote:
> Hi,
> 
> Also please output lsmod with your device plugged and the list of your
> installed modules (do you know how to do this?)
> 
> I may be wrong, but this device should be supported by usbvision module.
> 
> Thanks,
> Ezequiel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi there,

Is this information sufficient? Did lsmod, and the same but grepping
'usbvision' module.

[root@g62 skorzen]# lsmod
Module                  Size  Used by
saa7115                22886  0
usbvision              74822  0
v4l2_common            15133  2 saa7115,usbvision
binfmt_misc            17431  1
usb_storage            52112  0
vboxpci                23198  0
vboxnetadp             13382  0
vboxnetflt             23424  0
vboxdrv               267808  3 vboxpci,vboxnetadp,vboxnetflt
lockd                  84763  0
fcoe                   27289  0
libfcoe                47156  1 fcoe
libfc                 108615  2 fcoe,libfcoe
scsi_transport_fc      53339  2 fcoe,libfc
scsi_tgt               19553  1 scsi_transport_fc
8021q                  24177  0
garp                   14069  1 8021q
stp                    12823  1 garp
llc                    14090  2 garp,stp
be2iscsi               72382  0
iscsi_boot_sysfs       15641  1 be2iscsi
bnx2i                  54521  0
cnic                   62821  1 bnx2i
uio                    19028  1 cnic
cxgb4i                 32909  0
cxgb4                 103017  1 cxgb4i
cxgb3i                 32972  0
libcxgbi               56508  2 cxgb4i,cxgb3i
cxgb3                 155458  1 cxgb3i
mdio                   13398  1 cxgb3
ib_iser                38001  0
rdma_cm                41898  1 ib_iser
ib_cm                  41692  1 rdma_cm
iw_cm                  18176  1 rdma_cm
ib_sa                  28417  2 rdma_cm,ib_cm
ib_mad                 46392  2 ib_cm,ib_sa
ib_core                73803  6 ib_iser,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mad
ib_addr                13745  1 rdma_cm
iscsi_tcp              18333  0
libiscsi_tcp           23970  4 cxgb4i,cxgb3i,libcxgbi,iscsi_tcp
libiscsi               50527  8
be2iscsi,bnx2i,cxgb4i,cxgb3i,libcxgbi,ib_iser,iscsi_tcp,libiscsi_tcp
scsi_transport_iscsi    51924  8
be2iscsi,bnx2i,libcxgbi,ib_iser,iscsi_tcp,libiscsi
nf_conntrack_ipv4      14622  1
nf_defrag_ipv4         12673  1 nf_conntrack_ipv4
ip6t_REJECT            12939  2
nf_conntrack_ipv6      14290  1
nf_defrag_ipv6         18139  1 nf_conntrack_ipv6
xt_state               12578  2
nf_conntrack           82286  3 nf_conntrack_ipv4,nf_conntrack_ipv6,xt_state
ip6table_filter        12815  1
ip6_tables             26976  1 ip6table_filter
i2c_i801               17765  0
arc4                   12529  2
brcmsmac              551177  0
mac80211              496450  1 brcmsmac
brcmutil               14124  1 brcmsmac
cfg80211              195558  2 brcmsmac,mac80211
crc8                   12708  1 brcmsmac
cordic                 12486  1 brcmsmac
snd_hda_codec_hdmi     36157  1
snd_hda_codec_realtek   145364  1
bcma                   30101  1 brcmsmac
r8169                  60789  0
snd_hda_intel          33276  5
snd_hda_codec         115767  3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              17611  1 snd_hda_codec
snd_seq                64807  0
snd_seq_device         14129  1 snd_seq
snd_pcm                97170  4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
snd_timer              28815  2 snd_seq,snd_pcm
snd                    78908  18
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer
soundcore              14484  1 snd
snd_page_alloc         18101  2 snd_hda_intel,snd_pcm
iTCO_wdt               17948  0
hp_wmi                 18048  0
iTCO_vendor_support    13419  1 iTCO_wdt
uvcvideo               76346  0
mii                    13527  1 r8169
sparse_keymap          13526  1 hp_wmi
videobuf2_core         31894  1 uvcvideo
videodev              106837  5
saa7115,usbvision,v4l2_common,uvcvideo,videobuf2_core
media                  20444  2 uvcvideo,videodev
videobuf2_vmalloc      12967  1 uvcvideo
rfkill                 21342  3 cfg80211,hp_wmi
microcode              23348  0
videobuf2_memops       13262  1 videobuf2_vmalloc
serio_raw              13371  0
joydev                 17412  0
sunrpc                235361  2 lockd
uinput                 17606  0
wmi                    18697  1 hp_wmi
i915                  466809  2
drm_kms_helper         40231  1 i915
drm                   242003  3 i915,drm_kms_helper
i2c_algo_bit           13156  1 i915
i2c_core               37991  9
saa7115,usbvision,v4l2_common,i2c_i801,videodev,i915,drm_kms_helper,drm,i2c_algo_bit
video                  18932  1 i915
[root@g62 skorzen]# lsmod | grep usbvision
usbvision              74822  0
v4l2_common            15133  2 saa7115,usbvision
videodev              106837  5
saa7115,usbvision,v4l2_common,uvcvideo,videobuf2_core
i2c_core               37991  9
saa7115,usbvision,v4l2_common,i2c_i801,videodev,i915,drm_kms_helper,drm,i2c_algo_bit

Kind regards,

-- 
Bruno Martins
bruno@skorzen.net
(+351) 939 668 667
http//www.skorzen.net/
