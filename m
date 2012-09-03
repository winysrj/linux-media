Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37630 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932174Ab2ICOcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Sep 2012 10:32:50 -0400
Date: Mon, 3 Sep 2012 17:32:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 01/10] v4l: Remove experimental tag from certain
 API elements
Message-ID: <20120903143245.GC6834@valkosipuli.retiisi.org.uk>
References: <1346680124-15169-1-git-send-email-hverkuil@xs4all.nl>
 <c31da93f2bf615b90086d749e3f3eae6d6c3fc41.1346679785.git.hans.verkuil@cisco.com>
 <201209031707.53631@leon.remlab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209031707.53631@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 03, 2012 at 05:07:53PM +0300, Rémi Denis-Courmont wrote:
> Le lundi 3 septembre 2012 16:48:35, Hans Verkuil a écrit :
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Remove experimantal tag from the following API elements:
> > 
> > V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY buffer type.
> > V4L2_CAP_VIDEO_OUTPUT_OVERLAY capability flag.
> > VIDIOC_ENUM_FRAMESIZES IOCTL.
> 
> The patch correctly but silently clears ENUM_FRAMEINTERVALS too...

Good point. I had that in my original patch (for cleaning up the two enums
only) but didn't notice that when I reworked it.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
