Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1589 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945894Ab3BGW5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 17:57:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC PATCH] ivtv-alsa: regression fix: remove __init from ivtv_alsa_load
Date: Thu, 7 Feb 2013 23:57:03 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201302071807.47221.hverkuil@xs4all.nl> <b5588d09-bb0a-4571-a580-78e34042f4e3@email.android.com>
In-Reply-To: <b5588d09-bb0a-4571-a580-78e34042f4e3@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072357.03659.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu February 7 2013 22:58:53 Andy Walls wrote:
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> >Andy,
> >
> >Please review this patch. This fix probably should be fast-tracked to
> >3.8 and
> >queued for stable 3.7.
> >
> >ivtv-alsa kept crashing my machine every time I loaded it, and this is
> >the
> >cause.
> >
> >Regards,
> >
> >	Hans
> >
> >This function is called after initialization, so it should never be
> >marked
> >__init!
> >
> >Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >---
> > drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c
> >b/drivers/media/pci/ivtv/ivtv-alsa-main.c
> >index 4a221c6..e970cfa 100644
> >--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
> >+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
> >@@ -205,7 +205,7 @@ err_exit:
> > 	return ret;
> > }
> > 
> >-static int __init ivtv_alsa_load(struct ivtv *itv)
> >+static int ivtv_alsa_load(struct ivtv *itv)
> > {
> > 	struct v4l2_device *v4l2_dev = &itv->v4l2_dev;
> > 	struct ivtv_stream *s;
> 
> Hans,
> 
> I concur.  Now I have to check cx18 for the same problem.

Hmm, there is the same problem in cx18 as well:

static int __init cx18_alsa_load(struct cx18 *cx)

Checking some more I saw that this __init annotation was added only in 3.8,
both for ivtv and cx18 (so 3.7 is fine).

Ah, I see that Mauro added __init accidentally when fixing some compiler
warnings in ivtv and cx18.

I'll make a pull request tomorrow morning removing the __init from ivtv_alsa_load
and cx18_alsa_load and ask Mauro to fast-track this regression.

I assume I have your SoB for this?

Regards,

	Hans

> 
> Your patch looks good.
> 
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
> 
> Regards,
> Andy  
> 
