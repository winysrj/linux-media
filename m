Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37973 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754128AbdCJQDJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 11:03:09 -0500
Received: by mail-wm0-f41.google.com with SMTP id t189so13927859wmt.1
        for <linux-media@vger.kernel.org>; Fri, 10 Mar 2017 08:03:08 -0800 (PST)
Date: Fri, 10 Mar 2017 20:03:44 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: release vb2 buffers in
 solo_stop_streaming()
Message-ID: <20170310160343.GA4406@magpie-gentoo>
References: <20170308174704.GA22020@magpie-gentoo>
 <20170308215930.GA14151@dell-m4800>
 <20170309215842.GB2940@pirotess.bf.iodev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170309215842.GB2940@pirotess.bf.iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 09, 2017 at 06:58:45PM -0300, Ismael Luceno wrote:
> On 08/Mar/2017 21:59, Andrey Utkin wrote:
> > Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> > Signed-off-by: Andrey Utkin <andrey_utkin@fastmail.com>
> > 
> > Please welcome Anton who is now in charge of solo6x10 and tw5864 support
> > and development in Bluecherry company, I have sent out to him the
> > hardware samples I possessed. (We will prepare the patch updating
> > MAINTAINERS file soon.)
> > 
> > If anybody has any outstanding complains, concerns or tasks regarding
> > solo6x10 and tw5864 drivers, I think now is good occasion to let us know
> > about it.
> 
> Welcome Anton!
> 
> The first issue that comes to mind is that quantization matrices
> need to be adjusted since forever. Also it needs more realistic
> buffer sizes.

Hi Ismael,

can you provide more details about quantization matrices issue and
buffer sizes?
