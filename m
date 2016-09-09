Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53031
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753371AbcIIPXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 11:23:34 -0400
Date: Fri, 9 Sep 2016 23:23:20 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Andrey Utkin <andrey_utkin@fastmail.com>
cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        kernel-janitors@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Sergey Kozlov <serjk@netup.ru>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] pci: constify vb2_ops structures
In-Reply-To: <20160909150716.daols6gymz2miiko@zver>
Message-ID: <alpine.DEB.2.10.1609092322490.2832@hadrien>
References: <1473379158-17344-1-git-send-email-Julia.Lawall@lip6.fr> <20160909091741.re5ll3jelooeitpv@zver> <alpine.DEB.2.10.1609092231090.2832@hadrien> <20160909150716.daols6gymz2miiko@zver>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 9 Sep 2016, Andrey Utkin wrote:

> On Fri, Sep 09, 2016 at 10:31:30PM +0800, Julia Lawall wrote:
> > Will this soon reach linux-next?
>
> No idea. Indeed it's simpler if you leave your patch as is, and then
> later we patch this new driver separately.

OK, thanks.

julia
