Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32835 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab3HLNVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 09:21:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1V8s3r-00057U-40
	for linux-media@vger.kernel.org; Mon, 12 Aug 2013 15:21:27 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Aug 2013 15:21:27 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Aug 2013 15:21:27 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: omap3-isp pipeline using media-ctl and yavta
Date: Mon, 12 Aug 2013 13:21:06 +0000 (UTC)
Message-ID: <loom.20130812T150832-440@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, 
I'm trying to use a ov3640 camera sensor along with the isp of my overo
board. I implemented the media-ctl pipeline configuration in my application,
because I had trouble when trying to compile it on my board.
Can someone help me out what I am doing wrong?

the pipeline commands look like this:

char test[] = "\"ov3640 3-003c\":0->\"OMAP3 ISP CCDC\":0[1], \"OMAP3 ISP
CCDC\":1->\"OMAP3 ISP CCDC output\":0[1]";

char test2[] =  "\"ov3640 3-003c\":0 [SGRBG10 2048x1536 (32,20)/2048x1536],
\"OMAP3 ISP CCDC\":1 [SGRBG10 2048x1536]";

and my output log says:

Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
Setting up selection target 0 rectangle (32,20)/2048x1536 on pad ov3640 3-003c/0
Selection rectangle set: (32,20)/2040x1536
Setting up format SGRBG10 2048x1536 on pad ov3640 3-003c/0
Format set: YUYV2X8 2040x1536
Setting up format YUYV2X8 2040x1536 on pad OMAP3 ISP CCDC/0
Format set: SGRBG10 2040x1536
Setting up format SGRBG10 2048x1536 on pad OMAP3 ISP CCDC/1
Format set: SGRBG10 2032x1536

it seems that it goes through without an error. 
so when I want to test the pipeline with yavta:
./yavta -f SGRBG10 -s 2048x1536 --capture=1 --file=image  /dev/video2

I get this error log:

root@overo2:~/yavta-HEAD-d9b7cfc# ./yavta -f SGRBG10 -s 2048x1536
--capture=1 --file=image  /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
Video format: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
8 buffers requested.
length: 6291456 offset: 0 timestamp type: unknown
Buffer 0 mapped at address 0xb6863000.
length: 6291456 offset: 6291456 timestamp type: unknown
Buffer 1 mapped at address 0xb6263000.
length: 6291456 offset: 12582912 timestamp type: unknown
Buffer 2 mapped at address 0xb5c63000.
length: 6291456 offset: 18874368 timestamp type: unknown
Buffer 3 mapped at address 0xb5663000.
length: 6291456 offset: 25165824 timestamp type: unknown
Buffer 4 mapped at address 0xb5063000.
length: 6291456 offset: 31457280 timestamp type: unknown
Buffer 5 mapped at address 0xb4a63000.
length: 6291456 offset: 37748736 timestamp type: unknown
Buffer 6 mapped at address 0xb4463000.
length: 6291456 offset: 44040192 timestamp type: unknown
Buffer 7 mapped at address 0xb3e63000.
 overo2 [  282.482574] Internal error: Oops: 17 [#1] PREEMPT ARM
 overo2 [  282.557525] Process yavta (pid: 1293, stack limit = 0xcefe62f0)
 overo2 [  282.563690] Stack: (0xcefe7a00 to 0xcefe8000)
 overo2 [  282.568237] 7a00: ceec6440 cefe7a68 cefe7a10 bf01d320 00000001
00000000 000007f8 00000600
 overo2 [  282.576782] 7a20: 00002008 00000000 00000000 00000000 00000000
00000000 00000000 00000000
 overo2 [  282.585296] 7a40: 00000000 00000000 6c0a0109 ffff0006 000000d0
cefe7a58 6c0a0100 00000030
 overo2 [  282.593841] 7a60: c02b01d4 c0724e48 00000001 00000000 000007f8
00000600 0000300a 00000001
 overo2 [  282.602386] 7a80: 00000008 00000000 00000000 00000000 00000000
00000000 00000000 00000000
 overo2 [  282.610900] 7aa0: c0724e48 ce3d02ac 00000001 cefe7ad4 ce0a5610
ce3d9148 ce3d9148 ce3d02ac
 overo2 [  282.619445] 7ac0: 00000009 ce3d8fd8 ce3d9148 bf0013f8 c0033b4c
00000000 00000400 ce3d9148
 overo2 [  282.627990] 7ae0: 00000001 ce3d8fd8 00000009 ce0a5610 00000001
00000021 00000021 00000004
 overo2 [  282.636535] 7b00: 00000000 00000000 00000000 c0034568 00000000
00000000 00000000 00000000
 overo2 [  282.645050] 7b20: c0725248 00000021 00000000 00000000 cefe7e68
cefe7b40 c048eb6c c005db38
 overo2 [  282.653594] 7b40: 22222222 22222222 22222222 22222222 ce048e00
00000001 00000001 ce1d1e40
 overo2 [  282.662109] 7b60: 00000001 ce3d9148 ce1d1e40 ce3d93f4 ce048e00
ce3d9148 cefe7e68 bf03d948
 overo2 [  282.670654] 7b80: ce3d942c 7fffffff 00000003 8bd3b000 00000000
00000000 00000000 00000000
 overo2 [  282.679199] 7ba0: 00000000 00000000 0000001b 8bd1c000 00000000
c038efac cecdb600 c038efd4
 overo2 [  282.687744] 7bc0: 03007000 cefe7bd0 c038e8bc c005db38 c008ef14
cefe7bf0 00000002 cec96008
 overo2 [  282.696289] 7be0: cecdb600 c038e9bc c003a83c c005db38 03007000
8bd1c000 00000002 00000000
 overo2 [  282.704803] 7c00: 00000001 00000000 00000000 00000000 00050000
00001000 00001000 8bd1c000
 overo2 [  282.713348] 7c20: 03007000 00001000 cd7b7800 c038dd74 00050000
c00e21bc ce352a00 00001000
 overo2 [  282.721893] 7c40: d09dcff0 cbd4a2e0 00001000 c048e7a0 00001000
00000000 cbd4a2e0 c038fb14
 overo2 [  282.730407] 7c60: 00050000 ffffffff cefe7ca4 c000e400 cc0af500
cc0b0000 00000040 ce352a00
 overo2 [  282.738952] 7c80: cd7b7800 cecdb630 00000000 00050000 00001000
00000000 ce352a00 ce03f840
 overo2 [  282.747467] 7ca0: d09d7000 ce3d9148 00000000 cecdb600 00000002
c0390020 00000000 00600000
 overo2 [  282.756011] 7cc0: 00050000 c06c8928 000005ff 00000000 cd7b7800
00600000 00000000 ce352a00
 overo2 [  282.764556] 7ce0: 00000600 ce03f840 d09d7000 ce3d9148 ce048e00
ce3d0000 00000002 bf03e128
 overo2 [  282.773071] 7d00: 00000000 ce03f840 ce03f840 ce03f840 ce03f840
c048e7a0 ce03f840 00000000
 overo2 [  282.781616] 7d20: 00000601 bf03c9b0 00000000 bf04c1f8 00000000
ce3d9148 cefe7e68 ce048e38
 overo2 [  282.790161] 7d40: bf04dfd1 cefe7d54 00000001 00000001 ce048e00
00000000 ce1d1e40 bf04c1f8
 overo2 [  282.798675] 7d60: ffffffe7 ce3d9148 cefe7e68 bf0143ac c742cb63
00000000 00000000 00000000
 overo2 [  282.807220] 7d80: 00000000 00000002 ce03c10c ce03c0f8 00000000
00000002 fffff720 00000402
 overo2 [  282.815734] 7da0: 00000000 40045612 ce1d1e40 ce048e00 00000000
000001e8 cefe7dec ce03c080
 overo2 [  282.824279] 7dc0: 60000113 c00e0b00 ce03c080 00000020 ce03c080
ce0dc740 00000020 c0424340
 overo2 [  282.832824] 7de0: 00000020 ce0dc740 ce03c080 ce0dc740 ce03c080
cbdc41e4 00000016 32c213ac
 overo2 [  282.841369] 7e00: 00000002 c042bd08 ce03c080 c0416064 00000000
00000000 ce0dc740 c0710b20
 overo2 [  282.849884] 7e20: 00000000 ce03c080 cbdc41d0 cefe7e38 c042c474
00000000 40045612 00000000
 overo2 [  282.858428] 7e40: ce1d1e40 00000000 00000000 cefe7e68 00000000
bf012774 00000004 bf012908
 overo2 [  282.866973] 7e60: bee2850c 00000001 00000001 00000001 00000000
00000000 00000000 00000000
 overo2 [  282.875488] 7e80: 00000000 00000000 00000000 00000000 00000000
00000000 00000001 00000000
 overo2 [  282.884033] 7ea0: 00600000 00000000 00000000 c06c51d8 00000008
cee91800 c06c51d8 c03ea784
 overo2 [  282.892547] 7ec0: cee91c80 00000046 00000001 ce0dc740 00000010
c06c51f8 00000010 cefe7ee8
 overo2 [  282.901092] 7ee0: c030a484 c005db38 00000010 ce1d1e40 ce3d9148
00000000 40045612 bee2850c
 overo2 [  282.909637] 7f00: cefe6000 00000000 00000000 bf010708 cd5a0c68
ce1d1e40 00000003 00000003
 overo2 [  282.918151] 7f20: bee2850c c00f9c18 cefe6000 00000003 0000000c
00000101 0000000a c0765b80
 overo2 [  282.926696] 7f40: cefe6000 c003a448 cec06170 c025d4b4 fb058018
00000000 00000001 01400000
 overo2 [  282.935241] 7f60: 60000193 c008f234 00000000 bee2850c 40045612
00000003 ce1d1e40 cefe6000
 overo2 [  282.943756] 7f80: 00000000 c00f9ccc cefe7fb0 00000000 00000008
00000001 bee28aec 00000036
 overo2 [  282.952301] 7fa0: c000e984 c000e800 00000008 00000001 00000003
40045612 bee2850c 40045612
 overo2 [  282.960815] 7fc0: 00000008 00000001 bee28aec 00000036 00000000
00000001 bee28aec 00000000
 overo2 [  282.969360] 7fe0: 00001000 bee28508 00008f4c b6f3d45c 20000010
00000003 00000000 00000000
 overo2 [  283.079528] Code: ebffeba8 e1a05000 e1a00004 ebffeba5 (e595200c)

Best Regards, Tom

