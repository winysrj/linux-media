Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44583 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbcCJQQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 11:16:32 -0500
Subject: Re: [PATCH] Revert "[media] au0828: use v4l2_mc_create_media_graph()"
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	nenggun.kim@samsung.com, inki.dae@samsung.com,
	jh1009.sung@samsung.com, chehabrafael@gmail.com,
	sakari.ailus@linux.intel.com
References: <1457493972-4063-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E19DDE.9080307@osg.samsung.com>
Date: Thu, 10 Mar 2016 09:16:30 -0700
MIME-Version: 1.0
In-Reply-To: <1457493972-4063-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2016 08:26 PM, Shuah Khan wrote:
> This reverts commit 9822f4173f84cb7c592edb5e1478b7903f69d018.
> This commit breaks au0828_enable_handler() logic to find the tuner.
> Audio, Video, and Digital applications are broken and fail to start
> streaming with tuner busy error even when tuner is free.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 103 ++++++++++++++++++++++++++++++--
>  drivers/media/v4l2-core/v4l2-mc.c       |  21 +------
>  2 files changed, 99 insertions(+), 25 deletions(-)
> 

Hi Mauro,

Please pull this revert in as soon as possible. Without
the revert, auido, video, and digital applications won't
start even. There is a bug in the common routine introduced
in the commit 9822f4173f84cb7c592edb5e1478b7903f69d018 which
causes the link between source and sink to be not found.
I am testing on WIn-TV HVR 950Q

Here is my test sequence I use to verify the mutual exclusion
works between audio, video, and dvb applications.

Generate media graph graph - verify graph looks good.

Basic testing:
Test case 1:
Step 1: Start arecord and generate graph to verify the right
source is enabled
Step 2: Exit arecord and generate graph and verify resource is released.

Test case 2:
Step 1: Start kaffeine and generate graph to verify the right
source is enabled
Step 2: Exit kaffeine - generate graph and verify resource is released.

Test case 3:
Step 1: Start xawtv and generate graph to verify the right
source is enabled
Step 2: Exit xawtv - generate graph and verify resource is released.

Mutual exclusion testing:
Test case 1:
Step 1: Start arecord and generate graph to verify the right
source is enabled
Step 2: Start kaffeine - should see it fail to EBUSY
Step 3: Start xawtv - should see it fail with EBUSY
Step 4: Exit arecord - generate graph and verify resource is released.

Test Case 2:
Step 1: Start kaffeine and generate graph to verify the right
source is enabled
Step 2: Start arecord - it should fail - unable to set hwparams - device busy error
Step 3: Start xawtv - should see it fail with EBUSY
Step 4: Exit kaffeine - generate graph and verify resource is released.

Test Case 3:
Step 1: Start xawtv and generate graph to verify the right
source is enabled
Step 2: Start arecord - it should fail - device busy error
Step 3: Start kaffeine should see it fail with EBUSY
Step 4: Exit xawtv - generate graph and verify resource is released.

At each step make dmesg looks good. I build my kernel with kasan
enabled - to detect out of bounds access etc. good stuff.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
