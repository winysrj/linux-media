Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64189 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab0EMSp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 14:45:58 -0400
Received: by gwj19 with SMTP id 19so781484gwj.19
        for <linux-media@vger.kernel.org>; Thu, 13 May 2010 11:45:57 -0700 (PDT)
Message-ID: <4BEC48DF.8060900@gmail.com>
Date: Thu, 13 May 2010 15:45:51 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Sander Pientka <cumulus0007@gmail.com>,
	linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Mercurial x git tree sync - was: Re: Remote control at Zolid
 Hybrid TV Tuner
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>	 <1266375385.3176.5.camel@pc07.localdom.local>	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>	 <1266445236.7202.17.camel@pc07.localdom.local>	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>	 <4BEAFA76.5070809@redhat.com>	 <1273721312.10695.12.camel@pc07.localdom.local>	 <4BEB84F5.5030506@redhat.com>	 <1273736253.3197.71.camel@pc07.localdom.local>	 <4BEBF165.4070603@redhat.com> <1273772767.3195.21.camel@pc07.localdom.local> <4BEC432D.5010501@redhat.com>
In-Reply-To: <4BEC432D.5010501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> hermann pitton wrote:
> 
>>> My view is that the backport tree is very useful to have a broader number
>>> of people testing V4L/DVB code, as it can be applied against legacy kernels.
>>> Of course, for this to work, people should quickly fix broken backports
>>> (that means that not only Douglas should work on it, but other developers
>>> are welcomed to contribute with backport fixes).
>> For now, if not using git, Sander needs a 2.6.33 with recent v4l-dvb
>> then to provide relevant debug output and eventually patches.
> 
> Until Douglas or someone fix the breakages with older kernels, yes.

As the fix patch is really trivial, I found a couple of minutes to write a patch
for fixing this issue. I haven't test the patch, but, as it uses the same backport
logic as found at cx2355-ir, I don't expect much troubles on it.

-- 

Cheers,
Mauro
