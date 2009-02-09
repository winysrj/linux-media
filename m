Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:22782 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZBIUcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 15:32:42 -0500
Received: by yw-out-2324.google.com with SMTP id 5so468189ywh.1
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2009 12:32:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49908F1F.90501@free.fr>
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr>
	 <20090129074735.76e07d47@caramujo.chehab.org>
	 <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
	 <49820C26.5090309@free.fr> <498215A8.3020203@free.fr>
	 <499086BC.4080605@free.fr>
	 <412bdbff0902091144x56a00289u55c8f65015f28365@mail.gmail.com>
	 <49908F1F.90501@free.fr>
Date: Mon, 9 Feb 2009 15:32:41 -0500
Message-ID: <412bdbff0902091232w14de97c8j2d374bdcc1f174df@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] Support faulty USB IDs on DIBUSB_MC
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: DVB list <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 9, 2009 at 3:16 PM, matthieu castet <castet.matthieu@free.fr> wrote:
> Devin Heitmueller wrote:
>> On Mon, Feb 9, 2009 at 2:40 PM, matthieu castet <castet.matthieu@free.fr> wrote:
>>> Hi,
>>>
>>> matthieu castet wrote:
>>>> matthieu castet wrote:
>>>>> Hi Patrick,
>>>>>
>>>>> Patrick Boettcher wrote:
>>>>>> Hi,
>>>>>>
>>
>> The assumption that you can only have write/read or write requests is
>> one of the big things fixed in the 1.20 firmware.  If you are running
>> the 1.20 firmware, you just need to add the option to use the new i2c
>> function instead of the legacy i2c transfer function.
> Unfortunamty this is for dib0700 and not dib3000.
> dib3000 doesn't got new firmware/i2c API.
>
> But the same patch should be done for dib0700_i2c_xfer_legacy...

Wow, I totally overlooked that your patch was against dibusb-common.c
instead of dib0700_core.c.  Yes, you are correct then.  However I
would still suggest sending an error to the console and returning
failure rather than just silently dropping the i2c read request.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
