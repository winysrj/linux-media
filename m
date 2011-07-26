Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:43601 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1GZTFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 15:05:41 -0400
Date: Tue, 26 Jul 2011 22:05:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Yordan Kamenov <ykamenov@mm-sol.com>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v4 1/1] libv4l: Add plugin support to libv4l
Message-ID: <20110726190536.GE32629@valkosipuli.localdomain>
References: <1304436396-10501-1-git-send-email-ykamenov@mm-sol.com>
 <1678f1f41284ad9665de8717b7b8be117ddf9596.1304435825.git.ykamenov@mm-sol.com>
 <4E234D53.4030604@redhat.com>
 <4E2999C6.1090006@mm-sol.com>
 <4E2C5826.6040109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2C5826.6040109@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 24, 2011 at 07:36:38PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 07/22/2011 05:39 PM, Yordan Kamenov wrote:
> >Hi Hans,
> >
> >Hans de Goede wrote:
> >>Hi,
> >>
> >>Sorry it took so long, but I've just merged the plugin
> >>support into v4l-utils git. I did make some minor mods /
> >>bugfixes before merging, see the commit message in git.
> >>
> >>Regards,
> >>
> >>Hans
> >>
> >>p.s.
> >>
> >>I think we should expand the plugin support with support
> >>for a output devices, iow add a write() dev_op. If you
> >>guys agree I can easily do so myself, we should do this
> >>asap before people start depending on the ABI
> >>(although there is no ABI stability promise until I
> >>release 0.10.x, see my message to the list wrt
> >>the start of the 0.9.x cycle).
> >>
> >
> >I think that it is a good point, you can add write() and
> >reserved dev_ops.
> 
> Ok, done, this is in v4l-utils git master now.

Wow! Thanks, Hans and Yordan! :-)

-- 
Sakari Ailus
sakari.ailus@iki.fi
