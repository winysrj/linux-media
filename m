Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50198 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3ATRsO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 12:48:14 -0500
Message-ID: <50FC2D8D.7080205@iki.fi>
Date: Sun, 20 Jan 2013 19:46:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Frank_Sc?= =?ISO-8859-1?Q?h=E4fer?=
	<fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.co m> <50CCAAA4.4030808@iki.fi> <50CE70E0.2070809@pyther.net> <50CE74C7.90809@iki.fi> <50CE7763.3030900@pyther.net> <50CEE6FA.4030901@iki.fi> <50CEFD29.8060009@iki.fi> <50CEFF43.1030704@pyther.net> <50CF44CD.5060707@redhat.com> <50CFDE2B.6040100@pyther.net> <50E49FA6.8010402@iki.fi> <50E4F2BA.7060407@pyther.net> <50FC01DE.3080203@pyther.net>
In-Reply-To: <50FC01DE.3080203@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2013 04:40 PM, Matthew Gyurgyik wrote:
> On 01/02/2013 09:53 PM, Matthew Gyurgyik wrote:
>> On 01/02/2013 03:59 PM, Antti Palosaari wrote:
>>> On 12/18/2012 05:08 AM, Matthew Gyurgyik wrote:
>>>> I can test patches Tue and Wed this week. Afterwards, I probably won't
>>>> be able to test anything until Dec 28th/29th as I will be away from my
>>>> workstation.
>>>>
>>>> In regards to my issue compiling my kernel, it helps if I include
>>>> devtmpfs. :)
>>>
>>> Matthew, test? Both remote and television.
>>>
>>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/HU345-Q
>>>
>>> regards
>>> Antti
>>
>>
>> So using the HU345-Q branch I get the following results
>>
>> Remote:
>>
>> Using evtest it looks like all the key codes register correctly. (KEY_1,
>> KEY_YELLOW, KEY_VOLUMEUP, etc...)
>>
>> However, ir_keytable fails
>>
>> [root@tux bin]# ./ir-keytable -t
>> Not found device rc0
>>
>> Tunning:
>>
>> I did a basic test with mplayer and tunning worked. I'll have to do more
>> testing.
>>
>> Scanning:
>>
>> Running a scan resulted in a kernel panic.
>>
>> Scan command: scan -A 2 -t 1
>> /usr/share/dvb/atsc/us-Cable-Standard-center-frequencies-QAM256 >
>> ~/channels_msidigivox.conf
>>
>> Kernel Messages: http://pyther.net/a/digivox_atsc/jan02/kernel_log.txt
>>
>> Let me know what additional info I can provide. As always, I appreciate
>> the help!
>>
>> Thanks,
>> Matthew
>>
>
>
> Antti,
>
> Is there any follow up testing I could do? Is there any additional
> information you need from me.
>
> Thanks,
> Matthew

Matthew,
Thank you for testing continuously! I looked it and for my eyes it works 
as it should (both television and remote controller as you reported). 
All those bugs you mention has no relations to that certain device. I 
think all are general em28xx driver bugs. There has been recently quite 
much changes done for the em28xx driver and probably some of those 
findings are already fixed. I am not em28xx driver expert, due to that 
it is hard to say what is wrong. I will try to make final patch soon and 
after your test it could be sent to the mainline.

regards
Antti

-- 
http://palosaari.fi/
