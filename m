Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:45108 "EHLO
        v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbeLBPZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2018 10:25:49 -0500
Subject: Re: [PATCH] pulse8-cec: return 0 when invalidating the logical
 address
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3bc19549-ea46-1273-11b9-49482e3574f0@xs4all.nl>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <ad8d4315-59d7-f7eb-6c35-630c57a6b64b@mbox200.swipnet.se>
Date: Sun, 2 Dec 2018 16:25:42 +0100
MIME-Version: 1.0
In-Reply-To: <3bc19549-ea46-1273-11b9-49482e3574f0@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-11-14 14:25, Hans Verkuil wrote:
> Return 0 when invalidating the logical address. The cec core produces
> a warning for drivers that do this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
> ---
> diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> index 365c78b748dd..b085b14f3f87 100644
> --- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
> +++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> @@ -586,7 +586,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>   	else
>   		pulse8->config_pending = true;
>   	mutex_unlock(&pulse8->config_lock);
> -	return err;
> +	return log_addr == CEC_LOG_ADDR_INVALID ? 0 : err;
>   }
> 
>   static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> 


question, is below warning also fixed by this patch? or is it a different problem?
note that this warning showed up without me unplugging the usb device.
and cec-ctl have stopped working (again...)


[75420.604557] WARNING: CPU: 5 PID: 23114 at drivers/media/cec/cec-adap.c:1217 
cec_adap_unconfigure+0x9c/0xa0 [cec]
[75420.604562] Modules linked in: fuse 8021q garp mrp xt_nat macvlan 
xt_CHECKSUM iptable_mangle ip6t_REJECT nf_reject_ipv6 tun xfs devlink 
ebtable_filter ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 xt_addrtype 
xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter 
bridge stp llc nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache 
target_core_user uio target_core_pscsi bonding target_core_file 
target_core_iblock iscsi_target_mod target_core_mod rc_cec pulse8_cec cec 
ip6table_filter ip6_tables nct6775 hwmon_vid vfat fat dm_multipath scsi_dh_rdac 
scsi_dh_emc scsi_dh_alua nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) 
nvidia(POE) cx25840 cx23885 rc_tt_1500 altera_ci tda18271 altera_stapl tveeprom 
cx2341x sp2 si2157 si2168 intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp
[75420.604634]  snd_hda_codec_hdmi ir_rc6_decoder videobuf2_dma_sg 
videobuf2_memops kvm_intel dvb_usb_dvbsky dvb_usb_v2 videobuf2_dvb m88ds3103 
videobuf2_v4l2 videobuf2_common rc_rc6_mce v4l2_common videodev kvm dvb_core 
iTCO_wdt mceusb rc_core iTCO_vendor_support snd_hda_codec_realtek 
snd_hda_codec_generic joydev crct10dif_pclmul cdc_acm cp210x snd_hda_intel 
crc32_pclmul ghash_clmulni_intel snd_hda_codec intel_cstate intel_uncore 
ipmi_ssif snd_hda_core intel_rapl_perf media snd_hwdep drm_kms_helper i2c_mux 
snd_seq snd_seq_device snd_pcm drm snd_timer snd soundcore i2c_i801 mei_me 
lpc_ich mei ipmi_si ipmi_devintf ipmi_msghandler pcc_cpufreq nfsd binfmt_misc 
auth_rpcgss nfs_acl lockd grace sunrpc dm_thin_pool dm_cache_smq dm_cache 
dm_persistent_data libcrc32c dm_bio_prison mxm_wmi uas crc32c_intel igb
[75420.604705]  usb_storage megaraid_sas dca i2c_algo_bit wmi vfio_pci 
irqbypass vfio_virqfd vfio_iommu_type1 vfio i2c_dev
[75420.604722] CPU: 5 PID: 23114 Comm: cec-ctl Tainted: P           OE 
4.19.5-200.local.fc28.x86_64 #1
[75420.604725] Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 
06/15/2018
[75420.604732] RIP: 0010:cec_adap_unconfigure+0x9c/0xa0 [cec]
[75420.604736] Code: 3c 05 00 00 e8 b5 fa ff ff 48 8d bb 30 04 00 00 31 c9 ba 
01 00 00 00 be 01 00 00 00 e8 8d a8 80 e0 48 89 df 5b e9 a4 fe ff ff <0f> 0b eb 
98 0f 1f 44 00 00 41 57 41 56 4c 8d b7 d0 03 00 00 41 55
[75420.604739] RSP: 0018:ffffaa7423197d78 EFLAGS: 00010282
[75420.604743] RAX: 00000000ffffff92 RBX: ffff99d61cdbd800 RCX: 0000000000000000
[75420.604746] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff99d62e903700
[75420.604749] RBP: ffff99d19d4aaa00 R08: 000000000000000e R09: 0000000000000000
[75420.604752] R10: 00000000000018fa R11: 0000000000000000 R12: ffffaa7423197de8
[75420.604755] R13: 00007ffe4fb9bd40 R14: 00007ffe4fb9bd01 R15: ffff99d61cdbd800
[75420.604759] FS:  00007f1e0310d740(0000) GS:ffff99d63f940000(0000) 
knlGS:0000000000000000
[75420.604762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[75420.604765] CR2: 00007f0d225fe680 CR3: 0000000ac544a005 CR4: 00000000003626e0
[75420.604768] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[75420.604771] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[75420.604773] Call Trace:
[75420.604784]  __cec_s_log_addrs+0x25c/0x4c0 [cec]
[75420.604790]  cec_ioctl+0x1e2/0xda0 [cec]
[75420.604800]  ? do_filp_open+0xa7/0x100
[75420.604806]  do_vfs_ioctl+0xa4/0x630
[75420.604812]  ksys_ioctl+0x60/0x90
[75420.604818]  __x64_sys_ioctl+0x16/0x20
[75420.604826]  do_syscall_64+0x5b/0x160
[75420.604833]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[75420.604838] RIP: 0033:0x7f1e0210bc57
[75420.604842] Code: 00 00 90 48 8b 05 49 82 2c 00 64 c7 00 26 00 00 00 48 c7 
c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d 19 82 2c 00 f7 d8 64 89 01 48
[75420.604845] RSP: 002b:00007ffe4fb9b908 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[75420.604849] RAX: ffffffffffffffda RBX: 0000000000000101 RCX: 00007f1e0210bc57
[75420.604852] RDX: 00007ffe4fb9bd40 RSI: 00000000c05c6104 RDI: 0000000000000003
[75420.604854] RBP: 00007ffe4fb9bef0 R08: 0000000000000000 R09: 0000000000000000
[75420.604857] R10: 0000000000000000 R11: 0000000000000246 R12: 000055d41aca0c1f
[75420.604860] R13: 0000000000000010 R14: 0000000000000101 R15: 00007ffe4fb9bc40
[75420.604864] ---[ end trace 338ae722a1bb9fd4 ]---
