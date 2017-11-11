Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52995 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751741AbdKKSCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 13:02:01 -0500
Date: Sat, 11 Nov 2017 18:01:59 +0000
From: Sean Young <sean@mess.org>
To: Laurent Caumont <lcaumont2@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
Message-ID: <20171111180159.fb33mc2t467ygfqw@gofer.mess.org>
References: <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org>
 <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
 <20171023185750.5m5qo575myogzbhz@gofer.mess.org>
 <CACG2urzH5dAtnasGfjiK1Y8owGcsn0VtRSEWX75A6mb0pyuSRw@mail.gmail.com>
 <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org>
 <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan>
 <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
 <20171111105643.ozwukzmdhalxhoho@gofer.mess.org>
 <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Nov 11, 2017 at 06:53:54PM +0100, Laurent Caumont wrote:
> Hi Sean,
> 
> I just realized that files in media_build/linux/driver are not
> associate with a git repository. They are retrieved by the build
> command.
> So, I cloned the linux-stable repository to generate the patch.

Great, thank you.

We need a Signed-off-by: line to accept your patch, see part 11 of

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Thanks,

Sean
