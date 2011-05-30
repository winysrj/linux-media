Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61390 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1E3Gs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 02:48:57 -0400
Received: by wya21 with SMTP id 21so2407970wya.19
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 23:48:56 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
Date: Mon, 30 May 2011 08:48:52 +0200
Cc: g.liakhovetski@gmx.de, javier.martin@vista-silicon.com,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E74B8A99-B35F-4A98-AA25-AF0D4DDA37BC@beagleboard.org>
References: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
To: Chris Rodley <carlighting@yahoo.co.nz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 30 mei 2011, om 04:13 heeft Chris Rodley het volgende geschreven:

> On 29/05/11 03:04, Guennadi Liakhovetski wrote:
>> On Sat, 28 May 2011, Guennadi Liakhovetski wrote:
>> 
>>> Hi Javier
>>> 
>>> On Thu, 26 May 2011, javier Martin wrote:
>>> 
>>>> I use a patched version of yavta and Mplayer to see video
>>>> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)
>>> 
>>> Are you really using those versions and patches, as described in 
>>> BBxM-MT9P031.txt? I don't think those versions still work with 2.6.39, 
>>> they don't even compile for me. Whereas if I take current HEAD, it builds 
>>> and media-ctl seems to run error-free, but yavta produces no output.
>> 
>> Ok, sorry for the noise. It works with current media-ctl with no patches, 
>> so, we better don't try to confuse our users / testers:)
>> 
>> Thanks
>> Guennadi
> 
> Hi,
> 
> Still no luck getting the v3 patch working.
> I did go back and re-test the first v1 patch that Javier released.
> This works fine with the same version of media-ctl and yavta.
> So it isn't either of those programs that is causing the problem.
> 
> Must be something else.
> 
> Will wait and see how Koen goes.

I'm still stuck in "isp did no go idle" land, so even if yavta works, I can't get any output. It did output 3 frames to disk a few days ago, but that got deleted on reboot :(