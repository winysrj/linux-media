Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KWHZk-0004bl-Ij
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 23:20:13 +0200
Date: Thu, 21 Aug 2008 23:14:37 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080821211437.GE32022@raven.wolf.lan>
References: <20080820211005.GA32022@raven.wolf.lan>
	<20080821191758.GD32022@raven.wolf.lan>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080821191758.GD32022@raven.wolf.lan>
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

On Thu, Aug 21, 2008 at 09:17:58PM +0200, Josef Wolf wrote:
> On Wed, Aug 20, 2008 at 11:10:06PM +0200, Josef Wolf wrote:
> 
> >   jw@dvb1:~$ dvbsnoop -s pes -if zdf.test|grep Stream_id|head -40
> >   Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2 video stream]
> >   Stream_id: 0 (0x00)  [= picture_start_code]
> >   Stream_id: 181 (0xb5)  [= extension_start_code]
> >   Stream_id: 1 (0x01)  [= slice_start_code]
> >   Stream_id: 2 (0x02)  [= slice_start_code]
> >   [ consecutive lines deleted ]
> >   Stream_id: 34 (0x22)  [= slice_start_code]
> >   Stream_id: 35 (0x23)  [= slice_start_code]
> >   [ here the list of stream ids start over again and repeats ]
> 
> Table 2-18 in iso-13818-1 don't list any stream_id's below 0xBC.
> Anybody knows what those stream_id's 0x00..0x23 and 0xB5 are for
> and whether they could be the reason for the artefacts?

The more I look at this PES stream the more confused I get:  The
stream_id 0xe0 seems to transport PTS and DTS _only_.  Everything
else seems to be contained in PES packets with those unknown
stream_id's.  Here is what I see:

At byte position 0x0:
0x0000+0x0000: 00 00 01 e0 00 00 88 80  05 25 ea ad 04 69 00 00
0x0000+0x0010: 01 00 02 9f ff fb b8 00  00 01 b5 85 55 53 9c 00

stream_id:            0xe0
PES_packet_length:       0 (unlimited)
PES_priority:            1
PTS_DTS_flags:          10
PES_header_data_length:  5 (so the header ends on position 0x0d)
PTS:                     25 ea ad 04 69 (bit fiddling not done yet)

at position 0x0e comes the next packet with stream_id==0x00
So this video PES packet don't contain any payload at all.


The next packet with stream_id==0xe0 is on position 0x2c83:

0x2c83+0x0000: 00 00 01 e0 00 00 88 c0  0b 35 ea ad 74 e9 15 ea
0x2c83+0x0010: ad 20 89 ff 00 00 01 b3  2d 02 40 33 24 9f 23 81

stream_id:             0xe0
PES_packet_length:        0 (unlimited)
PES_priority:             1
PTS_DTS_flags:           11
PES_header_data_length: 0x0b (so the header ends on position 0x13)
PTS:                     35 ea ad 74 e9 (bit fiddling not done yet)
DTS:                     15 ea ad 20 89 (bit fiddling not done yet)
payload:               0xff (ough, only one byte padding in payload?)

at position 0x14 comes the next packet with stream_id==0xb3
So this video packet don't contain any payload at all.

And so it goes on and on.  All the payload seems to be contained
in those unknown packets.  Packets with stream_id==0xe0 don't
seem to contain any payload at all.

Obviously, I must have misunderstood something very badly.  But
I simply can't figure out what.  I bet there is some sort of stuffing
or escaping that I should do when removing the TS layer?

Any ideas how those unknown stream_id's come to carry all the
ES contents?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
