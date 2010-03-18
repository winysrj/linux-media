Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38981 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0CRMUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 08:20:00 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 18 Mar 2010 07:19:57 -0500
Subject: RE: [PATCH 1/2] v4l: Add V4L2_CID_IRIS_ABSOLUTE and
 V4L2_CID_IRIS_RELATIVE controls
Message-ID: <A24693684029E5489D1D202277BE8944541CC73C@dlee02.ent.ti.com>
References: <1268913303-30565-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1268913303-30565-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1268913303-30565-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Just a minor grammar issue.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Thursday, March 18, 2010 6:55 AM
> To: linux-media@vger.kernel.org
> Subject: [PATCH 1/2] v4l: Add V4L2_CID_IRIS_ABSOLUTE and
> V4L2_CID_IRIS_RELATIVE controls
> 

<snip>

> 
>     <section id="other">
> diff --git a/Documentation/DocBook/v4l/controls.xml
> b/Documentation/DocBook/v4l/controls.xml
> index f464506..c412e89 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -1825,6 +1825,25 @@ wide-angle direction. The zoom speed unit is
> driver-specific.</entry>
>  	  <row><entry></entry></row>
> 
>  	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_IRIS_ABSOLUTE</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row><row><entry spanname="descr">This control sets the
> +camera aperture's to the specified value. The unit is undefined.

"camera's aperture"

> +Positive values open the iris, negative close it.</entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_IRIS_RELATIVE</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row><row><entry spanname="descr">This control modifies the
> +camera aperture's by the specified amount. The unit is undefined.

"camera's aperture"

Regards,
Sergio

<snip>
