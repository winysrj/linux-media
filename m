Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33108 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751667AbcIHDIW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 23:08:22 -0400
Date: Thu, 8 Sep 2016 11:08:06 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] pci: constify snd_pcm_ops structures
In-Reply-To: <20160908022755.mr45eulz4r7vfoo5@zver>
Message-ID: <alpine.DEB.2.10.1609081106070.6858@hadrien>
References: <1473295479-24615-1-git-send-email-Julia.Lawall@lip6.fr> <20160908022755.mr45eulz4r7vfoo5@zver>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 8 Sep 2016, Andrey Utkin wrote:

> Thanks for looking into this.
> I have tested that it compiles and passes checks (C=2) cleanly after
> this patch.
>
> Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
>
> While we're at it, what about constification of
> *-core.c:static struct pci_driver *_pci_driver = {
> *-video.c:static struct vb2_ops *_video_qops = {
> *-video.c:static struct video_device *_video_template = {
>
> in drivers/media/pci/? Also there are even more similar entries not
> constified yet in drivers/media/, however I may be underestimating
> complexity of making semantic rules for catching that all.

I will check on these.  Thanks for the suggestion.

julia
