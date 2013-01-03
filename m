Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:36386 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ACCxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 21:53:48 -0500
Message-ID: <50E4F2BA.7060407@pyther.net>
Date: Wed, 02 Jan 2013 21:53:46 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Frank_Sc?= =?ISO-8859-1?Q?h=E4fer?=
	<fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.co m> <50CCAAA4.4030808@iki.fi> <50CE70E0.2070809@pyther.net> <50CE74C7.90809@iki.fi> <50CE7763.3030900@pyther.net> <50CEE6FA.4030901@iki.fi> <50CEFD29.8060009@iki.fi> <50CEFF43.1030704@pyther.net> <50CF44CD.5060707@redhat.com> <50CFDE2B.6040100@pyther.net> <50E49FA6.8010402@iki.fi>
In-Reply-To: <50E49FA6.8010402@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 03:59 PM, Antti Palosaari wrote:
> On 12/18/2012 05:08 AM, Matthew Gyurgyik wrote:
>> I can test patches Tue and Wed this week. Afterwards, I probably won't
>> be able to test anything until Dec 28th/29th as I will be away from my
>> workstation.
>>
>> In regards to my issue compiling my kernel, it helps if I include
>> devtmpfs. :)
>
> Matthew, test? Both remote and television.
>
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/HU345-Q
>
> regards
> Antti


So using the HU345-Q branch I get the following results

Remote:

Using evtest it looks like all the key codes register correctly. (KEY_1, 
KEY_YELLOW, KEY_VOLUMEUP, etc...)

However, ir_keytable fails

[root@tux bin]# ./ir-keytable -t
Not found device rc0

Tunning:

I did a basic test with mplayer and tunning worked. I'll have to do more 
testing.

Scanning:

Running a scan resulted in a kernel panic.

Scan command: scan -A 2 -t 1 
/usr/share/dvb/atsc/us-Cable-Standard-center-frequencies-QAM256 > 
~/channels_msidigivox.conf

Kernel Messages: http://pyther.net/a/digivox_atsc/jan02/kernel_log.txt

Let me know what additional info I can provide. As always, I appreciate 
the help!

Thanks,
Matthew

