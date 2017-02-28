Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36714 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751966AbdB1JP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 04:15:58 -0500
Date: Tue, 28 Feb 2017 09:15:10 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] tw5864: handle unknown video std gracefully
Message-ID: <20170228091510.GA26160@stationary.pb.com>
References: <20170227203252.3295528-1-arnd@arndb.de>
 <20170228010803.GA7977@dell-m4800.Home>
 <CAK8P3a0GgrDsQeCzXJvRn+a5u1JavVhRZ+7q7ztYrTP2W5XoNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0GgrDsQeCzXJvRn+a5u1JavVhRZ+7q7ztYrTP2W5XoNw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2017 at 09:20:53AM +0100, Arnd Bergmann wrote:
> On Tue, Feb 28, 2017 at 2:08 AM, Andrey Utkin
> <andrey.utkin@corp.bluecherry.net> wrote:
> > Retcode checking takes place everywhere, but currently it overwrites
> > supplied structs with potentially-uninitialized values. To make it
> > cleaner, it should be (e.g. tw5864_g_parm())
> >
> > ret = tw5864_frameinterval_get(input, &cp->timeperframe);
> > if (ret)
> >         return ret;
> > cp->timeperframe.numerator *= input->frame_interval;
> > cp->capturemode = 0;
> > cp->readbuffers = 2;
> > return 0;
> >
> > and not
> >
> > ret = tw5864_frameinterval_get(input, &cp->timeperframe);
> > cp->timeperframe.numerator *= input->frame_interval;
> > cp->capturemode = 0;
> > cp->readbuffers = 2;
> > return ret;
> >
> > That would resolve your concerns of uninitialized values propagation
> > without writing bogus values 1/1 in case of failure. I think I'd
> > personally prefer a called function to leave my data structs intact when
> > it fails.
> 
> That seems reasonable, I can try to come up with a new version that
> incorporates this change, but I haven't been able to avoid the warning
> without either removing the WARN() or adding an initialization.

I don't mind dropping WARN().

Thanks for your elaborate reply.
