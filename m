Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:59821 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1H3QXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 12:23:07 -0400
Message-ID: <4E5D0E69.6020909@mlbassoc.com>
Date: Tue, 30 Aug 2011 10:23:05 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: Getting started with OMAP3 ISP
References: <4E56734A.3080001@mlbassoc.com> <4E5CEECC.6040804@mlbassoc.com> <4E5CF118.3050903@mlbassoc.com> <201108301620.09365.laurent.pinchart@ideasonboard.com> <4E5CFA0B.3010207@mlbassoc.com> <CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com>
In-Reply-To: <CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-08-30 10:07, Enrico wrote:
> On Tue, Aug 30, 2011 at 4:56 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> Yes, that helped a lot.  When I create the devices by hand, I can now see
>> my driver starting to be accessed (right now it's very much an empty stub)
>
>> From your logs it seems you are using a tvp5150, i've posted a patch
> [1] for tvp5150 that makes it very close to work, it could be faster
> to debug it instead of starting from scratch.
>
> Enrico
>
> [1] http://www.spinics.net/lists/linux-media/msg37116.html

Thanks, I'll give it a look.

Your note says that /dev/video* is properly registered.  Does this
mean that udev created them for you on boot as well?  If so, what
version of udev are you using?  What's your root file system setup?
n.b. I'm using an OpenEmbedded variant, Poky

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
