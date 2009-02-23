Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.icp-qv1-irony-out2.iinet.net.au ([203.59.1.151]:41387
	"EHLO webmail.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbZBWXDK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 18:03:10 -0500
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: sonofzev@iinet.net.au, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: running multiple DVB cards successfully.. what do I need to  	know?? (major and minor numbers??)
Reply-To: sonofzev@iinet.net.au
Date: Tue, 24 Feb 2009 08:03:04 +0900
Cc: linux-media@vger.kernel.org
Message-Id: <40915.1235430184@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mike

Is this likely to stop the "Incorrect Readback of kernel version issue as well?" 

cheers

Allan 

On Mon Feb 23 17:57 , Michael Krufky  sent:

>On Mon, Feb 23, 2009 at 5:49 PM, sonofzev@iinet.net.au
>sonofzev@iinet.net.au> wrote:
>> Some of you may have read some of my posts about an "incorrect firmware readback"
>> message appearing in my dmesg, shortly after a tuner was engaged.
>>
>> I have isolated this problem, but the workaround so far has not been pretty.
>> On a hunch I removed my Dvico Fusion HDTV lite card from the system, running now
>> only with the Dvico Fusion Dual Express.
>>
>> The issue has gone, I am not getting the kdvb process hogging cpu cycles and this
>> message has stopped.
>>
>> I had tried both letting the kernel (or is it udev) assign the major and minor
>> numbers and I had tried to manually set them via modprobe.conf (formerly
>> modules.conf, I don't know if this is a global change or specific to Gentoo)....
>>
>> I had the major number the same for both cards, with a separate minor number for
>> each of the three tuners, this seems to be the same.
>>
>> Is this how I should be setting up for 2 cards or should I be using some other
>> type of configuration.
>
>Allan,
>
>I recommend to use the 'adapter_nr' module option.  You can specify
>this option in modprobe.conf -- the name of this file is
>distro-specific.
>
>For instance, to make the dual card appear before the lite card:
>
>options cx23885 adapter_nr=0,1
>options dvb-bt8xx adapter_nr=2
>
>to make the lite card appear before the dual card:
>
>options cx23885 adapter_nr=0
>options dvb-bt8xx adapter_nr=1,2
>
>I hope you find this helpful.
>
>Regards,
>
>Mike
>)


