Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:60733 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908Ab2LHQvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 11:51:43 -0500
Message-ID: <50C3701D.9000700@pyther.net>
Date: Sat, 08 Dec 2012 11:51:41 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com>
In-Reply-To: <50C35AD1.3040000@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2012 10:20 AM, Frank Schäfer wrote:
> Am 08.12.2012 15:10, schrieb Matthew Gyurgyik:
>
> Ok, thanks. So the USB log was right and the bridge setup should be
> complete, except that the remote control doesn't work yet...
>
> Could you please test the patch in the attachment ?
> Changes from V3:
> - use the correct demodulator configuration
> - changed the remote control map to RC_MAP_KWORLD_315U (same as DIGIVOX
> III but without NEC extended address byte)
> - switched from the KWorld std_map for the tuner to a custom one. For
> QAM, I selected the values from the log and for atsc I took the standard
> values from the tda18271 driver.
>
> Regards,
> Frank
>

I tested the patch and this is what I found

The remote still doesn't work, would it be helpful to do a usb snoop 
while using the remote in windows (not sure I can make the win7 driver 
work in xp)?

http://pyther.net/a/digivox_atsc/patch4/evtest.txt

A channel scan still fails with the following error:
 > start_filter:1752: ERROR: ioctl DMX_SET_FILTER failed: 71 Protocol error

However there are no messages in dmesg that indicate any errors / warnings.
http://pyther.net/a/digivox_atsc/patch4/scan.txt

When using mplayer dvb://

It seems that switching channels work a bit better, I can switch more 
channels before I get errors and mplayer closes.

http://pyther.net/a/digivox_atsc/patch4/mplayer.txt

Dmesg: http://pyther.net/a/digivox_atsc/patch4/dmesg.txt

Thanks,
Matthew
