Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48744 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbeEGPqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:46:39 -0400
Date: Mon, 7 May 2018 12:46:27 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 01/28] v4l2-device.h: always expose mdev
Message-ID: <20180507124627.5054b56f@vento.lan>
In-Reply-To: <20180504105128.fruwu2jofn2iz5gt@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
        <20180503145318.128315-2-hverkuil@xs4all.nl>
        <20180504105128.fruwu2jofn2iz5gt@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 4 May 2018 13:51:28 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Thu, May 03, 2018 at 04:52:51PM +0200, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The mdev field is only present if CONFIG_MEDIA_CONTROLLER is set.
> > But since we will need to pass the media_device to vb2 and the
> > control framework it is very convenient to just make this field
> > available all the time. If CONFIG_MEDIA_CONTROLLER is not set,
> > then it will just be NULL.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>  
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

This patch is no-brainer. It could be sent no matter what. However,
the patch is too simple :-)

There are a number of places where if CONFIG_MEDIA_CONTROLLER
(and for CONFIG_MEDIA_CONTROLLER_DVB - with is also optionally 
added at DVB core) is tested just because the field may or may
not be there.

If we're willing to always have it at the struct, then we should look
on all #ifs for CONFIG_MEDIA_CONTROLLER and get rid of most (or all)
of them, ensuring that function stubs will be enough for the code
itself to do the right thing if !CONFIG_MEDIA_CONTROLLER.

Thanks,
Mauro
