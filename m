Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35034 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752375AbaBSXQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 18:16:06 -0500
Date: Thu, 20 Feb 2014 01:15:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 22/35] DocBook media: update control section.
Message-ID: <20140219231521.GA15635@valkosipuli.retiisi.org.uk>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-23-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392631070-41868-23-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 17, 2014 at 10:57:37AM +0100, Hans Verkuil wrote:
...
> @@ -501,6 +511,32 @@ for (queryctrl.id = V4L2_CID_PRIVATE_BASE;;
>      </example>
>  
>      <example>
> +      <title>Enumerating all user controls (alternative)</title>
> +	<programlisting>
> +memset(&amp;queryctrl, 0, sizeof(queryctrl));
> +
> +queryctrl.id = V4L2_CTRL_CLASS_USER | V4L2_CTRL_FLAG_NEXT_CTRL;
> +while (0 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
> +	if (V4L2_CTRL_ID2CLASS(queryctrl.id) != V4L2_CTRL_CLASS_USER)
> +		break;
> +	if (queryctrl.flags &amp; V4L2_CTRL_FLAG_DISABLED)
> +		continue;
> +
> +	printf("Control %s\n", queryctrl.name);
> +
> +	if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
> +		enumerate_menu();
> +
> +	queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
> +}
> +if (errno != EINVAL) {
> +	perror("VIDIOC_QUERYCTRL");
> +	exit(EXIT_FAILURE);
> +}

This is wrong; errno is guaranteed to be valid only if there's been an
error.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
