Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51547 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0JSTdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 15:33:14 -0400
Received: by eyx24 with SMTP id 24so199849eyx.19
        for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 12:33:13 -0700 (PDT)
Subject: Re: rtl2832u support
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Damjan Marion <damjan.marion@gmail.com>
In-Reply-To: <4CBDED21.5040204@iki.fi>
Date: Tue, 19 Oct 2010 21:33:10 +0200
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EDE698A2-FCE2-4BE2-BE08-EB5FAF162B8F@gmail.com>
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com> <4CBDED21.5040204@iki.fi>
To: Antti Palosaari <crope@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On Oct 19, 2010, at 9:10 PM, Antti Palosaari wrote:
> On 10/19/2010 08:42 PM, Damjan Marion wrote:
>> Is there any special reason why driver for rtl2832u DVB-T receiver chipset is not included into v4l-dvb?
> 
> It is due to lack of developer making driver suitable for Kernel. I have done some work and have knowledge what is needed, but no time nor interest enough currently. It should be implement as one USB-interface driver and two demod drivers (RTL2830, RTL2832) to support for both RTL2831U and RTL2832U.

Can you share what you done so far?

