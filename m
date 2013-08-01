Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m01.mx.aol.com ([64.12.143.75]:37661 "EHLO
	omr-m01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3HARVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 13:21:08 -0400
Message-ID: <51FA97F0.9010206@netscape.net>
Date: Thu, 01 Aug 2013 14:16:32 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org> <51F40976.8090106@netscape.net> <20130801090436.6dfa0f68@infradead.org>
In-Reply-To: <20130801090436.6dfa0f68@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 01/08/13 09:04, Mauro Carvalho Chehab escribió:
>>
>> I found the patch that affects the X8507 board is: commit
>> a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb
>>
>> --------
>> alfredo@linux-puon:/usr/src/git/linux> git stash
>> Saved working directory and index state WIP on (no branch): c6f56e7
>> [media] dvb: don't use DVBv3 bandwidth macros
>> HEAD is now at c6f56e7 [media] dvb: don't use DVBv3 bandwidth macros
>> alfredo@linux-puon:/usr/src/git/linux> git bisect good
>> a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb is the first bad commit
>> commit a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb
>> Author: Mauro Carvalho Chehab <mchehab  redhat.com>
>> Date:   Mon Dec 26 20:48:54 2011 -0300
>>
>>       [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
>>
>>       The cx23885-dvb driver has a dirty hack:
>>           1) it hooks the DVBv3 legacy call to FE_SET_FRONTEND;
>>           2) it uses internally the DVBv3 struct to decide some
>>              configs.
>>
>>       Replace it by a change during the gate control. This will
>>       likely work, but requires testing. Anyway, the current way
>>       will break, as soon as we stop copying data for DVBv3 for
>>       pure DVBv5 calls.
>>
>>       Compile-tested only.
>>
>>       Cc: Michael Krufky <mkrufky  linuxtv.org>
>>       Signed-off-by: Mauro Carvalho Chehab <mchehab  redhat.com>
>>
>> :040000 040000 6d0695eb9e59b837425ed64d4e2be6625864b609
>> 89700b867069ec0ad2713367e607763e91798e98 M      drivers
>> --------
>>
>>
>> I manually removed the patch, then the TV card works.
>>
>>
>> Unfortunately my lack of knowledge prevents me fix it.
>>
>> I test new code with pleasure :) !
> Hi Alfredo,
>
>
> Please send me the patches you've made to make isdb-t work on
> it, and I'll try to address this issue.
>
> Regards,
> Mauro
>
>
Mauro thank you very much for your interest.

I send the patch. 3.2 is on a kernel.

-----------------------------------------------------------------------

  .../{ => }/media/dvb/frontends/mb86a20s.c          |  332 
++++++--------------
  .../{ => }/media/video/cx23885/cx23885-cards.c     |   38 +++
  .../{ => }/media/video/cx23885/cx23885-dvb.c       |   26 ++
  .../{ => }/media/video/cx23885/cx23885-video.c     |    1 +
  .../cx23885/{ => }/media/video/cx23885/cx23885.h   |    1 +
  5 files changed, 163 insertions(+), 235 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a20s.c 
b/drivers/media/dvb/frontends/mb86a20s.c
index 0f867a5..26e06b4 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -47,271 +47,133 @@ struct mb86a20s_state {
      bool need_init;
  };

  struct regdata {
      u8 reg;
      u8 data;
  };

  /*
   * Initialization sequence: Use whatevere default values that PV SBTVD
   * does on its initialisation, obtained via USB snoop
   */
  static struct regdata mb86a20s_init[] = {
      { 0x70, 0x0f },
      { 0x70, 0xff },
-    { 0x08, 0x01 },
-    { 0x09, 0x3e },
-    { 0x50, 0xd1 },
-    { 0x51, 0x22 },
-    { 0x39, 0x01 },
-    { 0x71, 0x00 },
-    { 0x28, 0x2a },
-    { 0x29, 0x00 },
-    { 0x2a, 0xff },
-    { 0x2b, 0x80 },
-    { 0x28, 0x20 },
-    { 0x29, 0x33 },
-    { 0x2a, 0xdf },
-    { 0x2b, 0xa9 },
+    { 0x09, 0x3a },
+    { 0x50, 0xd1 }, { 0x51, 0x22 },
+    { 0x39, 0x00 },
+    { 0x28, 0x2a }, { 0x29, 0x00 }, { 0x2a, 0xfd }, { 0x2b, 0xc8 },
      { 0x3b, 0x21 },
-    { 0x3c, 0x3a },
+    { 0x3c, 0x38 },
+    { 0x28, 0x20 }, { 0x29, 0x3e }, { 0x2a, 0xde }, { 0x2b, 0x4d },
+    { 0x28, 0x22 }, { 0x29, 0x00 }, { 0x2a, 0x1f }, { 0x2b, 0xf0 },
      { 0x01, 0x0d },
-    { 0x04, 0x08 },
-    { 0x05, 0x05 },
-    { 0x04, 0x0e },
-    { 0x05, 0x00 },
-    { 0x04, 0x0f },
-    { 0x05, 0x14 },
-    { 0x04, 0x0b },
-    { 0x05, 0x8c },
-    { 0x04, 0x00 },
-    { 0x05, 0x00 },
-    { 0x04, 0x01 },
-    { 0x05, 0x07 },
-    { 0x04, 0x02 },
-    { 0x05, 0x0f },
-    { 0x04, 0x03 },
-    { 0x05, 0xa0 },
-    { 0x04, 0x09 },
-    { 0x05, 0x00 },
-    { 0x04, 0x0a },
-    { 0x05, 0xff },
-    { 0x04, 0x27 },
-    { 0x05, 0x64 },
-    { 0x04, 0x28 },
-    { 0x05, 0x00 },
-    { 0x04, 0x1e },
-    { 0x05, 0xff },
-    { 0x04, 0x29 },
-    { 0x05, 0x0a },
-    { 0x04, 0x32 },
-    { 0x05, 0x0a },
-    { 0x04, 0x14 },
-    { 0x05, 0x02 },
-    { 0x04, 0x04 },
-    { 0x05, 0x00 },
-    { 0x04, 0x05 },
-    { 0x05, 0x22 },
-    { 0x04, 0x06 },
-    { 0x05, 0x0e },
-    { 0x04, 0x07 },
-    { 0x05, 0xd8 },
-    { 0x04, 0x12 },
-    { 0x05, 0x00 },
-    { 0x04, 0x13 },
-    { 0x05, 0xff },
+    { 0x04, 0x08 }, { 0x05, 0x03 },
+    { 0x04, 0x0e }, { 0x05, 0x00 },
+    { 0x04, 0x0f }, { 0x05, 0x32 },
+    { 0x04, 0x0b }, { 0x05, 0x78 },
+    { 0x04, 0x00 }, { 0x05, 0x00 },
+    { 0x04, 0x01 }, { 0x05, 0x1e },
+    { 0x04, 0x02 }, { 0x05, 0x07 },
+    { 0x04, 0x03 }, { 0x05, 0xd0 },
+    { 0x04, 0x09 }, { 0x05, 0x00 },
+    { 0x04, 0x0a }, { 0x05, 0xff },
+    { 0x04, 0x27 }, { 0x05, 0x00 },
+    { 0x04, 0x28 }, { 0x05, 0x00 },
+    { 0x04, 0x1e }, { 0x05, 0x00 },
+    { 0x04, 0x29 }, { 0x05, 0x64 },
+    { 0x04, 0x32 }, { 0x05, 0x64 },
+    { 0x04, 0x14 }, { 0x05, 0x02 },
+    { 0x04, 0x04 }, { 0x05, 0x00 },
+    { 0x04, 0x05 }, { 0x05, 0x22 },
+    { 0x04, 0x06 }, { 0x05, 0x0e },
+    { 0x04, 0x07 }, { 0x05, 0xd8 },
+    { 0x04, 0x12 }, { 0x05, 0x00 },
+    { 0x04, 0x13 }, { 0x05, 0xff },
      { 0x52, 0x01 },
-    { 0x50, 0xa7 },
-    { 0x51, 0x00 },
-    { 0x50, 0xa8 },
-    { 0x51, 0xff },
-    { 0x50, 0xa9 },
-    { 0x51, 0xff },
-    { 0x50, 0xaa },
-    { 0x51, 0x00 },
-    { 0x50, 0xab },
-    { 0x51, 0xff },
-    { 0x50, 0xac },
-    { 0x51, 0xff },
-    { 0x50, 0xad },
-    { 0x51, 0x00 },
-    { 0x50, 0xae },
-    { 0x51, 0xff },
-    { 0x50, 0xaf },
-    { 0x51, 0xff },
+    { 0x50, 0xa7 }, { 0x51, 0x00 },
+    { 0x50, 0xa8 }, { 0x51, 0xff },
+    { 0x50, 0xa9 }, { 0x51, 0xff },
+    { 0x50, 0xaa }, { 0x51, 0x00 },
+    { 0x50, 0xab }, { 0x51, 0xff },
+    { 0x50, 0xac }, { 0x51, 0xff },
+    { 0x50, 0xad }, { 0x51, 0x00 },
+    { 0x50, 0xae }, { 0x51, 0xff },
+    { 0x50, 0xaf }, { 0x51, 0xff },
      { 0x5e, 0x07 },
-    { 0x50, 0xdc },
-    { 0x51, 0x01 },
-    { 0x50, 0xdd },
-    { 0x51, 0xf4 },
-    { 0x50, 0xde },
-    { 0x51, 0x01 },
-    { 0x50, 0xdf },
-    { 0x51, 0xf4 },
-    { 0x50, 0xe0 },
-    { 0x51, 0x01 },
-    { 0x50, 0xe1 },
-    { 0x51, 0xf4 },
-    { 0x50, 0xb0 },
-    { 0x51, 0x07 },
-    { 0x50, 0xb2 },
-    { 0x51, 0xff },
-    { 0x50, 0xb3 },
-    { 0x51, 0xff },
-    { 0x50, 0xb4 },
-    { 0x51, 0xff },
-    { 0x50, 0xb5 },
-    { 0x51, 0xff },
-    { 0x50, 0xb6 },
-    { 0x51, 0xff },
-    { 0x50, 0xb7 },
-    { 0x51, 0xff },
-    { 0x50, 0x50 },
-    { 0x51, 0x02 },
-    { 0x50, 0x51 },
-    { 0x51, 0x04 },
+    { 0x50, 0xdc }, { 0x51, 0x3f },
+    { 0x50, 0xdd }, { 0x51, 0xff },
+    { 0x50, 0xde }, { 0x51, 0x3f },
+    { 0x50, 0xdf }, { 0x51, 0xff },
+    { 0x50, 0xe0 }, { 0x51, 0x3f },
+    { 0x50, 0xe1 }, { 0x51, 0xff },
+    { 0x50, 0xb0 }, { 0x51, 0x07 },
+    { 0x50, 0xb2 }, { 0x51, 0x3f },
+    { 0x50, 0xb3 }, { 0x51, 0xff },
+    { 0x50, 0xb4 }, { 0x51, 0x3f },
+    { 0x50, 0xb5 }, { 0x51, 0xff },
+    { 0x50, 0xb6 }, { 0x51, 0x3f },
+    { 0x50, 0xb7 }, { 0x51, 0xff },
+    { 0x50, 0x51 }, { 0x51, 0x04 },
+    { 0x50, 0x50 }, { 0x51, 0x02 },
      { 0x45, 0x04 },
      { 0x48, 0x04 },
-    { 0x50, 0xd5 },
-    { 0x51, 0x01 },        /* Serial */
-    { 0x50, 0xd6 },
-    { 0x51, 0x1f },
-    { 0x50, 0xd2 },
-    { 0x51, 0x03 },
-    { 0x50, 0xd7 },
-    { 0x51, 0x3f },
+    { 0x50, 0xd5 }, { 0x51, 0x00 },
+    { 0x50, 0xd6 }, { 0x51, 0x1f },
+    { 0x50, 0xd2 }, { 0x51, 0x03 },
+    { 0x50, 0xd7 }, { 0x51, 0x3f },
+    { 0x28, 0x74 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0xff },
+    { 0x28, 0x46 }, { 0x29, 0x00 }, { 0x2a, 0x1a }, { 0x2b, 0x0c },
+    { 0x04, 0x40 },
+    { 0x05, 0x00 },
+    { 0x28, 0x00 }, { 0x2b, 0x08 },
+    { 0x28, 0x05 }, { 0x2b, 0x00 },
      { 0x1c, 0x01 },
-    { 0x28, 0x06 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x03 },
-    { 0x28, 0x07 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x0d },
-    { 0x28, 0x08 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x02 },
-    { 0x28, 0x09 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x01 },
-    { 0x28, 0x0a },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x21 },
-    { 0x28, 0x0b },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x29 },
-    { 0x28, 0x0c },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x16 },
-    { 0x28, 0x0d },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x31 },
-    { 0x28, 0x0e },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x0e },
-    { 0x28, 0x0f },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x4e },
-    { 0x28, 0x10 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x46 },
-    { 0x28, 0x11 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x0f },
-    { 0x28, 0x12 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x56 },
-    { 0x28, 0x13 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x35 },
-    { 0x28, 0x14 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x01 },
-    { 0x2b, 0xbe },
-    { 0x28, 0x15 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x01 },
-    { 0x2b, 0x84 },
-    { 0x28, 0x16 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x03 },
-    { 0x2b, 0xee },
-    { 0x28, 0x17 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x98 },
-    { 0x28, 0x18 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x00 },
-    { 0x2b, 0x9f },
-    { 0x28, 0x19 },
-    { 0x29, 0x00 },
-    { 0x2a, 0x07 },
-    { 0x2b, 0xb2 },
-    { 0x28, 0x1a },
-    { 0x29, 0x00 },
-    { 0x2a, 0x06 },
-    { 0x2b, 0xc2 },
-    { 0x28, 0x1b },
-    { 0x29, 0x00 },
-    { 0x2a, 0x07 },
-    { 0x2b, 0x4a },
-    { 0x28, 0x1c },
-    { 0x29, 0x00 },
-    { 0x2a, 0x01 },
-    { 0x2b, 0xbc },
-    { 0x28, 0x1d },
-    { 0x29, 0x00 },
-    { 0x2a, 0x04 },
-    { 0x2b, 0xba },
-    { 0x28, 0x1e },
-    { 0x29, 0x00 },
-    { 0x2a, 0x06 },
-    { 0x2b, 0x14 },
-    { 0x50, 0x1e },
-    { 0x51, 0x5d },
-    { 0x50, 0x22 },
-    { 0x51, 0x00 },
-    { 0x50, 0x23 },
-    { 0x51, 0xc8 },
-    { 0x50, 0x24 },
-    { 0x51, 0x00 },
-    { 0x50, 0x25 },
-    { 0x51, 0xf0 },
-    { 0x50, 0x26 },
-    { 0x51, 0x00 },
-    { 0x50, 0x27 },
-    { 0x51, 0xc3 },
-    { 0x50, 0x39 },
-    { 0x51, 0x02 },
-    { 0x50, 0xd5 },
-    { 0x51, 0x01 },
-    { 0xd0, 0x00 },
+    { 0x28, 0x06 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x1f },
+    { 0x28, 0x07 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x18 },
+    { 0x28, 0x08 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x18 },
+    { 0x28, 0x09 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x30 },
+    { 0x28, 0x0a }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x37 },
+    { 0x28, 0x0b }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x02 },
+    { 0x28, 0x0c }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x09 },
+    { 0x28, 0x0d }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x06 },
+    { 0x28, 0x0e }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x7b },
+    { 0x28, 0x0f }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x76 },
+    { 0x28, 0x10 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x7d },
+    { 0x28, 0x11 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x08 },
+    { 0x28, 0x12 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x0b },
+    { 0x28, 0x13 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x00 },
+    { 0x28, 0x14 }, { 0x29, 0x00 }, { 0x2a, 0x01 }, { 0x2b, 0xf2 },
+    { 0x28, 0x15 }, { 0x29, 0x00 }, { 0x2a, 0x01 }, { 0x2b, 0xf3 },
+    { 0x28, 0x16 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x05 },
+    { 0x28, 0x17 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x16 },
+    { 0x28, 0x18 }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x0f },
+    { 0x28, 0x19 }, { 0x29, 0x00 }, { 0x2a, 0x07 }, { 0x2b, 0xef },
+    { 0x28, 0x1a }, { 0x29, 0x00 }, { 0x2a, 0x07 }, { 0x2b, 0xd8 },
+    { 0x28, 0x1b }, { 0x29, 0x00 }, { 0x2a, 0x07 }, { 0x2b, 0xf1 },
+    { 0x28, 0x1c }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x3d },
+    { 0x28, 0x1d }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0x94 },
+    { 0x28, 0x1e }, { 0x29, 0x00 }, { 0x2a, 0x00 }, { 0x2b, 0xba },
+    { 0x50, 0x1e }, { 0x51, 0x5d },
+    { 0x50, 0x22 }, { 0x51, 0x00 },
+    { 0x50, 0x23 }, { 0x51, 0xc8 },
+    { 0x50, 0x24 }, { 0x51, 0x00 },
+    { 0x50, 0x25 }, { 0x51, 0xf0 },
+    { 0x50, 0x26 }, { 0x51, 0x00 },
+    { 0x50, 0x27 }, { 0x51, 0xc3 },
+    { 0x50, 0x39 }, { 0x51, 0x02 },
  };

  static struct regdata mb86a20s_reset_reception[] = {
      { 0x70, 0xf0 },
      { 0x70, 0xff },
      { 0x08, 0x01 },
      { 0x08, 0x00 },
  };

  static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
                   u8 i2c_addr, int reg, int data)
  {
      u8 buf[] = { reg, data };
      struct i2c_msg msg = {
          .addr = i2c_addr, .flags = 0, .buf = buf, .len = 2
@@ -418,31 +280,31 @@ static int mb86a20s_read_signal_strength(struct 
dvb_frontend *fe, u16 *strength)
      u8     val;

      dprintk("\n");

      if (fe->ops.i2c_gate_ctrl)
          fe->ops.i2c_gate_ctrl(fe, 0);

      /* Does a binary search to get RF strength */
      rf_max = 0xfff;
      rf_min = 0;
      do {
          rf = (rf_max + rf_min) / 2;
          mb86a20s_writereg(state, 0x04, 0x1f);
          mb86a20s_writereg(state, 0x05, rf >> 8);
          mb86a20s_writereg(state, 0x04, 0x20);
-        mb86a20s_writereg(state, 0x04, rf);
+        mb86a20s_writereg(state, 0x05, rf);

          val = mb86a20s_readreg(state, 0x02);
          if (val & 0x08)
              rf_min = (rf_max + rf_min) / 2;
          else
              rf_max = (rf_max + rf_min) / 2;
          if (rf_max - rf_min < 4) {
              *strength = (((rf_max + rf_min) / 2) * 65535) / 4095;
              break;
          }
      } while (1);

      dprintk("signal strength = %d\n", *strength);

      if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/video/cx23885/cx23885-cards.c 
b/drivers/media/video/cx23885/cx23885-cards.c
index c3cf089..41bafff 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -426,30 +426,61 @@ struct cx23885_board cx23885_boards[] = {
              .vmux   = CX25840_COMPOSITE2,
              .amux   = CX25840_AUDIO6,
              .gpio0  = 0,
          }, {
              .type   = CX23885_VMUX_COMPOSITE3,
              .vmux   = CX25840_COMPOSITE3,
              .amux   = CX25840_AUDIO7,
              .gpio0  = 0,
          }, {
              .type   = CX23885_VMUX_COMPOSITE4,
              .vmux   = CX25840_COMPOSITE4,
              .amux   = CX25840_AUDIO7,
              .gpio0  = 0,
          } },
      },
+    [CX23885_BOARD_MYGICA_X8507] = {
+        .name = "Mygica X8507",
+        .tuner_type = TUNER_XC5000,
+        .tuner_addr = 0x61,
+        .tuner_bus = 1,
+        .porta = CX23885_ANALOG_VIDEO,
+        .portb= CX23885_MPEG_DVB,
+        .input = {
+            {
+            .type   = CX23885_VMUX_TELEVISION,
+            .vmux   = CX25840_COMPOSITE2,
+            .amux   = CX25840_AUDIO8,
+            },
+            {
+            .type   = CX23885_VMUX_COMPOSITE1,
+            .vmux   = CX25840_COMPOSITE8,
+            },
+            {
+            .type   = CX23885_VMUX_SVIDEO,
+            .vmux   = CX25840_SVIDEO_LUMA3 |
+            CX25840_SVIDEO_CHROMA4,
+            },
+            {
+            .type   = CX23885_VMUX_COMPONENT,
+            .vmux   = CX25840_COMPONENT_ON |
+                  CX25840_VIN1_CH1 |
+                  CX25840_VIN6_CH2 |
+                  CX25840_VIN7_CH3,
+            },
+            }
+        },
  };
  const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);

  /* ------------------------------------------------------------------ */
  /* PCI subsystem IDs                                                  */

  struct cx23885_subid cx23885_subids[] = {
      {
          .subvendor = 0x0070,
          .subdevice = 0x3400,
          .card      = CX23885_BOARD_UNKNOWN,
      }, {
          .subvendor = 0x0070,
          .subdevice = 0x7600,
          .card      = CX23885_BOARD_HAUPPAUGE_HVR1800lp,
@@ -625,30 +656,34 @@ struct cx23885_subid cx23885_subids[] = {
          .subvendor = 0x14f1,
          .subdevice = 0x8578,
          .card      = CX23885_BOARD_MYGICA_X8558PRO,
      }, {
          .subvendor = 0x107d,
          .subdevice = 0x6f22,
          .card      = CX23885_BOARD_LEADTEK_WINFAST_PXTV1200,
      }, {
          .subvendor = 0x5654,
          .subdevice = 0x2390,
          .card      = CX23885_BOARD_GOTVIEW_X5_3D_HYBRID,
      }, {
          .subvendor = 0x1b55,
          .subdevice = 0xe2e4,
          .card      = CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF,
+    }, {
+        .subvendor = 0x14f1,
+        .subdevice = 0x8502,
+        .card      = CX23885_BOARD_MYGICA_X8507,
      },
  };
  const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);

  void cx23885_card_list(struct cx23885_dev *dev)
  {
      int i;

      if (0 == dev->pci->subsystem_vendor &&
          0 == dev->pci->subsystem_device) {
          printk(KERN_INFO
              "%s: Board has no valid PCIe Subsystem ID and can't\n"
                 "%s: be autodetected. Pass card=<n> insmod option\n"
                 "%s: to workaround that. Redirect complaints to the\n"
                 "%s: vendor of the TV card.  Best regards,\n"
@@ -1056,30 +1091,31 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
      case CX23885_BOARD_HAUPPAUGE_HVR1255:
      case CX23885_BOARD_HAUPPAUGE_HVR1210:
          /* GPIO-5 RF Control: 0 = RF1 Terrestrial, 1 = RF2 Cable */
          /* GPIO-6 I2C Gate which can isolate the demod from the bus */
          /* GPIO-9 Demod reset */

          /* Put the parts into reset and back */
          cx23885_gpio_enable(dev, GPIO_9 | GPIO_6 | GPIO_5, 1);
          cx23885_gpio_set(dev, GPIO_9 | GPIO_6 | GPIO_5);
          cx23885_gpio_clear(dev, GPIO_9);
          mdelay(20);
          cx23885_gpio_set(dev, GPIO_9);
          break;
      case CX23885_BOARD_MYGICA_X8506:
      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+    case CX23885_BOARD_MYGICA_X8507:
          /* GPIO-0 (0)Analog / (1)Digital TV */
          /* GPIO-1 reset XC5000 */
          /* GPIO-2 reset LGS8GL5 / LGS8G75 */
          cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
          cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
          mdelay(100);
          cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
          mdelay(100);
          break;
      case CX23885_BOARD_MYGICA_X8558PRO:
          /* GPIO-0 reset first ATBM8830 */
          /* GPIO-1 reset second ATBM8830 */
          cx23885_gpio_enable(dev, GPIO_0 | GPIO_1, 1);
          cx23885_gpio_clear(dev, GPIO_0 | GPIO_1);
          mdelay(100);
@@ -1393,30 +1429,31 @@ void cx23885_card_setup(struct cx23885_dev *dev)
          ts1->gen_ctrl_val  = 0x5; /* Parallel */
          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          break;
      case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
      case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
          ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
          ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          break;
      case CX23885_BOARD_MYGICA_X8506:
      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+    case CX23885_BOARD_MYGICA_X8507:
          ts1->gen_ctrl_val  = 0x5; /* Parallel */
          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          break;
      case CX23885_BOARD_MYGICA_X8558PRO:
          ts1->gen_ctrl_val  = 0x5; /* Parallel */
          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
          ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
          ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
          break;
      case CX23885_BOARD_HAUPPAUGE_HVR1250:
      case CX23885_BOARD_HAUPPAUGE_HVR1500:
      case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
@@ -1456,30 +1493,31 @@ void cx23885_card_setup(struct cx23885_dev *dev)
      case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
      case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
      case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
      case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
      case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF:
      case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
      case CX23885_BOARD_HAUPPAUGE_HVR1270:
      case CX23885_BOARD_HAUPPAUGE_HVR1850:
      case CX23885_BOARD_MYGICA_X8506:
      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
      case CX23885_BOARD_HAUPPAUGE_HVR1290:
      case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
      case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
      case CX23885_BOARD_HAUPPAUGE_HVR1500:
      case CX23885_BOARD_MPX885:
+    case CX23885_BOARD_MYGICA_X8507:
          dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
                  &dev->i2c_bus[2].i2c_adap,
                  "cx25840", 0x88 >> 1, NULL);
          if (dev->sd_cx25840) {
              dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
              v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
          }
          break;
      }

      /* AUX-PLL 27MHz CLK */
      switch (dev->board) {
      case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
          netup_initialize(dev);
          break;
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c 
b/drivers/media/video/cx23885/cx23885-dvb.c
index bcb45be..46628e2 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -49,30 +49,31 @@
  #include "stv0900.h"
  #include "stv0900_reg.h"
  #include "stv6110.h"
  #include "lnbh24.h"
  #include "cx24116.h"
  #include "cimax2.h"
  #include "lgs8gxx.h"
  #include "netup-eeprom.h"
  #include "netup-init.h"
  #include "lgdt3305.h"
  #include "atbm8830.h"
  #include "ds3000.h"
  #include "cx23885-f300.h"
  #include "altera-ci.h"
  #include "stv0367.h"
+#include "mb86a20s.h"

  static unsigned int debug;

  #define dprintk(level, fmt, arg...)\
      do { if (debug >= level)\
          printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
      } while (0)

  /* ------------------------------------------------------------------ */

  static unsigned int alt_tuner;
  module_param(alt_tuner, int, 0644);
  MODULE_PARM_DESC(alt_tuner, "Enable alternate tuner configuration");

  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
@@ -448,30 +449,41 @@ static struct stv6110_config 
netup_stv6110_tunerconfig_b = {
      .gain = 8, /* +16 dB  - maximum gain */
  };

  static struct cx24116_config tbs_cx24116_config = {
      .demod_address = 0x55,
  };

  static struct ds3000_config tevii_ds3000_config = {
      .demod_address = 0x68,
  };

  static struct cx24116_config dvbworld_cx24116_config = {
      .demod_address = 0x05,
  };

+static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
+    .demod_address = 0x10,
+    /*.is_serial = 0,*/
+};
+
+static struct xc5000_config mygica_x8507_xc5000_config = {
+    .i2c_address = 0x61,
+    .if_khz = 4000,
+    /*.radio_input = XC5000_RADIO_FM1,*/
+};
+
  static struct lgs8gxx_config mygica_x8506_lgs8gl5_config = {
      .prod = LGS8GXX_PROD_LGS8GL5,
      .demod_address = 0x19,
      .serial_ts = 0,
      .ts_clk_pol = 1,
      .ts_clk_gated = 1,
      .if_clk_freq = 30400, /* 30.4 MHz */
      .if_freq = 5380, /* 5.38 MHz */
      .if_neg_center = 1,
      .ext_adc = 0,
      .adc_signed = 0,
      .if_neg_edge = 0,
  };

  static struct xc5000_config mygica_x8506_xc5000_config = {
@@ -488,30 +500,31 @@ static int cx23885_dvb_set_frontend(struct 
dvb_frontend *fe,
      switch (dev->board) {
      case CX23885_BOARD_HAUPPAUGE_HVR1275:
          switch (param->u.vsb.modulation) {
          case VSB_8:
              cx23885_gpio_clear(dev, GPIO_5);
              break;
          case QAM_64:
          case QAM_256:
          default:
              cx23885_gpio_set(dev, GPIO_5);
              break;
          }
          break;
      case CX23885_BOARD_MYGICA_X8506:
      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+    case CX23885_BOARD_MYGICA_X8507:
          /* Select Digital TV */
          cx23885_gpio_set(dev, GPIO_0);
          break;
      }
      return 0;
  }

  static int cx23885_dvb_fe_ioctl_override(struct dvb_frontend *fe,
                       unsigned int cmd, void *parg,
                       unsigned int stage)
  {
      int err = 0;

      switch (stage) {
      case DVB_FE_IOCTL_PRE:
@@ -1004,30 +1017,43 @@ static int dvb_register(struct cx23885_tsport *port)
                          &netup_stv6110_tunerconfig_b,
                          &i2c_bus->i2c_adap)) {
                      if (!dvb_attach(lnbh24_attach,
                              fe0->dvb.frontend,
                              &i2c_bus->i2c_adap,
                              LNBH24_PCL | LNBH24_TTX,
                              LNBH24_TEN, 0x0a))
                          printk(KERN_ERR
                              "No LNBH24 found!\n");

                  }
              }
              break;
          }
          break;
+    case CX23885_BOARD_MYGICA_X8507:
+        i2c_bus = &dev->i2c_bus[0];
+        i2c_bus2 = &dev->i2c_bus[1];
+        fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
+            &mygica_x8507_mb86a20s_config,
+            &i2c_bus->i2c_adap);
+        if (fe0->dvb.frontend != NULL) {
+            dvb_attach(xc5000_attach,
+            fe0->dvb.frontend,
+            &i2c_bus2->i2c_adap,
+            &mygica_x8507_xc5000_config);
+            }
+        break;
      case CX23885_BOARD_MYGICA_X8506:
          i2c_bus = &dev->i2c_bus[0];
          i2c_bus2 = &dev->i2c_bus[1];
          fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
              &mygica_x8506_lgs8gl5_config,
              &i2c_bus->i2c_adap);
          if (fe0->dvb.frontend != NULL) {
              dvb_attach(xc5000_attach,
                  fe0->dvb.frontend,
                  &i2c_bus2->i2c_adap,
                  &mygica_x8506_xc5000_config);
          }
          break;
      case CX23885_BOARD_MAGICPRO_PROHDTVE2:
          i2c_bus = &dev->i2c_bus[0];
diff --git a/drivers/media/video/cx23885/cx23885-video.c 
b/drivers/media/video/cx23885/cx23885-video.c
index e730b92..02bbf30 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -480,30 +480,31 @@ static int cx23885_flatiron_mux(struct cx23885_dev 
*dev, int input)
          cx23885_flatiron_dump(dev);

      return 0;
  }

  static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
  {
      dprintk(1, "%s() video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
          __func__,
          input, INPUT(input)->vmux,
          INPUT(input)->gpio0, INPUT(input)->gpio1,
          INPUT(input)->gpio2, INPUT(input)->gpio3);
      dev->input = input;

      if (dev->board == CX23885_BOARD_MYGICA_X8506 ||
+        dev->board == CX23885_BOARD_MYGICA_X8507 ||
          dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2) {
          /* Select Analog TV */
          if (INPUT(input)->type == CX23885_VMUX_TELEVISION)
              cx23885_gpio_clear(dev, GPIO_0);
      }

      /* Tell the internal A/V decoder */
      v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
              INPUT(input)->vmux, 0, 0);

      if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
          (dev->board == CX23885_BOARD_MPX885)) {
          /* Configure audio routing */
          v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
              INPUT(input)->amux, 0, 0);
diff --git a/drivers/media/video/cx23885/cx23885.h 
b/drivers/media/video/cx23885/cx23885.h
index b49036f..519f40d 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -75,30 +75,31 @@
  #define CX23885_BOARD_HAUPPAUGE_HVR1270        18
  #define CX23885_BOARD_HAUPPAUGE_HVR1275        19
  #define CX23885_BOARD_HAUPPAUGE_HVR1255        20
  #define CX23885_BOARD_HAUPPAUGE_HVR1210        21
  #define CX23885_BOARD_MYGICA_X8506             22
  #define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
  #define CX23885_BOARD_HAUPPAUGE_HVR1850        24
  #define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
  #define CX23885_BOARD_HAUPPAUGE_HVR1290        26
  #define CX23885_BOARD_MYGICA_X8558PRO          27
  #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
  #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
  #define CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF 30
  #define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000 31
  #define CX23885_BOARD_MPX885                   32
+#define CX23885_BOARD_MYGICA_X8507             33

  #define GPIO_0 0x00000001
  #define GPIO_1 0x00000002
  #define GPIO_2 0x00000004
  #define GPIO_3 0x00000008
  #define GPIO_4 0x00000010
  #define GPIO_5 0x00000020
  #define GPIO_6 0x00000040
  #define GPIO_7 0x00000080
  #define GPIO_8 0x00000100
  #define GPIO_9 0x00000200
  #define GPIO_10 0x00000400
  #define GPIO_11 0x00000800
  #define GPIO_12 0x00001000
  #define GPIO_13 0x00002000


-----------------------------------------------------------------------




I think it is about this part of the patch ( [media] cx23885-dvb: Remove 
a dirty hack that would require DVBv3 ) is that the fault occurs:

----------
static int cx23885_dvb_fe_ioctl_override(struct dvb_frontend *fe,
                      unsigned int cmd, void *parg,
                      unsigned int stage)
{
     int err = 0;

     switch (stage) {
     case DVB_FE_IOCTL_PRE:

         switch (cmd) {
         case FE_SET_FRONTEND:
             err = cx23885_dvb_set_frontend(fe,
                 (struct dvb_frontend_parameters *) parg);
             break;
         }
         break;
------------

Because without it, I have not "signal"

I tried to see as it was replaced DVB_FE_IOCTL_PRE in LINUX DVBv5 API, 
but did not see in http://linuxtv.org/downloads/v4l-dvb-apis/dvbapi.html

Again, thank you very much.

Alfredo

