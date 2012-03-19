Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:48429 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832Ab2CSRon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 13:44:43 -0400
Date: Mon, 19 Mar 2012 11:44:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [Q] ov7670: green line in VGA resolution
Message-ID: <20120319114441.5c64574f@dt>
In-Reply-To: <CACKLOr28ECqBhTkMsd=6vSOMPZk2DgbRFWZOZXH39omQRP0fcA@mail.gmail.com>
References: <CACKLOr28ECqBhTkMsd=6vSOMPZk2DgbRFWZOZXH39omQRP0fcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 19 Mar 2012 17:27:06 +0100
javier Martin <javier.martin@vista-silicon.com> wrote:

> I suspect the problem is related to the fact that this sensor has an
> array of 656 x 488 pixels but only 640 x 480 are active. The datasheet
> available from Omnivision (Version 1.4, August 21, 2006) is not clear
> about how to configure the sensor not to show non active pixels but I
> could find the following patch which addresses a similar problem for
> QVGA:

Interesting...nobody ever sent that patch anywhere where I've seen it.

Anyway, the ov7670 datasheet is not clear on much of anything, and the
things it *is* clear on are likely to be wrong.

The comment in the patch makes it clear how this was worked out, anyway:
"empirically determined."  Unless you can get through to the one person at
OmniVision who knows how this sensor actually works, the best that can be
done is to mess with the values for the window.  That's often done at both
the sensor and the controller level - if you look at the Marvell
controller, you'll see window tweaking there too.

jon
