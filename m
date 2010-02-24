Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0BXFk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 00:40:59 -0500
Message-ID: <4B84BBB0.1020408@redhat.com>
Date: Wed, 24 Feb 2010 02:40:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: helmut@helmutauer.de, moinejf@free.fr, m-karicheri2@ti.com,
	g.liakhovetski@gmx.de, pboettcher@dibcom.fr, tobias.lorenz@gmx.net,
	awalls@radix.net, khali@linux-fr.org, hdegoede@redhat.com,
	abraham.manu@gmail.com, davidtlwong@gmail.com, stoth@kernellabs.com
Subject: Status of the patches under review (29 patches)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I suspect that Linus should be releasing the 2.6.33 kernel any time soon,
so the next merge window is about to open. I've handled already everything
on my pending queues. However, I missed some emails due to a crash on my 
exim filter. Also, patchwork.kernel.org missed some emails due to some
trouble there. So, maybe there are still some unnoticed pending stuff.

If you still have any pending work for 2.6.34 that aren't merged nor
are under review, please submit it ASAP, as patches received after the 
release of 2.6.33 will likely be postponed to 2.6.35.

Cheers,
Mauro

--

This is the summary of the patches that are currently under review.
Each patch is represented by its submission date, the subject (up to 70 
chars) and the patchwork link (if submitted via email).

		== Videobuf patch - Need more tests before committing it - Volunteers? == 

Jan,19 2010: [v1,1/1] V4L: Add sync before a hardware operation to videobuf.        http://patchwork.kernel.org/patch/73896

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

Dec,31 2009: [v2] input: imon driver for SoundGraph iMON/Antec Veris IR devices     http://patchwork.kernel.org/patch/70348

		== Waiting Helmut Auer <helmut@helmutauer.de> to get the Signed-off-by from Dirk Herrendoerfer == 

Feb,11 2010: Add support for SMT7020 to cx88                                        http://patchwork.kernel.org/patch/78823

		== Gspca patches - Waiting Hans de Goede <hdegoede@redhat.com> submission/review == 

Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837

		== Gspca patches - Waiting Jean-Francois Moine <moinejf@free.fr> submission/review == 

Jan,31 2010: [RFC] gspca pac7302: add USB PID range based on heuristics             http://patchwork.kernel.org/patch/75960
Jan,14 2010: Problem with gspca and zc3xx                                           http://patchwork.kernel.org/patch/72895

		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 

Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997
Feb,19 2010: v4l: soc_camera: fix bound checking of mbus_fmt[] index                http://patchwork.kernel.org/patch/80757
Feb, 2 2010: [1/3] soc-camera: mt9t112: modify exiting conditions from standby mode http://patchwork.kernel.org/patch/76212
Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214

		== Waiting for my fixes on Docbook == 

Feb,17 2010: [1/4] DocBook/Makefile: Make it less verbose                           http://patchwork.kernel.org/patch/79981
Feb,17 2010: [2/4] DocBook: Add rules to auto-generate some media docbooks          http://patchwork.kernel.org/patch/79983
Feb,17 2010: [3/4] DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and  http://patchwork.kernel.org/patch/79985
Feb,17 2010: [4/4] V4L/DVB: v4l: document new Bayer and monochrome pixel formats    http://patchwork.kernel.org/patch/79987

		== Waiting for Steven Toth <stoth@kernellabs.com> comments on it == 

Feb, 6 2010: cx23885: Enable Message Signaled Interrupts(MSI).                      http://patchwork.kernel.org/patch/77492

		== Patch(broken) Lock fixes. Patch is wrong but Siano has lock problems - Waiting for developers with time to fix it == 

Nov,12 2009: Locking in Siano driver (untested)                                     http://patchwork.kernel.org/patch/59590

		== Patch(broken) - Waiting Steven Toth <stoth@kernellabs.com> comments on it == 

Aug,19 2009: cx23885: fix support for TBS 6920 card                                 http://patchwork.kernel.org/patch/42777

		== Patch(broken) - DVB Stats API - Got a few more comments in priv, but better wait for a while == 

Dec, 7 2009: Details about DVB frontend API                                         http://patchwork.kernel.org/patch/65583
Dec, 9 2009: New DVB-Statistics API                                                 http://patchwork.kernel.org/patch/66133

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
