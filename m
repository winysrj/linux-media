Return-path: <linux-media-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:52700 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbZBXOec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 09:34:32 -0500
Received: from aamtaout02-winn.ispmail.ntl.com ([81.103.221.35])
          by mtaout02-winn.ispmail.ntl.com
          (InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP
          id <20090224143427.HPDW4080.mtaout02-winn.ispmail.ntl.com@aamtaout02-winn.ispmail.ntl.com>
          for <linux-media@vger.kernel.org>;
          Tue, 24 Feb 2009 14:34:27 +0000
Received: from gateway.localdomain ([86.10.71.240])
          by aamtaout02-winn.ispmail.ntl.com
          (InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP
          id <20090224143427.EZQZ21638.aamtaout02-winn.ispmail.ntl.com@gateway.localdomain>
          for <linux-media@vger.kernel.org>;
          Tue, 24 Feb 2009 14:34:27 +0000
Message-ID: <49A40571.90306@tesco.net>
Date: Tue, 24 Feb 2009 14:34:25 +0000
From: John Pilkington <J.Pilk@tesco.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <20090223144917.257a8f65@hyperion.delvare>	<49A3DDFC.6010608@tesco.net> <20090224141540.4b8a765f@hyperion.delvare>
In-Reply-To: <20090224141540.4b8a765f@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean:
Jean Delvare wrote:
> Hi John,
> 
> (re-adding linux-media on Cc as I doubt you dropped it on purpose...)

Right: I do subconsciously expect 'reply' to go to the list, and don't 
always remember to check first.  No doubt you got two copies.
> 
> On Tue, 24 Feb 2009 11:46:04 +0000, John Pilkington wrote:
>> Jean Delvare wrote:
>>
>>> * Enterprise-class distributions (RHEL, SLED) are not the right target
>>>   for the v4l-dvb repository, so we don't care which kernels these are
>>>   running.
>> I think you should be aware that the mythtv and ATrpms communities 
>> include a significant number of people who have chosen to use the 
>> CentOS_5 series in the hope of getting systems that do not need to be 
>> reinstalled every few months.  I hope you won't disappoint them.
> 
> CentOS is a parasite, if it dies I can't care less. CentOS users have
> the recurrent habit to expect professional support from the community
> without giving anything in return. Even worse: they consider that
> running an antediluvian OS is the default and they don't understand why
> upstream developers won't help them.
> 
> You said it yourself: they expect to be able to keep the same system
> for a long time. This is a service you normally get from Red Hat or
> Novell, and you pay for it. This is something the community is
> generally not willing to offer for free, because it is not fun.

I know there is a range of visions from linux-as-playground to 
linux-as-tool. Sometimes just learning to use the tool is not a trivial 
matter, and shows enthusiasm too. I recognize that enthusiasm is the 
great driver of development, but would still hope that users might 
expect to be able to slow their personal treadmills without actually 
falling off. :-)
> 
> If the MythTV community cares that much about the v4l-dvb tree, they are
> free to fork it right before support for kernel 2.6.18 is dropped, and
> maintain that copy themselves. But their model is broken to start with:
> sticking to a several-year-old kernel and OS, and OTOH picking critical
> (for their use case) kernel drivers from a development tree which
> evolves continuously by definition, makes little sense. Then again, I
> would be happy to keep support for them if the cost wasn't too high.
> But right now, the cost _is_ too high.
> 
> Your view of community distributions is a bit too negative BTW. You
> don't need to go to the extreme CentOS_5 is to not have to reinstall
> every few months. openSUSE distributions are maintained for 2 years for
> example.
> 

