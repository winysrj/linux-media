Return-path: <linux-media-owner@vger.kernel.org>
Received: from snt0-omc2-s22.snt0.hotmail.com ([65.55.90.97]:9934 "EHLO
	snt0-omc2-s22.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab0DEBxc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Apr 2010 21:53:32 -0400
Message-ID: <SNT130-w4175BDDB645635565E780BF4190@phx.gbl>
From: Gavin Ramm <gavin_ramm@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: RE: help: Leadtek DTV2000 DS
Date: Mon, 5 Apr 2010 11:47:21 +1000
In-Reply-To: <SNT130-w8A3CD8D7472E29B37D0B9F45D0@phx.gbl>
References: <SNT130-w530BA3C80D244EB3C39701F45F0@phx.gbl>,<4B5F870C.4040807@iki.fi>,<SNT130-w45A99AE87EEBD10A3DCD60F45D0@phx.gbl>,<SNT130-w65FFEB98498ECA954DE96F45D0@phx.gbl>,<SNT130-w4584A0C48F74BB401E4C73F45D0@phx.gbl>,<SNT130-w649D6B6E5B4CD0233A2F73F45D0@phx.gbl>,<SNT130-w310DB522F4C5458EB94E4EF45D0@phx.gbl>,<SNT130-w8A3CD8D7472E29B37D0B9F45D0@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Finally got back to my mythtv and found that the card isn't working 100%

what I've noticed.
1) Installed card run a LSMOD (shown below) did a scandvb -a 0 /usr/share/dvb-apps/dvb-t/au-Bendigo and scandvb -a 1 /usr/share/dvb-apps/dvb-t/au-Bendigo. The cards found all the channels and works.

lsmod Start
Module                  Size  Used by
sunrpc                160130  1
ipv6                  223810  30
dvb_usb_dib0700        51842  0
dib7000p               13813  1 dvb_usb_dib0700
dib0090                11198  1 dvb_usb_dib0700
dib7000m               11308  1 dvb_usb_dib0700
dib0070                 6749  1 dvb_usb_dib0700
dib8000                21692  1 dvb_usb_dib0700
dib3000mc               9617  1 dvb_usb_dib0700
dibx000_common          2804  4 dib7000p,dib7000m,dib8000,dib3000mc
tda18271               43121  2
af9013                 16098  2
nouveau               292109  2
ttm                    40269  1 nouveau
dvb_usb_af9015         24958  0
drm_kms_helper         22251  1 nouveau
forcedeth              42741  0
dvb_usb                15013  2 dvb_usb_dib0700,dvb_usb_af9015
dvb_core               72883  3 dib7000p,dib8000,dvb_usb
drm                   134966  4 nouveau,ttm,drm_kms_helper
i2c_algo_bit            4073  1 nouveau
i2c_nforce2             5575  0
i2c_core               21732  17 dvb_usb_dib0700,dib7000p,dib0090,dib7000m,dib0070,dib8000,dib3000mc,dibx000_common,tda18271,af9013,nouveau,dvb_usb_af9015,drm_kms_helper,dvb_usb,drm,i2c_algo_bit,i2c_nforce2
k8temp                  2815  0
ata_generic             2399  0
pata_acpi               2303  0
sata_nv                16524  3
pata_amd                7613  0

lsmod finished


2) I then rebooted the computer and did a lsmod again (see below) i did another candvb -a 0 /usr/share/dvb-apps/dvb-t/au-Bendigo which worked but when i did candvb -a 1 /usr/share/dvb-apps/dvb-t/au-Bendigo it failed to find anything.. see the output of the dvbscan of the failed scan below.

I noticed in the first one the tda18271 is used 2 and in the second one its used 1 thats the only difference I see.

Module                  Size  Used by
sunrpc                160130  1
ipv6                  223810  30
dvb_usb_dib0700        51842  0
dib7000p               13813  1 dvb_usb_dib0700
dib0090                11198  1 dvb_usb_dib0700
dib7000m               11308  1 dvb_usb_dib0700
dib0070                 6749  1 dvb_usb_dib0700
dib8000                21692  1 dvb_usb_dib0700
dib3000mc               9617  1 dvb_usb_dib0700
dibx000_common          2804  4 dib7000p,dib7000m,dib8000,dib3000mc
tda18271               43121  1
af9013                 16098  2
nouveau               292109  2
ttm                    40269  1 nouveau
dvb_usb_af9015         24958  0
dvb_usb                15013  2 dvb_usb_dib0700,dvb_usb_af9015
dvb_core               72883  3 dib7000p,dib8000,dvb_usb
drm_kms_helper         22251  1 nouveau
drm                   134966  4 nouveau,ttm,drm_kms_helper
i2c_nforce2             5575  0
k8temp                  2815  0
i2c_algo_bit            4073  1 nouveau
i2c_core               21732  17 dvb_usb_dib0700,dib7000p,dib0090,dib7000m,dib0070,dib8000,dib3000mc,dibx000_common,tda18271,af9013,nouveau,dvb_usb_af9015,dvb_usb,drm_kms_helper,drm,i2c_nforce2,i2c_algo_bit
forcedeth              42741  0
ata_generic             2399  0
pata_acpi               2303  0
pata_amd                7613  0
sata_nv                16524  3



dvbscan start

[mythtv@mythbackend ~]$ scandvb -a 1 /usr/share/dvb-apps/dvb-t/au-Bendigo
scanning /usr/share/dvb-apps/dvb-t/au-Bendigo
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 669500000 1 3 9 3 1 1 0
initial transponder 620500000 1 3 9 3 1 1 0
initial transponder 572500000 1 3 9 3 1 1 0
initial transponder 690500000 1 3 9 3 1 1 0
initial transponder 655500000 1 3 9 3 1 1 0
initial transponder 555250000 1 3 9 3 1 1 0
initial transponder 576250000 1 3 9 3 1 1 0
initial transponder 592500000 1 3 9 3 1 1 0
initial transponder 618250000 1 3 9 3 1 1 0
initial transponder 529500000 1 2 9 3 1 2 0
initial transponder 634500000 1 2 9 3 1 2 0
initial transponder 534250000 1 2 9 3 1 2 0
initial transponder 676500000 1 3 9 3 1 1 0
initial transponder 571500000 1 3 9 3 1 1 0
initial transponder 536625000 1 3 9 3 1 1 0
initial transponder 585625000 1 3 9 3 1 1 0
initial transponder 564500000 1 3 9 3 1 1 0
initial transponder 543500000 1 3 9 3 1 1 0
initial transponder 536500000 1 3 9 3 1 1 0
initial transponder 529500000 1 3 9 3 1 1 0
initial transponder 205500000 1 3 9 3 1 1 0
initial transponder 564500000 1 3 9 3 1 1 0
initial transponder 536625000 1 3 9 3 1 1 0
initial transponder 690500000 1 3 9 3 1 1 0
initial transponder 711500000 1 3 9 3 1 1 0
initial transponder 550500000 1 3 9 3 1 1 0
>>> tune to: 669500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
^[[AWARNING:>>> tuning failed!!!
>>> tune to: 669500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)

WARNING:>>> tuning failed!!!
>>> tune to: 620500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 620500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 572500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 572500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 690500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 690500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 655500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 655500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 555250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 555250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 576250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 576250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 592500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 592500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 618250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 618250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 529500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 529500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 634500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 634500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 534250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 534250000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 676500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 676500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 585625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 543500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 536500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 529500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 529500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 205500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 205500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 690500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 690500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 711500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 711500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
>>> tune to: 550500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING:>>> tuning failed!!!
>>> tune to: 550500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING:>>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

----------------------------------------
> From: gavin_ramm@hotmail.com
> To: linux-media@vger.kernel.org
> Subject: RE: help: Leadtek DTV2000 DS
> Date: Wed, 27 Jan 2010 22:30:07 +1100
>
>
>
>>>>>> ----------------------------------------
>>>>>>> Date: Wed, 27 Jan 2010 02:21:32 +0200
>>>>>>> From: crope@iki.fi
>>>>>>> To: gavin_ramm@hotmail.com
>>>>>>> CC: linux-media@vger.kernel.org
>>>>>>> Subject: Re: help: Leadtek DTV2000 DS
>>>>>>>
>>>>>>> Terve Gavin,
>>>>>>>
>>>>>>> On 01/25/2010 01:44 PM, Gavin Ramm wrote:
>>>>>>>> Tried the current build of v4l-dvb (as of 25/01/2010) for a Leadtek DTV2000 DS.
>>>>>>>> product site : http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=530&check=f
>>>>>>>>
>>>>>>>> The chipset are AF9015 + AF9013 and the tuner is TDA18211..
>>>>>>>> Im running it on mythdora 10.21 *fedora 10* i've had no luck with this.
>>>>>>>>
>>>>>>>> Any help would be great.. im willing to test..
>>>>>>>
>>>>>>> I added support for that device, could you test now?
>>>>>>> http://linuxtv.org/hg/~anttip/af9015/
>>>>>>>
>>>>
>>>>
>>>> I created a channels.conf via the output tried in xine and it worked.. tried in mythtv and it picked a few up only by importing the channels.conf. The auto scan in mythtv didn't work (which is out of scope i'd say)
>>>> _________________________________________________________________
>>>
>>>
>>> The card is up and running within mythtv also, forgot i rebuilt the box and didn't change it back to Australian freq...
>>>
>>> thanks alot for the help!!
>>>
>>> gav
>>> _________________________________________________________________
>>
>> celebrated too soon!
>>
>> the adpater0 works but all the other adapters1/2/3 do not find anything.
>>
>> I've ran the identical "scan -a 1 /usr/share/dvb/dvb-t/au-Bendigo" on them all and only the first one works..
>>
>> I've changed the physical arial cables also, this didn't help..
>>
>> I have 2x of the cards installed.
>>
>> -gav
>> _________________________________________________________________
>
> Ok first up sorry for the "spamming" of message..
>
> I took an old card out that was also in the box.. rebooted my pc and now it looks like they're all working..
>
> Tried via "scan -a 0 /usr/share/dvb/dvb-t/au-Bendigo" for 0 1 2 and 3 and they all got channels.
>
> then tried on my mythfrontend and i could view channels on all adapters..
>
> -gav
>
>
> _________________________________________________________________
> Search for properties that match your lifestyle! Start searching NOW!
> http://clk.atdmt.com/NMN/go/157631292/direct/01/

 		 	   		  
_________________________________________________________________
New, Used, Demo, Dealer or Private? Find it at CarPoint.com.au
http://clk.atdmt.com/NMN/go/206222968/direct/01/