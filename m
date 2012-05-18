Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51417 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967003Ab2ERTdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 15:33:01 -0400
Received: by bkcji2 with SMTP id ji2so2627598bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 12:33:00 -0700 (PDT)
Message-ID: <4FB6A3E9.3000804@gmail.com>
Date: Fri, 18 May 2012 21:32:57 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL FOR v3.5] Fix gspca compile error if CONFIG_PM is not
 set
References: <201205181343.46414.hverkuil@xs4all.nl>
In-Reply-To: <201205181343.46414.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/18/2012 01:43 PM, Hans Verkuil wrote:
> The field 'frozen' is only there if CONFIG_PM is set, so don't use it
> directly, always check for CONFIG_PM first.

If it is safe to assume that for !CONFIG_PM the field 'frozen' is always
zero, wouldn't it be better to create a macro in a header file, something 
like:

#ifdef CONFIG_PM
#define gspca_pm_frozen(__dev) ((__dev)->frozen)
#else
#define gspca_pm_frozen(__dev) (0)
#endif

and use it instead ?


diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/video/gspca/sq905.c
index a144ce7..04f5465 100644 (file)
--- a/drivers/media/video/gspca/sq905.c
+++ b/drivers/media/video/gspca/sq905.c
@@ -232,7 +232,11 @@ static void sq905_dostream(struct work_struct *work)
        frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage
                        + FRAME_HEADER_LEN;
 
-       while (!gspca_dev->frozen && gspca_dev->dev && gspca_dev->streaming) {
+       while (!gspca_pm_frozen(gspca_dev) && gspca_dev->dev && gspca_dev->streaming) {


I really hate #ifdefs ... :-)


--
Regards,
Sylwester
 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 61282daf505f3c8def09332ca337ac257b792029:
> 
>    [media] V4L2: mt9t112: fixup JPEG initialization workaround (2012-05-15 16:15:35 -0300)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/hverkuil/media_tree.git frozenfix
> 
> for you to fetch changes up to 4ba342204948e9df49dc1f639ffdbfe49579e626:
> 
>    gspca: the field 'frozen' is under CONFIG_PM (2012-05-18 13:40:42 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>        gspca: the field 'frozen' is under CONFIG_PM
> 
>   drivers/media/video/gspca/finepix.c   |   20 +++++++++++++++-----
>   drivers/media/video/gspca/jl2005bcd.c |    6 +++++-
>   drivers/media/video/gspca/sq905.c     |    6 +++++-
>   drivers/media/video/gspca/sq905c.c    |    6 +++++-
>   drivers/media/video/gspca/vicam.c     |    6 +++++-
>   drivers/media/video/gspca/zc3xx.c     |    7 +++++--
>   6 files changed, 40 insertions(+), 11 deletions(-)

