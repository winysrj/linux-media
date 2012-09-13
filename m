Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab2IMKQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 14/28] DocBook: clarify that sequence is also set for output devices.
Date: Thu, 13 Sep 2012 04:28:41 +0200
Message-ID: <1972373.6VO1sanVZv@avalon>
In-Reply-To: <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:14 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> It was not entirely obvious that the sequence count should also
> be set for output devices. Also made it more explicit that this
> sequence counter counts frames, not fields.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index b680d66..d1c2369 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -617,8 +617,8 @@ field is independent of the
> <structfield>timestamp</structfield> and <entry>__u32</entry>
>  	    <entry><structfield>sequence</structfield></entry>
>  	    <entry></entry>
> -	    <entry>Set by the driver, counting the frames in the
> -sequence.</entry>
> +	    <entry>Set by the driver, counting the frames (not fields!) in the
> +sequence. This field is set for both input and output devices.</entry>

Nitpicking, s/in the sequence/in sequence/ ?

>  	  </row>
>  	  <row>
>  	    <entry spanname="hspan"><para>In <link

-- 
Regards,

Laurent Pinchart

