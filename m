Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40915 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbeA2OLL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 09:11:11 -0500
Date: Mon, 29 Jan 2018 12:11:03 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 08/12] v4l2-compat-ioctl32.c: fix ctrl_is_pointer
Message-ID: <20180129121057.07de64d1@vela.lan>
In-Reply-To: <20180127231857.jwn3c6a4vjnwcu2z@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
        <20180126124327.16653-9-hverkuil@xs4all.nl>
        <20180127231857.jwn3c6a4vjnwcu2z@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Jan 2018 01:18:57 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Hans,
> 

...

> > +
> > +	if (ops->vidioc_query_ext_ctrl)
> > +		ret = ops->vidioc_query_ext_ctrl(file, fh, &qec);  
> 
> Is there a need for this?
> 
> The only driver implementing vidioc_query_ext_ctrl op is the uvcvideo
> driver --- and it does not support string controls.

Well, one day, it could be added there, or some other driver may
need to implement it. So, better safe than sorry. I would keep it
(either as-is or with your suggestion)


Cheers,
Mauro
