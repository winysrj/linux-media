Return-path: <linux-media-owner@vger.kernel.org>
Received: from em002a.cxnet.dk ([87.72.115.243]:50595 "EHLO em002a.cxnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZIBSWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 14:22:08 -0400
Message-ID: <4A9EB032.7000503@rokamp.dk>
Date: Wed, 02 Sep 2009 19:49:38 +0200
From: Thomas Rokamp <thomas@rokamp.dk>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with Hauppauge Nova-T USB2
References: <41138.1251890451@rokamp.dk> <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick

Patrick Boettcher wrote:
> Hi Thomas,
>
> Ignore the SNR value. It is forced to 0000 even if the SNR is good 
> (enough). This is a missing feature in the DiBx000-drivers (x < 8).
>
> Beside that, everything looks fine: locks are there, signal is 
> mid-range (~60 dBm I would estimate). ber = 0 and unc = 0, that means 
> no problem on the demodulator side.
>
> How did you get the channels.conf? How do you know the video and audio 
> PID is correct?
>
> Did you try to run scan or w_scan?
I used w_scan to get the the channels.conf file. I dont have the 
transponder data, so 'scan' is of no use. Unless I extract them from the 
output of w_scan, in which case the to generated files are identical on 
the numbers.
X:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:644:905
>
>> [..[
>> This 'test.mpg' output file, however, shows no video at all, despite 
>> it actually containing data. VLC reports 'nothing to play'.
>
> What's the size of this file? (Should be ~1MB per second max on a very 
> good MPEG2-stream) Maybe you're receiving H264... then it can be more 
> and some versions of mplayer and vlc may not play it, because they are 
> not able to detect that it is H264 + AAC without stream-meta-data 
> (PAT, PMT).
The file varies in size, from around 3MB to around 7MB for the 5 seconds.

I have no idea if the PIDs are the correct ones, but at least they match 
the output from dvbsnoop:

dvbsnoop -s pidscan
---------------------------------------------------------
Transponder PID-Scan...
---------------------------------------------------------
PID found:    0 (0x0000)  [SECTION: Program Association Table (PAT)]
PID found:  110 (0x006e)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
ISO/IEC 11172-2 video stream]
PID found:  120 (0x0078)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 
audio stream]
PID found:  130 (0x0082)  [PS/PES: private_stream_1]
PID found:  131 (0x0083)  [unknown]
PID found:  257 (0x0101)  [SECTION: Program Map Table (PMT)]
PID found:  259 (0x0103)  [SECTION: Program Map Table (PMT)]
PID found:  260 (0x0104)  [SECTION: Program Map Table (PMT)]
PID found:  261 (0x0105)  [SECTION: Program Map Table (PMT)]
PID found:  301 (0x012d)  [PS/PES: private_stream_1]
PID found:  512 (0x0200)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
ISO/IEC 11172-2 video stream]
PID found:  513 (0x0201)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
ISO/IEC 11172-2 video stream]
PID found:  640 (0x0280)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 
audio stream]
PID found:  644 (0x0284)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 
audio stream]
PID found: 1200 (0x04b0)  [PS/PES: ITU-T Rec. H.262 | ISO/IEC 13818-2 or 
ISO/IEC 11172-2 video stream]
PID found: 1201 (0x04b1)  [PS/PES: ISO/IEC 13818-3 or ISO/IEC 11172-3 
audio stream]
PID found: 5008 (0x1390)  [PS/PES: private_stream_1]
PID found: 5009 (0x1391)  [PS/PES: private_stream_1]
PID found: 8180 (0x1ff4)  [unknown]
PID found: 8191 (0x1fff)  [stuffing]


If it can be any help, I have uploaded 2 test files
(both made with "dvbstream -n 5 -qam 64 -gi 16 -cr 5_6 -crlp 5_6 -bw 8 
-tm 2 -hy NONE -f 722000000 513 644 -o > testX.mpg")

http://phail.dk/test01.mpg
http://phail.dk/test02.mpg

/Thomas
