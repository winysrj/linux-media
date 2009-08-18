Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.26]:37906 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZHRQUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 12:20:11 -0400
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Date: Tue, 18 Aug 2009 18:20:24 +0200
References: <20090818170820.3d999fb9.don@tricon.hu>
In-Reply-To: <20090818170820.3d999fb9.don@tricon.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908181820.24506.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Tuesday 18 August 2009 17:08:20 Pásztor Szilárd, vous avez écrit :
> Hi,
>
> I recently got the USB DVB-C tuner mentioned in the subject.
> Everything seems to work fine, except that the MPEG-4 HD channels have no
> video, only sound. Regular SD channels broadcasted in MPEG-2 are flawless.
>
> The tuner can receive MPEG-4 streams; decoder is not built in but Mplayer
> would do the job if it could get the data. I have also tried in Window$ and
> HD channels are working properly.
>
> I used w_scan to scan through the channels and it found almost everything
> that the Win scanner did (one block is missing in linux though, probably
> due to different scanning parameters needed but the win one is dumb and
> won't tell me any useful information).
>
> My kernel: 2.6.30.5
>
> Excerpt from dmesg:
> dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer. DVB: registering new adapter (Anysee DVB USB2.0)
> anysee: firmware version:0.1.2 hardware id:15
> DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
> input: IR-receiver inside an USB DVB receiver as /class/input/input3
> dvb-usb: schedule remote query interval to 200 msecs.
> dvb-usb: Anysee DVB USB2.0 successfully initialized and connected.
>
> Any ideas on how I could start with my investigations? I took a quick peek
> into the driver source but no story of mpeg 2/4 differences there.

Not a driver issue.
Maybe mplayer doesn't autodetect h264, or maybe the h264 stream's pid is 
missing in your channels.conf


-- 
Christophe Thommeret


