Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab2IYLZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:25:29 -0400
Message-ID: <1348572325.10028.5.camel@localhost.localdomain>
Subject: Re: [PATCH] [media] DocBook: Fix docbook compilation
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Tue, 25 Sep 2012 08:25:25 -0300
In-Reply-To: <201209132300.03671.hverkuil@xs4all.nl>
References: <1347567100-2256-1-git-send-email-mchehab@redhat.com>
	 <201209132300.03671.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Qui, 2012-09-13 às 23:00 +0200, Hans Verkuil escreveu:
> On Thu September 13 2012 22:11:40 Mauro Carvalho Chehab wrote:
> > changeset 1248c7cb66d734b60efed41be7c7b86909812c0e broke html compilation:
> > 
> > Documentation/DocBook/v4l2.xml:584: parser error : Entity 'sub-subdev-g-edid' not defined
> > Documentation/DocBook/v4l2.xml:626: parser error : chunk is not well balanced
> > Documentation/DocBook/media_api.xml:74: parser error : Failure to process entity sub-v4l2
> > Documentation/DocBook/media_api.xml:74: parser error : Entity 'sub-v4l2' not defined
> > 
> > I suspect that one file was simply missed at the patch.
> 
> Indeed. The missing vidioc-subdev-g-edid.xml file is here:
> 
> https://patchwork.kernel.org/patch/1209461/
> 
> I forgot to do a git add when I made the RFCv3, but that documentation file
> hasn't changed since RFCv2, so you can just use the one from RFCv2 and revert
> this patch.
> 
> My apologies, I haven't found a good way yet to check that I didn't forgot to
> add a file.

The above patch is not 100%:

Warning: multiple "IDs" for constraint linkend: v4l2-dv-tx-mode.
Warning: multiple "IDs" for constraint linkend: v4l2-dv-rgb-range.
Warning: multiple "IDs" for constraint linkend: v4l2-dv-tx-mode.
Warning: multiple "IDs" for constraint linkend: v4l2-dv-rgb-range.

Please fix it and re-send.

Thanks!
Mauro


> 
> Regards,
> 
> 	Hans
> 
> > Yet, keeping
> > it broken is a very bad idea, so we should either remove the broken
> > patch or to remove just the invalid include. Let's take the latter
> > approach.
> > 
> > Due to that, a warning is now produced:
> > 
> > Error: no ID for constraint linkend: v4l2-subdev-edid.
> > 
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  Documentation/DocBook/media/v4l/v4l2.xml | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > index 10ccde9..0292ed1 100644
> > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > @@ -581,7 +581,6 @@ and discussions on the V4L mailing list.</revremark>
> >      &sub-subdev-enum-frame-size;
> >      &sub-subdev-enum-mbus-code;
> >      &sub-subdev-g-crop;
> > -    &sub-subdev-g-edid;
> >      &sub-subdev-g-fmt;
> >      &sub-subdev-g-frame-interval;
> >      &sub-subdev-g-selection;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

