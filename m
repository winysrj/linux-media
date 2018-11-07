Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58034 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbeKHFfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 00:35:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Shuah Khan <shuah@kernel.org>, sean@mess.org
Subject: Re: [RFC] Create test script(s?) for regression testing
Date: Wed, 07 Nov 2018 22:04:03 +0200
Message-ID: <15267027.MHiCTJmF4z@avalon>
In-Reply-To: <20181107175320.640a8c74@coco.lan>
References: <d0b6420c-e6b9-64c3-3577-fd0546790af3@xs4all.nl> <3038136.0uhjixLgno@avalon> <20181107175320.640a8c74@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday, 7 November 2018 21:53:20 EET Mauro Carvalho Chehab wrote:
> Em Wed, 07 Nov 2018 21:35:32 +0200 Laurent Pinchart escreveu:
> > On Wednesday, 7 November 2018 21:10:35 EET Mauro Carvalho Chehab wrote:

[snip]

> >> I'm with Hans on that matter: better to start with an absolute minimum
> >> of dependencies (like just: make, autotools, c, c++, bash),
> > 
> > On a site note, for a new project, we might want to move away from
> > autotools. cmake and meson are possible alternatives that are way less
> > painful.
> 
> Each toolset has advantages or disadvantages. We all know how
> autotools can be painful.
> 
> One bad thing with cmake is that they deprecate stuff. A long-live project
> usually require several" backward" compat stuff at cmake files in order
> to cope with different behaviors that change as cmake evolves.

I don't know how much of a problem that would be. My experience with cmake is 
good so far, but I haven't used it in a large scale project with 10+ years of 
contributions :-)

> I never used mason myself.

It's the build system we picked for libcamera, I expect to provide feedback in 
the not too distant future.

[snip]

-- 
Regards,

Laurent Pinchart
