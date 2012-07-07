Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53191 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2GGKDh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 06:03:37 -0400
Message-ID: <4FF8096F.7050908@iki.fi>
Date: Sat, 07 Jul 2012 13:03:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: success! (Re: media_build and Terratec Cinergy T Black.)
References: <1341627106.90091.YahooMailClassic@web29405.mail.ird.yahoo.com>
In-Reply-To: <1341627106.90091.YahooMailClassic@web29405.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2012 05:11 AM, Hin-Tak Leung wrote:
> --- On Fri, 6/7/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:
>
> <snipped>
>>> Typical channels.conf entry looks like that:
>>>
>> MTV3:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:305:561:49
>>>
>>> And tuning to that channel using mplayer:
>>> mplayer dvb://MTV3
>>
>> Well that at least clear up something - I tried this form
>> (from
>> /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* ) but
>> did not get anything either - the error message seemed worse
>> so I didn't go further. I guess I should try getting w_scan
>> to do this form.
>
> <snipped>
>> There seems to be at least two channels.conf formats (one
>> for mplayer/vlc/gstreamer, one for vdr?), and unfortunately
>> both seems to have the same name conventionally, but
>> different content. I can't find documentation about either,
>> or even examples :-).
>
> Apparently it was just me not reading the manual/options properly. There are 3 formats - gstreamer, vdr and mplayer's! I thought it was just vdr vs everything else. It was also confusing that mplayer did not complain about it.
>
> scandvb still does not work at all, nor those sample config files under /usr/share/doc/dvb-apps-1.1.2/channels-conf/dvb-t/* , or use those (tried about 6 different transmitter config various distance away). It is also true that I have poor reception: all the BBC* channels seems to work okay - about 18 channels - but none of the non-BBC stations. Also they are not there on a 2nd scan, so I guess they are weaker.

UK is a little bit special case as it uses different channel raster. I 
just looked and there seems to be "auto-With167kHzOffsets" which could 
be used. It scans all the possible channels using auto parameter detection.

> So obviously there are a lot of rough edges. I also think it is a bit stupid for w_scan not to offer writing *all* the formats, since all the information should be there after a scan. It takes about 8 minutes to do a full scan. It would be more logical to generate all the channels.conf formats on one scan, and let the user throw away the ones he does not need, if it takes that long to do a full scan.

Yes there is. There is no many desktop applications supporting DVB and 
even less applications having own channels scanner.

regards
Antti

-- 
http://palosaari.fi/


