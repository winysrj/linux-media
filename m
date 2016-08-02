Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42333 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbcHBHfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 03:35:44 -0400
Subject: Re: [PATCH v7 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: "Wu, Songjun" <Songjun.Wu@microchip.com>, nicolas.ferre@atmel.com
References: <1469778856-24253-1-git-send-email-songjun.wu@microchip.com>
 <1469778856-24253-2-git-send-email-songjun.wu@microchip.com>
 <f77652aa-3d41-d85f-11a9-9f5290223834@xs4all.nl>
 <b32b2346-cc11-521e-c2f8-6d9e951c7a16@microchip.com>
Cc: robh@kernel.org, laurent.pinchart@ideasonboard.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, linux-kernel@vger.kernel.org,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cdb406b8-bb1e-9a78-e07c-f5df3dbcfe34@xs4all.nl>
Date: Tue, 2 Aug 2016 09:32:44 +0200
MIME-Version: 1.0
In-Reply-To: <b32b2346-cc11-521e-c2f8-6d9e951c7a16@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2016 08:20 AM, Wu, Songjun wrote:
>>> +static unsigned int sensor_preferred = 1;
>>> +module_param(sensor_preferred, uint, S_IRUGO|S_IWUSR);
>>> +MODULE_PARM_DESC(sensor_preferred,
>>> +		 "Sensor is preferred to output the specified format (1-on 0-off) default 1");
>>
>> I have no idea what this means. Can you elaborate? Why would you want to set this to 0?
>>
> ISC can convert the raw format to the other format, e.g. YUYV.
> If we want to output YUYV format, there are two choices, one is the 
> sensor output YUYV format, ISC bypass the data to the memory, the other 
> is the sensor output raw format, ISC convert raw format to YUYV.
> 
> So I provide a module parameter to user to select.
> I prefer to select the sensor to output the specified format, then I set 
> this parameter to '1', not '0'.

Does this only apply to YUYV?

The reason I am hesitant about this option is that I am not convinced you need
it. The default (sensor preferred) makes sense and that's what other drivers
do as well. Unless you know of a real use-case where you want to set this to 0,
I would just drop this option.

If there *is* a real use-case, then split off adding this module option into a
separate patch so we can discuss it more without blocking getting this driver
into mainline. I don't like the way this is done here.

Regards,

	Hans
