Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1290 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab1AKUcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 15:32:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.38] Use the control framework in various subdevs
Date: Tue, 11 Jan 2011 21:32:28 +0100
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
References: <201012311437.00074.hverkuil@xs4all.nl> <201101071144.55426.hverkuil@xs4all.nl> <4D2CD5A4.2040404@redhat.com>
In-Reply-To: <4D2CD5A4.2040404@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101112132.28221.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, January 11, 2011 23:11:48 Mauro Carvalho Chehab wrote:
> Em 07-01-2011 08:44, Hans Verkuil escreveu:
> > On Friday, January 07, 2011 10:49:30 Hans Verkuil wrote:
> 
> > So this patch series is OK to merge.
> 
> >>> The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
> >>>   David Henningsson (1):
> >>>         [media] DVB: IR support for TechnoTrend CT-3650
> >>>
> >>> are available in the git repository at:
> >>>
> >>>   ssh://linuxtv.org/git/hverkuil/media_tree.git subdev-ctrl1
> >>>
> >>> Hans Verkuil (11):
> >>>       vivi: convert to the control framework and add test controls.
> 
> 
> Hmm.. this patch is producing a new warning:
> drivers/media/video/vivi.c:1059: warning: this decimal constant is unsigned only in ISO C90
> 
> Please fix.
> Mauro.

Here it is:

vivi: fix compiler warning

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 598acfe..6beb270 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1056,8 +1056,8 @@ static const struct v4l2_ctrl_config vivi_ctrl_int32 = {
 	.id = VIVI_CID_CUSTOM_BASE + 2,
 	.name = "Integer 32 Bits",
 	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = -2147483648,
-	.max = 2147483647,
+	.min = 0x80000000,
+	.max = 0x7f000000,
 	.step = 1,
 };
 


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
