Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33382 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab2LHVrw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Dec 2012 16:47:52 -0500
Message-ID: <50C3B567.3070300@iki.fi>
Date: Sat, 08 Dec 2012 23:47:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C3701D.9000700@pyther .net> <50C37DA8.4080608@googlemai l.com> <50C3B3EB.40606@pyther.net>
In-Reply-To: <50C3B3EB.40606@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2012 11:40 PM, Matthew Gyurgyik wrote:
> On 12/08/2012 12:49 PM, Frank Schäfer wrote:
>> Am 08.12.2012 17:51, schrieb Matthew Gyurgyik:
>>
>> That shouldn't be necessary. I just noticed that there is a module
>> parameter 'ir_debug'. ;)
>> With ir_debug enabled, you should see messages
>>
>>          em28xx_ir_handle_key: toggle: XX, count: XX, key XXYYZZ
>>
>> everytime you press a button. Once we know the key codes, we can set up
>> a key map (if it doesn't exist yet).
>>
>
> Maybe I'm doing something wrong but didn't have any luck :(
>
>> [root@tux ~]# sudo rmmod em28xx_rc
>> [root@tux ~]# sudo rmmod em28xx_dvb
>> [root@tux ~]# sudo rmmod em28xx
>> [root@tux ~]# modprobe em28xx_rc ir_debug=1
>
> I don't see any additional messages in dmesg.
>
> I verified the remote still works in windows (a stupidity check on my part)

Maybe Kernel debugs are not enabled? em28xx driver is a little bit 
legacy in logging too as it uses own logging whilst nowadays dynamic 
logging is recommended.

replace KERN_DEBUG as KERN_INFO inside em28xx-input.c and test. It will 
change driver to use Kernel normal log writings instead of current debug 
ones.

regards
Antti


-- 
http://palosaari.fi/
