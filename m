Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:56553 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbZC2PEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 11:04:52 -0400
Date: Sun, 29 Mar 2009 17:04:31 +0200
From: Janne Grunau <j@jannau.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>
Subject: Re: [PATCH 5 of 6] au0828: use usb_interface.dev for
	v4l2_device_register
Message-ID: <20090329150431.GJ17855@aniel>
References: <patchbomb.1238329154@aniel> <20090329124251.GF637@aniel> <412bdbff0903290644s3c70d5e7rfd4182f55650ead0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412bdbff0903290644s3c70d5e7rfd4182f55650ead0@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Sun, Mar 29, 2009 at 09:44:25AM -0400, Devin Heitmueller wrote:
> On Sun, Mar 29, 2009 at 8:42 AM, Janne Grunau <j@jannau.net> wrote:
> >
> 
> I'm not against this change, but you should also get rid of the "i"
> variable and the au0828_instance list (since the v4l2_device.name was
> the only purpose for both).

done

> Also, your subject didn't really match the function of the patch.  Had
> I not looked at the patch itself, I would have only thought you were
> changing the v4l2_device_register().

yeah, the subject was bad for au0828 and cx231xx but I had trouble to
find find something better. I splitted the patches nao.

> Please put me on the CC: for anything related to au0828 analog
> support, since I authored the code in question.

noted, Sorry I had only looked at the au0228-core.c header which notes
only Steven.

Janne
