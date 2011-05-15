Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51758 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1EOVN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 17:13:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v2 1/1] v4l: Document EACCES in VIDIOC_[GS]_CTRL and VIDIOC_{G,S,TRY}_EXT_CTRLS
Date: Sun, 15 May 2011 23:14:34 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
References: <1305473638-19440-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1305473638-19440-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105152314.34321.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 15 May 2011 17:33:58 Sakari Ailus wrote:
> VIDIOC_S_CTRL and VIDIOC_S_EXT_CTRLS return EACCES when setting a read-only
> control VIDIOC_TRY_EXT_CTRLS when trying a read-only control and
> VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS when getting a write-only control.
> Document this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/v4l/vidioc-g-ctrl.xml      |    7 +++++++
>  Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml |    7 +++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
> b/Documentation/DocBook/v4l/vidioc-g-ctrl.xml index 8b5e6ff..5146d00
> 100644
> --- a/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
> +++ b/Documentation/DocBook/v4l/vidioc-g-ctrl.xml
> @@ -117,6 +117,13 @@ because another applications took over control of the
> device function this control belongs to.</para>
>  	</listitem>
>        </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EACCES</errorcode></term>
> +	<listitem>
> +	  <para>Attempt to set a read-only control or to get a
> +	  write-only control.</para>
> +	</listitem>
> +      </varlistentry>
>      </variablelist>
>    </refsect1>
>  </refentry>
> diff --git a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
> b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml index 3aa7f8f..5e73517
> 100644
> --- a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
> @@ -294,6 +294,13 @@ The field <structfield>size</structfield> is set to a
> value that is enough to store the payload and this error code is
> returned.</para>
>  	</listitem>
>        </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EACCES</errorcode></term>
> +	<listitem>
> +	  <para>Attempt to try or set a read-only control or to get a
> +	  write-only control.</para>
> +	</listitem>
> +      </varlistentry>
>      </variablelist>
>    </refsect1>
>  </refentry>

-- 
Regards,

Laurent Pinchart
