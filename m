Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51096 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752500AbcEKVHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 17:07:36 -0400
Date: Thu, 12 May 2016 00:07:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David R <david@unsolicited.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org, hverkuil@xs4all.nl
Subject: Re: Patch: V4L stable versions 4.5.3 and 4.5.4
Message-ID: <20160511210731.GS26360@valkosipuli.retiisi.org.uk>
References: <57337E39.40105@unsolicited.net>
 <57338272.4080908@unsolicited.net>
 <20160511173823.7d0dca7e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160511173823.7d0dca7e@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and David,

On Wed, May 11, 2016 at 05:38:23PM -0300, Mauro Carvalho Chehab wrote:
> Hi David,
> 
> Em Wed, 11 May 2016 20:05:22 +0100
> David R <david@unsolicited.net> escreveu:
> 
> > On 11/05/16 19:47, David R wrote:
> > > Hi
> > > 
> > > Please consider applying the attached patch (or something like it) to
> > > V4L2, and whatever is appropriate to the mainstream kernel. Without this
> > > my media server crashes and burns at boot.
> > > 
> > > See https://lkml.org/lkml/2016/5/7/88 for more details
> > > 
> > > Thanks
> > > David
> > >   
> > I see the offending patch was reverted earlier today. My box is fine
> > with my (more simple) alternative, but your call.
> 
> Yes, I noticed the bug earlier today, while testing a DVB device.
> As this affects 2 stable releases plus the upcoming Kernel 4.6,
> I decided to just revert it for now, while we don't solve the
> issue.
> 
> Your patch looks good. So, eventually it will be merged on a new
> version of this patch, after we test it properly.

Indeed vb2_core_dqbuf() is called with pb == NULL in file I/O, which was
unfortunately missed until now.

The proposed fix looks good to me.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
