Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40205 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2JALkn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 07:40:43 -0400
Message-ID: <50698126.8050408@iki.fi>
Date: Mon, 01 Oct 2012 14:40:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [media/usb] Trivial fix for 3.7 if not too late
References: <1349076833-1864-1-git-send-email-pboettcher@kernellabs.com> <506980DA.6050101@iki.fi>
In-Reply-To: <506980DA.6050101@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2012 02:39 PM, Antti Palosaari wrote:
> On 10/01/2012 10:33 AM, Patrick Boettcher wrote:
>> Hi Mauro,
>>
>>
>> If it is not too late could you please incorporate the following patch
>> to 3.7.
>>
>> It fixed the autoloading of the technisat-ubs2-module when the device
>> is actually detected.
>>
>> - [PATCH] [media]: add MODULE_DEVICE_TABLE to technisat-usb2
>>
>> best regards,
>>
>> --
>> Patrick.
>
> -ENOPATCH
>
> I didn't saw it in git too.

argh, it was the next message. sorry for the noise.

Antti

-- 
http://palosaari.fi/
