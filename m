Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48093 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750908AbcIIPHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 11:07:20 -0400
Date: Fri, 9 Sep 2016 18:07:16 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        kernel-janitors@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Sergey Kozlov <serjk@netup.ru>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] pci: constify vb2_ops structures
Message-ID: <20160909150716.daols6gymz2miiko@zver>
References: <1473379158-17344-1-git-send-email-Julia.Lawall@lip6.fr>
 <20160909091741.re5ll3jelooeitpv@zver>
 <alpine.DEB.2.10.1609092231090.2832@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1609092231090.2832@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 09, 2016 at 10:31:30PM +0800, Julia Lawall wrote:
> Will this soon reach linux-next?

No idea. Indeed it's simpler if you leave your patch as is, and then
later we patch this new driver separately.
