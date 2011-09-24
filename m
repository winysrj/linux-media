Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1IXPRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 11:17:13 -0400
Message-ID: <4E7DF467.5070807@redhat.com>
Date: Sat, 24 Sep 2011 12:16:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: LMML <linux-media@vger.kernel.org>, Pawel Osiak <pawel@osciak.com>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Eddi De Pieri <eddi@depieri.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Status of the patches under review at LMML (28 patches)
References: <4E7DCE71.4030200@redhat.com> <1316875947.12899.8.camel@palomino.walls.org>
In-Reply-To: <1316875947.12899.8.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 11:52, Andy Walls escreveu:
> On Sat, 2011-09-24 at 09:34 -0300, Mauro Carvalho Chehab wrote:
>> Everything at patchwork were reviewed by me, and I've applied all patches
>> that I didn't notice any review by the drivers maintainers.
>>
>> Driver maintainers:
>> Please review the remaining patches.
> 
>> 		== Patches for Andy Walls <Andy Walls <awalls@md.metrocast.net>> review == 
>>
>> May,25 2011: ivtv: use display information in info not in var for panning           http://patchwork.linuxtv.org/patch/6706   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> You committed this one from one of my pull requests.  The subject line
> changed a little (ivtv: -> ivtvfb:)
> 
> http://www.gossamer-threads.com/lists/ivtv/devel/41425
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=5d9c08dea0c13c09408f97fe61d34c198c4f3277
> http://lkml.org/lkml/2011/6/7/311

Ok. Patch updated.

> 
>> 		== Waiting for Andy Walls <awalls@md.metrocast.net> double-check == 
>>
>> Dec,19 2010: [RESEND, for, 2.6.37] cx23885, cx25840: Provide IR Rx timeout event re http://patchwork.linuxtv.org/patch/5133   Andy Walls <awalls@md.metrocast.net>
> 
> By inspection, this one is still OK.  It is still relevant and looks
> like it still should apply cleanly.  I have not compile tested it
> recently.

Thanks! Applied.
> 
> 
>> 		== waiting for Michael Krufky <mkrufky@linuxtv.org> review == 
>>
>> Sep, 4 2011: Medion 95700 analog video support                                      http://patchwork.linuxtv.org/patch/7767   Maciej Szmigiero <mhej@o2.pl>
> 
> I need to comment on the cx25840 portion of this patch.  I plan to make
> time to do that in a few hours. 

Thank you!
Mauro
