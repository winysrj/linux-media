Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1FBJTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 05:19:50 -0400
Received: by wya21 with SMTP id 21so449306wya.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 02:19:49 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH v6 2/2] Add support for mt9p031 sensor in Beagleboard XM.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <BANLkTimDJG3xgwhKznQG0sHKKutmHQSOpw@mail.gmail.com>
Date: Thu, 2 Jun 2011 11:19:45 +0200
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
Content-Transfer-Encoding: 8BIT
Message-Id: <9B67B12E-0A3B-4D31-A708-44C1AF06A242@beagleboard.org>
References: <1306942609-2440-1-git-send-email-javier.martin@vista-silicon.com> <1306942609-2440-2-git-send-email-javier.martin@vista-silicon.com> <F6CCC3E5-67AF-4D22-9541-C31A91924DFE@beagleboard.org> <BANLkTimDJG3xgwhKznQG0sHKKutmHQSOpw@mail.gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 2 jun 2011, om 08:52 heeft javier Martin het volgende geschreven:

> Hi Koen,
> 
> On 1 June 2011 20:08, Koen Kooi <koen@beagleboard.org> wrote:
>> 
>> Op 1 jun 2011, om 17:36 heeft Javier Martin het volgende geschreven:
>> 
>>> New "version" and "vdd_io" flags have been added.
>>> 
>>> A subtle change now prevents camera from being registered
>>> in the wrong platform.
>> 
>> I get a decent picture now with the following:
>> 
>> media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>> 
>> yavta-nc --stdout -f SGRBG8 -s 320x240 -n 4 --capture=10000 --skip 3 -F $(media-ctl -e "OMAP3 ISP CCDC output") | mplayer-bayer - -demuxer  rawvideo -rawvideo w=320:h=240:format=ba81:size=76800 -vo fbdev2 -vf ba81
>> 
>> 720p also seems to work.
>> 
>> It is really, really dark though. Is this due to missing controls or due to the laneshifting?
> 
> I suspect it is due to the patched mplayer.
> I know this because I have enabled some custom patterns in the sensor,
> thus generating pure red, blue and green pictures and they didn't seem
> so when played through mplayer-bayer.
> 
> You could try the same if you want. Just to confirm.

So mplayer-bayer is a bad test :) So what other tool(chain) can I use to display images captured with this driver? Ideally I would use mediactl to point the CCDC output to the v4l2 overlay, but I guess that would need some extra code in the ISP and omapvout drivers.
I heard it's really sunny in Texas where they will be testing this, so the mplayer darkness might be OK for there.

regards,

Koen