Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54325 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751044AbbAMJfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 04:35:37 -0500
Date: Tue, 13 Jan 2015 11:35:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: smiapp-core.c error if !defined(CONFIG_OF)
Message-ID: <20150113093504.GE17565@valkosipuli.retiisi.org.uk>
References: <54B4DD2D.7030303@xs4all.nl>
 <20150113093135.GD17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113093135.GD17565@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 13, 2015 at 11:31:35AM +0200, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Jan 13, 2015 at 09:54:05AM +0100, Hans Verkuil wrote:
> > Hi Sakari,
> > 
> > The daily build fails because of this error:
> > 
> > media_build/v4l/smiapp-core.c: In function 'smiapp_get_pdata':
> > media_build/v4l/smiapp-core.c:3061:3: error: implicit declaration of function 'of_read_number' [-Werror=implicit-function-declaration]
> >    pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
> >    ^
> > 
> > Some digging showed that of_read_number is only available if CONFIG_OF
> > is defined. As far as I can see that is actually a bug in linux/of.h, as
> > I see no reason why it should be under CONFIG_OF.
> 
> Well, it could be defined I guess --- it shouldn't have any use if OF isn't
> in use. I'll submit a patch for that.

Or not. There are a number of functions that are available only if CONFIG_OF
is defined, this is not an only case. If the drivers are happy with that, I
guess it's fine. I think a better solution might be to define a header for
drivers to include.

The issue in the smiapp driver is indeed better fixed by using the right
function to read the 64-bit unsigned integer array.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
