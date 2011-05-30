Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39872 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1E3HIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 03:08:44 -0400
Received: by ewy4 with SMTP id 4so1230172ewy.19
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 00:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E74B8A99-B35F-4A98-AA25-AF0D4DDA37BC@beagleboard.org>
References: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
	<E74B8A99-B35F-4A98-AA25-AF0D4DDA37BC@beagleboard.org>
Date: Mon, 30 May 2011 09:08:42 +0200
Message-ID: <BANLkTimFqgRJRRS+ejDkWO0-io9fSgvnQw@mail.gmail.com>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with
 power managament.
From: javier Martin <javier.martin@vista-silicon.com>
To: Koen Kooi <koen@beagleboard.org>
Cc: Chris Rodley <carlighting@yahoo.co.nz>, g.liakhovetski@gmx.de,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 30 May 2011 08:48, Koen Kooi <koen@beagleboard.org> wrote:
>
> Op 30 mei 2011, om 04:13 heeft Chris Rodley het volgende geschreven:
>
>> On 29/05/11 03:04, Guennadi Liakhovetski wrote:
>>> On Sat, 28 May 2011, Guennadi Liakhovetski wrote:
>>>
>>>> Hi Javier
>>>>
>>>> On Thu, 26 May 2011, javier Martin wrote:
>>>>
>>>>> I use a patched version of yavta and Mplayer to see video
>>>>> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)
>>>>
>>>> Are you really using those versions and patches, as described in
>>>> BBxM-MT9P031.txt? I don't think those versions still work with 2.6.39,
>>>> they don't even compile for me. Whereas if I take current HEAD, it builds
>>>> and media-ctl seems to run error-free, but yavta produces no output.
>>>
>>> Ok, sorry for the noise. It works with current media-ctl with no patches,
>>> so, we better don't try to confuse our users / testers:)
>>>
>>> Thanks
>>> Guennadi
>>
>> Hi,
>>
>> Still no luck getting the v3 patch working.
>> I did go back and re-test the first v1 patch that Javier released.
>> This works fine with the same version of media-ctl and yavta.
>> So it isn't either of those programs that is causing the problem.
>>
>> Must be something else.
>>
>> Will wait and see how Koen goes.
>
> I'm still stuck in "isp did no go idle" land, so even if yavta works, I can't get any output. It did output 3 frames to disk a few days ago, but that got deleted on reboot :(

I don't know guys what to tell you.
I use kernel 2.6.39 + last version of my patches + old patched yavta
version (http://download.open-technology.de/BeagleBoard_xM-MT9P031/).

Guennadi, did you manage to get it working?
I'm preparing new patches for kernel 2.6.39 which I think should be
ready for submission. I'll send them during the morning.

Thank you.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
