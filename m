Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33684 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbcIHC17 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 22:27:59 -0400
Received: by mail-lf0-f47.google.com with SMTP id h127so11235542lfh.0
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 19:27:58 -0700 (PDT)
Date: Thu, 8 Sep 2016 05:27:55 +0300
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] pci: constify snd_pcm_ops structures
Message-ID: <20160908022755.mr45eulz4r7vfoo5@zver>
References: <1473295479-24615-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473295479-24615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for looking into this.
I have tested that it compiles and passes checks (C=2) cleanly after 
this patch.

Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

While we're at it, what about constification of
*-core.c:static struct pci_driver *_pci_driver = {
*-video.c:static struct vb2_ops *_video_qops = {
*-video.c:static struct video_device *_video_template = {

in drivers/media/pci/? Also there are even more similar entries not
constified yet in drivers/media/, however I may be underestimating
complexity of making semantic rules for catching that all.
