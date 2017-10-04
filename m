Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56490 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdJDUMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 16:12:53 -0400
Message-ID: <1507147945.2981.56.camel@collabora.com>
Subject: Re: [PATCH v3 02/15] [media] vb2: add explicit fence user API
From: Gustavo Padovan <gustavo.padovan@collabora.com>
To: Brian Starkey <brian.starkey@arm.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org, Jonathan.Chai@arm.com
Date: Wed, 04 Oct 2017 17:12:25 -0300
In-Reply-To: <20171002134212.GC22538@e107564-lin.cambridge.arm.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
         <20170907184226.27482-3-gustavo@padovan.org>
         <20171002134212.GC22538@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-10-02 at 14:42 +0100, Brian Starkey wrote:
> Hi,
> 
> On Thu, Sep 07, 2017 at 03:42:13PM -0300, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Turn the reserved2 field into fence_fd that we will use to send
> > an in-fence to the kernel and return an out-fence from the kernel
> > to
> > userspace.
> > 
> > Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be
> > used
> > when sending a fence to the kernel to be waited on, and
> > V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-
> > fence.
> 
> It seems a bit off to me to add this to the uapi, and document it,
> before any of the implementation is present in the kernel.
> 
> Wouldn't it be better to move this patch to be the last one, after
> all
> of the implementation is done?

Yes, that seems a better idea.

Gustavo
