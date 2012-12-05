Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46479 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2LEMgN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Dec 2012 07:36:13 -0500
Message-ID: <50BF3F9A.3020803@iki.fi>
Date: Wed, 05 Dec 2012 14:35:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net>
In-Reply-To: <50BEC253.4080006@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2012 05:41 AM, Matthew Gyurgyik wrote:
> On 12/04/2012 04:06 PM, Frank Schäfer wrote:
>> I double-checked the log and it is indeed set to LGDT3305_MPEG_SERIAL,
>> but LGDT3305_TPCLK_FALLING_EDGE is used instead of
>> LGDT3305_TPCLK_RISING_EDGE.
>> OTOH, the KWorld A340 bord sets this to LGDT3305_MPEG_PARALLEL...
>>
>> Matthew, could you please test V3 of the patch ? It is written against
>> the media_tree staging/for_v3.8 (see
>> http://git.linuxtv.org/media_tree.git).
>> You could also already test the remote control key map (e.g. with evtest)
>>
>> Regards,
>> Frank
> Version 3 has the same behavior has v2. It seems I can tune a channel,
> but trying to watch it fails. There is no data being set to
> /dev/dvb/adapter0/dvr0
>
> Tune channel
>> [root@tux ~]# azap -r -c /home/pyther/channels.conf "ION LIF"
>
>> [root@tux ~]# dvbdate
>> dvbdate: Unable to get time from multiplex.
>
> I got further on a channel scan but then encountered some errors (no
> channels detected):
>
> http://pyther.net/a/digivox_atsc/patch3/scan.txt
> http://pyther.net/a/digivox_atsc/patch3/dmesg_after_scan.txt
>
> dmesg: http://pyther.net/a/digivox_atsc/patch3/dmesg.txt
> azap: http://pyther.net/a/digivox_atsc/patch3/azap.txt
> dvbtraffic: http://pyther.net/a/digivox_atsc/patch3/dvbtraffic.txt
>
> Matthew

There is something really wrong.

I am not at US expert but why the hell 
us-Cable-Standard-center-frequencies-QAM256 scans up to 999MHz whilst 
demodulator max is set 858? Either one is wrong.

Also, demod seems to be HAS_LOCK about all the time. As that basic LOCK 
flag is simply false you cannot even thing if there is correct 
configuration on TS interface. If you start zapping that known channel 
and then unplug & plug antenna cable did you see still all the time 
HAS_LOCK? (it should disappear when antenna cable is unplugged).

regards
Antti

-- 
http://palosaari.fi/
