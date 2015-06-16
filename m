Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep18.mx.upcmail.net ([62.179.121.38]:40650 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbbFPNRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 09:17:49 -0400
Message-ID: <558021FA.5010509@chello.at>
Date: Tue, 16 Jun 2015 15:17:46 +0200
From: Hurda <hurda@chello.at>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: si2168/dvbsky - blind-scan for DVB-T2 with PLP fails
References: <556644C7.8040701@chello.at> <5566A70A.1090805@iki.fi> <55708CB2.8090502@chello.at> <5570A6F9.1030004@iki.fi> <5572FE86.9010707@chello.at> <5573010C.6000402@iki.fi>
In-Reply-To: <5573010C.6000402@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending as the first try apparently hasn't made it onto the mailing-list)


On 06.06.2015 16:17, Antti Palosaari wrote:
> On 06/06/2015 05:07 PM, Hurda wrote:
>> Thanks, this worked.
>> The kernel of Ubuntu 15.04 already was compiled with dynamic debug,
>> which saved
>> me a lot of time.
>> The driver is properly setting stream_id to 1 when needed.
>>
>> I tried again with the vanilla source and "cmd.args[2] = 0;".
>> With the vanilla source, it doesn't find any T2-transponders.
>
> You mean with vanilla source, but without that "cmd.args[2] = 0;" hack it does
> not find any transponders?
>

No T2-transponders, no.
With "cmd.args[2] = 0;" the number of found T2-transponders is changing with 
every scan.
Using the dvbsky-driver, the scan always finds all four T2-transponders.

>
>> With the modified source, the number of found transponders changes every
>> time
>
> You mean with source, modified with that "cmd.args[2] = 0;" hack it finds
> transponders, but not always?
>
> If that is difference, then it sounds just like application is requesting some
> PLP, probably 0, and it will not work as your network delivers channels using
> PLP 1.
>
> "cmd.args[2] = 0;" disables PLP filtering - it sets auto mode. Why it likely
> does not find all channels is too short timeout.
>
> Increase timeout value to 3 second, 900 => 3000, in funtion
> si2168_get_tune_settings()

No difference, even with 10000. Tried that timeout with "cmd.args[2] = 0;" and 
"cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;"

> You didn't provide any debugs to see what PLP ID your application is
> requesting. It is the most important thing I would like to know, as I suspect
> it is wrong.
>
> regards
> Antti
>

Debug-logs:
http://www.mediafire.com/download/8j4s9oytsfv9s40/si2168-dvbsky_debug_logs.zip
Made with the vanilla tree and "cmd.args[2] = 0;", and timeout 900 (default) and 
3000msec.
