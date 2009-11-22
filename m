Return-path: <linux-media-owner@vger.kernel.org>
Received: from anny.lostinspace.de ([80.190.182.2]:60946 "EHLO
	anny.lostinspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZKVSJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 13:09:00 -0500
Received: from server.idefix.lan (ppp-93-104-109-205.dynamic.mnet-online.de [93.104.109.205])
	(authenticated bits=0)
	by anny.lostinspace.de (8.14.3/8.14.3) with ESMTP id nAMI7Zod016142
	for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 19:07:39 +0100 (CET)
	(envelope-from idefix@fechner.net)
Received: from localhost (unknown [127.0.0.1])
	by server.idefix.lan (Postfix) with ESMTP id 2D7AD95C5B
	for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 19:08:59 +0100 (CET)
Received: from server.idefix.lan ([127.0.0.1])
	by localhost (server.idefix.lan [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 33yCiVLbqwOv for <linux-media@vger.kernel.org>;
	Sun, 22 Nov 2009 19:08:55 +0100 (CET)
Received: from idefix-mobil.idefix.lan (idefix-mobil.idefix.lan [192.168.1.15])
	by server.idefix.lan (Postfix) with ESMTPA id CF83895BFA
	for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 19:08:54 +0100 (CET)
Message-ID: <4B097E37.10402@fechner.net>
Date: Sun, 22 Nov 2009 19:08:55 +0100
From: Matthias Fechner <idefix@fechner.net>
Reply-To: linux-media@vger.kernel.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: IR Receiver on an Tevii S470
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>	 <1258836102.1794.7.camel@localhost>  <200911220303.36715.liplianin@me.by> <1258858102.3072.14.camel@palomino.walls.org>
In-Reply-To: <1258858102.3072.14.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Andy Walls wrote:
> Thank you.  I will probably need you for testing when ready.
>
>
> I was planning to do step 1 above for HVR-1800 IR anyway.
>
> I will estimate that I may have something ready by about Christmas (25
> December 2009), unless work becomes very busy.
>   

thanks a lot for your answer.
I uploaded two pictures I did from the card, you can find it here:
http://fechner.net/tevii-s470/

It is a CX23885.
The driver I use is the ds3000.
lspci says:
02:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
    Subsystem: Device d470:9022
    Flags: bus master, fast devsel, latency 0, IRQ 19
    Memory at fac00000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express Endpoint, MSI 00
    Capabilities: [80] Power Management version 2
    Capabilities: [90] Vital Product Data <?>
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
    Capabilities: [100] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq+ ACSVoil-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        AERCap:    First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [200] Virtual Channel <?>
    Kernel driver in use: cx23885
    Kernel modules: cx23885

lsmod says:
Module                  Size  Used by
lirc_serial            10740  1
snd_mixer_oss          12428  0
lirc_dev                9512  3 lirc_serial
snd_hda_codec_nvhdmi     3976  1
ds3000                 12820  1
snd_hda_codec_realtek   184292  1
cx23885               105116  9
cx2341x                10784  1 cx23885
v4l2_common            15428  2 cx23885,cx2341x
nvidia               8860344  44
videodev               34080  2 cx23885,v4l2_common
v4l1_compat            11252  1 videodev
videobuf_dma_sg        11176  1 cx23885
videobuf_dvb            6308  1 cx23885
dvb_core               78492  2 cx23885,videobuf_dvb
videobuf_core          16280  3 cx23885,videobuf_dma_sg,videobuf_dvb
snd_hda_intel          22004  1
ir_common              46132  1 cx23885
snd_hda_codec          55908  3 
snd_hda_codec_nvhdmi,snd_hda_codec_realtek,snd_hda_intel
btcx_risc               4244  1 cx23885
tveeprom               10652  1 cx23885
snd_pcm                63812  3 snd_hda_intel,snd_hda_codec
snd_timer              17584  1 snd_pcm
ehci_hcd               29628  0
ohci_hcd               19664  0
snd                    49728  7 
snd_mixer_oss,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
usbcore               117380  2 ehci_hcd,ohci_hcd
i2c_nforce2             6092  0
serio_raw               4708  0
soundcore               6276  1 snd
i2c_core               19848  7 
ds3000,cx23885,v4l2_common,nvidia,videodev,tveeprom,i2c_nforce2
snd_page_alloc          7952  2 snd_hda_intel,snd_pcm
evdev                   8148  4


I can test any patch when you have one ready, currently I'm using lirc 
together with a TechnoTrend RemoteControl.
Thanks a lot and have a nice week

Best regards,
Matthias

-- 
"Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the universe trying to produce bigger and better idiots. So far, the universe is winning." -- Rich Cook

