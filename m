Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab0CITGq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 14:06:46 -0500
Message-ID: <4B969C08.2030807@redhat.com>
Date: Tue, 09 Mar 2010 16:05:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: moinejf@free.fr, m-karicheri2@ti.com, g.liakhovetski@gmx.de,
	pboettcher@dibcom.fr, tobias.lorenz@gmx.net, awalls@radix.net,
	khali@linux-fr.org, hdegoede@redhat.com, abraham.manu@gmail.com,
	hverkuil@xs4all.nl, crope@iki.fi, davidtlwong@gmail.com,
	henrik@kurelid.se, stoth@kernellabs.com
Subject: Status of the patches under review (45 patches)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the summary of the patches that are currently under review.
Each patch is represented by its submission date, the subject (up to 70 
chars) and the patchwork link (if submitted via email). Currently, there's
no pending hg/git pull request or new patches at patchwork.

P.S.: This email is c/c to the developers that some review action is expected.

		== Waiting for my fixes on Docbook == 

Feb,25 2010: DocBook/Makefile: Make it less verbose                                 http://patchwork.kernel.org/patch/82076
Feb,25 2010: DocBook: Add rules to auto-generate some media docbooks                http://patchwork.kernel.org/patch/82075
Feb,25 2010: [PATCHv2,                                                              http://patchwork.kernel.org/patch/82074
Feb,25 2010: [PATCHv2,                                                              http://patchwork.kernel.org/patch/82073

		== Videobuf patches - Need more tests before committing it - Volunteers? == 

Jan,19 2010: [v1,1/1] V4L: Add sync before a hardware operation to videobuf.        http://patchwork.kernel.org/patch/73896
Mar, 4 2010: [1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen            http://patchwork.kernel.org/patch/83626
Mar, 4 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated       http://patchwork.kernel.org/patch/83627

		== Waiting for Antti Palosaari <crope@iki.fi> review == 

Feb,26 2010: af901x: NXP TDA18218                                                   http://patchwork.kernel.org/patch/82494

		== Waiting for Muralidharan Karicheri <m-karicheri2@ti.com> review == 

Feb,19 2010: video_device: don't free_irq() an element past array vpif_obj.dev[]    http://patchwork.kernel.org/patch/80845

		== Waiting for Tobias Lorenz <tobias.lorenz@gmx.net> review == 

Feb, 3 2010: radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()    http://patchwork.kernel.org/patch/76786

		== waiting for Jean Delvare <khali@linux-fr.org> final submission after tests == 

Jan,30 2010: saa7134: Fix IR support of some ASUS TV-FM 7135 variants               http://patchwork.kernel.org/patch/75883

		== Waiting for its addition at linux-firmware and driver test by David Wong <davidtlwong@gmail.com>  == 

Nov, 1 2009: lgs8gxx: remove firmware for lgs8g75                                   http://patchwork.kernel.org/patch/56822

		== Andy Walls <awalls@radix.net> and Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com> are discussing around the solution == 

Oct,11 2009: AVerTV MCE 116 Plus radio                                              http://patchwork.kernel.org/patch/52981

		== Patches waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

Jan,15 2010: remove obsolete conditionalizing on DVB_DIBCOM_DEBUG                   http://patchwork.kernel.org/patch/73147
Feb, 8 2010: dib7000p: reduce large stack usage                                     http://patchwork.kernel.org/patch/77891
Feb, 8 2010: dib3000mc: reduce large stack usage                                    http://patchwork.kernel.org/patch/77892

		== IR driver for IMON - Will likely go via drivers/input tree == 

Feb,25 2010: [v2,                                                                   http://patchwork.kernel.org/patch/82119

		== Gspca patches - Waiting Hans de Goede <hdegoede@redhat.com> submission/review == 

Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837
Mar, 8 2010: [1/1] gspca-stv06xx: Remove the 046d:08da usb id from linking to the   http://patchwork.kernel.org/patch/84145

		== Gspca patches - Waiting Jean-Francois Moine <moinejf@free.fr> submission/review == 

Jan,14 2010: Problem with gspca and zc3xx                                           http://patchwork.kernel.org/patch/72895
Feb,24 2010: gspca pac7302: add USB PID range based on heuristics                   http://patchwork.kernel.org/patch/81612
Feb,27 2010: [01/11] ov534: Remove ambiguous controls                               http://patchwork.kernel.org/patch/82721
Feb,27 2010: [02/11] ov534: Remove hue control                                      http://patchwork.kernel.org/patch/82722
Feb,27 2010: [03/11] ov534: Fix autogain control, enable it by default              http://patchwork.kernel.org/patch/82725
Feb,27 2010: [04/11] ov534: Add Auto Exposure                                       http://patchwork.kernel.org/patch/82728
Mar, 1 2010: [v2,05/11] ov534: Fix and document setting manual exposure             http://patchwork.kernel.org/patch/82910
Feb,27 2010: [06/11] ov534: Fix Auto White Balance control                          http://patchwork.kernel.org/patch/82718
Feb,27 2010: [07/11] ov534: Fixes for sharpness control                             http://patchwork.kernel.org/patch/82724
Feb,27 2010: [08/11] ov534: Fix unsetting hflip and vflip bits                      http://patchwork.kernel.org/patch/82729
Mar, 1 2010: [v2,09/11] ov534: Cosmetics: fix indentation and hex digits            http://patchwork.kernel.org/patch/82911
Mar, 8 2010: [v2,10/11] ov534: Add Powerline Frequency control                      http://patchwork.kernel.org/patch/84076
Feb,27 2010: [11/11] ov534: Update copyright info                                   http://patchwork.kernel.org/patch/82723
Feb,28 2010: [1/3] add feedback LED control                                         http://patchwork.kernel.org/patch/82773
Feb,28 2010: [2/3] gspca pac7302: add LED control                                   http://patchwork.kernel.org/patch/82774
Feb,28 2010: [3/3] gspca pac7302: remove LED blinking when switching stream on and  http://patchwork.kernel.org/patch/82775

		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 

Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997
Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214
Mar, 5 2010: [v2] V4L/DVB: mx1-camera: compile fix                                  http://patchwork.kernel.org/patch/83742

		== Waiting for Steven Toth <stoth@kernellabs.com> comments on it == 

Feb, 6 2010: cx23885: Enable Message Signaled Interrupts(MSI).                      http://patchwork.kernel.org/patch/77492

		== Waiting for Henrik Kurelid <henrik@kurelid.se> comments about an userspace patch for MythTV == 

Mar, 1 2010: firedtv: add parameter to fake ca_system_ids in CA_INFO                http://patchwork.kernel.org/patch/82912

		== Waiting for Hans Verkuil <hverkuil@xs4all.nl> review == 

Mar, 3 2010: changeset 14351:2eda2bcc8d6f                                           http://patchwork.kernel.org/patch/83319

		== Patch(broken) Lock fixes. Patch is wrong but Siano has lock problems - Waiting for developers with time to fix it == 

Nov,12 2009: Locking in Siano driver (untested)                                     http://patchwork.kernel.org/patch/59590

		== Patch(broken) - Waiting Steven Toth <stoth@kernellabs.com> comments on it == 

Aug,19 2009: cx23885: fix support for TBS 6920 card                                 http://patchwork.kernel.org/patch/42777

		== Patch(broken) - waiting for Manu Abraham <abraham.manu@gmail.com> submission == 

Feb,16 2010: Twinhan 1027 + IR Port support                                         http://patchwork.kernel.org/patch/79753

Cheers,
Mauro

---

All patches sent to linux-media@vger.kernel.org are automatically stored at
Patchwork. The driver maintainer then analyzes it it and apply or reply
with comments. Others also may comment about it.

When the patch is is too trivial, or touches on a driver without a specific
maintainer, I analyze and apply it directly. Otherwise, it will be taged
as under review and the proper maintainer will be warned.

If you submitted or are waiting for the review of some patchset that weren't
applied at the git://git.kernel.org/v4l-dvb.git nor it is at the list bellow,
please check the status of the patch at the patchwork:
	http://patchwork.kernel.org/project/linux-media/list/

To check for a patch that is not New or Under Review, you'll need to click at
the "Filters" and pass some parameters to find the patch. Don't forget to
change the "State" to "any".

Eventually, your patch were rejected for some reason, or someone asked for
changes on it. If the patch is there, with a status different than
New/Under Review, double check for the received comments at the mailing list.
If it got Rejected, marked as RFC or as Changes Requested, please review it
according with the requests and send it again. In the very unlikely case
that the patch were wrongly tagged, please ping me.

If you discover any patch submitted via email that weren't caught by Patchwork,
this means that the patch got mangled by your emailer. The more likely
cause is that the emailer converted tabs into spaces or broke long lines.

If you're using Thunderbird, the solution is to install Asalted Patches
extension, available at:
	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
Other emailers will need you to disable the wrapping long lines feature.
