Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54090 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751213AbdJVHgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 03:36:41 -0400
Subject: Re: Camera support, Prague next week, sdlcam
To: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan> <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan> <20171021220026.GA26881@amd>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
Date: Sun, 22 Oct 2017 09:36:32 +0200
MIME-Version: 1.0
In-Reply-To: <20171021220026.GA26881@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/10/17 00:00, Pavel Machek wrote:
> Hi!
> 
> I'd still like to get some reasonable support for cellphone camera in
> Linux.
> 
> IMO first reasonable step is to merge sdlcam, then we can implement
> autofocus, improve autogain... and rest of the boring stuff. Ouch and
> media graph support would be nice. Currently, _nothing_ works with
> media graph device, such as N900.

Can you post your latest rebased patch for sdlcam for v4l-utils?

I'll do a review and will likely merge it for you. Yes, I've changed my
mind on that.

> 
> I'll talk about the issues at ELCE in few days:
> 
> https://osseu17.sched.com/event/ByYH/cheap-complex-cameras-pavel-machek-denx-software-engineering-gmbh
> 
> Will someone else be there? Is there some place where v4l people meet?

Why don't we discuss this Tuesday morning at 9am? I have no interest in the
keynotes on that day, so those who are interested can get together.

I'll be at your presentation tomorrow and we can discuss a bit during
the following coffee break if time permits.

Regards,

	Hans
