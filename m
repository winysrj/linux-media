Return-path: <linux-media-owner@vger.kernel.org>
Received: from doors.huapi.net.ar ([168.83.68.222]:58837 "EHLO
	doors.huapi.net.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFXPEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 11:04:06 -0400
Received: from [201.216.241.201] (helo=[192.168.101.3])
	by doors.huapi.net.ar with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <tron@acm.org>)
	id 1MJTgv-000122-JH
	for linux-media@vger.kernel.org; Wed, 24 Jun 2009 11:43:14 -0300
Message-ID: <4A423B88.9060602@acm.org>
Date: Wed, 24 Jun 2009 11:43:20 -0300
From: Carlos G Mendioroz <tron@acm.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <1460a1a20906240657t5b114b68r27beba0735a0e3f7@mail.gmail.com> <200906241623.29466.hftom@free.fr>
In-Reply-To: <200906241623.29466.hftom@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Subject: Re: [linux-dvb] how to code a driver for a tv tuner card??
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a problem, though.
Programming data for the chipsets seems not to be easily available.

I would also love to be able to make a try at supporting a card (in my
case, the HVR-2250 in analog mode) but to do so requires access to info
that I could not get.

-Carlos

Christophe Thommeret @ 24/6/2009 11:23 UTC -0300 dixit:
> Le Wednesday 24 June 2009 15:57:43 Julien Martin, vous avez écrit :
>> Hello,
>>
>> I am posting today because I am VERY interested in learning more about how
>> to code a driver for a tv tuner card.
>>
>> I am learning C and to a lesser extent Assembly.
>>
>> Could you be so kind as to answer the following questions:
>>
>> 1. What documentation do you suggest I read in order to start coding
>> drivers for tv tuner cards for Linux?
>> 2. What programming languages are used for the above purpose?
>> 3. Do I need to know electronics?
> 
>  Browsing the v4l-dvb repository should answer most of your questions ..
> 

-- 
Carlos G Mendioroz  <tron@acm.org>
