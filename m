Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:43185 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750702AbZGBJlu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 05:41:50 -0400
Message-ID: <4A4C80DE.5000103@epfl.ch>
Date: Thu, 02 Jul 2009 11:41:50 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC] fix cropping and scaling for mx3-camera and mt9t031
 drivers
References: <Pine.LNX.4.64.0906301656471.5748@axis700.grange> <4A4B9416.7040107@epfl.ch> <Pine.LNX.4.64.0907012048340.5609@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907012048340.5609@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 1 Jul 2009, Valentin Longchamp wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> While trying all possible skipping / binning combinations of mt9t031 I
>>> came across a problem, that in some configurations the sensor produces
>>> regular horizontal stripes. They depend on window geometry, with some
>>> skipping factors they can be eliminated by using properly aligned left
>>> window border, but with some other AFAICS valid parameter combinations
>>> stripes persist. And - they seem to depend on lighting conditions... I
>>> think, I'll try to ask Aptina again... Or does anyone have an idea what I
>>> might be doing wrong?
>> It may be completely unrelated, but we had quite similar problem with
>> our hardware. With a part of the image "saturated", we had some
>> artefacts (missing data in fact) on some horizontal lines: pixclk wave
>> was poor and the i.MX31 could not read data correctly. In order to
>> resovle this problem, we had to change the bus drivers (we now use some
>> SN74LVCH16244ADGGR that work well with the 3V3 signals from the camera).
>> Now even with high contrast and some parts saturated, pix clk looks nice and
>> we don't loose pixels anymore.
> 
> Hm interesting. What exactly did those missing pixels look like in your 
> case? In my case these are periodic horizontal lines of 1 or 2 (approx.) 
> pixels wide. Sometimes they are repeated one such stripe every x pixels, 
> sometimes they are repeated in pairs.
> 

Mine were a bit different: they started at a the pixel where there was a 
border between a saturated and unsaturated area and then the pixels were 
missing until the end of the line. The line below usually was correct 
(but not always) and it did happen again 2-3 pixels below if the border 
was still present.

But since yours are dependant to lightning conditions and also happen on 
horizontal lines, it may also be something related to what has happened 
for us. I would suggest that you really control the pixclk signal.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
