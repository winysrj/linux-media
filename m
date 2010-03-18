Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0CRMUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 08:20:04 -0400
Message-ID: <4BA21A6D.30500@redhat.com>
Date: Thu, 18 Mar 2010 09:19:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v4l: Add V4L2_CID_IRIS_ABSOLUTE and V4L2_CID_IRIS_RELATIVE
 controls
References: <1268913303-30565-1-git-send-email-laurent.pinchart@ideasonboard.com> <1268913303-30565-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1268913303-30565-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Those control, as their names imply, control the camera aperture
> settings.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/v4l/compat.xml      |   11 +++++++++++
>  Documentation/DocBook/v4l/controls.xml    |   19 +++++++++++++++++++
>  Documentation/DocBook/v4l/videodev2.h.xml |    3 +++
>  include/linux/videodev2.h                 |    3 +++
>  4 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
> index b9dbdf9..854235b 100644
> --- a/Documentation/DocBook/v4l/compat.xml
> +++ b/Documentation/DocBook/v4l/compat.xml
> @@ -2332,6 +2332,17 @@ more information.</para>
>  	</listitem>
>        </orderedlist>
>      </section>
> +    <section>
> +      <title>V4L2 in Linux 2.6.34</title>
> +      <orderedlist>
> +	<listitem>
> +	  <para>Added
> +<constant>V4L2_CID_IRIS_ABSOLUTE</constant> and
> +<constant>V4L2_CID_IRIS_RELATIVE</constant> controls to the
> +	    <link linkend="camera-controls">Camera controls class</link>.
> +	  </para>
> +	</listitem>
> +      </orderedlist>
>     </section>
>  
>     <section id="other">
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index f464506..c412e89 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -1825,6 +1825,25 @@ wide-angle direction. The zoom speed unit is driver-specific.</entry>
>  	  <row><entry></entry></row>
>  
>  	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IRIS_ABSOLUTE</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row><row><entry spanname="descr">This control sets the
> +camera aperture's to the specified value. The unit is undefined.
> +Positive values open the iris, negative close it.</entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_IRIS_RELATIVE</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row><row><entry spanname="descr">This control modifies the
> +camera aperture's by the specified amount. The unit is undefined.
> +Positive values open the iris one step further, negative values close
> +it one step further. This is a write-only control.</entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +
> +	  <row>
>  	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
>  	    <entry>boolean</entry>
>  	  </row><row><entry spanname="descr">Prevent video from being acquired

Seems ok to me, but it would be good to add some sort of scale for those controls.

Cheers,
Mauro
