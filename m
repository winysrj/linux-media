Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:52194 "EHLO draco.skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751547AbZHAPdd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Aug 2009 11:33:33 -0400
Received: from manio ([10.1.0.2])
	by draco.skyboo.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <manio@skyboo.net>)
	id 1MXFrD-0007Ao-Hs
	for linux-media@vger.kernel.org; Sat, 01 Aug 2009 16:46:47 +0200
Message-ID: <4A7471D2.3070004@skyboo.net>
Date: Sat, 01 Aug 2009 18:48:18 +0200
From: manio <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: SAA7146 / TT1.3 stream corruption
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I am using Technotrend Rev1.3 for many years. But last time
suddenly i find out strange problem. Seems that in some
circumstances the card can't decode stream from satellite properly.
I don't know for sure but it could be a driver problem, firmware
or even (worse) a hardware problem.
I know that for now the problems occurs for example on HotBird (13.2E)
Transponder 11158 V, SR 27500, PID 0x010B - but also for others from
this ECM provider.
The stream is ECM stream - most of the time the stream is OK,
and the ECM's have FF's at the end, but from time to time the ECM's
seems be wrong - are longer and have a garbage instead of FF's.
The garbage is same for whole "ECM period".

two ECM examples:
saved from TT1.3:
00037ff0h: 47 41 0B DD 00 81 30 8F 07 8D B4 8D 2E FE 3F C1
00038000h: 9B 14 74 AD 17 FC AA B4 3F F4 86 5D 74 E2 B9 AD
00038010h: 56 52 93 4D E3 59 79 44 E3 87 1B CF 6B 41 3E 76
00038020h: 18 8C 07 62 B0 93 AA D4 24 0B 5B E0 00 F1 53 45
00038030h: 85 CA E1 C4 99 D0 81 5B 59 65 22 A1 4C 2B 2C 6C
00038040h: FB A4 97 60 DF B2 0B 6B 46 A9 D8 EF 6E AB DA E3
00038050h: 91 8E 6D 08 37 73 DE E0 AE 15 80 19 24 EF 3C A3
00038060h: 3B 30 D1 56 D5 90 D0 5A DF 76 29 2A 16 E6 0A 77
00038070h: 5A 46 E8 28 46 A2 12 24 43 F6 DE CE 08 3C EE 3E
00038080h: 4E C9 43 5E 4E 75 94 B8 A7 22 61 A8 88 C9 9E 94
00038090h: CD 60 AC 6C 69 35 28 F2 03 91 B1 A2 5B 26 EA 58
000380a0h: 53 11 F1 EE AF 8A 66 9D F7 47 D7 DA

saved from different DVB-S card:
00037ff0h: 47 41 0B 1D 00 81 30 8F 07 8D B4 8D 2E FE 3F C1
00038000h: 9B 14 74 AD 17 FC AA B4 3F F4 86 5D 74 E2 B9 AD
00038010h: 56 52 93 4D E3 59 79 44 E3 87 1B CF 6B 41 3E 76
00038020h: 18 8C 07 62 B0 93 AA D4 24 0B 5B 91 14 8F F4 83
00038030h: 40 6B 0D 91 EC 74 FB 06 4C 8C 4A 90 36 BA 67 11
00038040h: 7B D8 22 2B 77 C2 8B 61 C7 ED 4A 25 21 6B DB 1D
00038050h: 5F 40 AF 12 1C F5 53 2D 2B 84 00 E1 AC 63 9A 76
00038060h: 57 A2 E6 46 25 BC D6 C6 89 D1 40 07 AA 27 30 58
00038070h: A0 81 91 E2 B3 8A BD D8 F8 A3 6B C5 98 77 E4 81
00038080h: A7 52 E5 56 D9 A6 58 FF FF FF FF FF FF FF FF FF
00038090h: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
000380a0h: FF FF FF FF FF FF FF FF FF FF FF FF

saved from TT1.3:
00055c8ch: 47 41 0B D6 00 81 30 8F 07 8D BA 7D 24 B2 E6 3A
00055c9ch: 86 4E FA E3 75 80 B6 E6 03 E6 C7 55 62 10 7C 92
00055cach: 4A DE 56 AD 86 45 6F 70 43 8B 00 D0 56 85 67 6F
00055cbch: AC 05 97 F8 1D AB 6F F5 C8 FE 20 8B E2 2C B0 59
00055ccch: 0F C5 80 38 38 BF 9B DA 66 25 E3 BB A0 E3 39 7E
00055cdch: CB 45 7F 62 AD E0 D0 60 88 90 90 AA EE 1D 6E FE
00055cech: 17 9F 81 E2 52 2A 4E 74 3B 8F C0 3E 5B 0E 57 4C
00055cfch: 8F EC CE EA C2 EA 10 F3 4A 57 F2 C2 48 C5 34 0D
00055d0ch: CB 2E 2C CB 62 84 1F 9D 90 3B 7C C4 37 F1 1D 1D
00055d1ch: 82 90 FB DA 15 0C C0 C7 8F 33 1E 5A 1A EE 44 43
00055d2ch: B3 B3 AF D5 97 D6 45 2E 39 2D E6 02 45 07 13 20
00055d3ch: BE 5A EF 7D 21 E6 4E 31 7E 8F F8 AD

saved from different DVB-S card:
00055c8ch: 47 41 0B 16 00 81 30 8F 07 8D BA 7D 24 B2 E6 3A
00055c9ch: 86 4E FA E3 75 80 B6 E6 03 E6 C7 55 62 10 7C 92
00055cach: 4A DE 56 AD 86 45 6F 70 43 8B 00 D0 56 85 67 6F
00055cbch: AC B7 66 86 D8 FF 41 28 8E 02 FC 0E E7 B2 E5 5C
00055ccch: 9E 81 8F 06 BE AD C0 FC 49 9F 3A 23 88 98 F7 EF
00055cdch: C9 F5 37 4C 57 31 B9 C2 1B BE BC 65 BE 60 CC E6
00055cech: F3 E5 A3 AD 76 03 20 11 25 09 88 A6 42 32 5D 2B
00055cfch: 06 65 B8 B6 B8 4D 3E 0B 77 97 EE D1 FD A6 DE CC
00055d0ch: 6C B6 BB F4 B1 78 39 8E 6D 9F 14 3D 39 64 86 42
00055d1ch: 58 61 0D 78 DD C7 64 FF FF FF FF FF FF FF FF FF
00055d2ch: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
00055d3ch: FF FF FF FF FF FF FF FF FF FF FF FF

As you can see the begining of the ECM are same, but
the problem with garbage occurs later (not always after the
same byte in stream).
The above results comes from saving the PID in the same
time on my TT1.3 and friend's other DVB-S card.
I also find out that "affected" are only ECMs which
starts with: [81|80] 30 8F 07 8D and the following low-nible
of byte is A or B.

I was trying to collect as many information as i can - and here
they are:

1. the problem is not related with any specific dvb application
   i was fetching the "pure" stream using i.e. such command:
   dvbstream -f 11158 -p v -s 27500 -o 267 > my_file.raw

2. the problem also occurs on different physical TT1.3 cards
   - i was testing it on several computers and several TT1.3 cards
   with different Satellite instalations - and it occur always
   on TT1.3 cards.

3. the problem is also on Windows - i heard that firmware
   (dvb-ttpci-01.fw) is very similar/based on windows firmware
   so maybe the bug was "copied"

4. a screen from binary diff and same sample of ECM data from
   TT1.3 and other card are on my homepage:
   http://manio.skyboo.net/dvb/

5. of course i am using latest dvb-ttpci driver from current
   stable kernel

so that's all what i could collect about it...
Please help!

regards,
-- 
manio
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
