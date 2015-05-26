Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33896 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbEZOsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 10:48:14 -0400
Received: by wicmc15 with SMTP id mc15so67284997wic.1
        for <linux-media@vger.kernel.org>; Tue, 26 May 2015 07:48:13 -0700 (PDT)
From: Piotr Staszewski <p.staszewski@gmail.com>
Date: Tue, 26 May 2015 16:48:09 +0200
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: omap4iss: Reformat overly long lines
Message-ID: <20150526144809.GA23560@swordfish>
References: <20150526085418.GA22775@swordfish>
 <20150526141524.GD21573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150526141524.GD21573@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2015 at 07:15:24AM -0700, Greg Kroah-Hartman wrote:
> > -		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
> > +		WARN(1,
> > +		     KERN_ERR "CSI2: pixel format %08x unsupported!\n",
> 
> That line wasn't over 80 characters long, why change it?

Indeed my bad. Checkpatch complains there about something else.
I'll resubmit corrected version promptly.

Best regards,
Piotr

-- 
Piotr S. Staszewski                              http://www.drbig.one.pl
dRbiG at FreeNode, IRCNet
                         But all's one level plain he hunts for flowers.
