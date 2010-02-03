Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab0BCLki (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 06:40:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13BecWe023829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 3 Feb 2010 06:40:38 -0500
Received: from [10.11.11.130] (vpn-11-130.rdu.redhat.com [10.11.11.130])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o13BeYPr032508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 3 Feb 2010 06:40:36 -0500
Message-ID: <4B6960B1.8060205@redhat.com>
Date: Wed, 03 Feb 2010 09:40:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Patches that there are currently under review
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be sure that we won't have any patches pending review/addition, I'll
start to produce periodically a list of the patches submitted to linux-media@vger.kernel.org.

As you know, those patches are automatically stored at Patchwork. However, patchwork misses
the feature to store why a patch weren't merged.

I did a large effort during the last days to merge all patches that got acked there,
and the trivial patches. Currently, there are only 36 patches pending. For all of them,
some action is needed by someone for it to move on.

If you submitted or are waiting for the review of some patchset that weren't applied nor is
at the list bellow, please check the status at the patchwork:
	http://patchwork.kernel.org/project/linux-media/list/

To check for a patch that is not New or Under Review, you'll need to click at the "Filters" and
pass some parameters to find the patch. Don't forget to change the "State" to "any".

Eventually, your patch were rejected for some reason, or someone asked for changes on it. If
the patch is there, with a status different than New/Under Review, double check for the received
comments at the mailing list. As I am just a human, the scripts I wrote may be buggy or I may
have incorrectly tagged a patch with the wrong state. In this case, please ping me.

If you discover any submitted patch that weren't caught by Patchwork, this means that
the patch got mangled by your email. The more likely cause is that the emailer converted tabs
into spaces or broke long lines. If you're using Thunderbird, the solution is to install
Asalted Patches extension (available at https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/).

In the case of gspca and soc_camera drivers/sub-drivers, I generally just wait for the patches
to be merged at the driver tree, as they have a common core driver with specific requirements.

In the case of DaVinci/OMAP, those drivers passes to lots of interactions before being ready.
So, all patches are marked as RFC, as the final version will be submitted via -git PULL request.


================

The current list of patches under review is:


		== IR driver for IMON - Will likely go via drivers/input tree == 

[v2] input: imon driver for SoundGraph iMON/Antec Veris IR devices    	http://patchwork.kernel.org/patch/70348

		== Driver is OK. Waiting for tests == 

saa7134: Fix IR support of some ASUS TV-FM 7135 variants              	http://patchwork.kernel.org/patch/75883

		== Patch submitted on Aug, 2009 - currently broken - Waiting Seven comments on it == 

cx23885: fix support for TBS 6920 card                                	http://patchwork.kernel.org/patch/42777

		== Siano patch fixing locks - Still broken - Waiting for some time to fix it == 

Locking in Siano driver (untested)                                    	http://patchwork.kernel.org/patch/59590

		== Waiting for linux-firmware submission and testing == 

V4L/DVB: lgs8gxx: remove firmware for lgs8g75                         	http://patchwork.kernel.org/patch/56822

		== Andy is waiting for the SOB from the patch author == 

AVerTV MCE 116 Plus radio                                             	http://patchwork.kernel.org/patch/52981

		== Waiting for Laurent merge on it == 

[5/8] drivers/media/video/uvc: Use %pUl to print UUIDs                	http://patchwork.kernel.org/patch/52139

		== hdpvr - Janne never submitted his proposed patch upstream - Waiting to be added == 

[3/8] drivers/media/video/hdpvr: introduce missing kfree              	http://patchwork.kernel.org/patch/47948

		== Asked Manu on Feb, 2 to review it - Waiting for his tests == 

drivers/media/dvb/bt8xx/dst.c:fixes for DVB-C Twinhan VP2031 in       	http://patchwork.kernel.org/patch/71907

		== DVB Stats API - Waiting comments == 

Details about DVB frontend API                                        	http://patchwork.kernel.org/patch/65583
New DVB-Statistics API                                                	http://patchwork.kernel.org/patch/66133

		== Videobuf patch - Need more tests before committing it == 

[v1,1/1] V4L: Add sync before a hardware operation to videobuf.       	http://patchwork.kernel.org/patch/73896

		== dmx demux patches - Waiting Andy/Obi review == 

Fix the risk of an oops at dvb_dmx_release                            	http://patchwork.kernel.org/patch/76071
dvb_demux: Don't use vmalloc at dvb_dmx_swfilter_packet               	http://patchwork.kernel.org/patch/76083

		== Telegent 2300 - Waiting for the removal of the Country Code == 

[v2,01/10] add header files for tlg2300                               	http://patchwork.kernel.org/patch/76219
[v2,02/10] add the generic file                                       	http://patchwork.kernel.org/patch/76220
[v2,03/10] add video/vbi file for tlg2300                             	http://patchwork.kernel.org/patch/76232
[v2,04/10] add DVB-T support for tlg2300                              	http://patchwork.kernel.org/patch/76221
[v2,05/10] add FM support for tlg2300                                 	http://patchwork.kernel.org/patch/76222
[v2,06/10] add audio support for tlg2300                              	http://patchwork.kernel.org/patch/76230
[v2,07/10] add document file for tlg2300                              	http://patchwork.kernel.org/patch/76223
[v2,08/10] add Kconfig and Makefile for tlg2300                       	http://patchwork.kernel.org/patch/76231
[v2,09/10] modify the Kconfig and Makefile for tlg2300                	http://patchwork.kernel.org/patch/76233
[v2,10/10] add maintainers for tlg2300                                	http://patchwork.kernel.org/patch/76224

		== Asked patrick to review it on Jan, 25 - Waiting his review == 

[PATCH 4/4] remove obsolete conditionalizing on DVB_DIBCOM_DEBUG      	http://patchwork.kernel.org/patch/73147

		== Waiting for janne ack - requested on Jan, 29 == 

hdpvr-video: cleanup signedness                                       	http://patchwork.kernel.org/patch/74902

		== Gspca patches - Waiting Francois to get them and submit via his tree == 

ov534: allow enumerating supported framerates                         	http://patchwork.kernel.org/patch/71896
[gspca_jf,tree] gspca zc3xx: signal when unknown packet received      	http://patchwork.kernel.org/patch/75837
[RFC] gspca pac7302: add USB PID range based on heuristics            	http://patchwork.kernel.org/patch/75960
Problem with gspca and zc3xx                                          	http://patchwork.kernel.org/patch/72895

		== soc_camera patches - Waiting Guennadi to catch them == 

MT9T031: write xskip and yskip at each set_params call                	http://patchwork.kernel.org/patch/74108
soc_camera: match signedness of soc_camera_limit_side()               	http://patchwork.kernel.org/patch/75616
[PULL] soc-camera and mediabus                                        	http://patchwork.kernel.org/patch/69697
[1/3] soc-camera: mt9t112: modify exiting conditions from standby mode	http://patchwork.kernel.org/patch/76212
[2/3] soc-camera: mt9t112: modify delay time after initialize         	http://patchwork.kernel.org/patch/76213
[3/3] soc-camera: mt9t112: The flag which control camera-init is      	http://patchwork.kernel.org/patch/76214

