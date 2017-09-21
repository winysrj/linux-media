Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:34708 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdIURLs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 13:11:48 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v3 2/2] media: rc: Add driver for tango HW IR decoder
References: <0e433f1b-ec16-5fce-ab21-085f69e266ce@free.fr>
        <4fe2e398-ba7d-3670-f29b-fe3c5e079b39@free.fr>
        <yw1xbmm4xdfr.fsf@mansr.com>
        <f510d7a6-0b6a-002b-3aad-7dd634392d07@sigmadesigns.com>
Date: Thu, 21 Sep 2017 18:11:46 +0100
In-Reply-To: <f510d7a6-0b6a-002b-3aad-7dd634392d07@sigmadesigns.com> (Marc
        Gonzalez's message of "Thu, 21 Sep 2017 18:09:24 +0200")
Message-ID: <yw1xd16kf031.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> On 21/09/2017 17:46, Måns Rullgård wrote:
>
>> Marc Gonzalez writes:
>> 
>>> From: Mans Rullgard <mans@mansr.com>
>>>
>>> The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
>>>
>>> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
>> 
>> Have you been able to test all the protocols?  Universal remotes usually
>> support something or other with each of them.
>
> I found the Great Pile of Remotes locked away in a drawer.
> Played "What kind of batteries do you eat?" for about an hour.
> And found several NEC remotes, one RC-5, and one RC-6.
> Repeats seem to be handled differently than for NEC.
> I'll take a closer look.

That's not surprising, seeing as the way repeats are transmitted differs
between protocols.

If you're new to IR remote controls, this site has some good
information:
http://www.sbprojects.com/knowledge/ir/index.php

-- 
Måns Rullgård
