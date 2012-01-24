Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweb5.versatel.de ([82.140.32.141]:33511 "EHLO
	mxweb5.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab2AXShg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 13:37:36 -0500
Received: from cinnamon-sage.de (i577A8E19.versanet.de [87.122.142.25])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id q0OIbXg3008376
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 19:37:33 +0100
Received: from 192.168.23.2:49482 by cinnamon-sage.de for <dheitmueller@kernellabs.com>,<crope@iki.fi>,<MARK.HAWES@au.fujitsu.com>,<linux-media@vger.kernel.org> ; 24.01.2012 19:37:33
Message-ID: <4F1EFA6E.50704@flensrocker.de>
Date: Tue, 24 Jan 2012 19:37:34 +0100
From: Lars Hanisch <dvb@flensrocker.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
	"Hawes, Mark" <MARK.HAWES@au.fujitsu.com>,
	linux-media@vger.kernel.org
Subject: Re: HVR 4000 hybrid card still producing multiple frontends for single
 adapter
References: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com> <4F1E9A78.7020203@iki.fi> <CAGoCfizF=aO-JTLLCAK=QgsPSVP13SzbB9j6wCFfVzGXc4hnfw@mail.gmail.com> <4F1EC725.7090204@iki.fi> <CAGoCfiwZ2_+rQgXxq9DF_veGZ8vqaZf2JtUSi8SyLW_pd6VFAA@mail.gmail.com>
In-Reply-To: <CAGoCfiwZ2_+rQgXxq9DF_veGZ8vqaZf2JtUSi8SyLW_pd6VFAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 24.01.2012 16:16, schrieb Devin Heitmueller:
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

  The two frontends of the HVR 4000 can only be open mutually exclusive so I think the recent changes are for those 
devices, aren't they? Sure you can connect DVB-T and DVB-S at the same time to the HVR 4000, but you can't use it in 
parallel.

Lars.

>
> That said, there could be opportunities for consolidation if the
> demods could not be used in parallel, but I believe that would require
> a nontrivial restructuring of the core code and API.  In my opinion
> the entry point for the kernel ABI should *never* have been the
> demodulator but rather the bridge driver (where you can exercise
> greater control over what can be used in parallel).
>
> Devin
>
