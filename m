Return-path: <linux-media-owner@vger.kernel.org>
Received: from zed.grinta.net ([109.74.203.128]:47236 "EHLO zed.grinta.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751833AbdIVSgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 14:36:04 -0400
Subject: Re: [media] spca500: Use common error handling code in
 spca500_synch310()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d496ca24-1725-768b-5e55-4e45097cb77d@users.sourceforge.net>
 <alpine.DEB.2.20.1709221908230.3170@hadrien>
 <4921ea61-49cd-4071-e636-c199daddec8e@users.sourceforge.net>
 <alpine.DEB.2.20.1709221941020.3170@hadrien>
 <0baa322a-6019-70dc-0245-caae824ccb49@users.sourceforge.net>
From: Daniele Nicolodi <daniele@grinta.net>
Message-ID: <25a82438-8760-66fd-23d3-24569078f906@grinta.net>
Date: Fri, 22 Sep 2017 12:27:09 -0600
MIME-Version: 1.0
In-Reply-To: <0baa322a-6019-70dc-0245-caae824ccb49@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/22/17 11:46 AM, SF Markus Elfring wrote:
>>>> They are both equally uninformative.
>>>
>>> Which identifier would you find appropriate there?
>>
>> error was fine.
> 
> How do the different views fit together?

You want to change something.  Changing something requires to spend
energy.  You need to to justify why spending that energy is a good
thing.  No one needs to argue about keeping it the way it is.

What about stopping changing code for the sake of having one more patch
accepted in the kernel?  I don't see any improvement brought by the
proposed change, other than making the code harder to read.  I find goto
statements hard to read, because they inherently make some information
non local.  They are justified in error path handling, if the error path
only unwinds what the function did early on.  That's not the case here.

The same applies to dozens of patches you proposed recently.

By the way, there may be some useful absent minded code churn of the
king you like in that driver: I don't think the PERR macro is the
idiomatic way of doing logging.

Cheers,
Daniele
