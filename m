Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1EBR6Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 13:58:24 -0400
Message-ID: <4DBEF0B7.8020300@redhat.com>
Date: Mon, 02 May 2011 14:58:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, warthog9@kernel.org
Subject: Re: [PATCH 00/10] rc-core: my current patchqueue
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <1304021602.3288.5.camel@localhost>
In-Reply-To: <1304021602.3288.5.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-04-2011 17:13, Malcolm Priestley escreveu:
> On Thu, 2011-04-28 at 17:13 +0200, David Härdeman wrote:
>> The following series is what's in my current patch queue for rc-core.
>>
>> It only been lightly tested so far and it's based on the "for_v2.6.39" branch,
>> but I still wanted to send it to the list so that I can get some feedback while
>> I refresh the patches to "for_v2.6.40" and do more testing.
> 
> Patch [06/10] hasn't made it to gmane or spinics servers.
> 
> Patchwork appears to be down again :(

None of the patches of this series were caught by patchwork :(

Btw, patchwork is broke again today: it is refusing to accept any commands to
update via pwclient interface. On the last 7 days, I counted 7 days of partial
outage at patchwork :(

It is time for us move from patchwork to something that works. 

I intend to finish to apply the patches that patchwork caught and work on another 
process to get those patches from my imap server, probably writing a script using
perl Mail::IMAPClient. The bad news is that, without patchwork, we'll loose some
visibility about the patch status. I need to think a little more about that.

> 
> Regards
> 
> Malcolm
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

