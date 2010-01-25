Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33003 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0AYQYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 11:24:23 -0500
Date: Mon, 25 Jan 2010 10:45:53 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with cx18
In-Reply-To: <4B5DB387.70707@redhat.com>
Message-ID: <alpine.LNX.2.00.1001251041510.14128@banach.math.auburn.edu>
References: <4B5DB387.70707@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 25 Jan 2010, Mauro Carvalho Chehab wrote:

> Hi Devin/Andy/Jean,

<snip>

> The sq905c has a warning.

<snip>

> drivers/media/video/gspca/sq905c.c: In function ?sd_config?:
> drivers/media/video/gspca/sq905c.c:207: warning: unused variable ?i?

<snip>

> Please fix.
>
> Cheers,
> Mauro.

This one has been fixed, already. A more recent version of sq905c.c is in 
the pipeline somewhere.

Theodore Kilgore
