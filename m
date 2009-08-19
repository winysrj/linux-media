Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41793 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZHSK2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 06:28:45 -0400
Message-ID: <4A8BD3DB.1010704@iki.fi>
Date: Wed, 19 Aug 2009 13:28:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1sztor_Szil=E1rd?= <don@tricon.hu>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
References: <20090818170820.3d999fb9.don@tricon.hu>	<alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>	<20090818210107.2a6a5146.don@tricon.hu>	<!&!AAAAAAAAAAAYAAAAAAAAACX9qQa/LtVPmfnAK0XM/DwChwAAEAAAAAZ+O15rAjRKhc61nu2RPHIBAAAAAA==@tv-numeric.com> <20090819094242.50ae2a03.don@tricon.hu>
In-Reply-To: <20090819094242.50ae2a03.don@tricon.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2009 10:42 AM, Pásztor Szilárd wrote:
> Thierry Lelegard:
>> Stream type 0x1B precisely means AVC / H.264 video stream (cf. ISO
>> 138181-1:2000/FDAM 3)
>>
>> Try VLC instead of mplayer. VLC does render H.264 HD video, provided you
>> have a (very) good CPU.
>
> Thanks for the info. Anyway, mplayer also does render H.264 of course, it's
> the stream that's not very cleverly muxed, it seems. And with mplayer I have
> vdpau acceleration on my nvidia card that can render 1920x1080@50 fps in real
> time.

Actually I met just similar case some months ago (I have also Anysee 
E30C and fi-3ktv cable). Only audio no video. HD-video PIDs were 
missing. I zapped to the channel and looked correct PIDs from dvbtraffic 
traffic output and added those to the channels.conf. Mplayer and Totem 
still resists to show video, but VLC does!

After that I looked transmission parameters by using dvbsnoop and there 
was H.262 (MPEG2) set those H.264 (MPEG4-AVC) channels. I think that was 
reason for my problems.

Antti
-- 
http://palosaari.fi/
