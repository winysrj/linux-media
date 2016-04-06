Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57098 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbcDFLuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 07:50:06 -0400
Date: Wed, 6 Apr 2016 14:50:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 0/2] videobuf2: Fix kernel memory overwriting
Message-ID: <20160406115002.GK32125@valkosipuli.retiisi.org.uk>
References: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixing Mauro's e-mail address...

On Wed, Apr 06, 2016 at 02:46:06PM +0300, Sakari Ailus wrote:
> Hi all,
> 
> In multi-planar API, the buffer length and m.planes fields are checked
> against the vb2 buffer before passing the buffer on to the core, but
> commit b0e0e1f83de31aa0428c38b692c590cc0ecd3f03 removed this check from
> VIDIOC_DQBUF path. This leads to kernel memory overwriting in certain
> cases.
> 
> This affects only v4.4 and newer and a very few drivers which use the
> multi-planar API. Due to the very limited scope of the issue this is not
> seen to require special handling.
> 
> The patches should be applied to the stable series, I'll add cc stable
> in the pull request.
> 
> -- 
> Kind regards,
> Sakari
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
