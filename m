Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:61000 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbbJAMpH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 08:45:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ZhdEP-0000Hd-D5
	for linux-media@vger.kernel.org; Thu, 01 Oct 2015 14:45:05 +0200
Received: from p654785.hkidff01.ap.so-net.ne.jp ([121.101.71.133])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 14:45:05 +0200
Received: from yashi by p654785.hkidff01.ap.so-net.ne.jp with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 14:45:05 +0200
To: linux-media@vger.kernel.org
From: Yasushi SHOJI <yashi@atmark-techno.com>
Subject: Re: [RFC PATCH] media: uvc: *HACK* workaround uvc unregister device *HACK*
Date: Thu, 01 Oct 2015 21:08:34 +0900
Message-ID: <87io6qdc59.wl@dns1.atmark-techno.com>
References: <1412266187-28969-1-git-send-email-m.grzeschik@pengutronix.de>
	<1661627.kAJPFnURo3@avalon>
Mime-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
In-Reply-To: <1661627.kAJPFnURo3@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry to follow up on an old message, but:

On Fri, 31 Oct 2014 19:41:33 +0900,
Laurent Pinchart wrote:
> 
> On Thursday 02 October 2014 18:09:47 Michael Grzeschik wrote:
> > Currently the uvc_driver is not cleaning up its child devices if a
> > device is still in use. It leads to orphaned devices which are not
> > sitting on any interface. They get cleaned up on uvc_delete which will
> > be called on uvc_remove after the userspace application is closing the
> > stream. When PM_RUNTIME is used in the kernel, this leads to the
> > following backtrace for missing sysfs entries in the orphaned kobjects.
> > 
> > This patch is moving the device cleanup code for the child devices from
> > uvc_delete to uvc_unregister_video. It is an *HACK* workaround which
> > is ment to initiate the discussion for a proper solution.
> 
> Does https://patchwork.linuxtv.org/patch/26561/ help ? The usb_put_intf() and 
> usb_put_dev() calls could be moved to the end of the function to fix the 
> media_device_unregister() warning.

26561 does not seem to help, since I can reproduce the warning on 4.2.1

	4.2.0-1-amd64 #1 SMP Debian 4.2.1-2 (2015-09-27) x86_64 GNU/Linux

I haven't tried Michael's yet, but it seems, at least to me, that many
subsystem are having similar problem and proper fixes must be applied
per subsystem.  Is that the case right now?

ref:
  - https://bugzilla.redhat.com/show_bug.cgi?id=1174075
  - http://thread.gmane.org/gmane.linux.usb.general/119218/focus=85560
    - mention that this "is not new"
  - http://thread.gmane.org/gmane.linux.scsi/86237/focus=88328
-- 
             yashi


