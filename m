Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:37729 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0JSTlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 15:41:53 -0400
Message-ID: <4CBDF47F.6040702@iki.fi>
Date: Tue, 19 Oct 2010 22:41:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Damjan Marion <damjan.marion@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl2832u support
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com> <4CBDED21.5040204@iki.fi> <EDE698A2-FCE2-4BE2-BE08-EB5FAF162B8F@gmail.com>
In-Reply-To: <EDE698A2-FCE2-4BE2-BE08-EB5FAF162B8F@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/19/2010 10:33 PM, Damjan Marion wrote:
>
> On Oct 19, 2010, at 9:10 PM, Antti Palosaari wrote:
>> On 10/19/2010 08:42 PM, Damjan Marion wrote:
>>> Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
>>
>> It is due to lack of developer making driver suitable for Kernel. I have done some work and have knowledge what is needed, but no time nor interest enough currently. It should be implement as one USB-interface driver and two demod drivers (RTL2830, RTL2832) to support for both RTL2831U and RTL2832U.
>
> Can you share what you done so far?

Look LinuxTV.org HG trees. There is Jan and my trees, both for RTL2831U. 
I split driver logically correct parts. Also I have some RTL2832U hacks 
here in my computer, I can give those for the person really continuing 
development.

Antti

-- 
http://palosaari.fi/
