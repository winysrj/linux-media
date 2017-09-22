Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48760 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752218AbdIVRlv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 13:41:51 -0400
Date: Fri, 22 Sep 2017 19:41:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>, linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [media] spca500: Use common error handling code in
 spca500_synch310()
In-Reply-To: <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
Message-ID: <alpine.DEB.2.20.1709221941020.3170@hadrien>
References: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net> <alpine.DEB.2.20.1709221908230.3170@hadrien> <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 22 Sep 2017, SF Markus Elfring wrote:

> >>  	return 0;
> >> -error:
> >> +
> >> +report_failure:
> >> +	PERR("Set packet size: set interface error");
> >>  	return -EBUSY;
> >>  }
> >
> > Why change the label name?
>
> I find the suggested variant a bi better.
>
>
> > They are both equally uninformative.
>
> Which identifier would you find appropriate there?

error was fine.

julia
