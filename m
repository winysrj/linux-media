Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38423 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab1ERTQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 15:16:15 -0400
Received: by pwi15 with SMTP id 15so885755pwi.19
        for <linux-media@vger.kernel.org>; Wed, 18 May 2011 12:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD29848.6030901@braice.net>
References: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>
	<4DD29848.6030901@braice.net>
Date: Wed, 18 May 2011 12:16:14 -0700
Message-ID: <BANLkTin6astzASvU6VfDwD2XCRuZToq+RQ@mail.gmail.com>
Subject: Re: [libdvben50221] [PATCH] Assign same resource_id in
 open_session_response when "resource non-existent"
From: Tomer Barletz <barletz@gmail.com>
To: Brice DUBOST <braice@braice.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 17, 2011 at 8:46 AM, Brice DUBOST <braice@braice.net> wrote:
> On 18/01/2011 15:42, Tomer Barletz wrote:
>> Attached a patch for a bug in the lookup_callback function, were in
>> case of a non-existent resource, the connected_resource_id is not
>> initialized and then used in the open_session_response call of the
>> session layer.
>>
>
> Hello
>
> Can you explain what kind of bug it fixes ?
>
> Thanks
>

The standard states that in case the module can't provide the
requested resource , it should reply with the same resource id - this
is the only line that was added.
Also, since the caller to this function might use the variable
returned, this variable must be initialized.
The attached patch solves both bugs.

Tomer
