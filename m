Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54267 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbbAMJbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 04:31:38 -0500
Date: Tue, 13 Jan 2015 11:31:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: smiapp-core.c error if !defined(CONFIG_OF)
Message-ID: <20150113093135.GD17565@valkosipuli.retiisi.org.uk>
References: <54B4DD2D.7030303@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4DD2D.7030303@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jan 13, 2015 at 09:54:05AM +0100, Hans Verkuil wrote:
> Hi Sakari,
> 
> The daily build fails because of this error:
> 
> media_build/v4l/smiapp-core.c: In function 'smiapp_get_pdata':
> media_build/v4l/smiapp-core.c:3061:3: error: implicit declaration of function 'of_read_number' [-Werror=implicit-function-declaration]
>    pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
>    ^
> 
> Some digging showed that of_read_number is only available if CONFIG_OF
> is defined. As far as I can see that is actually a bug in linux/of.h, as
> I see no reason why it should be under CONFIG_OF.

Well, it could be defined I guess --- it shouldn't have any use if OF isn't
in use. I'll submit a patch for that.

The problem in the smiapp driver is better fixed by applying "smiapp: Use
of_property_read_u64_array() to read a 64-bit number array" instead. Could
you try that? I'll submit this as a fix then. of_read_number() was just a
workaround for missing of_property_read_u64_array().

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
