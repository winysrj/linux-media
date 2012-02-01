Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweb4.versatel.de ([82.140.32.187]:53345 "EHLO
	mxweb4.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2BATUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 14:20:08 -0500
Received: from cinnamon-sage.de (i577A1B03.versanet.de [87.122.27.3])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id q11HeheT006948
	for <linux-media@vger.kernel.org>; Wed, 1 Feb 2012 18:40:43 +0100
Received: from 192.168.23.2:49442 by cinnamon-sage.de for <h@realh.co.uk>,<linux-media@vger.kernel.org> ; 01.02.2012 18:40:42
Message-ID: <4F29791C.6060201@flensrocker.de>
Date: Wed, 01 Feb 2012 18:40:44 +0100
From: Lars Hanisch <dvb@flensrocker.de>
MIME-Version: 1.0
To: Tony Houghton <h@realh.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: DVB TS/PES filters
References: <20120126154015.01eb2c18@tiber> <20120201133234.0b6222bc@junior>
In-Reply-To: <20120201133234.0b6222bc@junior>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 01.02.2012 14:32, schrieb Tony Houghton:
> On Thu, 26 Jan 2012 15:40:15 +0000
> Tony Houghton<h@realh.co.uk>  wrote:
>
>> I could do with a little more information about DMX_SET_PES_FILTER.
>> Specifically I want to use an output type of DMX_OUT_TS_TAP. I believe
>> there's a limit on how many filters can be set, but I don't know
>> whether the kernel imposes such a limit or whether it depends on the
>> hardware, If the latter, how can I read the limit?
>
> Can anyone help me get more information about this (and the "magic
> number" pid of 8192 for the whole stream)?

  In the TS-header there are 13 bits for the PID, so it can be from 0 to 8191.
  Therefore dvb-core interprets 8192 (and greater values I think) as "all PIDs".

Regards,
Lars.
