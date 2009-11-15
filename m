Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.meta.ua ([194.0.131.19]:36013 "EHLO webmail.meta.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZKOMds (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 07:33:48 -0500
Message-ID: <36834.95.133.222.95.1258288433.metamail@webmail.meta.ua>
In-Reply-To: <1258159955.3234.9.camel@pc07.localdom.local>
References: <1258073462.8348.35.camel@pc07.localdom.local>
    <36685.95.133.109.178.1258107794.metamail@webmail.meta.ua>
    <1258143870.3242.31.camel@pc07.localdom.local>
    <1258159955.3234.9.camel@pc07.localdom.local>
Date: Sun, 15 Nov 2009 14:33:53 +0200 (EEST)
Subject: Re: Tuner drivers
From: rulet1@meta.ua
To: "hermann pitton" <hermann-pitton@arcor.de>
Cc: rulet1@meta.ua, "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=windows-1251
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing to SECAM in tvtime doesn't bring sound.
Here is output of modinfo saa7134:

r@NGF:~$ modinfo saa7134
filename:      
/lib/modules/2.6.31-14-generic-pae/kernel/drivers/media/video/saa7134/saa7134.ko
license:        GPL
author:         Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
description:    v4l2 driver module for saa7130/34 based TV cards
srcversion:     27FF2831DA439BC7A9BB745
alias:          pci:v00001131d00007135sv*sd*bc*sc*i*
alias:          pci:v00001131d00007134sv*sd*bc*sc*i*
alias:          pci:v00001131d00007133sv*sd*bc*sc*i*
alias:          pci:v00001131d00007130sv*sd*bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00000000bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00000000bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F31Dbc*sc*i*
alias:          pci:v00001131d00007134sv000017DEsd00007128bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004878bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F736bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F636bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006290bc*sc*i*
alias:          pci:v00001131d00007133sv00005169sd00001502bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000380bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C900bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A836bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F936bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F436bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00008625bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000010bc*sc*i*
alias:          pci:v00001131d00007133sv00001822sd00000022bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00003502bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006191bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006193bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006190bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006093bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006092bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006091bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00006090bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006073bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006072bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006071bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00006070bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00005201bc*sc*i*
alias:          pci:v00001131d00007133sv00005ACEsd00005090bc*sc*i*
alias:          pci:v00001131d00007134sv00005ACEsd00005070bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd0000507Bbc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00005071bc*sc*i*
alias:          pci:v00001131d00007130sv00005ACEsd00005050bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd0000505Bbc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00004090bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004071bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004070bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004051bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004050bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004037bc*sc*i*
alias:          pci:v00001131d00007134sv00000000sd00004036bc*sc*i*
alias:          pci:v00001131d00007130sv00000000sd00004016bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F01Dbc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002304bc*sc*i*
alias:          pci:v00001131d00007134sv00000919sd00002003bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004857bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004871bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000306bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F31Ebc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001175bc*sc*i*
alias:          pci:v00001131d00007130sv00001A7Fsd00002008bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd0000230Fbc*sc*i*
alias:          pci:v00001131d00007130sv00003016sd00002344bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002341bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002342bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001172bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd0000670Abc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006709bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006708bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006707bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006706bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006705bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006704bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006703bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006702bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006701bc*sc*i*
alias:          pci:v00001131d00007133sv00000070sd00006700bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004876bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000A11Bbc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00009715bc*sc*i*
alias:          pci:v00001131d00007133sv000011BDsd0000002Fbc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004860bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00002C00bc*sc*i*
alias:          pci:v00001131d00007130sv00000919sd00002003bc*sc*i*
alias:          pci:v00001131d00007133sv00001489sd00000502bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00002C05bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd0000000Dbc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000008bc*sc*i*
alias:          pci:v00001131d00007133sv000016BEsd00000007bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003307bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003502bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00003306bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000304bc*sc*i*
alias:          pci:v00001131d00007134sv00001489sd00000301bc*sc*i*
alias:          pci:v00001131d00007134sv00004E42sd00000300bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000300bc*sc*i*
alias:          pci:v00001131d00007134sv000016BEsd00000005bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00006360bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00007360bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007352bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007350bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007250bc*sc*i*
alias:          pci:v00001131d00007133sv000017DEsd00007201bc*sc*i*
alias:          pci:v00001131d00007133sv00000331sd00001421bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000301bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00002C05bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000319bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001160bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00008624bc*sc*i*
alias:          pci:v00001131d00007133sv00001462sd00006231bc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00002018bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004862bc*sc*i*
alias:          pci:v00001131d00007133sv000011BDsd0000002Ebc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00004EE9bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd00001044bc*sc*i*
alias:          pci:v00001131d00007133sv00001435sd00007330bc*sc*i*
alias:          pci:v00001131d00007133sv00001435sd00007350bc*sc*i*
alias:          pci:v00001131d00007130sv0000185Bsd0000C901bc*sc*i*
alias:          pci:v00001131d00007134sv0000185Bsd0000C900bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00002004bc*sc*i*
alias:          pci:v00001131d00007133sv00005456sd00007135bc*sc*i*
alias:          pci:v00001131d00007133sv00000000sd00004091bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00000210bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00000210bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000502bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00001370bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000370bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000351bc*sc*i*
alias:          pci:v00001131d00007133sv00001421sd00000350bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002004bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F11Dbc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000F31Fbc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000306bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000502bc*sc*i*
alias:          pci:v00001131d00007134sv00001540sd00009524bc*sc*i*
alias:          pci:v00001131d00007134sv0000185Bsd0000C200bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000A70Abc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd00009715bc*sc*i*
alias:          pci:v00001131d00007130sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007130sv0000153Bsd00001152bc*sc*i*
alias:          pci:v00001131d00007133sv000012ABsd00000800bc*sc*i*
alias:          pci:v00001131d00007134sv00001019sd00004CB6bc*sc*i*
alias:          pci:v00001131d00007133sv00001019sd00004CB5bc*sc*i*
alias:          pci:v00001131d00007134sv00001019sd00004CB4bc*sc*i*
alias:          pci:v00001131d00007134sv000011BDsd0000002Dbc*sc*i*
alias:          pci:v00001131d00007134sv000011BDsd0000002Bbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd0000050Cbc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000B7E9bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000D6EEbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd000010FFbc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd00002108bc*sc*i*
alias:          pci:v00001131d00007130sv00001461sd00002115bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A7A2bc*sc*i*
alias:          pci:v00001131d00007133sv00001461sd0000A7A1bc*sc*i*
alias:          pci:v00001131d00007134sv00001461sd0000A70Bbc*sc*i*
alias:          pci:v00001131d00007130sv0000102Bsd000048D0bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007133sv0000185Bsd0000C100bc*sc*i*
alias:          pci:v00001131d00007130sv00001131sd00002001bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00007133bc*sc*i*
alias:          pci:v00001131d00007134sv00001894sd0000A006bc*sc*i*
alias:          pci:v00001131d00007134sv00001894sd0000FE01bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd0000FE01bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004840bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004843bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004830bc*sc*i*
alias:          pci:v00001131d00007133sv00001043sd00004845bc*sc*i*
alias:          pci:v00001131d00007134sv00001043sd00004842bc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Cbc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Abc*sc*i*
alias:          pci:v00001131d00007130sv00001048sd0000226Bbc*sc*i*
alias:          pci:v00001131d00007134sv000016BEsd00005000bc*sc*i*
alias:          pci:v00001131d00007134sv000016BEsd00000003bc*sc*i*
alias:          pci:v00001131d00007133sv00001489sd00000214bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00005214bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000214bc*sc*i*
alias:          pci:v00001131d00007133sv00004E42sd00000212bc*sc*i*
alias:          pci:v00001131d00007133sv000014C0sd00001212bc*sc*i*
alias:          pci:v00001131d00007133sv00005168sd00000212bc*sc*i*
alias:          pci:v00001131d00007130sv00004E42sd00000138bc*sc*i*
alias:          pci:v00001131d00007130sv00005168sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00004E42sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00005168sd00000138bc*sc*i*
alias:          pci:v00001131d00007134sv00005169sd00000138bc*sc*i*
alias:          pci:v00001131d00007133sv0000153Bsd00001162bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001158bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001143bc*sc*i*
alias:          pci:v00001131d00007134sv0000153Bsd00001142bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00004E85bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00006752bc*sc*i*
alias:          pci:v00001131d00007133sv00001131sd00002001bc*sc*i*
alias:          pci:v00001131d00007134sv00001131sd00002001bc*sc*i*
depends:       
videobuf-core,videobuf-dma-sg,ir-common,v4l2-common,videodev,tveeprom
vermagic:       2.6.31-14-generic-pae SMP mod_unload modversions 586
parm:           disable_ir:disable infrared remote support (int)
parm:           ir_debug:enable debug messages [IR] (int)
parm:           pinnacle_remote:Specify Pinnacle PCTV remote: 0=coloured,
1=grey (defaults to 0) (int)
parm:           ir_rc5_remote_gap:int
parm:           ir_rc5_key_timeout:int
parm:           repeat_delay:delay before key repeat started (int)
parm:           repeat_period:repeat period between keypresses when key is
down (int)
parm:           disable_other_ir:disable full codes of alternative remotes
from other manufacturers (int)
parm:           video_debug:enable debug messages [video] (int)
parm:           gbuffers:number of capture buffers, range 2-32 (int)
parm:           noninterlaced:capture non interlaced video (int)
parm:           secam:force SECAM variant, either DK,L or Lc (string)
parm:           vbi_debug:enable debug messages [vbi] (int)
parm:           vbibufs:number of vbi buffers, range 2-32 (int)
parm:           audio_debug:enable debug messages [tv audio] (int)
parm:           audio_ddep:audio ddep overwrite (int)
parm:           audio_clock_override:int
parm:           audio_clock_tweak:Audio clock tick fine tuning for cards
with audio crystal that's slightly off (range [-1024 .. 1024]) (int)
parm:           ts_debug:enable debug messages [ts] (int)
parm:           tsbufs:number of ts buffers for read/write IO, range 2-32
(int)
parm:           ts_nr_packets:size of a ts buffers (in ts packets) (int)
parm:           i2c_debug:enable debug messages [i2c] (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           irq_debug:enable debug messages [IRQ handler] (int)
parm:           core_debug:enable debug messages [core] (int)
parm:           gpio_tracking:enable debug messages [gpio] (int)
parm:           alsa:enable/disable ALSA DMA sound [dmasound] (int)
parm:           latency:pci latency timer (int)
parm:           no_overlay:allow override overlay default (0 disables, 1
enables) [some VIA/SIS chipsets are known to have problem with overlay]
(int)
parm:           video_nr:video device number (array of int)
parm:           vbi_nr:vbi device number (array of int)
parm:           radio_nr:radio device number (array of int)
parm:           tuner:tuner type (array of int)
parm:           card:card type (array of int)

______________________________
Моя почта живет на Мете http://webmail.meta.ua

