Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:26135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1EIDK0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 23:10:26 -0400
Message-ID: <4DC75B0E.7030508@redhat.com>
Date: Mon, 09 May 2011 00:10:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Steve Kerrison <steve@stevekerrison.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] DVB-T2 API updates, documentation and accompanying
 small fixes
References: <4DC417DA.5030107@redhat.com>	 <1304869873-9974-1-git-send-email-steve@stevekerrison.com>	 <4DC6BF28.8070006@redhat.com> <1304875061.2920.13.camel@ares> <4DC71884.6040400@linuxtv.org>
In-Reply-To: <4DC71884.6040400@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 08-05-2011 19:26, Andreas Oberritter escreveu:
> On 05/08/2011 07:17 PM, Steve Kerrison wrote:
>> Quick question about resubmission:
>>
>> Do I resubmit all 6 (5 after fold) patches as v2, or can I ignore what
>> is currently patch 5 as it is uncommented? I don't know enough about
>> patchwork to know whether changing the PATCH x/n will break things or
>> what the proper procedure is. (RTFM with appropriate URL is an
>> appropriate response to this, of course :) )
> 
> I think that previously submitted, now obsolete patches need to be
> marked as superseded by hand in patchwork in any case.

Yes, but I think that only me do such change at patchwork. Unfortunately, 
patchwork has an all or nothing access: it is either Read only or full
access to all patches, even on delegate mode.

I'll mark the old patches as superseded soon.

Mauro.

> 
> Regards,
> Andreas

