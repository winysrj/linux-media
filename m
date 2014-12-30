Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41997 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaL3NPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 08:15:39 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so23977465wiv.13
        for <linux-media@vger.kernel.org>; Tue, 30 Dec 2014 05:15:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A26109.1040109@cogweb.net>
References: <54A1B4FD.70006@cogweb.net>
	<CAAZRmGxoOTf9f4gq05RgbcD44tmiySMXo-_ZHtBQX0pw6ZXPUA@mail.gmail.com>
	<54A26109.1040109@cogweb.net>
Date: Tue, 30 Dec 2014 15:15:38 +0200
Message-ID: <CAAZRmGz1Xp9bL+R-sMsHpeuwAJ4aR=Dhu2Hwo-wAqbbFkr1B9w@mail.gmail.com>
Subject: Re: dvbv5-scan needs which channel file?
From: Olli Salonen <olli.salonen@iki.fi>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Well, the initial scan files need to be supplied for dvbv5-scan somehow.

The initial scan files that are maintained in the the git repo I
posted earlier are updated by users who notice differencies. Basically
I and some other users have created scripts that automatically
generate the files for my country, so it's rather easy. I don't know
how it works for other countries.

Anyway, if you prefer to generate the data yourself you can use w_scan
to generate it in DVBV3 format:
w_scan -ft -c FI -x > ~/initial_v3.conf

Then use the dvb-format-convert tool that comes in the v4l-utils package:
dvb-format-convert -I CHANNEL -O DVBV5 ~/initial_v3.conf ~/initial_data_v5.conf

Then you can run dvbv5-scan with this file:
dvbv5-scan ~/initial_data_v5.conf

Alternatively you can skip the whole conversion phase and run
dvbv5-scan with the DVBV3 initial tuning data:
dvbv5-scan -I CHANNEL ~/initial_v3.conf

Cheers,
-olli

On 30 December 2014 at 10:23, David Liontooth <lionteeth@cogweb.net> wrote:
>
> Ah, thank you Olli -- much appreciated!
>
> If dvbv5-scan expects the initial scan files in the new DVBV5 format, does
> that mean that these still somewhat mysterious "initial scan files" have to
> be supplied, as in the link to the dtv-scan-tables? How are these "initial
> scan files" themselves generated?
>
> Surely there must be thousands of different dvb signal locations -- is
> linux-tv going to try to maintain these thousands of scan tables for
> download? What do users do when their particular location is not represented
> in the dtv-scan-tables.git?
>
> Finally, I'm using gnutv to record television; I imagine it still only
> accepts the old format? What's the new alternative?
>
> Cheers,
> David
>
> On 12/29/14, 11:55 PM, Olli Salonen wrote:
>>
>> Hello David,
>>
>> Coincidentally I was just yesterday working with dvbv5-scan and the
>> initial scan files. dvbv5-scan expects the initial scan files in the
>> new DVBV5 format. w_scan is not producing results in this format.
>>
>> The scan tables at
>> http://git.linuxtv.org/cgit.cgi/dtv-scan-tables.git/ are in the new
>> format. Some of them are a bit outdated though (send in a patch if you
>> can update it for your area).
>>
>> The v4l-utils package also includes tools to convert between the old
>> and the new format.
>>
>> Cheers,
>> -olli
>>
>>
>> On 29 December 2014 at 22:09, David Liontooth <lionteeth@cogweb.net>
>> wrote:
>>>
>>> Greetings --
>>>
>>> How do you actually use dvbv5-scan? It seems to require some kind of
>>> input
>>> file but there is no man page and the --help screen doesn't say anything
>>> about it.
>>>
>>> Could we document this? I tried
>>>
>>> $ dvbv5-scan
>>> Usage: dvbv5-scan [OPTION...] <initial file>
>>> scan DVB services using the channel file
>>>
>>> What is "the channel file"? Maybe the channels.conf file? (I created mine
>>> using "w_scan -ft -A3 -X -cUS -o7 -a /dev/dvb/adapter0/")
>>>
>>> $ dvbv5-scan /etc/channels.conf
>>> ERROR key/value without a channel group while parsing line 1 of
>>> /etc/channels.conf
>>>
>>> So it knows what it wants -- but what is it? Or is this a matter of dvb
>>> versions, and my /etc/channels.conf is in the older format?
>>>
>>> Very mysterious.
>>>
>>> Cheers,
>>> David
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
