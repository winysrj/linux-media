Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46781 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2AOVOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:14:42 -0500
Message-ID: <4F1341C0.2070608@iki.fi>
Date: Sun, 15 Jan 2012 23:14:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F0CAF53.3090802@iki.fi> <4F0CB512.7010501@redhat.com> <4F131CD8.2060602@iki.fi> <4F13312B.8060005@iki.fi> <4F13404D.2020001@redhat.com>
In-Reply-To: <4F13404D.2020001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2012 11:08 PM, Mauro Carvalho Chehab wrote:
> Em 15-01-2012 18:03, Antti Palosaari escreveu:
>> On 01/15/2012 08:37 PM, Antti Palosaari wrote:
>>> On 01/11/2012 12:00 AM, Mauro Carvalho Chehab wrote:
>>>> On 10-01-2012 19:36, Antti Palosaari wrote:

>> That seems to be due to cxd2820r bug introduced by multi-frontend to single-frontend change.
>
> Ok. Could you please fix it and send us a patch?

I already sent it and few others too. CXD2820R is still missing HAS_LOCK 
bit in DVB-C mode... This change introduces too many bugs as I have been 
fixing those whole day and not even found all yet.

>> But now I got that error:
>> [crope@localhost code]$ ./tmp/v4l-utils/utils/dvb/dvb-fe-tool --set-delsys=DVBC/ANNEX_A
>> Device or resource busy while opening /dev/dvb/adapter0/frontend0
>> Changing delivery system to: DVBC/ANNEX_A
>> Segmentation fault (core dumped)
>
> There was a bug at the error code handling on dvb-fe-tool: basically, if it can't open
> a device, it were using a NULL pointer. It was likely fixed by this commit:
>
> http://git.linuxtv.org/v4l-utils.git/commit/1f669eed5433d17df4d8fb1fa43d2886f99d3991

OK, will try.

Thanks
Antti


-- 
http://palosaari.fi/
