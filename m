Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58755 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755830Ab2ENMqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 08:46:16 -0400
Date: Mon, 14 May 2012 15:46:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [ANN] Selection API naming meeting #v4l-meeting next Monday
Message-ID: <20120514124611.GI3373@valkosipuli.retiisi.org.uk>
References: <20120510201849.GC3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510201849.GC3373@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 10, 2012 at 11:18:49PM +0300, Sakari Ailus wrote:
> Hi all,
> 
> Let's have a quick meeting 14:00 Finnish time (GMT + 3) next Monday on
> #v4l-meeting on two topics:
> 
> - Selection target naming. It has been proposed that the _ACTUAL / _ACTIVE
>   be removed and e.g. the crop targets would be then called
>   V4L2_SEL_TGT_CROP and V4L2_SUBDEV_SEL_TGT_CROP on V4L2 and subdve
>   interfaces, respectively.
> 
> - Unifying selection targets on subdevs and V4L2 API. Currently the IDs of
>   mostly equivalent targets are the same, but there are subtle differences
>   between the targets in some cases. We still have documented everything
>   twice, even if the differences are subtle. Would it make sese to unify the
>   two, and just mention the differences?

Hi all,

The meeting log is available here:

<URL:http://www.retiisi.org.uk/v4l2/notes/v4l2-selections-rename-2012-05-14.txt>

Short summary: we decided that the _ACTUAL/_ACTIVE can be removed from
selection target names, and that the selection targets can be unified
between V4L2 and V4L2 subdev interfaces.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
