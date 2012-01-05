Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab2AEPzI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 10:55:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 02/17] v4l: Document integer menu controls
Date: Thu, 5 Jan 2012 16:55:25 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1324412889-17961-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201051655.25660.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 20 December 2011 21:27:54 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/compat.xml         |   10 +++++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    7 ++++
>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |   39
> +++++++++++++++++++- 3 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml
> b/Documentation/DocBook/media/v4l/compat.xml index b68698f..569efd1 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2379,6 +2379,16 @@ that used it. It was originally scheduled for
> removal in 2.6.35. </orderedlist>
>      </section>
> 
> +    <section>
> +      <title>V4L2 in Linux 3.3</title>

Seems it will be for 3.4 :-) Same for Documentation/DocBook/media/v4l/v4l2.xml

> +      <orderedlist>
> +        <listitem>
> +	  <para>Added integer menus, the new type will be
> +	  V4L2_CTRL_TYPE_INTEGER_MENU.</para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> 

-- 
Regards,

Laurent Pinchart
