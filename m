Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZLCVwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 16:52:45 -0500
Date: 03 Dec 2009 22:51:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: mchehab@redhat.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <BEBfoS11qgB@lirc>
In-Reply-To: <4B18292C.6070303@redhat.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

on 03 Dec 09 at 19:10, Mauro Carvalho Chehab wrote:
[...]
>>> So the lirc_imon I submitted supports all device types, with the
>>> onboard decode devices defaulting to operating as pure input devices,
>>> but an option to pass hex values out via the lirc interface (which is
>>> how they've historically been used -- the pure input stuff I hacked
>>> together just a few weeks ago), to prevent functional setups from
>>> being broken for those who prefer the lirc way.
>>
>> Hmm.  I'd tend to limit the lirc interface to the 'raw samples' case.

>> Historically it has also been used to pass decoded data (i.e. rc5) from
>> devices with onboard decoding, but for that in-kernel mapping + input
>> layer really fits better.

> I agree.

Consider passing the decoded data through lirc_dev.
- there's a large user base already that uses this mode through lirc and  
would be forced to switch to input layer if it disappears.
- that way all IR drivers would consistently use lirc interface and all  
PnP hooks could be implemented there in one place.
- drivers like lirc_imon that have to support both raw and decoded mode,  
currently have to implement both the lirc and the input interface.  
Complexity could be reduced in such cases. But maybe this is necessary  
anyway for lirc_imon that also includes mouse functionality. Jarod?

Christoph
