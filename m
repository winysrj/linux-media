Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33088 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbFBWZc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 18:25:32 -0400
Received: by wiwd19 with SMTP id d19so33526028wiw.0
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2015 15:25:31 -0700 (PDT)
Received: from [192.168.0.3] (196.108.90.146.dyn.plus.net. [146.90.108.196])
        by mx.google.com with ESMTPSA id r9sm28851436wjo.26.2015.06.02.15.25.30
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jun 2015 15:25:30 -0700 (PDT)
Message-ID: <556E2D5B.5080201@gmail.com>
Date: Tue, 02 Jun 2015 23:25:31 +0100
From: Andy Furniss <adf.lists@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt to
 work when recording.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Running kernel 3.18.14 with git master v4l-utils and a pctv290e + a 292e.

If I try to record with dvbv5-zap and include the "p" option to get
pat/pmt I get -

read_sections: read error: Resource temporarily unavailable
couldn't find pmt-pid for sid 10bf

Doing this this fixes it for me (obviously not meant to be a a proper 
patch).

diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 30d4eda..b520948 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -151,8 +151,10 @@ int dvb_get_pmt_pid(int patfd, int sid)
                 if (((count = read(patfd, buf, sizeof(buft))) < 0) && 
errno == EOVERFLOW)
                 count = read(patfd, buf, sizeof(buft));
                 if (count < 0) {
-               perror("read_sections: read error");
-               return -1;
+                       if (errno == EAGAIN) /*ADF*/
+                               continue;
+                       perror("read_sections: read error");
+                       return -1;
                 }

                 section_length = ((buf[1] & 0x0f) << 8) | buf[2];


