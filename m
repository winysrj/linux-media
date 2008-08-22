Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1KWRWu-0002Mq-KN
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 09:57:56 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'Josef Wolf'" <jw@raven.inka.de>,
	<linux-dvb@linuxtv.org>
Date: Fri, 22 Aug 2008 09:57:07 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAgguJmjEUAk6GyhTPSI7ffwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <20080821191758.GD32022@raven.wolf.lan>
Subject: [linux-dvb] RE :  How to convert MPEG-TS to MPEG-PS on the fly?
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

>>   jw@dvb1:~$ dvbsnoop -s pes -if zdf.test|grep Stream_id|head -40
>>   Stream_id: 224 (0xe0)  [= ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2 video stream]
>>   Stream_id: 0 (0x00)  [= picture_start_code]
>>   Stream_id: 181 (0xb5)  [= extension_start_code]
>>   Stream_id: 1 (0x01)  [= slice_start_code]
>>   Stream_id: 2 (0x02)  [= slice_start_code]
>>   [ consecutive lines deleted ]
>>   Stream_id: 34 (0x22)  [= slice_start_code]
>>   Stream_id: 35 (0x23)  [= slice_start_code]
>>   [ here the list of stream ids start over again and repeats ]
>
> Table 2-18 in iso-13818-1 don't list any stream_id's below 0xBC.
> Anybody knows what those stream_id's 0x00..0x23 and 0xB5 are for
> and whether they could be the reason for the artefacts?

They are defined ISO-13818-2 (MPEG-2 video). They are "start codes"
for PES payload elements. Stream id's (in PES headers, not
payloads) are a subset of start codes and are named "system start
codes". You won't find other start codes in PES headers, only in
PES payloads.

[Quoted from ISO-13818-2]

Table 6-1  Start code values
name                 start code value (hexadecimal)
picture_start_code   00
slice_start_code     01 through AF
reserved             B0
reserved             B1
user_data_start_code B2
sequence_header_code B3
sequence_error_code  B4
extension_start_code B5
reserved             B6
sequence_end_code    B7
group_start_code     B8
system start codes   B9 through FF

NOTE - system start codes are defined in Part 1 of this specification

[End quote]

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
