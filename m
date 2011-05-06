Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1EFPqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 11:46:50 -0400
Message-ID: <4DC417DA.5030107@redhat.com>
Date: Fri, 06 May 2011 12:46:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C demodulator
 driver
References: <20110506125542.ADA1D162E7@stevekerrison.com> <4DC41409.4000705@redhat.com>
In-Reply-To: <4DC41409.4000705@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-05-2011 12:30, Mauro Carvalho Chehab escreveu:
> Em 06-05-2011 09:55, Steve Kerrison escreveu:
>> If antti doesn't do this before me, I will look at this over the weekend and generate a patch against antti's current code... if that's appropriate of course (I'm new at this ;))
> 
> Feel free to do it. I suspect that Antti won't work on it during this weekend. From
> what I understood, he's travelling in vacations.
> 
> It helps if you could also add the bits into the frontend API DocBook:
> 	Documentation/DocBook/dvb/dvbproperty.xml  
> 
> The chapter that describes DVBv5 extensions is at:
> 	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_PROPERTY.html

Just updated the above URL to reflect my last patch. Of course, feel free to review
the patch and send comments/fixes as usual ;)

Cheers,
Mauro.
