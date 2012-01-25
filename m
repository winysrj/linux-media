Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2AYWQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 17:16:19 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0PMGIwx008843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 17:16:19 -0500
Message-ID: <4F207E2B.7060307@redhat.com>
Date: Wed, 25 Jan 2012 17:11:55 -0500
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Corinna Vinschen <vinschen@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] imon: don't wedge hardware after early callbacks
References: <20120124203605.GQ2456@calimero.vinschen.de> <1327524982-26593-1-git-send-email-jarod@redhat.com> <20120125221136.GX2456@calimero.vinschen.de>
In-Reply-To: <20120125221136.GX2456@calimero.vinschen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Corinna Vinschen wrote:
> Hi Jarod,
>
> On Jan 25 15:56, Jarod Wilson wrote:
>> This patch is just a minor update to one titled "imon: Input from ffdc
>> device type ignored" from Corinna Vinschen. An earlier patch to prevent
>> an oops when we got early callbacks also has the nasty side-effect of
>> wedging imon hardware, as we don't acknowledge the urb. Rework the check
>> slightly here to bypass processing the packet, as the driver isn't yet
>> fully initialized, but still acknowlege the urb and submit a new rx_urb.
>> Do this for both interfaces -- irrelevant for ffdc hardware, but
>> relevant for newer hardware, though newer hardware doesn't spew the
>> constant stream of data as soon as the hardware is initialized like the
>> older ffdc devices, so they'd be less likely to trigger this anyway...
>
> just a question, wouldn't it make sense to bump the version number of the
> module to 0.9.4?  Or do you do that for functional changes only?

I've not been terribly consistent with it, but it does seem the last 
time I bumped the version number *was* to have an easy way to tell if a 
particular fix was included or not. We can bump it here too, doesn't 
really matter to me.

-- 
Jarod Wilson
jarod@redhat.com


