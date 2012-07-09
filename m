Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42103 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2GIIm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 04:42:29 -0400
Message-ID: <4FFA996D.9010206@iki.fi>
Date: Mon, 09 Jul 2012 11:42:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2012 09:24 AM, Marx wrote:
> On 08.07.2012 14:32, Antti Palosaari wrote:
>> I suspect you stopped szap ?
>>
>> You cannot use dvbdate or dvbtraffic, nor read data from dvr0 unless
>> frontend is tuned. Leave szap running backround and try again.
>
> That way it works, and I can save stream. Hovewer it's strange because I
> shouldn't have to constatly tune channel to watch it, and on previous
> cards it was enough to tune once and then use other commands.
> I base my knowledge on
> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
> There is nothing about constant tuning channel to use it. Am I missing
> something?

given wiki-page says:
"
4. After you've tuned a frequency and program

a) You could now start up your simple TV watching application and decode 
the stream you have tuned.

For example, while keeping {a,c,s,t}zap running in the first console 
shell, open up another console and run
"

Behavior have been always same, at least for the DVB USB.

So you don't have problems at all?

regards
Antti

-- 
http://palosaari.fi/


