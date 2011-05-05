Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1EEOlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 10:41:47 -0400
Received: by bwz15 with SMTP id 15so1888460bwz.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 07:41:46 -0700 (PDT)
Message-ID: <4DC2B797.3040202@gmail.com>
Date: Thu, 05 May 2011 16:43:35 +0200
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>	<4DC1236C.3000006@linuxtv.org> <19905.13923.40846.342434@morden.metzler> <4DC146E1.3000103@linuxtv.org> <4DC15633.3030300@gmail.com> <4DC166D4.4090408@linuxtv.org>
In-Reply-To: <4DC166D4.4090408@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Broadly speaking, I could put issues discussed in this thread into 
following categories:

- How devices are named;
- How devices are used;
- How devices relate to one another;
- How devices are enumerated;
- How devices are described;

Mostly we discuss category 1 and 2 with relation to nGENE CI, but 
sometimes we leap to other categories as well.

Andreas Oberritter wrote:
> On 05/04/2011 03:35 PM, Martin Vidovic wrote:
 >>
>> I think there is currently no useful API to connect devices. Every few
>> months there comes a new device which deprecates how I enumerate devices
>> and determine types of FE's.
> 
> Can you describe the most common problems? What do you mean by connecting?

What I mean by connecting devices falls into last 3 categories (above). 
I brought this up because I don't believe this is the actual problem we 
need to solve here since it's not nGENE specific.

Some examples of problems in categories 3-5:

a) Plug two TerraTec Cinergy T RC MKII and try to distinguish between them.

b) Take a Hybrid terrestrial TV tuner. V4L and DVB APIs (may) use shared 
resources, how does one find this out?

c.1) How does one know which frontend device can be used with which 
demux device?

c.2) Which CA device can be used with which frontend device?

d) How does one list all supported delivery systems for a device 
(FE_GET_INFO is not general, and DTV_DELIVERY_SYSTEM can't be used to 
query available delivery systems).

e) the list could be extended...

These problems are mostly not fatal, they have workarounds. Some of them 
require device/driver specific knowledge.

>> The most useful way to query devices seems to be using HAL, and I think
>> this is the correct way in Linux, but DVB-API may be lacking with
>> providing the necessary information. Maybe this is the direction we
>> should consider? Device names under /dev seem to be irrelevant nowadays.
> 
> I think in the long run we should look closely at how V4L2 is solving
> similar problems.

The best would be to create independent adapters for each independent CA 
device (ca0/caio0 pair) - they are independent after all (physically and 
in the way they're used).

What I understand you would like to see, is the ability to do direct 
transfers between independent devices or parts of devices. Is this correct?

Best regards,
Martin Vidovic
