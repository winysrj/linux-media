Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab2LEWCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Dec 2012 17:02:15 -0500
Message-ID: <50BFC445.6020305@iki.fi>
Date: Thu, 06 Dec 2012 00:01:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net>
In-Reply-To: <50BFBE39.90901@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2012 11:35 PM, Matthew Gyurgyik wrote:
> On 12/05/2012 07:35 AM, Antti Palosaari wrote:
>>
>> There is something really wrong.
>>
>> I am not at US expert but why the hell
>> us-Cable-Standard-center-frequencies-QAM256 scans up to 999MHz whilst
>> demodulator max is set 858? Either one is wrong.
>>
>> Also, demod seems to be HAS_LOCK about all the time. As that basic
>> LOCK flag is simply false you cannot even thing if there is correct
>> configuration on TS interface. If you start zapping that known channel
>> and then unplug & plug antenna cable did you see still all the time
>> HAS_LOCK? (it should disappear when antenna cable is unplugged).
>>
>> regards
>> Antti
>>
> When I disconnected the coax cable, the lock went away. When I
> reconnected FE_HAS_LOCK came back.
>
> http://pyther.net/a/digivox_atsc/patch3/azap_disconnect_coax.txt

OK, fine, I was then wrong. I have to say you have a lot of channels 
over there what I can see from scan result [1]. Those channels which 
says "tuning failed" are channels where is no transmission and those 
"filter timeout pid" means there is ta ransmission and demod locks. Here 
in Finland we have only ~4 MUX DVB-T and maybe other 4 for DVB-T2.

It is then actually working quite well from the developer point of view 
(as demod loses lock when antenna is unplugged). It means tuner and 
demodular are working but interface (transport stream interface, TS IF) 
between demod and USB-bridge is still broken.

I tried to look again your sniff if I can see what it does just before 
streaming starts, but unfortunately there is no any mention about those 
streaming packets (isoc packets where picture stream is going). Did you 
remove those yourself?


[1] http://pyther.net/a/digivox_atsc/patch3/scan.txt

regards
Antti

-- 
http://palosaari.fi/
