Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62987 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3FMJ4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 05:56:42 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so7557753pdj.17
        for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 02:56:41 -0700 (PDT)
Date: Thu, 13 Jun 2013 17:56:47 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"open list:USB VIDEO CLASS" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default
 on uvcvideo"
Message-ID: <20130613095647.GC21583@adam-laptop>
References: <1366790239-838-1-git-send-email-adam.lee@canonical.com>
 <6159110.qEtHHiJYtm@avalon>
 <20130425063306.GA20928@adam-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425063306.GA20928@adam-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 25, 2013 at 02:33:06PM +0800, Adam Lee wrote:
> On Wed, Apr 24, 2013 at 11:17:52AM +0200, Laurent Pinchart wrote:
> > Hi Adam,
> > 
> > Thanks for the patch.
> > 
> > On Wednesday 24 April 2013 15:57:19 adam.lee@canonical.com wrote:
> > > From: Adam Lee <adam.lee@canonical.com>
> > > 
> > > This reverts commit 3dae8b41dc5651f8eb22cf310e8b116480ba25b7.
> > > 
> > > 1, I do have a Chicony webcam, implements autosuspend in a broken way,
> > > make `poweroff` performs rebooting when its autosuspend enabled.
> > > 
> > > 2, There are other webcams which don't support autosuspend too, like
> > > https://patchwork.kernel.org/patch/2356141/
> > > 
> > > 3, kernel removed USB_QUIRK_NO_AUTOSUSPEND in
> > > a691efa9888e71232dfb4088fb8a8304ffc7b0f9, because autosuspend is
> > > disabled by default.
> > > 
> > > So, we need to disable autosuspend in uvcvideo, maintaining a quirk list
> > > only for uvcvideo is not a good idea.
> > 
> > I've received very few bug reports about broken auto-suspend support in UVC 
> > devices. Most of them could be solved by setting the RESET_RESUME quirk in USB 
> > core, only the Creative Live! Cam Optia AF required a quirk in the uvcvideo 
> > driver. I would thus rather use the available quirks (USB_QUIRK_RESET_RESUME 
> > if possible, UVC_QUIRK_DISABLE_AUTOSUSPEND otherwise) than killing power 
> > management for the vast majority of webcams that behave correctly.
> 
> Here comes another one, integrated Chicony webcam 04f2:b39f, its
> autosuspend makes `poweroff` performs rebooting at the laptop I'm
> working on. I tried USB_QUIRK_RESET_RESUME, not helping.
> 
> The quirks list will go longer and longer absolutely, do uvcvideo wanna
> maintain that? And why only uvcvideo do this in kernel space which
> against general USB module?
> 
> I still suggest we disable it by default, people can enable it in udev
> just like almost all distroes do for udisks. Please consider about it.

Hi, Laurent

Any comment of this? I still think it's a risk to enable autosuspend in
uvcvideo by default, there must be users meeting weird issues but didn't
report to you becaue they didn't figured out the cause.

-- 
Regards,
Adam Lee
Hardware Enablement
