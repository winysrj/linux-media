Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:38915 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab1ESM6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:58:33 -0400
Message-ID: <4DD513F5.8060602@linuxtv.org>
Date: Thu, 19 May 2011 14:58:29 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Tomer Barletz <barletz@gmail.com>
CC: Brice DUBOST <braice@braice.net>, linux-media@vger.kernel.org
Subject: Re: [libdvben50221] [PATCH] Assign same resource_id in open_session_response
 when "resource non-existent"
References: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>	<4DD29848.6030901@braice.net> <BANLkTin6astzASvU6VfDwD2XCRuZToq+RQ@mail.gmail.com>
In-Reply-To: <BANLkTin6astzASvU6VfDwD2XCRuZToq+RQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/18/2011 09:16 PM, Tomer Barletz wrote:
> On Tue, May 17, 2011 at 8:46 AM, Brice DUBOST <braice@braice.net> wrote:
>> On 18/01/2011 15:42, Tomer Barletz wrote:
>>> Attached a patch for a bug in the lookup_callback function, were in
>>> case of a non-existent resource, the connected_resource_id is not
>>> initialized and then used in the open_session_response call of the
>>> session layer.
>>>
>>
>> Hello
>>
>> Can you explain what kind of bug it fixes ?
>>
>> Thanks
>>
> 
> The standard states that in case the module can't provide the
> requested resource , it should reply with the same resource id - this
> is the only line that was added.
> Also, since the caller to this function might use the variable
> returned, this variable must be initialized.
> The attached patch solves both bugs.

Can you please resend the patch inline with a proper signed-off-by line,
in order to get it tracked by patchwork.kernel.org?

Regards,
Andreas
