Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36865 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbcGVHVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 03:21:19 -0400
Subject: Re: [PATCH v6 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: "Wu, Songjun" <Songjun.Wu@microchip.com>, nicolas.ferre@atmel.com,
	robh@kernel.org
References: <1469088900-23935-1-git-send-email-songjun.wu@microchip.com>
 <1469088900-23935-2-git-send-email-songjun.wu@microchip.com>
 <3ad06658-1e5f-2cd0-f092-4d8f50b4aaa6@xs4all.nl>
 <bc8fc3da-9fe0-71ee-e55a-4d8c50b10cd3@microchip.com>
Cc: laurent.pinchart@ideasonboard.com,
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
Message-ID: <ebd3617c-ad3c-d0e0-e024-b72924b5f864@xs4all.nl>
Date: Fri, 22 Jul 2016 09:21:07 +0200
MIME-Version: 1.0
In-Reply-To: <bc8fc3da-9fe0-71ee-e55a-4d8c50b10cd3@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/22/2016 07:18 AM, Wu, Songjun wrote:

<snip>

>>> +/*
>>> + * index(0~11):  raw formats.
>>> + * index(12~12): the formats which can be converted from raw format by ISC.
>>> + * index():      the formats which can only be provided by subdev.
>>> + */
>>> +static struct isc_format isc_formats[] = {
>>
>> static const
>>
> Some members in structure isc_format need be modified, so it can not be 
> const.

OK. Please add a comment about that.

Regards,

	Hans
