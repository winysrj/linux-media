Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42650 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932698AbdIYKBb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:01:31 -0400
Date: Mon, 25 Sep 2017 13:01:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: Re: [PATCH] v4l2-ctrls.c: allow empty control handlers
Message-ID: <20170925100127.h6675epro4hawq6p@valkosipuli.retiisi.org.uk>
References: <98443a09-f861-0976-3b6e-cfd52c0cce43@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98443a09-f861-0976-3b6e-cfd52c0cce43@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 25, 2017 at 11:41:02AM +0200, Hans Verkuil wrote:
> If you have a control handler that does not contain any controls, then
> currently calling VIDIOC_G/S/TRY_EXT_CTRLS with count == 0 will return
> -EINVAL in the class_check() function.
> 
> This is not correct, there is no reason why this should return an error.
> 
> The purpose of setting count to 0 is to test if the ioctl can mix controls
> from different control classes. And this is possible. The fact that there
> are not actually any controls defined is another matter that is unrelated
> to this test.
> 
> This caused v4l2-compliance to fail, so that is fixed with this patch applied.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
