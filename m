Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:60857 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbaAPPHN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 10:07:13 -0500
Message-ID: <52D7F59F.5050503@unixsol.org>
Date: Thu, 16 Jan 2014 17:07:11 +0200
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: FE_READ_SNR and FE_READ_SIGNAL_STRENGTH docs
References: <52D554BA.3070906@unixsol.org> <20140114133044.1d5276f4@samsung.com> <52D55DE7.4050309@unixsol.org> <20140114140715.5ed126ac@samsung.com>
In-Reply-To: <20140114140715.5ed126ac@samsung.com>
Content-Type: multipart/mixed;
 boundary="------------090403090002080107050904"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090403090002080107050904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Around 01/14/2014 06:07 PM, Mauro Carvalho Chehab scribbled:
> Em Tue, 14 Jan 2014 17:55:19 +0200
> Georgi Chorbadzhiyski <gf@unixsol.org> escreveu:
>> Around 01/14/2014 05:30 PM, Mauro Carvalho Chehab scribbled:
>>> Em Tue, 14 Jan 2014 17:16:10 +0200
>>> Georgi Chorbadzhiyski <gf@unixsol.org> escreveu:
>>>
>>>> Hi guys, I'm confused the documentation on:
>>>>
>>>> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SNR
>>>> http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_READ_SIGNAL_STRENGTH
>>>>
>>>> states that these ioctls return int16_t values but frontend.h states:
>>>>
>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/dvb/frontend.h
>>>>
>>>> #define FE_READ_SIGNAL_STRENGTH  _IOR('o', 71, __u16)
>>>> #define FE_READ_SNR              _IOR('o', 72, __u16)
>>>>
>>>> So which one is true?
>>>
>>> Documentation is wrong. The returned values are unsigned. Would you mind send
>>> us a patch fixing it?
>>
>> I would be happy to, but I can't find the repo that holds the documentation.
> 
> It is in the Kernel tree, under Documentation/DocBook/media/dvb.

The attached file contains the discussed documentation fixes.

-- 
Georgi Chorbadzhiyski | http://georgi.unixsol.org/ | http://github.com/gfto/

--------------090403090002080107050904
Content-Type: text/plain; charset=UTF-8;
 name="0001-doc-Fix-FE_READ_SNR-and-FE_READ_SIGNAL_STRENGTH-para.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-doc-Fix-FE_READ_SNR-and-FE_READ_SIGNAL_STRENGTH-para.pa";
 filename*1="tch"

>From 2a633a125e616e8a9e701c34f088d7a4cc020ff8 Mon Sep 17 00:00:00 2001
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Date: Thu, 16 Jan 2014 17:04:55 +0200
Subject: [PATCH] doc: Fix FE_READ_SNR and FE_READ_SIGNAL_STRENGTH parameter
 types.

The proper types returned from FE_READ_SNR and FE_READ_SIGNAL_STRENGTH
are uint16_t not int16_t.
---
 Documentation/DocBook/media/dvb/frontend.xml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 0d6e81b..8a6a6ff 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -744,7 +744,7 @@ typedef enum fe_hierarchy {
 </para>
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_READ_SNR">FE_READ_SNR</link>, int16_t
+<para>int ioctl(int fd, int request = <link linkend="FE_READ_SNR">FE_READ_SNR</link>, uint16_t
  &#x22C6;snr);</para>
 </entry>
  </row></tbody></tgroup></informaltable>
@@ -766,7 +766,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row><row><entry
  align="char">
-<para>int16_t *snr</para>
+<para>uint16_t *snr</para>
 </entry><entry
  align="char">
 <para>The signal-to-noise ratio is stored into *snr.</para>
@@ -791,7 +791,7 @@ typedef enum fe_hierarchy {
 <informaltable><tgroup cols="1"><tbody><row><entry
  align="char">
 <para>int ioctl( int fd, int request =
- <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link>, int16_t &#x22C6;strength);</para>
+ <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link>, uint16_t &#x22C6;strength);</para>
 </entry>
  </row></tbody></tgroup></informaltable>
 
@@ -814,7 +814,7 @@ typedef enum fe_hierarchy {
 </entry>
  </row><row><entry
  align="char">
-<para>int16_t *strength</para>
+<para>uint16_t *strength</para>
 </entry><entry
  align="char">
 <para>The signal strength value is stored into *strength.</para>
-- 
1.8.4


--------------090403090002080107050904--
