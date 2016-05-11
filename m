Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48218 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcEKUi3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 16:38:29 -0400
Date: Wed, 11 May 2016 17:38:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David R <david@unsolicited.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Patch: V4L stable versions 4.5.3 and 4.5.4
Message-ID: <20160511173823.7d0dca7e@recife.lan>
In-Reply-To: <57338272.4080908@unsolicited.net>
References: <57337E39.40105@unsolicited.net>
	<57338272.4080908@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Wed, 11 May 2016 20:05:22 +0100
David R <david@unsolicited.net> escreveu:

> On 11/05/16 19:47, David R wrote:
> > Hi
> > 
> > Please consider applying the attached patch (or something like it) to
> > V4L2, and whatever is appropriate to the mainstream kernel. Without this
> > my media server crashes and burns at boot.
> > 
> > See https://lkml.org/lkml/2016/5/7/88 for more details
> > 
> > Thanks
> > David
> >   
> I see the offending patch was reverted earlier today. My box is fine
> with my (more simple) alternative, but your call.

Yes, I noticed the bug earlier today, while testing a DVB device.
As this affects 2 stable releases plus the upcoming Kernel 4.6,
I decided to just revert it for now, while we don't solve the
issue.

Your patch looks good. So, eventually it will be merged on a new
version of this patch, after we test it properly.

Thanks!
Mauro
