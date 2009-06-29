Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47392 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZF2WIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 18:08:13 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 29 Jun 2009 17:08:08 -0500
Subject: RE: [PATCH 3/3 - v0] davinci: platform changes to support vpfe
 camera capture
Message-ID: <A69FA2915331DC488A831521EAE36FE401448CE221@dlee06.ent.ti.com>
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com>
 <200906271042.01379.david-b@pacbell.net>
 <A69FA2915331DC488A831521EAE36FE401448CDD97@dlee06.ent.ti.com>
 <200906291043.43140.david-b@pacbell.net>
In-Reply-To: <200906291043.43140.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>
>> >
>>
>> That is because, I have my first (vpfe capture version v3)
>> patch lined up for merge to upstream/davinci git kernel ...
>>
>> >>NOTE: Depends on v3 version of vpfe capture driver patch
>>
>> What is your suggestion in such cases?
>
>Always submit against mainline.  In the handfull of cases
>that won't work (e.g. depends on code that's not there),
>submit against the DaVinci tree.
>
>
I think you didn't get my point. We have patches that are in the pipeline waiting for merge that is neither available in the upstream nor in the DaVinci tree. That gets merged to upstream at some point in future and also will get rebased to DaVinci later. But If I need to make patches based on them (like this one) it can be done only by applying the patches to the DaVinci tree and then creating new patches based on that. That is why my note clearly says " Depends on v3 version of vpfe capture driver patch"

Murali
