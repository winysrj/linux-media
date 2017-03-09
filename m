Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:45358 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdCIV7M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 16:59:12 -0500
Date: Thu, 9 Mar 2017 18:58:45 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Anton Sviridenko <anton@corp.bluecherry.net>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Utkin <andrey_utkin@fastmail.com>
Subject: Re: [PATCH] [media] solo6x10: release vb2 buffers in
 solo_stop_streaming()
Message-ID: <20170309215842.GB2940@pirotess.bf.iodev.co.uk>
References: <20170308174704.GA22020@magpie-gentoo>
 <20170308215930.GA14151@dell-m4800>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308215930.GA14151@dell-m4800>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/Mar/2017 21:59, Andrey Utkin wrote:
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Signed-off-by: Andrey Utkin <andrey_utkin@fastmail.com>
> 
> Please welcome Anton who is now in charge of solo6x10 and tw5864 support
> and development in Bluecherry company, I have sent out to him the
> hardware samples I possessed. (We will prepare the patch updating
> MAINTAINERS file soon.)
> 
> If anybody has any outstanding complains, concerns or tasks regarding
> solo6x10 and tw5864 drivers, I think now is good occasion to let us know
> about it.

Welcome Anton!

The first issue that comes to mind is that quantization matrices
need to be adjusted since forever. Also it needs more realistic
buffer sizes.
