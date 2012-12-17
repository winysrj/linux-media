Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:49927 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2LQBJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 20:09:54 -0500
Message-ID: <50CE70E0.2070809@pyther.net>
Date: Sun, 16 Dec 2012 20:09:52 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.co m> <50CCAAA4.4030808@iki.fi>
In-Reply-To: <50CCAAA4.4030808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2012 06:21 PM, Frank Schäfer wrote:
>> Matthew, could you please validate your test results and try Mauros
>> patches ? If it doesn't work, please create another USB-log.
>>

Sorry it took me so long to test the patch, but the results look 
promising, I actually got various keycodes!

dmesg: http://pyther.net/a/digivox_atsc/dec16/dmesg_remote.txt

evtest was also generating output

Event: time 1355705906.950551, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
61d618e7
Event: time 1355705906.950551, -------------- SYN_REPORT ------------

This is the current patch I'm using: 
http://pyther.net/a/digivox_atsc/dec16/dmesg_remote.txt

What needs to be done to generate a keymap file?

Is there anything I can collect or try to do, to get channel scanning 
working?

Just let me know what you need me to do. I really appreciate all the help!

Thanks,
Matthew
