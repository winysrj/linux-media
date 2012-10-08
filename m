Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62623 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2JHJ3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 05:29:04 -0400
Message-id: <50729CDA.5030500@samsung.com>
Date: Mon, 08 Oct 2012 11:28:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 10/14] media: soc-camera: support OF cameras
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-11-git-send-email-g.liakhovetski@gmx.de>
 <506F30E8.10206@gmail.com> <Pine.LNX.4.64.1210081028270.11034@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1210081028270.11034@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10/08/2012 10:37 AM, Guennadi Liakhovetski wrote:
>>>   	case BUS_NOTIFY_BOUND_DRIVER:
>>
>> There is no need for different handling of this event as well ?
> 
> There is. The former is entered before the sensor I2C probe method is 
> called and prepares the data for probing, the latter is entered after a 
> successful sensor I2C probing.
> 
>> Further, there is code like:
>>
>> 	adap = i2c_get_adapter(icl->i2c_adapter_id);
>>
>> which is clearly not going to work in OF case.
> 
> It does work. See the call to soc_camera_of_i2c_ifill() under 
> BUS_NOTIFY_BIND_DRIVER above. In it
> 
> 	icl->i2c_adapter_id = client->adapter->nr;
> 
>> Could you clarify how it is supposed to work ?
> 
> It is not only supposed to work, it actually does work. Does the above 
> explain it sufficiently?

Sorry, my fault. Somehow I didn't realize there is being passed
an I2C adapter already assigned by the I2C core. I confused it with
some static adapter nr, which would be -1 for dt case.
Apologies for wasting your time with those non-constructive questions.

--

Thanks,
Sylwester
