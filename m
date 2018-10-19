Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59868 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbeJSVgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:36:25 -0400
Message-ID: <53924f64785c3469915b19d32cefd36ed244cecd.camel@collabora.com>
Subject: Re: RFC: kernelCI media subsystem pilot (Test results for
 gtucker/kernelci-media - gtucker-kernelci-media-001-6-g1b2c6e5844d8)
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        kernelci@groups.io
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.co.uk>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Ana Guerrero Lopez <ana.guerrero@collabora.co.uk>,
        Guillaume Charles Tucker <guillaume.tucker@collabora.co.uk>
Date: Fri, 19 Oct 2018 10:30:08 -0300
In-Reply-To: <bea38cb8-5e1b-32b1-2d81-e6038b8d6c68@xs4all.nl>
References: <b569d756-5c4a-d0b4-e077-27a2e2ebb19d@collabora.com>
         <1f439267adf9a492a5d178808ba23682338d7e58.camel@collabora.com>
         <bea38cb8-5e1b-32b1-2d81-e6038b8d6c68@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-19 at 09:06 +0200, Hans Verkuil wrote:
> On 10/18/2018 09:23 PM, Ezequiel Garcia wrote:
> > Hi everyone,
> > 
> > In Collabora, and as part of our kernelci work, we are doing
> > research on kernel functional testing with kernelci.
> > 
> > For those new to kernelci, see https://github.com/kernelci/kernelci-doc/wiki/KernelCI 
> > and https://kernelci.org/.
> > 
> > The goal is to lay down the infrastructure required to make
> > automated test coverage an integral part of our feature
> > and bugfix development process.
> > 
> > So, as a first attempt, we've decided to extend kernelci test
> > v4l2 plan support, leading the way to extending
> > other subsystems' test plans.
> > 
> > Currently, kernelci looks for a list of branches every hour and
> > see if anything changed. For any branch that has changed, it triggers
> > builds, boots, tests and reports for each branch that had some changes
> > since last time it ran.
> > 
> > For this pilot, we've decided to target just a few devices:
> > qemu with vivid, rk3399-gru-kevin and rk3288-veyron-jaq
> > with uvc.
> 
> It's running v4l2-compliance, right?
> 

Exactly.

> Looking at the test cases, they appear in the reverse order that v4l2-compliance
> performs them, that's a bit odd.
> 

That's something to check in the parser. I'm sure it's fixable if you
find it annoying.

> And if we include uvc in the testing, then I need to prioritize the work I
> started for uvc to remove the last FAILs.
> 

Well, we can run anything. We decided to go for uvc and vivid, just too pick
two popular examples, but there are really no restrictions.

Thanks,
Ezequiel
