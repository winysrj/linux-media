Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49298 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754383AbcCWJkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 05:40:55 -0400
Date: Wed, 23 Mar 2016 11:40:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] EDID/DV_TIMINGS docbook fixes
Message-ID: <20160323094019.GI11084@valkosipuli.retiisi.org.uk>
References: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1458642629-15742-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 22, 2016 at 11:30:26AM +0100, Hans Verkuil wrote:
> Fixes a few issues I found in the documentation.
> 
> Hans Verkuil (3):
>   vidioc-g-edid.xml: be explicit about zeroing the reserved array
>   vidioc-enum-dv-timings.xml: explicitly state that pad and reserved
>     should be zeroed
>   vidioc-dv-timings-cap.xml: explicitly state that pad and reserved
>     should be zeroed
> 
>  Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml  | 12 +++++++-----
>  Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml |  5 +++--
>  Documentation/DocBook/media/v4l/vidioc-g-edid.xml          | 10 ++++++----
>  3 files changed, 16 insertions(+), 11 deletions(-)

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
