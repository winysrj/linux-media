Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:2717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1EHQFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 12:05:14 -0400
Message-ID: <4DC6BF28.8070006@redhat.com>
Date: Sun, 08 May 2011 13:04:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH 0/6] DVB-T2 API updates, documentation and accompanying
 small fixes
References: <4DC417DA.5030107@redhat.com> <1304869873-9974-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304869873-9974-1-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 08-05-2011 12:51, Steve Kerrison escreveu:
> Hi Mauro, Antti, Andreas,
> 
> I hope this patch set is formed appropriately - it is my first patch
> submission direct to the linux-media group.

They look sane on my eyes. I'll comment patch by patch were needed. Non-commented
patches mean that they're ok.

PS.: as I'm traveling abroad this week, I may eventually not apply the patch series this
week.
> 
> Following the pull of Antti's work on support for the cxd2820r and PCTV
> nanoStick T2 290e, this patch set implements Andreas' modifications to the API
> to give provisional DVB-T2 support and the removal of a workaround for this
> in the cxd2820r module.
> 
> In addition, there are some minor fixes to compiler warnings as a result
> of the expanded enums. I cannot test these myself but they treat unrecognized
> values as *_AUTO and I can't see where a problem would be created.
> 
> I have updated the documentation a little. If I've done the right thing then
> I guess there is incentive there for me continue to expand DVB related
> elements of the API docs.
> 
> This patch set has been tested by me on two systems, with one running a MythTV
> backend utilising a long-supported DVB tuner. MythTV works fine with the old
> tuner and the nanoStick T2 290e works in VLC. I've yet to test the 290e in
> MythTV - I was more intent on making sure the patches hadn't broken userland
> or older devices.
> 
> Feedback, testing  and discussion of where to go next is welcomed!
> 
> Regards,
> Steve Kerrison.
> 

