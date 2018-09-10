Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58318 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbeIJUjA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:39:00 -0400
Message-ID: <2fa0428d6e20b3bf511cff3b282a627f6aa42337.camel@collabora.com>
Subject: Re: [PATCH 1/2] vicodec: Drop unneeded symbol dependency
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Date: Mon, 10 Sep 2018 12:44:12 -0300
In-Reply-To: <09c8a682-209a-e325-cc56-1224773eab61@xs4all.nl>
References: <20180910152154.14291-1-ezequiel@collabora.com>
         <09c8a682-209a-e325-cc56-1224773eab61@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-09-10 at 17:23 +0200, Hans Verkuil wrote:
> On 09/10/2018 05:21 PM, Ezequiel Garcia wrote:
> > The vicodec doesn't use the Subdev API, so drop the dependency.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/platform/vicodec/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/vicodec/Kconfig b/drivers/media/platform/vicodec/Kconfig
> > index 2503bcb1529f..ad13329e3461 100644
> > --- a/drivers/media/platform/vicodec/Kconfig
> > +++ b/drivers/media/platform/vicodec/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VIDEO_VICODEC
> >  	tristate "Virtual Codec Driver"
> > -	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> 
> But it definitely needs the MEDIA_CONTROLLER. That's what it should depend on.
> 

Does it really? The code have proper ifdefs.
