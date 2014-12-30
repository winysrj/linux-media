Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.sscnet.ucla.edu ([128.97.229.230]:40819 "EHLO
	smtp0.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3IYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 03:24:14 -0500
Message-ID: <54A26109.1040109@cogweb.net>
Date: Tue, 30 Dec 2014 00:23:37 -0800
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvbv5-scan needs which channel file?
References: <54A1B4FD.70006@cogweb.net> <CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
In-Reply-To: <CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ah, thank you Olli -- much appreciated!

If dvbv5-scan expects the initial scan files in the new DVBV5 format, 
does that mean that these still somewhat mysterious "initial scan files" 
have to be supplied, as in the link to the dtv-scan-tables? How are 
these "initial scan files" themselves generated?

Surely there must be thousands of different dvb signal locations -- is 
linux-tv going to try to maintain these thousands of scan tables for 
download? What do users do when their particular location is not 
represented in the dtv-scan-tables.git?

Finally, I'm using gnutv to record television; I imagine it still only 
accepts the old format? What's the new alternative?

Cheers,
David

On 12/29/14, 11:55 PM, Olli Salonen wrote:
> Hello David,
>
> Coincidentally I was just yesterday working with dvbv5-scan and the
> initial scan files. dvbv5-scan expects the initial scan files in the
> new DVBV5 format. w_scan is not producing results in this format.
>
> The scan tables at
> http://git.linuxtv.org/cgit.cgi/dtv-scan-tables.git/ are in the new
> format. Some of them are a bit outdated though (send in a patch if you
> can update it for your area).
>
> The v4l-utils package also includes tools to convert between the old
> and the new format.
>
> Cheers,
> -olli
>
>
> On 29 December 2014 at 22:09, David Liontooth <lionteeth@cogweb.net> wrote:
>> Greetings --
>>
>> How do you actually use dvbv5-scan? It seems to require some kind of input
>> file but there is no man page and the --help screen doesn't say anything
>> about it.
>>
>> Could we document this? I tried
>>
>> $ dvbv5-scan
>> Usage: dvbv5-scan [OPTION...] <initial file>
>> scan DVB services using the channel file
>>
>> What is "the channel file"? Maybe the channels.conf file? (I created mine
>> using "w_scan -ft -A3 -X -cUS -o7 -a /dev/dvb/adapter0/")
>>
>> $ dvbv5-scan /etc/channels.conf
>> ERROR key/value without a channel group while parsing line 1 of
>> /etc/channels.conf
>>
>> So it knows what it wants -- but what is it? Or is this a matter of dvb
>> versions, and my /etc/channels.conf is in the older format?
>>
>> Very mysterious.
>>
>> Cheers,
>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

