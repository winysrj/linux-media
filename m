Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:36860 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839Ab2C3NtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 09:49:05 -0400
Message-ID: <4F75B9CE.2020707@mlbassoc.com>
Date: Fri, 30 Mar 2012 07:49:02 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: omap3isp & Linux-3.3
References: <4F75920C.9060103@mlbassoc.com> <2647564.mZcJGaWXom@avalon>
In-Reply-To: <2647564.mZcJGaWXom@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-03-30 07:33, Laurent Pinchart wrote:
> Hi Gary,
>
> On Friday 30 March 2012 04:59:24 Gary Thomas wrote:
>> Laurent,
>>
>> I'm looking at your latest tree.  I've merged my platform support
>> that I had working in 3.2, but I never see the TVP5150 sensor driver
>> being probed.
>
> Is the OMAP3 ISP driver loaded ? What does it print to the kernel log ?
>
>> Has this changed?  Do you have an example [tree] with working board
>> support?  Previously you had a branch with support for the BeagleBoard
>> in place.  Is 'omap3isp-sensors-board' up to date?
>
> The branch is up-to-date, yes. It contains support for the Beagleabord-xM with
> the MT9P031 camera module.
>

Thanks.  My configuration was a bit messed up, got that part working now.

Sadly, the TVP5150 driver has no pad operations which I'm now re-adding
from my previous version.  I'll let you know what else I find.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
