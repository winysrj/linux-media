Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60446
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756331AbdEGWUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 18:20:03 -0400
Date: Sun, 7 May 2017 08:43:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Reinhard Speyerer <rspmn@arcor.de>
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
Message-ID: <20170507084233.037ec0c3@vento.lan>
In-Reply-To: <20170504231429.GA1997@arcor.de>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
        <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
        <20170503095303.71cf3a75@vento.lan>
        <20170503193318.07ddf143@vento.lan>
        <00937473-581c-ecf8-58c6-616a78aa37c5@googlemail.com>
        <20170504091147.3f3edc16@vento.lan>
        <20170504231429.GA1997@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 May 2017 01:14:29 +0200
Reinhard Speyerer <rspmn@arcor.de> escreveu:

> Hi Gregor and Mauro,
> 
> For some reason several/most(?) programs from freenet.TV (connect) which
> are distributed via the Internet instead of DVB-T2 have duplicate entries.


Found the issue. There's a logic inside the scan algorithm that groups
multi-section tables. There was a mistake there with was causing it to
read twice the first section. As, on most cases, the SDT table has just
one section, nobody noticed it so far. Just added a patch, on both master 
and stable fixing this issue, as enclosed.

Thanks for reporting it!

Regards,
Mauro

-

[PATCH] dvb-scan: fix the logic for multi-section handling

The logic that parses multisection handling is broken.
Right now, it parses twice the initial section, causing
duplicated entries at the tables.

The net result is that, on tables like SDT, channels
appear duplicated. Before this patch, what was happening
was:

	dvb_read_sections: waiting for table ID 0x42, program ID 0x11
	dvb_parse_section: received table 0x42, extension ID 0x4072, section 0/1
	dvb_parse_section: received table 0x42, extension ID 0x4072, section 1/1
	dvb_parse_section: received table 0x42, extension ID 0x4072, section 0/1
	dvb_parse_section: table 0x42, extension ID 0x4072: done

So, section 0/1 were parsed twice. After that, it now properly
detects that section 0/1 was already parsed:
	dvb_read_sections: waiting for table ID 0x42, program ID 0x11
	dvb_parse_section: received table 0x42, extension ID 0x4072, section 0/1
	dvb_parse_section: received table 0x42, extension ID 0x4072, section 1/1
	dvb_parse_section: table 0x42, extension ID 0x4072: done

Reported-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 07fe13e808a8..7ff8ba4f0446 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -239,12 +239,6 @@ static int dvb_parse_section(struct dvb_v5_fe_parms_priv *parms,
 				return -1;
 			}
 			ext += i;
-
-			memset(ext, 0, sizeof(*ext));
-			ext->ext_id = h.id;
-			ext->first_section = h.section_id;
-			ext->last_section = h.last_section;
-			new = 1;
 		}
 	}
 
