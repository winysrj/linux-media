Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:55013 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab0JSTKb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 15:10:31 -0400
Message-ID: <4CBDED21.5040204@iki.fi>
Date: Tue, 19 Oct 2010 22:10:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Damjan Marion <damjan.marion@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl2832u support
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
In-Reply-To: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/19/2010 08:42 PM, Damjan Marion wrote:
> Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?

It is due to lack of developer making driver suitable for Kernel. I have 
done some work and have knowledge what is needed, but no time nor 
interest enough currently. It should be implement as one USB-interface 
driver and two demod drivers (RTL2830, RTL2832) to support for both 
RTL2831U and RTL2832U.

Antti
-- 
http://palosaari.fi/
