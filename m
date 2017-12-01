Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34697 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752492AbdLAMHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 07:07:16 -0500
Date: Fri, 1 Dec 2017 10:07:03 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: pieterg <pieterg@gmx.com>
Cc: linux-media@vger.kernel.org
Subject: Re: multiple frontends on a single dvb adapter
Message-ID: <20171201100703.65f55a7e@vento.lan>
In-Reply-To: <2a083a5e-a3dd-6225-4201-a4d62333fcfa@gmx.com>
References: <2a083a5e-a3dd-6225-4201-a4d62333fcfa@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 1 Dec 2017 12:38:14 +0100
pieterg <pieterg@gmx.com> escreveu:

> Hi,
> 
> The recent removal of DMX_SET_SOURCE
> 
> https://github.com/torvalds/linux/commit/13adefbe9e566c6db91579e4ce17f1e5193d6f2c
> 
> and earlier removal of the set_source callback
> 
> https://github.com/torvalds/linux/commit/1e92bbe08ad9fc0d5ec05174c176a9bc54921733
> 
> leads to the question how the situation of having multiple frontends on
> a single dvb adapter should be handled nowadays.
> Suppose the routing is flexible, any demux could be sourced by any frontend.
> In the past, this has been achieved by using the set_source callback,
> allowing userspace to configure the routing by using the DMX_SET_SOURCE
> ioctl.
> 
> The connect_frontend / disconnect_frontend callbacks are currently only
> called for the memory frontend, so it seems no longer possible to select
> hardware frontends.
> How do you guys see this, what does the standard dictate in this case?
> Should we assume a 1:1 mapping between frontendN:demuxN and forbid
> dynamic routing? Or am I overlooking something?
> 
> In my opinion, supporting dynamic routing would be an advantage.
> Especially when the number of (hardware) demuxes is smaller than the
> number of (hardware) frontends.

The best way to support dynamic routing is via the media controller
API. the DVB core already creates media controller entities for
the existing hardware, but the links for the non-trivial case
(e. g. there's no 1:1 mapping) should be created by the driver.

The big advantage of using the media controller is that you could
dynamically setup the pipeline, not only between frontend and
demux, but also with some other hardware. For example, with that,
you could easily add a CI module at the pipeline, for an scrambled
channel, or remove it, when the channel doesn't require, or when
it is required to store a movie scrambled (that's usually required
for embedded systems). At reproduction, a pipeline with the CI
descrambler could be used.


Thanks,
Mauro
