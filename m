Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZEXRbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 13:31:42 -0400
Message-ID: <4A19849F.3040000@redhat.com>
Date: Sun, 24 May 2009 19:32:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] to libv4lconvert, to do decompression for sn9c2028 cameras
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu> <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu> <4A144E41.6080806@redhat.com> <alpine.LNX.2.00.0905231628240.24795@banach.math.auburn.edu> <4A191837.4070002@hhs.nl> <alpine.LNX.2.00.0905241208010.25546@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0905241208010.25546@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/24/2009 07:22 PM, Theodore Kilgore wrote:
>
>
> On Sun, 24 May 2009, Hans de Goede wrote:
>
>> Hi,
>>
>> Thanks for the patch, but I see one big issue with this patch,
>> the decompression algorithm is GPL, where as libv4l is LGPL.
>>
>> Any chance you could get this relicensed to LGPL ?
>
> Hmmm. Come to think of it, that _is_ a problem, isn't it? I will see
> what I can do about it, but it might take a while.
>

Yes I'm afraid it is :(

Regards,

Hans
