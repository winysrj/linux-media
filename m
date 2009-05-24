Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44605 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZEXRJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 13:09:09 -0400
Date: Sun, 24 May 2009 12:22:57 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] to libv4lconvert, to do decompression for sn9c2028
 cameras
In-Reply-To: <4A191837.4070002@hhs.nl>
Message-ID: <alpine.LNX.2.00.0905241208010.25546@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu> <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu> <4A144E41.6080806@redhat.com> <alpine.LNX.2.00.0905231628240.24795@banach.math.auburn.edu>
 <4A191837.4070002@hhs.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 24 May 2009, Hans de Goede wrote:

> Hi,
>
> Thanks for the patch, but I see one big issue with this patch,
> the decompression algorithm is GPL, where as libv4l is LGPL.
>
> Any chance you could get this relicensed to LGPL ?

Hmmm. Come to think of it, that _is_ a problem, isn't it? I will see what 
I can do about it, but it might take a while.

Theodore Kilgore
