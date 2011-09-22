Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab1IVN0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 09:26:31 -0400
Message-ID: <4E7B3769.4070007@redhat.com>
Date: Thu, 22 Sep 2011 10:26:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
References: <4E7A4BA7.5050505@redhat.com> <4E7A4CA4.8040205@redhat.com> <201109220817.39634.hverkuil@xs4all.nl>
In-Reply-To: <201109220817.39634.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-09-2011 03:17, Hans Verkuil escreveu:
> On Wednesday, September 21, 2011 22:44:20 Mauro Carvalho Chehab wrote:
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
> 
> 
>> 		== Patches for Hans Verkuil <hans.verkuil@cisco.com> check == 
>>
>> Aug, 3 2010: [1/2] TVP7002: Return V4L2_DV_INVALID if any of the errors occur.      http://patchwork.linuxtv.org/patch/4064   Mats Randgaard <mats.randgaard@tandberg.com>
>> Aug, 3 2010: [2/2] TVP7002: Changed register values.                                http://patchwork.linuxtv.org/patch/4063   Mats Randgaard <mats.randgaard@tandberg.com>
> 
> As already mentioned earlier in an email, these two can be merged. So:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Applied, thanks!

Mauro
