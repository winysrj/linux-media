Return-path: <linux-media-owner@vger.kernel.org>
Received: from WARSL404PIP1.highway.telekom.at ([195.3.96.112]:48256 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753516AbZCGTwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 14:52:23 -0500
Message-ID: <49B2D075.8060801@yahoo.de>
Date: Sat, 07 Mar 2009 20:52:21 +0100
From: Elmar Stellnberger <estellnb@yahoo.de>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	linux-media@vger.kernel.org
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel 2.6.27.19-3.2-default
References: <49B2BAAE.8040808@yahoo.de> <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbscan -out channels channels.conf
hangs and does not create a channels.conf file

vlc dvb://
vlc /dev/dvb/adapter0/dvr0
vlc -> recording device -> dvb-s
  ... does not open a video window and does not play anything

kaffeine stdin:// < /dev/dvb/adapter0/dvr0
 ... no module found to handle source

mplayer /dev/dvb/adapter0/dvr0
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote
control.

Playing /dev/dvb/adapter0/dvr0.
  ...but no window opens

How can I play videos?
How can I select a channel?
How can I stream a channel to disk?


have modprobed all recommended kernel modules:

> lsmod | egrep "budget|mt312|b2c2-flexcop"
mt312                   7748  0
budget                 12588  0
budget_core             9884  1 budget
saa7146                15980  2 budget,budget_core
ttpci_eeprom            2020  1 budget_core
dvb_core               73144  4 budget,budget_core,stv0299,b2c2_flexcop
i2c_core               29916  9
t312,budget,budget_core,ttpci_eeprom,stv0299,i2c_viapro,b2c2_flexcop,cx24123,s5h1420




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

