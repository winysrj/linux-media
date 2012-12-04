Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:51175 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2LDCm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 21:42:26 -0500
Message-ID: <50BD6310.8000808@pyther.net>
Date: Mon, 03 Dec 2012 21:42:24 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
In-Reply-To: <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2012 09:29 PM, Devin Heitmueller wrote:
> On Mon, Dec 3, 2012 at 9:15 PM, Matthew Gyurgyik <matthew@pyther.net> wrote:
>> Although, it looked like tuning was semi-successful, I tried the following
>>
>>    * cat /dev/dvb/adapter0/dvr0 (no output)
>>    * mplayer /dev/dvb/adapter0/dvr0 (no output)
>>    * cat /dev/dvb/adapter0/dvr0 > test.mpg (test.mpg was 0 bytes)
> I would try running "lsusb -v" and send the output.  Make sure that
> it's not expecting to use bulk mode for DVB (which would require
> driver changes to support).
>
> Devin
>
Here is the output of lsusb -v
http://pyther.net/a/digivox_atsc/patch2/lsusb.txt
