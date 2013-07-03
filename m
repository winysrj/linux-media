Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:51025 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3GCTqZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 15:46:25 -0400
Message-ID: <51D47F8F.10906@schinagl.nl>
Date: Wed, 03 Jul 2013 21:46:23 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: dirk@GNUmatic.de
CC: =?UTF-8?B?SGVybWFubiBVbHJpY2hza8O2dHRlcg==?= <ulrichsk@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [DTV Update] Re: =?UTF-8?B?w4RuZGVydW5nIGRlciBTZW5kZWZyZXF1ZQ==?=
 =?UTF-8?B?bnplbiBiZWkgS2FiZWxCVw==?=
References: <51D452EC.5090008@gmx.de> <51D46548.8050904@schinagl.nl> <1372876350.31609.19.camel@twin.GNUmatic.de>
In-Reply-To: <1372876350.31609.19.camel@twin.GNUmatic.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pushed to the dtv-scan-tables tree. A package should be generated thanks 
to mauro soon, so if packagers download tomorrow, or pull from git now, 
they have the new version.

On 07/03/13 20:32, Dirk Ritter wrote:
> Hello Oliver! :-)
>
> Am Mittwoch, den 03.07.2013, 19:54 +0200 schrieb Oliver Schinagl:
>
>>> Ich habe in der Datei in dieser Datei die einzig relevante Zeile von "C
>>> 113000000 6900000 NONE QAM64" auf "C 114000000 6900000 NONE QAM256" korrigieren
>>> müssen, so dass der Scan wieder geklappt hat.
>> It looks like they changed frequencies.
>
> Yes.
>
>>   Their site confirms that a big
>> changeover happened in June. I have staged this commit and will push it
>> tomorrow unless anybody objects, Dirk, can you confirm/deny this being
>> correct?
>
> It is correct. I got an e-mail from Martin Klar who lives
> in a KabelBW area that got the change earlier than mine.
> I did wait for the change and can positively confirm it.
> Based on data available (I did try to make sense of his
> change beforehand) and based on testing done using Kaffeine
> just after KabelBW changed it in Stuttgart.
>
>> I already have it in my private repo [0]
>
> Life took it's toll, so I didn't manage to forward this.
> Martin already tried without any luck and that's why he
> contacted me so that I could try. It was a rather difficult
> story back then I first cooked it up since there was
> disagreement between documents floating around and actual
> frequencies used and as a result of further difficulties
> with different tables for different service levels we
> concluded it would be best to just have one frequency,
> especially since that worked across both levels, i.e. for
> both fully and partly populated network areas within KabelBW.
>
> I guess Martin would love to see the file changed as he
> did, see attachment... ;-)
>
> BTW - what about Kaffeeine? How do they handle it? I
> just changed it locally and it works, but I don't think
> they did update it either.
They probably maintain their own (bad).

>
> Hopefully, this will propagate fast...
>
> Cheers!
> Dirk
>
oliver
