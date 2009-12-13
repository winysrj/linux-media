Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:61202 "HELO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753322AbZLMUqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 15:46:32 -0500
Message-ID: <4B2552A4.5090901@freemail.hu>
Date: Sun, 13 Dec 2009 21:46:28 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 ERRORS
References: <200912131922.nBDJMMUm030337@smtp-vbr6.xs4all.nl>
In-Reply-To: <200912131922.nBDJMMUm030337@smtp-vbr6.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Sunday.log
>> linux-2.6.24.7-i686: ERRORS
>>
>> /marune/build/v4l-dvb-master/v4l/conex.c:1049: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__devinitconst'
>> /marune/build/v4l-dvb-master/v4l/conex.c:1065: error: 'device_table' undeclared here (not in a function)
>> make[3]: *** [/marune/build/v4l-dvb-master/v4l/conex.o] Error 1
>> make[3]: *** Waiting for unfinished jobs....
>> /marune/build/v4l-dvb-master/v4l/etoms.c:873: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__devinitconst'
>> /marune/build/v4l-dvb-master/v4l/etoms.c:893: error: 'device_table' undeclared here (not in a function)
>> make[3]: *** [/marune/build/v4l-dvb-master/v4l/etoms.o] Error 1
>> make[2]: *** [_module_/marune/build/v4l-dvb-master/v4l] Error 2
>> make[2]: Leaving directory `/marune/build/trees/i686/linux-2.6.24.7'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/marune/build/v4l-dvb-master/v4l'
>> make: *** [all] Error 2
>> Sun Dec 13 19:13:59 CET 2009

It seems that kernels before 2.6.24 (inclusively) do not have "__devinitconst", so  conex.c
and etoms.c can only build with 2.6.25 and later. Should USB_GSPCA_CONEX and USB_GSPCA_ETOMS
be added to v4l/versions.txt?

---
From: Márton Németh <nm127@freemail.hu>

The conex and etoms drivers only build with kernel version 2.6.25 and later.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e2f13778b5dc v4l/versions.txt
--- a/v4l/versions.txt	Sat Dec 12 17:25:43 2009 +0100
+++ b/v4l/versions.txt	Sun Dec 13 21:40:58 2009 +0100
@@ -54,6 +54,11 @@
 RADIO_SI4713
 I2C_SI4713

+[2.6.25]
+# The drivers uses "__devinitconst"
+USB_GSPCA_CONEX
+USB_GSPCA_ETOMS
+
 [2.6.24]
 # Some freezer routines
 USB_GSPCA_SN9C20X_EVDEV

