Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbcC3TNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 15:13:53 -0400
Subject: Re: [PATCH v3 2/2] [media] DocBook: update error code in
 videoc-streamon
To: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
References: <cover.1459363790.git.helen.koike@collabora.co.uk>
 <77998a67791470bc947beb421bec9a5c28fb5fd5.1459363790.git.helen.koike@collabora.co.uk>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56FC256C.4030809@linux.intel.com>
Date: Wed, 30 Mar 2016 22:13:48 +0300
MIME-Version: 1.0
In-Reply-To: <77998a67791470bc947beb421bec9a5c28fb5fd5.1459363790.git.helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Helen Mae Koike Fornazier wrote:
> Add description of ENOLINK error
>
> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
> ---
>
> The patch set is based on 'media/master' branch and available at
>          https://github.com/helen-fornazier/opw-staging media/devel
>
> Changes since v2:
> 	* this is a new commit in the set
>
>   Documentation/DocBook/media/v4l/vidioc-streamon.xml | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> index df2c63d..c4b88b0 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
> @@ -123,6 +123,14 @@ synchronize with other events.</para>
>   	  </para>
>   	</listitem>
>         </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ENOLINK</errorcode></term>
> +	<listitem>
> +	  <para>The driver implements Media Controller interface and
> +	  the pipeline configuration is invalid.

...pipeline link configuration...

Then it's apparent this is really about links (and not e.g. about formats).

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +	  </para>
> +	</listitem>
> +      </varlistentry>
>       </variablelist>
>     </refsect1>
>   </refentry>
>


-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
