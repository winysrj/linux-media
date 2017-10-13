Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38683 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdJMUQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 16:16:37 -0400
Date: Fri, 13 Oct 2017 17:16:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 09/17] media: cec-pin.h: convert comments for
 cec_pin_state into kernel-doc
Message-ID: <20171013171629.10950682@vento.lan>
In-Reply-To: <5c4a9146-3d05-6e42-88f7-f287ce4e085a@xs4all.nl>
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <41e0821221f6e601791c5e1e6ee74a0f26339a7e.1506548682.git.mchehab@s-opensource.com>
        <5c4a9146-3d05-6e42-88f7-f287ce4e085a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 17:48:21 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> > This enum is already documented, but it is not using a kernel-doc
> > format. Convert its format, in order to produce documentation.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> No, this does not belong in the kernel API doc. It is really just an internal
> API.
> 
> The only things that belong in this header are the two function prototypes
> and struct cec-pin_ops. Everything else should be moved to a cec-pin-priv.h
> header inside drivers/media/cec.

Ok. So, let's move the remaining stuff to cec-pin-priv.h.

> 
> If it is OK with you, then I'll take care of that.

Yeah, sure!

Regards,
Mauro
