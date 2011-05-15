Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52955 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1EOHte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 03:49:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/1] v4l: Document EACCES in VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS
Date: Sun, 15 May 2011 09:50:36 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
References: <1305293053-16448-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1305293053-16448-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105150950.37107.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Friday 13 May 2011 15:24:13 Sakari Ailus wrote:
> VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS return EACCES when setting a read-only
> control or getting a write-only control.  Document this.

You might want to modify the commit message to include VIDIOC_S_CTRL and 
VIDIOC_S_EXT_CTRLS. Setting a control with the VIDIOC_G_(EXT_)CTRL(S) ioctls 
is a bit difficult :-)

> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
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

Should you s/set/try or set/ ?

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
