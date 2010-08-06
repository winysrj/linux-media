Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44378 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935183Ab0HFVGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 17:06:51 -0400
Date: Fri, 6 Aug 2010 23:00:11 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Handling of large keycodes
Message-ID: <20100806210011.GB24488@hardeman.nu>
References: <20100731091936.GA22253@core.coreip.homeip.net>
 <4C5423E1.30805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5423E1.30805@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 10:23:45AM -0300, Mauro Carvalho Chehab wrote:
> Em 31-07-2010 06:19, Dmitry Torokhov escreveu:
> > The usefulnes of reserved data elements in the structure is 
> > doubtful,
> > since we do not seem to require them being set to a particular value and
> > so we'll be unable to distinguish betwee legacy and newer users.
> 
> David proposed some parameters that we rejected on our discussions. As we
> might need to add something similar, I decided to keep it on my approach,
> since a set of reserved fields wouldn't hurt (and removing it on our discussions
> would be easy), but I'm ok on removing them.

The parameters that we'll need for the ir subsystem can be implemented 
in a different way in the future (with no changes necessary to the input 
subsystem) so I'm also ok with removing them.


-- 
David Härdeman
