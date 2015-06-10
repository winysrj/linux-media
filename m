Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37167 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbbFJR1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 13:27:31 -0400
Received: by wifx6 with SMTP id x6so54574717wif.0
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 10:27:30 -0700 (PDT)
Message-ID: <55787382.5010607@gmail.com>
Date: Wed, 10 Jun 2015 18:27:30 +0100
From: Andy Furniss <adf.lists@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt
 to work when recording.
References: <556E2D5B.5080201@gmail.com> <20150610095215.79e5e77e@recife.lan>
In-Reply-To: <20150610095215.79e5e77e@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> Just applied a fix for it:
> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=c7c9af17163f282a147ea76f1a3c0e9a0a86e7fa
>
> It will retry up to 10 times. This should very likely be enough if the
> driver doesn't have any bug.
>
> Please let me know if this fixes the issue.

No, it doesn't, so I reverted the above and added back my hack + a 
counter as below and it seems to be retrying > a million times.

Tested both 290e and 292e.

I currently have a post on linux-usb because I am having some dvb packet 
loss issues unless I spin a cpu - don't know if that's relevant or not 
but thought I should mention it. The loss is relatively low level but 
enough to be annoying, spinning a cpu doesn't change the eagain count.

results with below patch recording =

asr[scans-dvb]$ dvbv5-zap -a 1  -pro ~/test1.ts -t 10 -c 
dvb_channel-290.conf "BBC TWO"
using demux '/dev/dvb/adapter1/demux0'
reading channels from file 'dvb_channel-290.conf'
service has pid type 05:  7270 250
tuning to 745833000 Hz

EAGAIN count = 1468127

video pid 201
   dvb_set_pesfilter 201
audio pid 202
   dvb_set_pesfilter 202
Lock   (0x1f) Signal= 100.00% C/N= 0.20% UCB= 132 postBER= 0
Lock   (0x1f) Signal= 100.00% C/N= 0.21% UCB= 138 postBER= 0
Record to file '/home/andy/test1.ts' started
copied 4581936 bytes (447 Kbytes/sec)
Lock   (0x1f) Signal= 100.00% C/N= 0.43% UCB= 283 postBER= 0

asr[scans-dvb]$ dvbv5-zap -a 0  -pro ~/test2.ts -t 10 -c 
dvb_channel-290.conf "BBC TWO"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file 'dvb_channel-290.conf'
service has pid type 05:  7270 250
tuning to 745833000 Hz

EAGAIN count = 1285533

video pid 201
   dvb_set_pesfilter 201
audio pid 202
   dvb_set_pesfilter 202
Lock   (0x1f) C/N= 16.75dB
Lock   (0x1f) C/N= 17.00dB
Record to file '/home/andy/test2.ts' started
copied 3780116 bytes (369 Kbytes/sec)
Lock   (0x1f) C/N= 34.00dB



diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 30d4eda..f435078 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -130,6 +130,7 @@ int dvb_get_pmt_pid(int patfd, int sid)
         int count;
         int pmt_pid = 0;
         int patread = 0;
+        int eacount = 0;
         int section_length;
         unsigned char buft[4096];
         unsigned char *buf = buft;
@@ -151,10 +152,16 @@ int dvb_get_pmt_pid(int patfd, int sid)
                 if (((count = read(patfd, buf, sizeof(buft))) < 0) && 
errno == EOVERFLOW)
                 count = read(patfd, buf, sizeof(buft));
                 if (count < 0) {
-               perror("read_sections: read error");
-               return -1;
+                       if (errno == EAGAIN){ /*ADF*/
+                               eacount++;
+                               continue;
+                       }
+                       perror("read_sections: read error");
+                       return -1;
                 }

+                fprintf(stderr, "EAGAIN count = %d\n", eacount);
+
                 section_length = ((buf[1] & 0x0f) << 8) | buf[2];
                 if (count != section_length + 3)
                 continue;


