Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33811 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946103Ab2ERXfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 19:35:21 -0400
Received: by weyu7 with SMTP id u7so2103903wey.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 16:35:20 -0700 (PDT)
Message-ID: <4FB6DCB4.3020909@gmail.com>
Date: Sat, 19 May 2012 01:35:16 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/5] support for rtl2832
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <4FB6B55D.4060500@iki.fi>
In-Reply-To: <4FB6B55D.4060500@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/18/2012 10:47 PM, Antti Palosaari wrote:
> Good evening!
> 
> On 18.05.2012 21:47, Thomas Mair wrote:
>> Good Evening!
>>
>> This is the corrected version of the patch series to support the
>> RTL2832 demodulator. There where no major changes. The majority of
>> the changes consist in fixing style issues and adhering to proper
>> naming conventions.
> 
> Review done and seems to be OK for my eyes.
> 
>> The next question for me is how to proceed when including new
>> devices. Poma already sent an extensive list a little while
>> ago (http://patchwork.linuxtv.org/patch/10982/). Should they
>> all be included at once, or should I wait until somone confirms
>> they are working correctly and include them one by one?
> 
> It has been rule that device is added after known to work.
> 
I second that.
'rtl28xxu-v2-rtl2832-fc0012.patch' is reference&template.

> Unfortunately DVB USB do not support dynamic USB ID. In order to
> workaround that I have done some small hackish solution for the
> dvb_usb_rtl28xxu driver. Currently it works for RTL2831U based devices,
> but I see it could be easily extended for RTL2832U too by adding module
> parameter.
> 
> regards
> Antti

regards,
poma
