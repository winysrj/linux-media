Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33125 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZL0WIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2009 17:08:45 -0500
Received: by fxm25 with SMTP id 25so4252094fxm.21
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2009 14:08:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B342CEE.8020205@redhat.com>
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com>
Date: Mon, 28 Dec 2009 02:08:43 +0400
Message-ID: <1a297b360912271408w191f35f4uc8c928a328a22a71@mail.gmail.com>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,


On Fri, Dec 25, 2009 at 7:09 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 24-12-2009 00:17, Mauro Carvalho Chehab escreveu:
>> I wrote several patches those days in order to allow dvb-apps to properly
>> parse ISDB-T channel.conf.
>>
>> On ISDB-T, there are several new parameters, so the parsing is more complex
>> than all the other currently supported video standards.
>>
>> I've added the changes at:
>>
>> http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/
>>
>> I've merged there Patrick's dvb-apps-isdbt tree.
>>
>> While there, I fixed a few bugs I noticed on the parser and converted it
>> to work with the DVB API v5 headers that are bundled together with dvb-apps.
>> This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests. The ones
>> there can now be removed.
>>
>> TODO:
>> =====
>>
>> The new ISDB-T parameters are parsed, but I haven't add yet a code to make
>> them to be used;
>>
>> There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
>> segment parameters. Currently, the parser will fail if those parameters are found.
>>
>> gnutv is still reporting ISDB-T as "DVB-T".
>>
>
> I've just fixed the issues on the TODO list. The DVB v5 code is now working fine
> for ISDB-T.
>
> Pending stuff (patches are welcome):
>        - Implement v5 calls for other video standards;
>        - Remove the duplicated DVBv5 code on /util/scan/scan.c (the code for calling
> DVBv5 is now at /lib/libdvbapi/v5api.c);
>        - Test/use the functions to retrieve values via DVBv5 API. The function is
> already there, but I haven't tested.
>
> With the DVBv5 API implementation, zap is now working properly with ISDB-T.
> gnutv also works (although some outputs - like decoder - may need some changes, in
> order to work with mpeg4/AAC video/audio codecs).


Few comments on your changes (that came up on a first glance):

- dvb-apps don't need a DCO (S-O-B) as for kernel related code (though
not an issue, whether it is there or not)

- changeset 1334 is a regression:

dvb-apps look at libraries that are shipped with the distribution
alone. The headers in there are a copy for szap2 alone for test cases
and szap2 is not a generic application such as zap and hence doesn't
need to be ported.

- get_v5_frontend keeps on malloc with no free .....

- the basic design we have in the libraries is that we don't allow the
library to do the allocation but allocation is done by the user
(application)

- the library is not meant to handle the basic in-kernel API alone,
there are others that's the whole intention for the library.

- changeset 1341 is broken

Regards,
Manu
