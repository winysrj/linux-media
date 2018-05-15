Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752950AbeEOMAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 08:00:01 -0400
Date: Tue, 15 May 2018 08:59:53 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180515085953.65bfa107@vento.lan>
In-Reply-To: <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
        <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
        <20180423152455.363d285c@vento.lan>
        <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
        <20180423161742.66f939ba@vento.lan>
        <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
        <20180426204241.03a42996@vento.lan>
        <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 May 2018 22:31:37 -0500
"Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:

> Hi Mauro,
> 
> On 04/26/2018 06:42 PM, Mauro Carvalho Chehab wrote:
> 
> >>
> >> I noticed you changed the status of this series from rejected to new.
> > 
> > Yes.
> > 
> >> Also, there are other similar issues in media/pci/
> > 
> > Well, the issues will be there everywhere on all media drivers.
> > 
> > I marked your patches because I need to study it carefully, after
> > Peter's explanations. My plan is to do it next week. Still not
> > sure if the approach you took is the best one or not.
> > 
> > As I said, one possibility is to change the way v4l2-core handles
> > VIDIOC_ENUM_foo ioctls, but that would be make harder to -stable
> > backports.
> > 
> > I need a weekend to sleep on it.
> > 
> 
> I'm curious about how you finally resolved to handle these issues.
> 
> I noticed Smatch is no longer reporting them.

There was no direct fix for it, but maybe this patch has something
to do with the smatch error report cleanup:

commit 3ad3b7a2ebaefae37a7eafed0779324987ca5e56
Author: Sami Tolvanen <samitolvanen@google.com>
Date:   Tue May 8 13:56:12 2018 -0400

    media: v4l2-ioctl: replace IOCTL_INFO_STD with stub functions
    
    This change removes IOCTL_INFO_STD and adds stub functions where
    needed using the DEFINE_V4L_STUB_FUNC macro. This fixes indirect call
    mismatches with Control-Flow Integrity, caused by calling standard
    ioctls using a function pointer that doesn't match the function type.
    
    Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
    Signed-off-by: Hans Verkuil <hansverk@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>



> 
> Thanks
> --
> Gustavo



Thanks,
Mauro
