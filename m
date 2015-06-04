Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep27.mx.upcmail.net ([62.179.121.47]:51711 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbFDRgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 13:36:52 -0400
Message-ID: <55708CB2.8090502@chello.at>
Date: Thu, 04 Jun 2015 19:36:50 +0200
From: Hurda <hurda@chello.at>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: si2168/dvbsky - blind-scan for DVB-T2 with PLP fails
References: <556644C7.8040701@chello.at> <5566A70A.1090805@iki.fi>
In-Reply-To: <5566A70A.1090805@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

How can I enable debug-output to get the log-messages like 
http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/drivers/media/dvb-frontends/si2168.c#n164 
?

Am 28.05.2015 07:26, schrieb Antti Palosaari:
> On 05/28/2015 01:27 AM, Hurda wrote:
>> Hello.
>>
>> I think I came across a bug in either of the drivers si2168 and dvbsky
>> regarding
>> blind-scanning DVB-T2-frequencies.
>>
>> HW: Technotrend CT2-4400v2 (afaik based on or the same as DVBSky T330)
>>      demod: Si2168-B40
>>      tuner: Si2158-A20
>> OS: Ubuntu 15.04 (kernel 3.19)
>>
>> In Austria, the DVB-T2-service "SimpliTV" is currently airing up to four
>> muxes, next to one or two DVB-T-muxes.
>> In my region, the frequencies are 490MHz, 546MHz, 690MHz, 714MHz for
>> DVB-T2,
>> and 498MHz for DVB-T.
>> These numbers might be of interest when reading the logs.
>>
>> The peculiar aspect of these T2-muxes is that they're aired on PLP 1
>> without
>> there being a PLP 0. I think this is also the root of my problem.
>
> dvbv5-scan is working, but w_scan not?
>
> Could you hack si2168.c file and test?
>
> if (c->delivery_system == SYS_DVBT2) {
>     /* select PLP */
>     cmd.args[0] = 0x52;
>     cmd.args[1] = c->stream_id & 0xff;
> //    cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;
>     cmd.args[2] = 0;
>     cmd.wlen = 3;
>     cmd.rlen = 1;
>     ret = si2168_cmd_execute(client, &cmd);
>     if (ret)
>         goto err;
> }
>
> Antti
>
>>
>>
>> When doing a blind-scan using w_scan 20140727 on Ubuntu 15.04 (kernel
>> 3.19),
>> w_scan does not find any of these four DVB-T2-muxes.
>> It just finds the DVB-T-mux.
>>
>> Logs:
>> media-tree_dmesg_lsusb.txt http://pastebin.com/0ixFPMSA
>> media-tree_w_scan.txt http://pastebin.com/yyG3jSwj
>>
>> The found transponder:
>> initial_v3_media_build_trunk.conf http://pastebin.com/LmFQavpy
>> initial_v5.conf http://pastebin.com/Jx6kymVt
>>
>> I also tried a fresh checkout from git.linuxtv.org as of last weekend
>> and the
>> most recent w_scan version (20141122).
>>
>> As you can see, w_scan tries to tune(?) the DVB-T2-frequencies, but
>> ultimately doesn't find anything on them.
>>
>>
>> Then I tried the DVBSky-linux-driver[1]
>> (media_build-bst-20150322.tar.gz)[2]
>> from their site, which is using a binary called sit2 for this card.
>> Using this driver, w_scan found all four DVB-T2-muxes and the DVB-T-mux.
>> Additionally, it found the DVB-T2-muxes during the DVB-T-scan.
>>
>> Logs:
>> media_build-bst_dmesg_lsusb.txt http://pastebin.com/vJeDMxtu
>> media_build-bst_w_scan.txt http://pastebin.com/yhwAYjen
>>
>> Found transponders:
>> initial_v3_bst.conf http://pastebin.com/ECKQvRWX
>> initial_v5_bst.conf http://pastebin.com/CbhY6Hpz
>>
>> Of course, doing a channel-scan using dvbv5-scan on these transponders
>> worked
>> too:
>>
>> dvbv5_sit2.conf http://pastebin.com/3W52bbhv
>> dvbv5_sit2.log http://pastebin.com/nc66PTkt
>>
>> Afterwards, I tried to do a channel-scan with the same initial tuning-file
>> using the opensource-driver, which also worked:
>>
>> dvbv5_si2168.conf http://pastebin.com/A6FbqUL1
>> dvbv5_si2168.log http://pastebin.com/ewyVPJR2
>>
>> This should verify that tuning PLP 1 without there being PLP 0 is not
>> the issue.
>>
>>
>> Additionally, if you compare the two channel-lists, you find interesting
>> differences:
>>
>> The scan with si2168 has AUTO for "MODULATION" and "INVERSION" for
>> DVB-T2-channels, and for "CODE_RATE_LP" and "INVERSION" for DVB-T-channels.
>>
>> The scan with sit2 has the respective values in the channel-list.
>>
>> The dvbv5-scan-logs also differ, as using sit2 also displays the signal
>> quality
>> during tuning.
>>
>>
>> I know that there were changes regarding DVB-T2-scanning[3], but as the
>> blog-
>> article specifically mentions si2168 and w_scan to be fully dvbv5-compliant
>> and good for using with DVB-T2, I thought you should know about this
>> particular problem.
>>
>>
>> In the attachment I've packed the previously linked logs, for archival
>> reasons.
>>
>>
>> Thank you for your attention.
>>
>> [1] http://www.dvbsky.net/Support_linux.html
>> [2] http://www.dvbsky.net/download/linux/media_build-bst-150322.tar.gz
>> [3] http://blog.palosaari.fi/2014/09/linux-dvb-t2-tuning-problems.html
>>
>> PS: Interesting comments regarding auto-detection for si2168:
>> http://blog.palosaari.fi/2014/09/linux-dvb-t2-tuning-problems.html?showComment=1427233615765#c8591459871945922951 
>>
>>
>> http://blog.palosaari.fi/2014/09/linux-dvb-t2-tuning-problems.html?showComment=1427234034259#c6500661729983566638 
>>
>>
>

