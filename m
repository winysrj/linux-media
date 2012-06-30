Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f194.google.com ([209.85.215.194]:45061 "EHLO
	mail-ey0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2F3VBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 17:01:06 -0400
Received: by eaaa14 with SMTP id a14so374837eaa.1
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 14:01:04 -0700 (PDT)
Message-ID: <4FEF690D.10305@gmail.com>
Date: Sat, 30 Jun 2012 23:01:01 +0200
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 4/8] v4l: Common documentation for selection targets
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk> <1341075839-18586-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1341075839-18586-4-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/30/2012 07:03 PM, Sakari Ailus wrote:
> Both V4L2 and V4L2 subdev interface have very similar selection APIs with
> differences foremost related to in-memory and media bus formats. However,
> the selection targets are the same for both. Most targets are and in the
> future will likely continue to be more the same than with any differences.
> Thus it makes sense to unify the documentation of the targets.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
..
> diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
> new file mode 100644
> index 0000000..d0411ab
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/selections-common.xml
> @@ -0,0 +1,92 @@
> +<section id="v4l2-selections-common">
> +
> +<title>Selection targets</title>
> +
> +<para>While the<link linkend="selection-api">V4L2 selection
> +  API</link>  and<link linkend="v4l2-subdev-selections">V4L2 subdev
> +  selection APIs</link>  are very similar, there's one fundamental
> +  difference between the two. On sub-device API, the selection
> +  rectangle refers to the media bus format, and is bound to a
> +  sub-device's pad. On the V4L2 interface the selection rectangles
> +  refer to the in-memory pixel format.</para>
> +
> +<para>The precise meaning of the selection targets may thus be
> +  affected on which of the two interfaces they are used.</para>
> +
> +<table pgwide="1" frame="none" id="v4l2-selection-targets-table">
> +<title>Selection target definitions</title>
> +<tgroup cols="4">

s/4/5

Looks good otherwise.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

 > +<colspec colname="c1" />
 > +<colspec colname="c2" />
 > +<colspec colname="c3" />
 > +<colspec colname="c4" />
 > +<colspec colname="c5" />
 > +&cs-def;
 > +<thead>
