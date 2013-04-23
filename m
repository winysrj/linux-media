Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:59386 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3DWU4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 16:56:46 -0400
Received: by mail-ia0-f171.google.com with SMTP id r13so842798iar.16
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 13:56:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Apr 2013 22:56:45 +0200
Message-ID: <CAEV8V2CoSGOCW90usDQ=KSNoom9Y-6Yn8Jn2nOHhSvHkazer0A@mail.gmail.com>
Subject: em28xx: Kernel panic after installing latest linuxtv.org modules
From: Marcel Kulicke <marcel.kulicke@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linux Media,

I was quite keen to try out the new modules for em28xx on my raspberry.
Unfortunately, when the module is about to be used by a frontend (TVHEADEND
in this case) a reproducable kernel panic occurs. Here is the console
output.

pi@raspbmc:~$ tvheadend
Apr 23 00:16:06.977 [ INFO] charset: 71 entries loaded
kernel:Internal error: Oops: 17 [#1] PREEMPT ARM
kernel:Process tvheadend (pid: 1409, stack limit = 0xd79ea268)
kernel:Stack: (0xd79ebc48 to 0xd79ec000)
kernel:bc40: d7951260 d563f000 00000000 c046be40 d8da1140 d79ebc68
kernel:bc60: d8d84288 00000048 00000000 00000048 d7992684 d79ebcc7 d79ffa00
d5207360
kernel:bc80: bf099be0 00000000 d79ebcbc d79ebc98 bf04eca4 bf04eb00 00000001
bf0ec0e0
kernel:bca0: 00000000 d7991000 fffffff7 d7992684 d79ebcd4 d79ebcc0 bf04ee78
bf04ec80
kernel:bcc0: d78700b0 00000001 d79ebcfc d79ebcd8 bf04ef28 bf04ee60 d7992684
d7991000
kernel:bce0: d7a49418 d56546e0 d79ffa00 d5207360 d79ebd0c d79ebd00 bf04efa8
bf04ee8c
kernel:bd00: d79ebd1c d79ebd10 bf09d4b0 bf04ef5c d79ebd64 d79ebd20 bf091038
bf09d490
kernel:bd20: c009a098 c01c7b0c 0d400000 d5703798 d79ebd4c d79ebd40 c009a04c
d5207360
kernel:bd40: bf09685c d5703798 d56546e0 00000000 bf099be0 00000000 d79ebd84
d79ebd68
kernel:bd60: bf08916c bf090fa4 d79ea000 d5703798 d5207360 bf099be0 d79ebdbc
d79ebd88
kernel:bd80: c009a8bc bf0890dc d79ebdbc 00000000 d79ebdbc d5207360 d5703798
d5207368
kernel:bda0: c009a7fc d79ebe90 00000024 00000000 d79ebde4 d79ebdc0 c0094cd8
c009a808
kernel:bdc0: d79ebea4 d79ebf60 00000000 00020000 d79ebe90 00000000 d79ebdfc
d79ebde8
kernel:bde0: c0094d94 c0094b20 d79ebea4 d79ebee0 d79ebe74 d79ebe00 c00a4ad4
c0094d78
kernel:be00: c00a1c58 c00a1b98 d79ebe74 d79ebe18 c00a1f38 c00a1c48 00000028
d7b6a820
kernel:be20: 00000000 d79ebee8 00000000 00000000 d753ecc8 d5207360 00000000
00000000
kernel:be40: d5703798 d57038e8 00000004 d79ebee0 d5207360 d79ebf60 d79ebe90
00000000
kernel:be60: 00000041 d79ea000 d79ebed4 d79ebe78 c00a5174 c00a4514 d79ebea4
c0080018
kernel:be80: d547edb0 00000028 00000678 d79ea000 d78101d0 d753b1a0 d79ebeb4
d79ebea8
kernel:bea0: 00000000 00000000 d79ebefc d79ebf60 00000001 ffffff9c d5546000
ffffff9c
kernel:bec0: d79ea000 00000000 d79ebf54 d79ebed8 c00a57fc c00a50d0 00000041
b6c98350
kernel:bee0: d78101d0 d753b1a0 7924c38a 00000009 d5546012 c04365b8 00000000
d74082b0
kernel:bf00: d5703798 00000101 00000004 00000000 00000000 00000004 d79ebf54
d79ebf28
kernel:bf20: c00b2508 c00b1f2c 00020000 d5546000 00020000 00000000 d5546000
00020000
kernel:bf40: 00000004 00000001 d79ebf94 d79ebf58 c0095af0 c00a57d4 d79ebf84
d79ebf68
kernel:bf60: 00020000 c0370000 00000024 00000100 be8eee30 00000000 00000000
00000005
kernel:bf80: c000e444 00000000 d79ebfa4 d79ebf98 c0095bb4 c0095a0c 00000000
d79ebfa8
kernel:bfa0: c000e2c0 c0095b98 be8eee30 00000000 be8eee30 00020000 00000000
00000000
kernel:bfc0: be8eee30 00000000 00000000 00000005 00000000 be8ef130 be8eee30
00000000
kernel:bfe0: b6702220 be8ee9d8 b6c97044 b6c983d8 80000010 be8eee30 00000000
00000000
kernel:Code: e3560000 e1a04000 e50b2030 e1a08003 (e5919000)

In addition, I tried to use an older version in the GIT (from April 9th).
It compiles fine, but the successful load of the em28xx module does not
trigger the creation of a /dev/dvb/adapter node.

Could anyone point me to a solution or how to find one? Thanks in advance,

Marcel
