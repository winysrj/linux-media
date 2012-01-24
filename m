Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34027 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2AXPhw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 10:37:52 -0500
Message-ID: <4F1ED04B.9040106@iki.fi>
Date: Tue, 24 Jan 2012 17:37:47 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "Hawes, Mark" <MARK.HAWES@au.fujitsu.com>,
	linux-media@vger.kernel.org
Subject: Re: HVR 4000 hybrid card still producing multiple frontends for single
 adapter
References: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>	<4F1E9A78.7020203@iki.fi>	<CAGoCfizF=aO-JTLLCAK=QgsPSVP13SzbB9j6wCFfVzGXc4hnfw@mail.gmail.com>	<4F1EC725.7090204@iki.fi> <CAGoCfiwZ2_+rQgXxq9DF_veGZ8vqaZf2JtUSi8SyLW_pd6VFAA@mail.gmail.com>
In-Reply-To: <CAGoCfiwZ2_+rQgXxq9DF_veGZ8vqaZf2JtUSi8SyLW_pd6VFAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2012 05:16 PM, Devin Heitmueller wrote:
> On Tue, Jan 24, 2012 at 9:58 AM, Antti Palosaari<crope@iki.fi>  wrote:
>> So what was the actual benefit then just introduce one way more to implement
>> same thing. As I sometime understood from Manu's talk there will not be
>> difference if my device is based of DVB-T + DVB-C demod combination or just
>> single chip that does same. Now there is devices that have same
>> characteristics but different interface.
>
> For one thing, you cannot use DVB-T and DVB-C at the same time if
> they're on the same demod.  With many of the devices that have S/S2
> and DVB-T, you can be using them both in parallel.  Having multiple
> frontends actually makes sense since you don't want two applications
> talking to the same frontend at the same time but operating on
> different tuners/streams.

For the demods that are not shared (like tuner shared) we register own 
frontend under own adapter. I don't see that is going to change. It have 
been ages as it is and I have not seen none have said it is needed to 
change.

> That said, there could be opportunities for consolidation if the
> demods could not be used in parallel, but I believe that would require
> a nontrivial restructuring of the core code and API.  In my opinion
> the entry point for the kernel ABI should *never* have been the
> demodulator but rather the bridge driver (where you can exercise
> greater control over what can be used in parallel).

Under the current situation I see it is better to select only one 
method. As it is now single frontend then it is just needed to make 
"virtual" frontend that combines multiple frontends as single and offers 
it through API.

And one thing I would like to mention, frontend is just logical entity 
that represent DigitalTV hardware. It is rather much mapped as hardware 
point of view to demod driver callbacks but it is not needed :)


regards
Antti

-- 
http://palosaari.fi/
