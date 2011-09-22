Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1IVNWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 09:22:42 -0400
Message-ID: <4E7B3675.8050601@redhat.com>
Date: Thu, 22 Sep 2011 10:21:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
References: <4E7A4BA7.5050505@redhat.com> <4E7A4CA4.8040205@redhat.com> <Pine.LNX.4.64.1109220022240.24024@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109220022240.24024@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-09-2011 05:21, Guennadi Liakhovetski escreveu:
> On Wed, 21 Sep 2011, Mauro Carvalho Chehab wrote:
> 
>> Em 21-09-2011 17:40, Mauro Carvalho Chehab escreveu:
>>> As announced on Sept, 18, we moved our patch queue to patchwork.linuxtv.org.
>>>
>>> As we were without access to the old patchwork instance, I simply sent all
>>> emails I had locally stored on my local mahine to the new instance and reviewed
>>> all patches again. Basically, for old patches, I basically did some scripting
>>> that were marking old patches as "superseded", if they didn't apply anymore.
>>> I also preserved the patches that were marked as "under review" from patchwork
>>> time, using some scripting and a local control file.
>>>
>>> So, we're basically close to what we had before kernel.org troubles (except for
>>> a series of patches that I've already applied today).
>>>
>>> My intention is to finish review all patches marked as "new" until the end of this
>>> week, and set a new tree for linux-next with our stuff (as the old one were at
>>> git.kernel.org).
>>>
>>> Please let me know if something is missed or if some patch from the list bellow
>>> is obsolete and can be marked with a different status.
>>>
>>> Thanks!
>>> Mauro
>>>
>>>
>>> 		== New patches == 
>>
>> Gah! forgot to update the URL on my script. the patch list with the right URL is:
>>
>> 		== New patches == 
> 
> 
> 
>> Sep, 6 2011: [v2] at91: add code to initialize and manage the ISI_MCK for Atmel ISI http://patchwork.linuxtv.org/patch/7780   Josh Wu <josh.wu@atmel.com>
> 
> More work is needed on this one
<snip>

Patches updated,
Thanks!
Mauro
