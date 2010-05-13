Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0EMSVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 14:21:43 -0400
Message-ID: <4BEC432D.5010501@redhat.com>
Date: Thu, 13 May 2010 15:21:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Sander Pientka <cumulus0007@gmail.com>,
	linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Mercurial x git tree sync - was: Re: Remote control at Zolid
 Hybrid TV Tuner
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>	 <1266375385.3176.5.camel@pc07.localdom.local>	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>	 <1266445236.7202.17.camel@pc07.localdom.local>	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>	 <4BEAFA76.5070809@redhat.com>	 <1273721312.10695.12.camel@pc07.localdom.local>	 <4BEB84F5.5030506@redhat.com>	 <1273736253.3197.71.camel@pc07.localdom.local>	 <4BEBF165.4070603@redhat.com> <1273772767.3195.21.camel@pc07.localdom.local>
In-Reply-To: <1273772767.3195.21.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:

>> My view is that the backport tree is very useful to have a broader number
>> of people testing V4L/DVB code, as it can be applied against legacy kernels.
>> Of course, for this to work, people should quickly fix broken backports
>> (that means that not only Douglas should work on it, but other developers
>> are welcomed to contribute with backport fixes).
> 
> For now, if not using git, Sander needs a 2.6.33 with recent v4l-dvb
> then to provide relevant debug output and eventually patches.

Until Douglas or someone fix the breakages with older kernels, yes.

> He has to
> check if his distribution has the minimal requirements for that one too.

In thesis, yes, but, unless he is running a really old distribution 
(those that come with kernels lower than 2.6.16), it should be ok to 
run 2.6.33 on it, provided that properly compiled with the minimum
requirements needed by the distro. Generally, "make oldconfig" do a
good job of enabling the needed bits, but sometimes, manual adjustments
at compilation parameters might be needed.

Well, if the distro is older than 2.6.16, it won't be capable of running 
from -hg anyway (as the minimum supported kernel is 2.6.16). So, I don't 
think that this would be a problem, in practice.

-- 

Cheers,
Mauro
