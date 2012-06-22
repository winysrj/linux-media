Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36400 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2FVUbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 16:31:00 -0400
Received: by yenl2 with SMTP id l2so1892316yen.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 13:30:59 -0700 (PDT)
Message-ID: <4FE4D5FF.70003@gmail.com>
Date: Fri, 22 Jun 2012 17:30:55 -0300
From: Ariel Mammoli <cmammoli@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Tuner NOGANET NG-PTV FM
References: <4FE4BC43.9070100@gmail.com> <CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com> <4FE4C2BE.2060301@gmail.com> <CALF0-+V430u34yv8arUsN=N5Vh-cJs=7JJdiaEH_OonarJ065g@mail.gmail.com> <4FE4CA11.5030208@gmail.com> <CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com> <4FE4CF8F.4050306@gmail.com> <CALF0-+WGL1_5ZgexDjfA6HM7D1+M3OUbu30HcaW6D4r1uOtM5w@mail.gmail.com>
In-Reply-To: <CALF0-+WGL1_5ZgexDjfA6HM7D1+M3OUbu30HcaW6D4r1uOtM5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

El 22/06/12 17:10, Ezequiel Garcia escribió:
> On Fri, Jun 22, 2012 at 5:03 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>> Ezequiel;
>>
>> El vie 22 jun 2012 16:54:52 ART, Ezequiel Garcia ha escrito:
>>> Hi Ariel,
>>>
>>> On Fri, Jun 22, 2012 at 4:40 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>> Hello again Ezequiel,
>>>>
>>>> El vie 22 jun 2012 16:16:51 ART, Ezequiel Garcia ha escrito:
>>>>> Hi Ariel,
>>>>>
>>>>> Please don't drop linux-media from Cc.
>>>>>
>>>>> On Fri, Jun 22, 2012 at 4:08 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>>>> Hi Ezequiel,
>>>>>>
>>>>>> El vie 22 jun 2012 15:51:02 ART, Ezequiel Garcia ha escrito:
>>>>>>> Hi Ariel,
>>>>>>>
>>>>>>> On Fri, Jun 22, 2012 at 3:41 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>>>>>> I have a tuner NOGANET "NG-FM PTV" which has the Philips chip 7134.
>>>>>>>> I have reviewed the list of values several times but can not find it.
>>>>>>>> What are the correct values to configure the module saa7134?
>>>>>>>>
>>>>>>> That's a PCI card, right? PCI are identified by subvendor  and subdevice IDs.
>>>>>>>
>>>>>>> Can you tell us those IDs for your card?
>>>>>>>
>>>>>>> Regards,
>>>>>>> Ezequiel.
>>>>>> Indeed it is a PCI card. Below are the data:
>>>>>> 04:05.0 Multimedia controller [0480]: Philips Semiconductors SAA7130
>>>>>> Video Broadcast Decoder [1131:7130] (rev 01)
>>>>>>
>>>>> I believe it is currently not supported under Linux.
>>>>>
>>> I was just looking here:
>>>
>>> http://linuxtv.org/wiki/index.php/Compro_VideoMate_S350
>>>
>>> and I think I gave you wrong information, sorry.
>>>
>>> Could you better *full* output of
>>>
>>> $ lspci -vvnn
>>>
>>> with the board connected?
>>>
>>> Sorry again for misdirections,
>>> Ezequiel.
>> No problem :) , here is the result of lspci-vvnn:
>>
> dmesg? lsmod?
>
> PS: For some reason when your reply address is different from your address.
dmesg:

[   31.130403] saa7130/34: v4l2 driver version 0.2.16 loaded
[   31.130543] saa7134 0000:04:05.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   31.130548] saa7130[0]: found at 0000:04:05.0, rev: 1, irq: 16,
latency: 64, mmio: 0xfbfffc00
[   31.130553] saa7134: Board is currently unknown. You might try to use
the card=<nr>
[   31.130554] saa7134: insmod option to specify which board do you
have, but this is
[   31.130555] saa7134: somewhat risky, as might damage your card. It is
better to ask
[   31.130556] saa7134: for support at linux-media@vger.kernel.org.

[   31.131151] saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
[card=0,autodetected]
[   31.131168] saa7130[0]: board init: gpio is 4040
[   31.234360] saa7130[0]: Huh, no eeprom present (err=-5)?
[   31.234680] saa7130[0]: registered device video1 [v4l2]
[   31.234769] saa7130[0]: registered device vbi0
[   31.244755] saa7134 ALSA driver for DMA sound loaded
[   31.244759] saa7130[0]/alsa: UNKNOWN/GENERIC doesn't support digital
audio
[ 3949.521864] saa7134 ALSA driver for DMA sound unloaded
[ 4107.188828] saa7130/34: v4l2 driver version 0.2.16 loaded
[ 4107.188870] saa7130[0]: found at 0000:04:05.0, rev: 1, irq: 16,
latency: 64, mmio: 0xfbfffc00
[ 4107.188876] saa7130[0]: subsystem: 1131:0000, board: Compro VideoMate
TV PVR/FM [card=40,insmod option]
[ 4107.188895] saa7130[0]: board init: gpio is 4040
[ 4107.228528] input: saa7134 IR (Compro VideoMate TV as
/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/rc/rc0/input11
[ 4107.228630] rc0: saa7134 IR (Compro VideoMate TV as
/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/rc/rc0
[ 4107.332369] saa7130[0]: Huh, no eeprom present (err=-5)?
[ 4107.400049] saa7130[0]: registered device video1 [v4l2]
[ 4107.400120] saa7130[0]: registered device vbi0
[ 4107.400183] saa7130[0]: registered device radio0
[ 4107.402280] saa7134 ALSA driver for DMA sound loaded
[ 4107.402282] saa7130[0]/alsa: Compro VideoMate TV PVR/FM doesn't
support digital audio

lsmod:

Module                  Size  Used by
saa7134_alsa           18172  0
tea5767                13113  1
tuner                  26836  1
rc_videomate_tv_pvr    12481  0
saa7134               153846  1 saa7134_alsa
nls_utf8               12493  0
isofs                  39549  0
pci_stub               12550  1
vboxpci                22882  0
vboxnetadp             25616  0
vboxnetflt             27211  0
vboxdrv               252228  3 vboxpci,vboxnetadp,vboxnetflt
dm_crypt               22565  0
bnep                   17923  2
rfcomm                 38408  0
bluetooth             148839  10 bnep,rfcomm
binfmt_misc            17292  1
arc4                   12473  2
ppdev                  12849  0
snd_hda_codec_hdmi     31426  1
snd_hda_codec_realtek   254125  1
ir_lirc_codec          12770  0
lirc_dev               18700  1 ir_lirc_codec
intel_ips              17753  0
ir_sony_decoder        12493  0
psmouse                63474  0
serio_raw              12990  0
ir_jvc_decoder         12490  0
rtl8180                35880  0
mac80211              393459  1 rtl8180
ir_rc6_decoder         12490  0
eeprom_93cx6           12653  1 rtl8180
joydev                 17393  0
ir_rc5_decoder         12490  0
cfg80211              172392  2 rtl8180,mac80211
gspca_sonixj           32391  0
gspca_main             27610  1 gspca_sonixj
ir_nec_decoder         12490  0
rc_core                25797  9
rc_videomate_tv_pvr,saa7134,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
videobuf_dma_sg        18786  2 saa7134_alsa,saa7134
videobuf_core          25409  2 saa7134,videobuf_dma_sg
v4l2_common            15793  2 tuner,saa7134
videodev               85626  4 tuner,saa7134,gspca_main,v4l2_common
tveeprom               17009  1 saa7134
snd_hda_intel          28358  2
snd_hda_codec          91754  3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              13276  1 snd_hda_codec
snd_pcm                80435  4
saa7134_alsa,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
snd_seq_midi           13132  0
snd_rawmidi            25241  1 snd_seq_midi
snd_seq_midi_event     14475  1 snd_seq_midi
snd_seq                51567  2 snd_seq_midi,snd_seq_midi_event
parport_pc             32114  1
snd_timer              28932  2 snd_pcm,snd_seq
snd_seq_device         14172  3 snd_seq_midi,snd_rawmidi,snd_seq
snd                    55902  15
saa7134_alsa,snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
hwmon_vid              12658  0
max6650                13929  0
coretemp               13188  0
soundcore              12600  1 snd
snd_page_alloc         14108  2 snd_hda_intel,snd_pcm
lp                     17455  0
parport                40930  3 ppdev,parport_pc,lp
usb_storage            44173  0
uas                    17699  0
usbhid                 41905  0
hid                    77367  1 usbhid
i915                  509290  3
pata_via               13398  1
drm_kms_helper         32889  1 i915
drm                   196290  4 i915,drm_kms_helper
r8169                  47200  0
i2c_algo_bit           13199  1 i915
video                  18908  1 i915

Ariel

PS:Fixed problem with the email addresses


