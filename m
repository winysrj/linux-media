Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54523 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcD2LOf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 07:14:35 -0400
Date: Fri, 29 Apr 2016 08:14:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Helen Koike <helen.koike@collabora.co.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL] two patches: pipeline validation error code
Message-ID: <20160429081430.224aac99@recife.lan>
In-Reply-To: <5720FE7B.6000002@collabora.co.uk>
References: <5720FE7B.6000002@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 15:01:31 -0300
Helen Koike <helen.koike@collabora.co.uk> escreveu:

> Hi Mauro,
> 
> Please pull the following patches correcting the returned error codes 
> and respective docs in the pipeline validation.
> 
> Regards,
> Helen
> 
> The following changes since commit 45c175c4ae9695d6d2f30a45ab7f3866cfac184b:
> 
>    [media] tw686x: avoid going past array (2016-04-26 06:38:53 -0300)
> 
> are available in the git repository at:
> 
>    https://github.com/helen-fornazier/opw-staging.git media/devel
> 
> for you to fetch changes up to 957f69645eae5faae6daa205e85471ef82752abc:
> 
>    [media] DocBook: update error code in videoc-streamon (2016-04-27 
> 14:14:11 -0300)

Hi Helen,

Not sure how you generated this pull request, but my script
didn't recognize it as a valid pull request.

My scripts use exactly the same format as the one produced
by "git request-pull" command without the "-p" flag.

PS.: I tried to remove the diff from the pull request and fix a
whitespace wrapper that your emailer seemed to do, but, even so,
it was not recognized.

This time, I manually apply the two patches from your tree, but
next time, please be sure to fix those issues if you intend to
send as a pull request (or otherwise, send as e-mails).

Regards,
Mauro


> 
> ----------------------------------------------------------------
> Helen Mae Koike Fornazier (2):
>        [media] media: change pipeline validation return error
>        [media] DocBook: update error code in videoc-streamon
> 
>   Documentation/DocBook/media/v4l/vidioc-streamon.xml | 8 ++++++++
>   drivers/media/media-entity.c                        | 2 +-
>   drivers/media/v4l2-core/v4l2-subdev.c               | 4 ++--
>   3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml 
> b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> index df2c63d..89fd7ce 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> @@ -123,6 +123,14 @@ synchronize with other events.</para>
>         </para>
>       </listitem>
>         </varlistentry>
> +      <varlistentry>
> +  <term><errorcode>ENOLINK</errorcode></term>
> +    <listitem>
> +      <para>The driver implements Media Controller interface and
> +      the pipeline link configuration is invalid.
> +      </para>
> +    </listitem>
> +      </varlistentry>
>       </variablelist>
>     </refsect1>
>   </refentry>
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index c53c1d5..d8a2299 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -445,7 +445,7 @@ __must_check int 
> __media_entity_pipeline_start(struct media_entity *entity,
>           bitmap_or(active, active, has_no_links, entity->num_pads);
> 
>           if (!bitmap_full(active, entity->num_pads)) {
> -            ret = -EPIPE;
> +            ret = -ENOLINK;
>               dev_dbg(entity->graph_obj.mdev->dev,
>                   "\"%s\":%u must be connected by an enabled link\n",
>                   entity->name,
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c 
> b/drivers/media/v4l2-core/v4l2-subdev.c
> index 224ea60..953eab0 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -510,7 +510,7 @@ int v4l2_subdev_link_validate_default(struct 
> v4l2_subdev *sd,
>       if (source_fmt->format.width != sink_fmt->format.width
>           || source_fmt->format.height != sink_fmt->format.height
>           || source_fmt->format.code != sink_fmt->format.code)
> -        return -EINVAL;
> +        return -EPIPE;
> 
>       /* The field order must match, or the sink field order must be NONE
>        * to support interlaced hardware connected to bridges that support
> @@ -518,7 +518,7 @@ int v4l2_subdev_link_validate_default(struct 
> v4l2_subdev *sd,
>        */
>       if (source_fmt->format.field != sink_fmt->format.field &&
>           sink_fmt->format.field != V4L2_FIELD_NONE)
> -        return -EINVAL;
> +        return -EPIPE;
> 
>       return 0;
>   }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
