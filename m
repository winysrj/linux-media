Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([76.76.67.137]:4389 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZGSPH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 11:07:57 -0400
Message-ID: <4A6336C6.8030807@mlbassoc.com>
Date: Sun, 19 Jul 2009 09:07:50 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Eino-Ville Talvala <talvala@stanford.edu>
CC: Zach LeRoy <zleroy@rii.ricoh.com>,
	"Aguirre Rodriguez, Sergio" <saaguirre@ti.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-omap <linux-omap@vger.kernel.org>
Subject: Re: Problems configuring OMAP35x ISP driver
References: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com> <4A5CBF3D.80002@stanford.edu>
In-Reply-To: <4A5CBF3D.80002@stanford.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eino-Ville Talvala wrote:
> Zach,
> 
> We've gotten a Aptina MT9P031 driver working with the latest ISP
> patchset, both with YUV and RAW data.
> I don't know what the problem might be with YUYV data - we get useful
> YUYV data without any changes to the ISP defaults.
> However, to request RAW data, that simply uses the CCDC and bypasses all
> the processing in the ISP, request the pixelformat of
> V4L2_PIX_FMT_SGRBG10.  This will give you two bytes per pixel, at least
> in our case (although we have a 12-bit sensor cut down to 10 bits), so
> be prepared to throw out every other byte.
> 
> Hope this helps,
> 
> Eino-Ville (Eddy) Talvala
> Computer Graphics Lab
> Stanford University
> 

I've been working on this same issue, using a Micron MT9T001 sensor, without
much success.  Could you share your tree and/or patches (against what?)??
This would be most helpful.

Thanks

> On 7/14/2009 9:49 AM, Zach LeRoy wrote:
>> Hello Sergio,
>>
>> I spoke with you earlier about using the ISP and omap34xxcam drivers
>> with a micron mt9d111 SOC sensor.  I have since been able to take
>> pictures, but the sensor data is not making it through the ISP
>> data-path correctly.  I know the problem is in the ISP data-path
>> because I am configuring the sensor the exact same way as I have been
>> on my working PXA system.  I am expecting 4:2:2 packed YUV data, but
>> all of the U and V data is no more than 2 bits where it should be 8. 
>> I know the ISP has a lot of capabilities, but all I want to use it for
>> is grabbing 8-bit data from my sensor and putting it in a buffer
>> untouched using the CCDC interface (and of course clocking and
>> timing).  What are the key steps to take to get this type of
>> configuration?
>>
>> Other Questions:
>>
>> Is there any processing done on YUV data in the ISP driver by default
>> that I am missing?
>> Has any one else experienced similar problems while adding new sensor
>> support?
>>
>> Any help here would be greatly appreciated.
>>
>> Thank you,
>>
>> Zach LeRoy



-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
