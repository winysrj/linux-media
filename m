Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KWFhv-0005Na-DR
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 21:20:33 +0200
Date: Thu, 21 Aug 2008 21:17:58 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080821191758.GD32022@raven.wolf.lan>
References: <20080820211005.GA32022@raven.wolf.lan>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080820211005.GA32022@raven.wolf.lan>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Aug 20, 2008 at 11:10:06PM +0200, Josef Wolf wrote:

>   jw@dvb1:~$ dvbsnoop -s pes -if zdf.test|grep Stream_id|head -40
>   Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2 video stream]
>   Stream_id: 0 (0x00)  [= picture_start_code]
>   Stream_id: 181 (0xb5)  [= extension_start_code]
>   Stream_id: 1 (0x01)  [= slice_start_code]
>   Stream_id: 2 (0x02)  [= slice_start_code]
>   [ consecutive lines deleted ]
>   Stream_id: 34 (0x22)  [= slice_start_code]
>   Stream_id: 35 (0x23)  [= slice_start_code]
>   [ here the list of stream ids start over again and repeats ]

Table 2-18 in iso-13818-1 don't list any stream_id's below 0xBC.
Anybody knows what those stream_id's 0x00..0x23 and 0xB5 are for
and whether they could be the reason for the artefacts?

> Maybe I should discard some of those to get a proper PES?

Hmm, guess I should give it a try.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
