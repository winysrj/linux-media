Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48598 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1ICH0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2011 03:26:17 -0400
Received: from hillosipuli.localdomain (nblzone-211-213.nblnetworks.fi [83.145.211.213])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-68.nebula.fi (Postfix) with ESMTP id 573D543F0438
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 10:26:14 +0300 (EEST)
Received: from valkosipuli.localdomain (valkosipuli.localdomain [192.168.4.2])
	by hillosipuli.localdomain (Postfix) with ESMTP id BC7BA60099
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 10:26:13 +0300 (EEST)
Date: Sat, 3 Sep 2011 10:26:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Remove experimental note from ENUM_FRAMESIZES and
 ENUM_FRAMEINTERVALS
Message-ID: <20110903072612.GG13242@valkosipuli.localdomain>
References: <1315002508-11651-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315002508-11651-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 03, 2011 at 01:28:28AM +0300, Sakari Ailus wrote:
> VIDIOC_ENUM_FRAMESIZES and VIDIOC_FRAME_INTERVALS have existed for quite
> some time, are widely supported by various drivers and are being used by
> applications. Thus they no longer can be considered experimental.

I mostly intended to send this as RFC/PATCH (but forgot to give right
options to git format-patch) to provoke a little bit discussion on how we
should remove the experimental tags from features. These two ioctls are such
that I'm aware are relatively widely used. No idea about the rest.

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/compat.xml         |    4 ----
>  .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |    7 -------
>  2 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index ce1004a..a6261c1 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2458,10 +2458,6 @@ and may change in the future.</para>
>  &VIDIOC-QUERYCAP; ioctl, <xref linkend="device-capabilities" />.</para>
>          </listitem>
>          <listitem>
> -	  <para>&VIDIOC-ENUM-FRAMESIZES; and
> -&VIDIOC-ENUM-FRAMEINTERVALS; ioctls.</para>
> -        </listitem>
> -        <listitem>
>  	  <para>&VIDIOC-G-ENC-INDEX; ioctl.</para>
>          </listitem>
>          <listitem>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> index f77a13f..a78454b 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> @@ -50,13 +50,6 @@ and pixel format and receives a frame width and height.</para>
>    <refsect1>
>      <title>Description</title>
>  
> -    <note>
> -      <title>Experimental</title>
> -
> -      <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -    </note>
> -
>      <para>This ioctl allows applications to enumerate all frame sizes
>  (&ie; width and height in pixels) that the device supports for the
>  given pixel format.</para>
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
sakari.ailus@iki.fi
