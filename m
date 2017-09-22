Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57842 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbdIVUok (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 16:44:40 -0400
Subject: Re: [media] spca500: Use common error handling code in
 spca500_synch310()
To: Daniele Nicolodi <daniele@grinta.net>, linux-media@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net>
 <alpine.DEB.2.20.1709221908230.3170@hadrien>
 <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
 <alpine.DEB.2.20.1709221941020.3170@hadrien>
 <0baa322a-6019-70dc-0245-caae824ccb49@users.sourceforge.net>
 <25a82438-8760-66fd-23d3-24569078f906@grinta.net>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ce9f77e1-aeb6-65ac-9224-33e12d81d641@users.sourceforge.net>
Date: Fri, 22 Sep 2017 22:44:23 +0200
MIME-Version: 1.0
In-Reply-To: <25a82438-8760-66fd-23d3-24569078f906@grinta.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> No one needs to argue about keeping it the way it is.

I got an other impression in this case after a bit of information
was presented which seems to be contradictory.


> I don't see any improvement brought by the proposed change,

Do you care if the source code for an error message is present only once
in this function?


> other than making the code harder to read.

I suggest to reconsider this concern.


> I find goto statements hard to read, because they inherently make some
> information non local.  They are justified in error path handling,
> if the error path only unwinds what the function did early on.
> That's not the case here.

I am looking also for change possibilities without such a restriction.

 
> The same applies to dozens of patches you proposed recently.

I proposed some software updates to reduce a bit of code duplication.

Do you find any corresponding approaches useful?

Regards,
Markus
