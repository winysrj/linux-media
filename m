Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:39964 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965876AbeAJRMY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 12:12:24 -0500
Date: Wed, 10 Jan 2018 15:11:56 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v7 0/6] V4L2 Explicit Synchronization
Message-ID: <20180110171156.GC3530@jade>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <1515602656.5266.15.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1515602656.5266.15.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-10 Nicolas Dufresne <nicolas@ndufresne.ca>:

> Le mercredi 10 janvier 2018 à 14:07 -0200, Gustavo Padovan a écrit :
> > v7 bring a fix for a crash when not using fences and a uAPI fix.
> > I've done a bit more of testing on it and also measured some
> > performance. On a intel laptop a DRM<->V4L2 pipeline with fences is
> > runnning twice as faster than the same pipeline with no fences.
> 
> What does it mean twice faster here ?

That capture then display on the screen for a given number of frames was
completing in about half of the time when using fences and passing then
to the other driver right away when they are received.

Gustavo
