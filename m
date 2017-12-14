Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36626 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752719AbdLNOFr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 09:05:47 -0500
Date: Thu, 14 Dec 2017 16:05:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mike Isely <isely@pobox.com>,
        Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
Subject: Re: [PATCH] pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
Message-ID: <20171214140545.3eibioqmjhqfk2yt@valkosipuli.retiisi.org.uk>
References: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 14, 2017 at 12:44:42AM +0100, Hans Verkuil wrote:
> The pvrusb2 code appears to have a some old workaround code for xawtv that causes a
> WARN() due to an unrecognized pixelformat 0 in v4l2_ioctl.c.
> 
> Since all other MPEG drivers fill this in correctly, it is a safe assumption that
> this particular problem no longer exists.
> 
> While I'm at it, clean up the code a bit.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
