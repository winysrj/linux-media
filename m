Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:37570 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCDAPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 19:15:47 -0500
Date: Tue, 3 Mar 2009 18:28:14 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support alternate resolutions for sq905
In-Reply-To: <200903032320.48037.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0903031820150.21483@banach.math.auburn.edu>
References: <200903032320.48037.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Mar 2009, Adam Baker wrote:

> Add support for the alternate resolutions offered by SQ-905 based cameras. As
> well as 320x240 all cameras can do 160x120 and some can do 640x480.
>
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> ---
> The patch to detect orientation needs to follow this as that is also simplified by
> the modified identity check that this introduces.

Since you all got a copy of the patch, I don't reproduce it here, munged 
by a

>

at the beginning of each line. But I would like to add a comment about the 
640x480 resolution:

It should be obvious that, since the SQ905 cameras use bulk transport and 
since they do not do compression in streaming mode, the 640x480 streaming 
is choppy. Nevertheless, those cameras which have big enough sensors to 
support it can operate at 640x480 in streaming mode. Therefore, it seems 
appropriate to support that resolution. If nothing else, it would be 
useful for intermittent or timed frame grabbing, or such like 
applications.

Oh, and it should be needless to say, but in order to satisfy all 
formalities

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
