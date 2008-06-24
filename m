Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O8MHfQ004295
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 04:22:17 -0400
Received: from vds19s01.yellis.net (ns1019.yellis.net [213.246.41.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5O8M3Gu009282
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 04:22:04 -0400
Message-ID: <4860AE9F.80104@anevia.com>
Date: Tue, 24 Jun 2008 10:21:51 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <485FA5A8.9000103@anevia.com>
	<1214259929.6208.26.camel@pc10.localdom.local>
In-Reply-To: <1214259929.6208.26.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [HVR 1300] secam bg
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

hermann pitton a écrit :
> Hi Frederic,
> 
> Am Montag, den 23.06.2008, 15:31 +0200 schrieb Frederic CAND:
>> dear all
>> I could not make secam b/g work on my hvr 1300
>> ioctl returns -1, error "Invalid argument"
>> I know my card is able to handle this tv norm since it's working fine
>> (video and sound are ok) under windows
>> anyone could confirm it isn't working ? any idea why, and how to make it 
>> work ?
> 
> since without reply, I don't claim to have seriously looked at it, but
> at least have one question myself.
> 
> In cx88-core is no define for SECAM B or G.
> 
> Do you use a signal generator?
Indeed, I do.
It's a Promax GV-198.
http://www.promaxprolink.com/gv198.htm

> 
> Hartmut asked once on the saa7134 driver, if there are any known
> remaining SECAM_BG users currently and we remained, that it is hard to
> get really up to date global analog lists for current broadcasts and I
> only could contribute that there was no single request for it during all
> these last years.
> 
> You know countries still using it?

 From what I've found on the internet, Cyprus, Greece, Saudi Arabia and 
some others. Plus people using a signal modulator (e.g: professionnal use).

> 
> Thanks,
> Hermann
> 
> 

Actually, tda9887 Secam BG was broken in (more or less) recent versions 
of v4l-dvb (I noticed that thanks to the signal modulator and my knc tv 
station saa7134 based). I came up with a "roll back" patch. I guess it 
can't be applied directly on the current tree but it can be done 
manually before being comited to the tree.

diff -pur1 a/linux/drivers/media/video/tda9887.c 
b/linux/drivers/media/video/tda9887.c
--- a/linux/drivers/media/video/tda9887.c      2007-07-02 
20:39:57.000000000 +0200
+++ b/linux/drivers/media/video/tda9887.c      2008-06-19 
12:21:50.000000000 +0200
@@ -172,7 +172,6 @@ static struct tvnorm tvnorms[] = {
                 .name  = "SECAM-BGH",
-               .b     = ( cPositiveAmTV  |
+               .b     = ( cNegativeFmTV  |
                            cQSS           ),
                 .c     = ( cTopDefault),
-               .e     = ( cGating_36     |
-                          cAudioIF_5_5   |
+               .e     = ( cAudioIF_5_5   |
                            cVideoIF_38_90 ),



For the Hauppauge HVR 1300, I found that adding mentions of SECAM B/G/H 
in cx88.h and cx88-core.c helped making it work. Same goes for this one, 
I guess it can't be applied on the current tree but it can easily be 
manually applied.

diff -pur1 a/linux/drivers/media/video/cx88/cx88-core.c 
b/linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c       2007-07-02 
20:39:57.000000000 +0200
+++ b/linux/drivers/media/video/cx88/cx88-core.c       2008-06-23 
18:48:21.000000000 +0200
@@ -890,2 +890,5 @@ static int set_tvaudio(struct cx88_core

+    } else if ((V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H) 
& norm) {
+        core->tvaudio = WW_BG;
+
         } else if (V4L2_STD_SECAM_DK & norm) {
@@ -979,3 +982,6 @@ int cx88_set_tvnorm(struct cx88_core *co
                 cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
-       cx_andor(MO_INPUT_FORMAT, 0xf, cxiformat);
+    /* Chroma AGC must be disabled if SECAM is used, we enable it
+        by default on PAL and NTSC */
+    cx_andor(MO_INPUT_FORMAT, 0x40f,
+            norm & V4L2_STD_SECAM ? cxiformat : cxiformat | 0x400);



diff -pur1 a/linux/drivers/media/video/cx88/cx88.h 
b/linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h    2008-05-13 
10:21:01.000000000 +0200
+++ b/linux/drivers/media/video/cx88/cx88.h    2008-06-23 
17:48:41.000000000 +0200
@@ -62,3 +62,4 @@
         V4L2_STD_PAL_M |  V4L2_STD_PAL_N    |  V4L2_STD_PAL_Nc   | \
-       V4L2_STD_PAL_60|  V4L2_STD_SECAM_L  |  V4L2_STD_SECAM_DK )
+       V4L2_STD_PAL_60|  V4L2_STD_SECAM_L  |  V4L2_STD_SECAM_DK | \
+    V4L2_STD_SECAM_B| V4L2_STD_SECAM_G  |  V4L2_STD_SECAM_H )

-- 
CAND Frederic
Product Manager
ANEVIA

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
