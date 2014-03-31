Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39532 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaCaTja (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 15:39:30 -0400
Date: Mon, 31 Mar 2014 21:39:29 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 03/11] rc-core: document the protocol type
Message-ID: <20140331193929.GD9610@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161100.13234.82892.stgit@zeus.muc.hardeman.nu>
 <53393B73.3010405@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53393B73.3010405@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 31, 2014 at 10:54:59AM +0100, James Hogan wrote:
>On 29/03/14 16:11, David Härdeman wrote:
>> Right now the protocol information is not preserved, rc-core gets handed a
>> scancode but has no idea which protocol it corresponds to.
>> 
>> This patch (which required reading through the source/keymap for all drivers,
>> not fun) makes the protocol information explicit which is important
>> documentation and makes it easier to e.g. support multiple protocols with one
>> decoder (think rc5 and rc-streamzap). The information isn't used yet so there
>> should be no functional changes.
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>
>Good stuff. I very much approve of the concept, and had considered doing
>the same thing myself.

Thanks, and to reiterate, the patch misses two drivers so I'll still
repost a new version...

-- 
David Härdeman
