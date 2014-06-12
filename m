Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:50273 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbaFLPTT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 11:19:19 -0400
Message-ID: <5399C4F7.1060905@dest-unreach.be>
Date: Thu, 12 Jun 2014 17:19:19 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [BUG & PATCH] media/rc/ir-nec-decode : phantom keypress
References: <538994CB.6020205@dest-unreach.be> <53980DF8.5040206@dest-unreach.be> <330c58e7d7849824b812db007c03b08d@hardeman.nu> <53998D69.60901@dest-unreach.be> <754858effccb1d52ebec59f91f860c26@hardeman.nu> <5399992E.8050502@dest-unreach.be> <0eaab4efe2fc37126f2bb444d7f3d507@hardeman.nu>
In-Reply-To: <0eaab4efe2fc37126f2bb444d7f3d507@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-12 14:42, David Härdeman wrote:
> Could you paste the output from lsmod?

At the end of this mail.


> Where did you get the driver? Is it this one?
> http://www.tbsdtv.com/download/document/common/tbs-linux-drivers_v140425.zip

Yes, inside the zip is `linux-tbs-drivers.tar.bz2`, where the actual
drivers live. I believe we should be looking at
linux-tbs-drivers/linux/drivers/media/common/saa716x/saa716x_input.c

I think the interesting parts are at the end of the file, where the two
IRQ-handling functions are.

I don't understand why there is a 15ms timer before
ir_raw_event_handle() is called (the comment just says what the code
does, not why it does it). I assume this throttles the decoders a bit.
Does that make sense?


>From what I understand from the code, the hardware fires an interrupt
every time there is an edge, so I need to start a timer myself to call
ir_raw_event_set_idle() some time in the future. (And possible
re-schedule the ir_raw_event_handle() call as well). Does that sound right?

I've been reading ir-raw.c, but I don't see any timers there. I see the
timeout-check in ir_raw_event_store_with_filter(), but that will only
fire when called, and won't trigger by itself.

Thanks again for your time,
Niels




# lsmod
Module                  Size  Used by
rpcsec_gss_krb5        35573  1
nfsv4                 465643  2
tbsfe                  13023  2
nfsd                  280297  2
auth_rpcgss            59338  3 nfsd,rpcsec_gss_krb5
nfs_acl                12837  1 nfsd
nfs                   236636  2 nfsv4
lockd                  93977  2 nfs,nfsd
sunrpc                284404  10
nfs,nfsd,rpcsec_gss_krb5,auth_rpcgss,lockd,nfsv4,nfs_acl
fscache                63988  2 nfs,nfsv4
hid_generic            12548  0
usbhid                 52616  0
hid                   106148  2 hid_generic,usbhid
tbs62x1fe              55345  2
snd_hda_codec_hdmi     46207  2
snd_hda_codec_realtek    61438  1
ir_lirc_codec          12898  0
lirc_dev               19166  1 ir_lirc_codec
snd_seq_midi           13324  0
snd_seq_midi_event     14899  1 snd_seq_midi
snd_rawmidi            30144  1 snd_seq_midi
ir_mce_kbd_decoder     12845  0
ir_sony_decoder        12549  0
ir_jvc_decoder         12546  0
intel_rapl             18773  0
x86_pkg_temp_thermal    14205  0
ir_rc6_decoder         12546  0
intel_powerclamp       14705  0
kvm_intel             143060  0
kvm                   451511  1 kvm_intel
ir_rc5_decoder         12546  0
crct10dif_pclmul       14289  0
ir_nec_decoder         12546  0
crc32_pclmul           13113  0
ghash_clmulni_intel    13259  0
rc_tbs_nec             12502  0
aesni_intel            55624  0
snd_seq                61560  2 snd_seq_midi_event,snd_seq_midi
aes_x86_64             17131  1 aesni_intel
lrw                    13286  1 aesni_intel
gf128mul               14951  1 lrw
glue_helper            13990  1 aesni_intel
snd_hda_intel          52355  5
ablk_helper            13597  1 aesni_intel
cryptd                 20359  3 ghash_clmulni_intel,aesni_intel,ablk_helper
snd_hda_codec         192906  3
snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_intel
snd_hwdep              13602  1 snd_hda_codec
i915                  783485  1
serio_raw              13462  0
snd_pcm               102099  3
snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
saa716x_tbs_dvb        76784  0
tbs6982fe              22408  1 saa716x_tbs_dvb
tbs6680fe              17791  1 saa716x_tbs_dvb
tbs6923fe              22408  1 saa716x_tbs_dvb
tbs6985se              17882  1 saa716x_tbs_dvb
tbs6928se              17884  1 saa716x_tbs_dvb
tbs6982se              22408  1 saa716x_tbs_dvb
tbs6991fe              17785  1 saa716x_tbs_dvb
tbs6618fe              17791  1 saa716x_tbs_dvb
saa716x_core           50899  1 saa716x_tbs_dvb
tbs6922fe              22478  1 saa716x_tbs_dvb
tbs6928fe              17785  1 saa716x_tbs_dvb
tbs6991se              17882  1 saa716x_tbs_dvb
tbs6290fe              50747  1 saa716x_tbs_dvb
stv090x                70414  1 saa716x_tbs_dvb
dvb_core              109932  2 saa716x_core,saa716x_tbs_dvb
rc_core                26933  11
ir_lirc_codec,ir_rc5_decoder,ir_nec_decoder,ir_sony_decoder,rc_tbs_nec,saa716x_tbs_dvb,ir_mce_kbd_decoder,ir_jvc_decoder,ir_rc6_decoder
snd_seq_device         14497  3 snd_seq,snd_rawmidi,snd_seq_midi
snd_page_alloc         18710  2 snd_pcm,snd_hda_intel
lpc_ich                21080  0
snd_timer              29482  2 snd_pcm,snd_seq
snd                    69238  21
snd_hda_codec_realtek,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec,snd_hda_intel,snd_seq_device,snd_seq_midi
nvidia              10675249  29
mei_me                 18627  0
mei                    82274  1 mei_me
soundcore              12680  1 snd
video                  19476  1 i915
drm_kms_helper         52758  1 i915
mac_hid                13205  0
drm                   302817  4 i915,drm_kms_helper,nvidia
i2c_algo_bit           13413  2 i915,saa716x_tbs_dvb
nct6775                55222  0
hwmon_vid              12783  1 nct6775
coretemp               13435  0
lp                     17759  0
parport                42348  1 lp
psmouse               102222  0
ahci                   25819  4
r8169                  67581  0
libahci                32168  1 ahci
mii                    13934  1 r8169

