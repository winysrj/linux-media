Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4510 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2IIIrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 04:47:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [RFCv2 API PATCH 13/28] Add V4L2_CAP_MONOTONIC_TS where applicable.
Date: Sun, 9 Sep 2012 10:46:27 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com> <201209081733.32755@leon.remlab.net>
In-Reply-To: <201209081733.32755@leon.remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209091046.27702.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat September 8 2012 16:33:32 Rémi Denis-Courmont wrote:
> Le vendredi 7 septembre 2012 16:29:13, Hans Verkuil a écrit :
> > diff --git a/drivers/media/platform/davinci/vpbe_display.c
> > b/drivers/media/platform/davinci/vpbe_display.c index 9a05c81..3a50547
> > 100644
> > --- a/drivers/media/platform/davinci/vpbe_display.c
> > +++ b/drivers/media/platform/davinci/vpbe_display.c
> > @@ -620,7 +620,8 @@ static int vpbe_display_querycap(struct file *file,
> > void  *priv, struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
> > 
> >  	cap->version = VPBE_DISPLAY_VERSION_CODE;
> > -	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> > +	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> > +		V4L2_MONOTONIC_TS;
> 
> Typo ?

Absolutely!

Thanks for catching this.

Regards,

	Hans

> 
> >  	strlcpy(cap->driver, VPBE_DISPLAY_DRIVER, sizeof(cap->driver));
> >  	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
> >  	strlcpy(cap->card, vpbe_dev->cfg->module_name, sizeof(cap->card));
> 
> 
> 
