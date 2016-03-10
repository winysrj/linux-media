Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44754 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbcCJRxQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 12:53:16 -0500
Date: Thu, 10 Mar 2016 14:53:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: hans.verkuil@cisco.com, nenggun.kim@samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[media] au0828: use
 v4l2_mc_create_media_graph()"
Message-ID: <20160310145309.30c47210@recife.lan>
In-Reply-To: <56E19DDE.9080307@osg.samsung.com>
References: <1457493972-4063-1-git-send-email-shuahkh@osg.samsung.com>
	<56E19DDE.9080307@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Mar 2016 09:16:30 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/08/2016 08:26 PM, Shuah Khan wrote:
> > This reverts commit 9822f4173f84cb7c592edb5e1478b7903f69d018.
> > This commit breaks au0828_enable_handler() logic to find the tuner.
> > Audio, Video, and Digital applications are broken and fail to start
> > streaming with tuner busy error even when tuner is free.
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > ---
> >  drivers/media/usb/au0828/au0828-video.c | 103 ++++++++++++++++++++++++++++++--
> >  drivers/media/v4l2-core/v4l2-mc.c       |  21 +------
> >  2 files changed, 99 insertions(+), 25 deletions(-)
> >   
> 
> Hi Mauro,
> 
> Please pull this revert in as soon as possible. Without
> the revert, auido, video, and digital applications won't
> start even. There is a bug in the common routine introduced
> in the commit 9822f4173f84cb7c592edb5e1478b7903f69d018 which
> causes the link between source and sink to be not found.
> I am testing on WIn-TV HVR 950Q

No, this patch didn't seem to have broken anything. The problems
you're reporting seem to be related, instead, to this patch:

	https://patchwork.linuxtv.org/patch/33422/

I rebased it on the top of the master tree (without reverting this
patch).

Please check if it solved for you.

Yet, I'm seeing several troubles with au0828 after your patch series:

1) when both snd-usb-audio and au0828 are compiled as module and not
blacklisted, I'm getting some errors:
	http://pastebin.com/nMzr3ueM

2) removing/reprobing au0828 driver ~3 times, the Kernel becomes
unstable. Probably, some kobj ref were decremented every time a
module insert/removal pair is called from userspace, causing the
kref to reach zero, thus causing the trouble;

3) the media entities that should have been created by
media_snd_stream_init() are never created. Maybe this is related
with (1).

Please check.

Regards,
Mauro
