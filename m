Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33939 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754542AbaHENAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Aug 2014 09:00:42 -0400
Date: Tue, 5 Aug 2014 16:00:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH for v3.17 2/2] DocBook media: update version number and
 V4L2 changes
Message-ID: <20140805130035.GB16460@valkosipuli.retiisi.org.uk>
References: <1407143943-4557-1-git-send-email-hverkuil@xs4all.nl>
 <1407143943-4557-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407143943-4557-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 04, 2014 at 11:19:03AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Note: the revision text for the v4l2_pix_format change from Laurent
> erroneously mentioned 3.16 when it only got merged for 3.17. Fixed
> that as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/compat.xml | 24 ++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/v4l2.xml   | 11 ++++++-----
>  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index eee6f0f..3a626d1 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2545,6 +2545,30 @@ fields changed from _s32 to _u32.
>        </orderedlist>
>      </section>
>  
> +    <section>
> +      <title>V4L2 in Linux 3.16</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Added event V4L2_EVENT_SOURCE_CHANGE.
> +	  </para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
> +    <section>
> +      <title>V4L2 in Linux 3.17</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Extended &v4l2-pix-format;. Added format flags.
> +	  </para>
> +        </listitem>
> +        <listitem>
> +	  <para>Added compound control types and &VIDIOC-QUERY-EXT-CTRL;.
> +	  </para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index f2f81f0..7cfe618 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -152,10 +152,11 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> -	<revnumber>3.16</revnumber>
> -	<date>2014-05-27</date>
> -	<authorinitials>lp</authorinitials>
> -	<revremark>Extended &v4l2-pix-format;. Added format flags.
> +	<revnumber>3.17</revnumber>
> +	<date>2014-08-04</date>
> +	<authorinitials>lp, hv</authorinitials>
> +	<revremark>Extended &v4l2-pix-format;. Added format flags. Added compound control types

Shouldn't 3.16 and 3.17 still have separate entries, or did the first two
changes make it to 3.17 only?

With the above considered, for both:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +and VIDIOC_QUERY_EXT_CTRL.
>  	</revremark>
>        </revision>
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
