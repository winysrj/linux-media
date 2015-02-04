Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37724 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932516AbbBDHyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 02:54:44 -0500
Message-ID: <54D1D01B.30201@xs4all.nl>
Date: Wed, 04 Feb 2015 08:54:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>, dCrypt <dcrypt@telefonica.net>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [possible BUG, cx23885] Dual tuner TV card, works using one tuner
 only, doesn't work if both tuners are used
References: <54472CB702988260@smtp.movistar.es>	<02ee01d031ec$283a80f0$78af82d0$@net>	<006301d03b58$0181a9a0$0484fce0$@net>	<006e01d03fe7$4cf3dd70$e6db9850$@net> <CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com>
In-Reply-To: <CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/2015 08:32 PM, Steven Toth wrote:
> While I am the maintainer of the cx23885 driver, its currently
> undergoing a significant amount of churn related to Han's recent VB2
> and other changes. I consider the current driver broken until the
> feedback on the mailing list dies down. I'm reluctant to work on the
> driver while its considered unstable.

Any issues in the driver are all related to streaming. Tuning has not
been touched at all and there is some anecdotal evidence that if there
are tuning issues they were there already before the vb2 conversion.

To my knowledge the driver is now stable. There is still the occasional
kernel message that shouldn't be there which I am trying to track down,
but the driver crashes due to a vb2 race condition have been fixed.

Regards,

	Hans

> 
> If you want to send me a Terratec card then I'll try to fund an hour
> to investigate in the coming weeks.
> 
> Best,
> 
> - Steve
> 

