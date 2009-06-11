Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43963 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZFKNht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 09:37:49 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 11 Jun 2009 08:37:43 -0500
Subject: RE: [PATCH] adding support for setting bus parameters in sub device
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08F69@dlee06.ent.ti.com>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <200906102251.57644.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0906102311410.4817@axis700.grange>
 <200906102351.34219.hverkuil@xs4all.nl>
In-Reply-To: <200906102351.34219.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>> Why force all platforms to set it if the driver is perfectly capable do
>> this itself? As I said - this is not a platform-specific feature, it's
>> chip-specific. What good would it make to have all platforms using
>> mt9t031 to specify, that yes, the chip can use both falling and rising
>> pclk edge, but only active high vsync and hsync?
>
>???
>
>You will just tell the chip what to use. So you set 'use falling edge' and
>either set 'active high vsync/hsync' or just leave that out since you know
>the mt9t031 has that fixed. You don't specify in the platform data what the
>chip can support, that's not relevant. You know what the host expects and
>you pass that information on to the chip.
>
>A board designer knows what the host supports, knows what the sensor
>supports, and knows if he added any inverters on the board, and based on
>all that information he can just setup these parameters for the sensor
>chip. Settings that are fixed on the sensor chip he can just ignore, he
>only need to specify those settings that the sensor really needs.
>
[MK] I agree with Hans. Looking my experience with various platforms, this is true. We have following decoders connected to the VPFE bus working in our internal release kernel. In all these cases, the bus parameters are fixed given a board and the platform. Given below are the list of boards, and decoders connected and bus available....

DM6446 -Bayer RGB bus(10 bit connected to MSB), Vsync, Hsync, PCLK
	  (MT9T001)
	 -YUV bus (embedded sync / separate sync), PCLK, Vsync, HSync, Field
	  (TVP5146) - 8/10 bit data bus
DM355 - Same as above 
	- VPFE Also supports YUV bus with 16 bit bus (8 bit, Y and 8 bit 
	  Cb/Cr), but no decoders tested with this interface.
DM365 - Bayer RGB bus Same as above
	- YUV bus - similar to that in DM355
	- TVP7002 - connected through 16 bit YUV bus with embedded sync 
	  (BT.1120)

>> > BTW, looking at the code there doesn't seem to be a bus type (probably
>> > only Bayer is used), correct? How is the datawidth negotiation done? Is
>> > the largest available width chosen? I assume that the datawidth is
>> > generally fixed by the host? I don't quite see how that can be
>> > negotiated since what is chosen there is linked to how the video data
>> > is transferred to memory. E.g., chosing a bus width of 8 or 10 bits can
>> > be the difference between transferring 8 bit or 16 bit data (with 6
>> > bits padding) when the image is transferred to memory. If I would
>> > implement negotiation I would probably limit it to those one-bit
>> > settings and not include bus type and width.
>>
>> Well, this is indeed hairy. And hardware developers compete in creativity
>> making us invent new and new algorithms:-( I think, so far _practically_
>> I have only worked with the following setups:
>>
>> 8 bit parallel with syncs and clocks. Data can be either Bayer or YUV.
>> This is most usual in my practice so far.
>>
>> 10 bit parallel (PXA270) with syncs and clocks bus with an 8 bit sensor
>> connected to most significant lanes... This is achieved by providing an
>> additional I2C controlled switch...
>>
>> 10 bit parallel with a 10 bit sensor, data 0-extended to 16 bit, raw
>> Bayer.
>>
>> 15 bit parallel bus (i.MX31) with 8 bit sensor connected to least
>> significant lanes, because i.MX31 is smart enough to use them correctly.
>>
>> ATM this is a part of soc-camera pixel format negotiation code, you can
>> look at various .set_bus_param() methods in sensor drivers. E.g., look in
>> mt9m001 and mt9v022 for drivers, using external bus-width switches...
>>
>> Now, I do not know how standard these various data packing methods on the
>> bus are, I think, we will have to give it a good thought when designing
>> an API, comments from developers familiar with various setups are much
>> appreciated.
>
>I think we should not attempt to be too fancy with this part of the API.
>Something like the pixel format API in the v4l2 spec which is basically
>just a random number with an associated format specification and no attempt
>and trying high-level format descriptions. In this case a simple enum might
>be enough. I'm not even sure whether we should specify the bus width but
>instead have it implicit in the bus type.
>
[MK] VPFE at least need to know if YUV bus has sync embedded or separate sync lines as well if it 10 bit or 8 bit. Similarly it needs 16 bit for interfacing with TVP7002.  For Raw Bayer, it needs to know the size of valid data on the bus and where the MSB of the sensor is connected (this can be specified in the platform data of the bridge driver, and is not applicable for sensor device). So data width information could either be explicit in the bus type or could be specified in width parameter. Both works for our driver.

What about embedded sync bool I have added in the latest patch? This can be removed too if it is explicit in the bus type. But my preference is to keep them as per my latest patch. I am also not sure if query capability will be really useful versus defining them per board/platform basis. 

>I'm sure we are never going to be able to come up with something that will
>work on all hardware, so perhaps we shouldn't try to. Each different format
>gets its own type. Which is OK I think as long as that format is properly
>documented.
>
>Regards,
>
>	Hans
>
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

