Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab2F2Ecv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 00:32:51 -0400
Message-ID: <4FED2FE0.9010602@redhat.com>
Date: Fri, 29 Jun 2012 01:32:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi>
In-Reply-To: <4FEBA656.7060608@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-06-2012 21:33, Antti Palosaari escreveu:
> Here is my list of needed DVB core related changes. Feel free to comment - what are not needed or what you would like to see instead. I will try to implement what I can (and what I like most interesting :).
> 
> 
> general validly checking for demodulator callback input values
> --------------------------------------------------
> * currently each driver needs to validate those
> * values are highly hooked up to used television standard
> * we can do almost all validly checking inside core
> * we can also check if call is possible to perform in given condition
> * for example BER is not valid when demod is unlocked
> 
> 
> suspend / resume support
> --------------------------------------------------
> * support is currently quite missing, all what is done is on interface drivers
> * needs power management
> * streaming makes it hard
> * quite a lot work to get it working in case of straming is ongoing
> 
> 
> use Kernel power management instead of own
> --------------------------------------------------
> * there seems to be Kernel services for power-management
> * study if it is wise to use Kernel services instead of own
> * own PM is still working very well, at least I dont know any problems
> 
> 
> SDR - Softaware Defined Radio support DVB API
> --------------------------------------------------
> * http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/44461
> * there is existing devices that are SDR (RTL2832U "rtl-sdr")
> * SDR is quite near what is digital TV streaming
> * study what is needed
> * new delivery system for frontend API called SDR?
> * some core changes needed, like status (is locked etc)
> * how about demuxer?
> * stream conversion, inside Kernel?
> * what are new parameters needed for DVB API?

Let's not mix APIs: the radio control should use the V4L2 API, as this is not
DVB. The V4L2 API has already everything needed for radio. The only missing
part ther is the audio stream. However, there are a few drivers that provide 
audio via the radio device node, using read()/poll() syscalls, like pvrusb. 
On this specific driver, audio comes through a MPEG stream. As SDR provides
audio on a different format, it could make sense to use VIDIOC_S_STD/VIDIOC_G_STD
to set/retrieve the type of audio stream, for SDR, but maybe it better to just
add capabilities flag at VIDIOC_QUERYCTL or VIDIOC_G_TUNER to indicate that
the audio will come though the radio node and if the format is MPEG or SDR.

> 
> 
> DTMB standard support for DVB API
> --------------------------------------------------
> * it is Chinese DTV standard
> * I already ran RFC but have been too busy for implementing it :]
> 
> 
> LNA (low-noise amplifier) support for DVB API
> --------------------------------------------------
> * there is quite a lot of devices having LNA
> * currently not supported => LNA is configured off typically
> 
> 
> offer polling method for statistics
> --------------------------------------------------
> * many static counters could not be read as a "one go"
> * typical cycle is : start measurement => wait => read counters
> * some drivers starts own internal work-queue for polling (complexity)
> * some drivers blocks IOCTL when taking measurement (bad)
> 
> 
> fix frontend properties
> --------------------------------------------------
> * those has been broken since MFE => SFE change
> * currently implemented as a properties per driver
> * need to be properties per delivery system
> * are broken because driver/chip could support multiple DTV standards
> 
> regards
> Antti


