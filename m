Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50368 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753099AbeDQNfb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:35:31 -0400
Date: Tue, 17 Apr 2018 10:35:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] media: v4l2-compat-ioctl32: fix several __user
 annotations
Message-ID: <20180417103521.28e5e120@vento.lan>
In-Reply-To: <e514a081-e70a-a6fb-d083-a5cc9e985f4f@cisco.com>
References: <cover.1523960171.git.mchehab@s-opensource.com>
        <510d0652872c612db21be8b846755f80e3cc4588.1523960171.git.mchehab@s-opensource.com>
        <a150928f-c236-4751-b704-7ce71fd56bc2@cisco.com>
        <20180417075358.61a878c8@vento.lan>
        <b3ed6478-9cf5-478d-067b-5d325dfeaadd@cisco.com>
        <20180417100131.3add7f67@vento.lan>
        <e514a081-e70a-a6fb-d083-a5cc9e985f4f@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Apr 2018 15:11:10 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> >> Be aware that the unsigned char * cast is actually a bug: it will clamp the
> >> u32 'blocks' value to a u8.
> >>
> >> Regards,
> >>
> >> 	Hans  
> > 
> > What about this approach (code untested)?  
> 
> I prefer the explicit casts. These are special situations and hiding it in
> defines makes it actually harder to follow.

There are just one special case there: USERPTR, where we force a cast
to unsigned long:

drivers/media/v4l2-core/v4l2-compat-ioctl32.c:              put_user((unsigned long)compat_ptr(p), &p64->m.userptr))
...
drivers/media/v4l2-core/v4l2-compat-ioctl32.c:                      put_user((unsigned long)compat_ptr(userptr),
drivers/media/v4l2-core/v4l2-compat-ioctl32.c-                               &p64->m.userptr))

I kept it out of the macros.

IMO, maintaining the code with the type_of() is more error-prune, as
the cast will be done the way it should. The cases where some other
cast like is needed - with is what it was done for USERPTR should
be explicit (and, btw, they should be properly documented why doing
that).

I don't remember anymore why it is casting to unsigned long,
but, based on v4l2-compliance tests, it seems that such cast works.

Thanks,
Mauro
