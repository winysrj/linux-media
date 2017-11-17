Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34124 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753602AbdKQLX7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:23:59 -0500
Date: Fri, 17 Nov 2017 09:23:50 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 03/11] [media] vb2: add 'ordered_in_driver' property to
 queues
Message-ID: <20171117112350.GA19033@jade>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-4-gustavo@padovan.org>
 <42409bb3-a6b6-43e7-a915-7e8e5f1f2198@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42409bb3-a6b6-43e7-a915-7e8e5f1f2198@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-11-17 Alexandre Courbot <acourbot@chromium.org>:

> On Thursday, November 16, 2017 2:10:49 AM JST, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > We use ordered_in_driver property to optimize for the case where
> > the driver can deliver the buffers in an ordered fashion. When it
> > is ordered we can use the same fence context for all fences, but
> > when it is not we need to a new context for each out-fence.
> 
> "we need to a new context" looks like it is missing a word.

oh

"we need to create a new context" 

Thanks for reviewing the patches!

Gustavo
