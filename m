Return-path: <linux-media-owner@vger.kernel.org>
Received: from WARSL404PIP1.highway.telekom.at ([195.3.96.112]:10105 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199AbZCGUoJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 15:44:09 -0500
Message-ID: <49B2DC97.9030605@yahoo.de>
Date: Sat, 07 Mar 2009 21:44:07 +0100
From: Elmar Stellnberger <estellnb@yahoo.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel 2.6.27.19-3.2-default
References: <49B2BAAE.8040808@yahoo.de> <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


dvbscan -out channels channels.conf
.... hangs and does not create a file named channels.conf

xine
... no valid channels.conf found

mplayer dvb://
Playing dvb://.
CAN'T READ CONFIG FILE /etc/mplayer/channels.conf
DVB CONFIGURATION IS EMPTY, exit
Failed to open dvb://.

kaffeine stdin:// < /dev/dvb/adapter0/dvr0
no module find to handle source

vlc dvb://
vlc -> open device -> dvb-s -> play -> "can not open dvb://"
... does not open any video window

me-tv
... "there are no available dvb tuner devices"



Patrick Boettcher schrieb:
> Hi Elmar,
> 
> On Sat, 7 Mar 2009, Elmar Stellnberger wrote:
> 
>> Following the instructions at
>> http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_2_TV_PCI_/_Sky2PC_PCI
>>
>> I have tried to make my Technisat Skystar 2 work.
> 
> This howto seems to be out of date. The skystar2.ko was removed like 4
> years ago. It was replaced by the b2c2-flexcop-drivers.
> 
> 
>> The thing is that suse ships most of the required kernel modules out of
>> the box; iter sunt
>> stv0299
>> mt312
>> budget
>> Only skystar2 is missing, so that I have no /dev/video0 and no
>> /dev/dvb/adapter0/video0 as required by all these dvb players.
>>>> ls /dev/dvb/adapter0/
>> demux0  dvr0  frontend0  net0
> 
> Furthermore this is totally correct. /dev/video0 is provided by
> analog-video-cards or by full-featured (with a overlay-chip on board)
> devices.
> 
> The SkyStar2 is neither of it.
> 
> Did you try to use Kaffeine or mplayer or (dvb)scan?
> 
> regards,
> Patrick.
> 
> -- 
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
> 

