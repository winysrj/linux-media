Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K8bR5-0000En-1c
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 15:41:24 +0200
Received: by ug-out-1314.google.com with SMTP id m3so602124uge.20
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 06:41:19 -0700 (PDT)
Message-Id: <42CF7D26-E68F-48A0-BECF-9CDA71AE7966@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <4857BE67.2010208@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 17 Jun 2008 09:41:13 -0400
References: <1E35FDF4-8D68-47AA-9DA6-B880879274E2@tvwhere.com>
	<4857BE67.2010208@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency?
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


On Jun 17, 2008, at 9:38 AM, Michael Krufky wrote:

> Brandon Jenkins wrote:
>> Greetings,
>>
>> I choose to compile only the modules which are required for the
>> hardware in my system as a way to speed up compilation times. When
>> compiling for the v4l-dvb I run make menuconfig and deselect the
>> modules for the adapters  not in my system. If I don't compile in
>> Simple tuner support the cx18 load process throws and error in  
>> tveeprom.
>
>
> The analog tuner on the hvr1600 is supported by tuner-simple -- you  
> need that module compiled.
>
> -Mike Krufky

Mike,

Thanks for the reply. I am sorry my intention was to highlight the  
fact that it is not auto-selected as part of the process and that I  
have to manually select it. If it is a dependency, should it not be  
auto-selected? Would it be a dependency of cx18 or tveeprom?

Thanks again,

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
