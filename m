Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63007 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbdIWUCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 16:02:35 -0400
Subject: Re: [GIT PULL FOR v4.15] Cleanup fixes
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <7f18a823-3827-5a9c-053d-61f113a2d36f@xs4all.nl>
 <20170923093802.34b31c98@vento.lan>
 <b33aac55-6749-3dc9-1258-c6518b05a94e@users.sourceforge.net>
 <20170923162550.503c9cf2@vento.lan>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <cfa265b8-03c9-7601-28dd-c17d7c81783e@users.sourceforge.net>
Date: Sat, 23 Sep 2017 22:02:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170923162550.503c9cf2@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Then change patch granularity: one patch per subsystem or per
> directory (e. g. pci, usb, platform, others).

I imagine that the risks for disagreements can grow with such
a bigger scope.


> That's the usual criteria most maintainers use for cleanups.

I picked some update candidates up where the adjustments could be interpreted
as controversial (despite of your acceptance so far.)


>> Do you want a “development pause” from my queue of change possibilities?
> 
> Those patches are mainly source code "polishing".

I prefer to improve existing source files for a while instead of finding
the next shiny development “toy”.


> I really don't want to take much time handling such kind of patches,
> as they usually doesn't fix any real bug, nor add functionality.

Can any of them influence the run time behaviour in desired ways?

Regards,
Markus
