Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48651 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1HQMdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 08:33:21 -0400
Date: Wed, 17 Aug 2011 15:33:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Message-ID: <20110817123317.GL7436@valkosipuli.localdomain>
References: <4E303E5B.9050701@samsung.com>
 <201108161057.57875.laurent.pinchart@ideasonboard.com>
 <4E4A8D27.1040602@redhat.com>
 <201108161744.34749.laurent.pinchart@ideasonboard.com>
 <4E4AF0FC.4070104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4AF0FC.4070104@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Aug 16, 2011 at 03:36:44PM -0700, Mauro Carvalho Chehab wrote:
[clip]
> > For instance, when switching between a b&w and a color sensor you will need to 
> > reconfigure the whole pipeline to select the right gamma table, white balance 
> > parameters, color conversion matrix, ... That's not something we want to 
> > hardcode in the kernel. This needs to be done from userspace.
> 
> This is something that, if it is not written somehwere, no userspace
> applications not developed by the hardware vendor will ever work.
> 
> I don't see any code for that any at the kernel or at libv4l. Am I missing
> something?

There actually is. The plugin interface patches went in to libv4l 0.9.0.
That's just an interface and it doesn't yet have support for any embedded
devices.

-- 
Sakari Ailus
sakari.ailus@iki.fi
