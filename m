Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:27026 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZHRToD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 15:44:03 -0400
Received: by ey-out-2122.google.com with SMTP id 22so827420eye.37
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 12:44:03 -0700 (PDT)
From: Luis Silva <lacsilva@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Date: Tue, 18 Aug 2009 21:43:59 +0200
References: <20090818170820.3d999fb9.don@tricon.hu>
In-Reply-To: <20090818170820.3d999fb9.don@tricon.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908182143.59875.lacsilva@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
>
> regards,
> s.
>
>         ---------------------------------------------------------------
>
>         |  Make it idiot proof and someone will make a better idiot.  |
>
>         ---------------------------------------------------------------


I don't know if this helps but from my experience xine or any xine based 
player always did a better job with respect to dvb. Maybe you want to give it 
a try.
Good luck,
-- 
Luís Silva
