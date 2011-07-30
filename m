Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta11.charter.net ([216.33.127.80]:53371 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1G3ViQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 17:38:16 -0400
Message-ID: <4E3479CC.7040403@cuw.edu>
Date: Sat, 30 Jul 2011 16:38:20 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	jpiszcz@lucidpixels.com
Subject: Re: [PATCH] uvcvideo: correct kernel version reference
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan> <201107302236.13354.laurent.pinchart@ideasonboard.com> <4E347824.9080207@cuw.edu> <201107302334.38723.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107302334.38723.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/30/2011 04:34 PM, Laurent Pinchart wrote:
> Hi Greg,
>
> On Saturday 30 July 2011 23:31:16 Greg Dietsche wrote:
>    
>> On 07/30/2011 03:36 PM, Laurent Pinchart wrote:
>>      
>>> Hi Greg,
>>>
>>> Thanks for the patch.
>>>
>>> On Saturday 30 July 2011 17:47:30 Greg Dietsche wrote:
>>>        
>>>> change from v2.6.42 to v3.2
>>>>          
>>> This patch would be queued for v3.2. As the code it fixes will go away at
>>> the same time, it would be pretty pointless to apply it :-) Thanks for
>>> warning me though.
>>>        
>> you're welcome - I thought the merge window was still open for 3.1 ...
>> so that's why I sent it in.
>>      
> Linus' merge window is still open, but this will have to go through Mauro's
> tree, and it won't make it on time.
>
>    
Ah, that makes sense :) Anyway it is very trivial...

thanks for the explanation!

Greg
