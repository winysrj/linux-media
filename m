Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab0BWQHD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 11:07:03 -0500
Message-ID: <4B83FD1A.3070508@redhat.com>
Date: Tue, 23 Feb 2010 13:06:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christophe Thommeret <hftom@free.fr>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] scan-s2 and dvb-apps
References: <1a297b361002230336q7065170tc79ef22426ef5a8a@mail.gmail.com> <201002231406.36939.hftom@free.fr>
In-Reply-To: <201002231406.36939.hftom@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christophe Thommeret wrote:
> Le mardi 23 février 2010 12:36:13, Manu Abraham a écrit :
>> Hi All,
>>
>> Recently, quite some people have been requesting for scan-s2 a simple
>> scan application which has been hacked on top of the scan application
>> as available in the dvb-apps tree, to be integrated/pulled in to the
>> dvb-apps tree, after it's author moved on to other arenas.
>>
>> http://www.mail-archive.com/vdr@linuxtv.org/msg11125.html
>>
>> The idea initially was to have a cloned copy of scan as scan-s2.
>> Now, on the other hand scan-s2 is much more like scan and similar
>> functionality wise too.
>>
>> Considering the aspects, do you think, that it is worthwhile to have
>>
>> a) the scan-s2 application and the scan application as well integrated
>> into the repository, such that they both live together
>>
>> or
>>
>> b) scan-s2 does things almost the same as scan2. scan can be replaced
>> by scan-s2.
>>
>>
>> What are your ideas/thoughts on this ?
> 
> I think S2 scanning should simply be added to scan.

See http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt2/

It adds support to DVB API v5 to the dvb-apps library. Originally, this were
done to add ISDB-T support, but the next patches added also DVB-T, DVB-C and
DVB-S support via APIv5. It also adds some DVB-S2 bits there. There are very
few things lacking there to fully implement DVB-S2. It shouldn't be hard to
add there also other standards like DVB-T2, ISDB-S, etc.

-- 

Cheers,
Mauro
