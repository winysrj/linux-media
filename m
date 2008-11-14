Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAELZBtx028751
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 16:35:11 -0500
Received: from mail.sra.uni-hannover.de (mail.sra.uni-hannover.de
	[130.75.33.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAELYtLf020574
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 16:34:56 -0500
Received: from a89-182-23-53.net-htp.de ([89.182.23.53] helo=[192.168.1.2])
	by mail.sra.uni-hannover.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <wittke@sra.uni-hannover.de>)
	id 1L16Jb-0005gY-7I
	for video4linux-list@redhat.com; Fri, 14 Nov 2008 22:34:55 +0100
Message-ID: <491DEEFA.6070105@sra.uni-hannover.de>
Date: Fri, 14 Nov 2008 22:34:50 +0100
From: Michael Wittke <wittke@sra.uni-hannover.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Multimedia video controller [0400]: Conexant Systems,
	Inc. CX23880/1/2/3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear readers,

I try to get my tv tuner card running, as there is no support until now 
by v4l.

$ lspci -nnv -d 14f1:*

04:07.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)              
        Subsystem: Yuan Yuan Enterprise Co., Ltd. Device [12ab:4700]                                                                           
        Flags: medium devsel, IRQ 20                                                                                                           
        Memory at fb000000 (32-bit, non-prefetchable) [size=16M]                                                                               
        Capabilities: <access denied>                                                                                                          
        Kernel modules: cx8800                                                                                                                 

04:07.1 Multimedia controller [0480]: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801] (rev 05)
        Subsystem: Yuan Yuan Enterprise Co., Ltd. Device [12ab:4700]
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

04:07.2 Multimedia controller [0480]: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
        Subsystem: Yuan Yuan Enterprise Co., Ltd. Device [12ab:4700]
        Flags: bus master, medium devsel, latency 64, IRQ 3
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>
        Kernel modules: cx8802


I modified cxx88-cards.c and cxx88.h by adding the subvendor's id etc.:

[CX88_BOARD_CONEXSYS] = {
       .name           = "Conexant Systems",
           .tuner_type     = TUNER_XC2028,
           .radio_type     = TUNER_XC2028,
           .tuner_addr     = 0x61,
           .radio_addr     = 0x61,
       .input          = {{
           .type   = CX88_VMUX_TELEVISION,
           .vmux   = 0,
       },{
           .type   = CX88_VMUX_COMPOSITE1,
           .vmux   = 2,
       },{
           .type   = CX88_VMUX_SVIDEO,
           .vmux   = 2,
       }},
       .mpeg           = CX88_MPEG_BLACKBIRD  //with this I get a video1 
device as well but no firmeware is loaded
       //.mpeg           = CX88_MPEG_DVB,       
        // I tried without the .mpeg setting as well
   },

The dmesg command says the following stuff:

$dmesg
13.035673] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   13.036184] cx8800 0000:04:07.0: PCI INT A -> GSI 20 (level, low) -> IRQ
20
[   13.036645] cx88[0]: subsystem: 12ab:4700, board: Conexant Systems
[card=79,autodetected], frontend(s): 1
[   13.036648] cx88[0]: TV tuner type 71, Radio tuner type 71
[   13.039615] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   13.071038] cx2388x alsa driver version 0.0.6 loaded
[   13.168939] tuner' 1-0061: chip found @ 0xc2 (cx88[0])
[   13.241954] xc2028 1-0061: creating new instance
[   13.241958] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   13.241966] xc2028 1-0061: destroying instance
[   13.242065] xc2028 1-0061: creating new instance
[   13.242067] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   13.242070] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
[   13.242083] cx88[0]/0: found at 0000:04:07.0, rev: 5, irq: 20, latency:
64, mmio: 0xfb000000
[   13.242229] cx88[0]/0: registered device video0 [v4l2]
[   13.242265] cx88[0]/0: registered device vbi0
[   13.242328] firmware: requesting xc3028-v27.fw
[   13.627695] xc2028 1-0061: Loading 80 firmware images from 
xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[   13.627812] cx88[0]: Calling XC2028/3028 callback
[   13.627814] cx88[0]: setting GPIO to TV!
[   14.371843] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
[   14.371847] cx88[0]: Calling XC2028/3028 callback
[   14.371849] cx88[0]: setting GPIO to TV!
[   16.195445] xc2028 1-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[   16.244013] cx88[0]: Calling XC2028/3028 callback
[   16.364206] cx88[0]/2: cx2388x 8802 Driver Manager
[   16.364221] cx88-mpeg driver manager 0000:04:07.2: PCI INT A -> GSI 20
(level, low) -> IRQ 20
[   16.364232] cx88[0]/2: found at 0000:04:07.2, rev: 5, irq: 20, latency:
64, mmio: 0xf9000000
[   16.364240] cx8802_probe() allocating 1 frontend(s)
[   16.364399] cx88_audio 0000:04:07.1: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[   16.364422] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   16.402355] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   16.402359] cx88/2: registering cx8802 driver, type: dvb access: shared
[   16.402362] cx88[0]/2: subsystem: 12ab:4700, board: Conexant Systems
[card=79]
[   16.402365] cx88[0]/2: cx2388x based DVB/ATSC card
[   16.402368] cx88[0]/2: The frontend of your DVB/ATSC card isn't 
supported
yet
[   16.402371] cx88[0]/2: frontend initialization failed
[   16.402374] cx88[0]/2: dvb_register failed (err = -22)
[   16.402376] cx88[0]/2: cx8802 probe failed, err = -22

Channels are detected as well:
scantv -a -c /dev/video0 -C /dev/vbi0
e.g. ivtv-tune -c 7 for analog cable tv in germany

But if I try a cat /dev/video0 there are only coloured pixels being 
captured.
I think it is a fine-tuning problem.

Can anybody tell me, if I used the right tuner parameters?
I would appreciate any help, because my knowlegde is definitly 
restricted in this area.

Best regards
Michael

-- 
Dipl.-Ing. Michael Wittke, M. Sc.
Institut für Systems Engineering - System- und Rechnerarchitektur (SRA)
Leibniz Universität Hannover
Appelstr. 4
D-30167 Hannover
www.sra.uni-hannover.de
wittke@sra.uni-hannover.de
Tel +49 (0)511 762 19738
Fax +49 (0)511 762 19733 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
