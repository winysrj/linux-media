Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1K3Eu9-0005o4-5A
	for linux-dvb@linuxtv.org; Mon, 02 Jun 2008 20:37:14 +0200
Received: by yw-out-2324.google.com with SMTP id 3so534107ywj.41
	for <linux-dvb@linuxtv.org>; Mon, 02 Jun 2008 11:37:07 -0700 (PDT)
Message-ID: <37219a840806021137t69088d2dg19298ff56b766b5e@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:37:07 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Dennis Noordsij" <dennis.noordsij@movial.fi>
In-Reply-To: <4844219C.3040700@movial.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <4843B75C.7090505@movial.fi>
	<37219a840806020838u5d46fba0xe5061ebb0f25bd9e@mail.gmail.com>
	<4844219C.3040700@movial.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Driver TerraTec Piranha functional,
	need some advice to finish up
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mon, Jun 2, 2008 at 12:36 PM, Dennis Noordsij
<dennis.noordsij@movial.fi> wrote:
> Michael Krufky schreef:
>
>> Dennis,
>>
>> I am currently in the process of cleaning up a public GPL'd driver
>> released by Siano for the SMS1010 / SMS1150 silicon.
>
>
> Hi Mike,
>
> Ehh, D'OH I guess! I wrote to Siano in April when I bought this adapter,
> but never got any reply. I know it was advertised as a mobile linux
> chipset, but couldn't find any reference to any actual drivers.
>
> At first try it seems to work in DVB-T mode with my device.

Great!  Please continue testing with the driver -- let me know if you
hit any issues.

I'm assuming that you didn't have to make any changes to the driver?


> Can you provide a link to the "officially supported" firmware blobs ?

Unfortunately, I can not distribute the firmware at this point in
time.  The firmware that I am working with is for the SMS1010 and
SMS1150 -- I believe that you need different firmware for the SMS100X
-- exactly which sms100x silicon is used in your device?

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
