Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36251 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbbERTPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 15:15:24 -0400
Received: by wizk4 with SMTP id k4so91082830wiz.1
        for <linux-media@vger.kernel.org>; Mon, 18 May 2015 12:15:23 -0700 (PDT)
Message-ID: <555A3A48.2010002@gmail.com>
Date: Mon, 18 May 2015 21:15:20 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >=  4.1.x
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com> <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com> <5550F842.3050604@gmail.com> <55520A08.1010605@iki.fi> <5552CB67.8070106@gmail.com> <5557CDBE.2030806@iki.fi>
In-Reply-To: <5557CDBE.2030806@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.05.2015 01:07, Antti Palosaari wrote:
> 
> 
> On 05/13/2015 06:56 AM, poma wrote:
>> On 12.05.2015 16:11, Antti Palosaari wrote:
>>> On 05/11/2015 09:43 PM, poma wrote:
>>>> On 05/11/2015 12:25 AM, poma wrote:
>>>>> On 10.05.2015 12:38, poma wrote:
>>>>>> On 08.05.2015 12:59, poma wrote:
>> Is a beer keg enough as bribe? :)
>> Just do not say that you drink juice.
>>
>> After the reverting of all changes
>> http://git.linuxtv.org/cgit.cgi/media_tree.git/log/drivers/media/tuners/mxl5007t.c
>>
>> device now survives both, 'lsdvb' and rc kernels.
>>
>> Besides, despite all this, this device is already not working at its full potential.
>> One of the tuners can withstand a few hours and then hangs.
>> After that, in the application e.g. vlc is needed to select the second tuner and so continue to use the device.
>> So this is actually a "single-seater" as Formula 1.
>> Vroom vroom!
> 
> try that
> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/commit/?h=af9015_mxl5007t_1
> 
> Antti
> 

Thanks.
For now, I have noticed, unlike before the EIT program data are updated in full and promptly.

I'll be back in a week.


