Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:51124 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2LDCPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 21:15:33 -0500
Message-ID: <50BD5CC3.1030100@pyther.net>
Date: Mon, 03 Dec 2012 21:15:31 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com>
In-Reply-To: <50BCEC60.4040206@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2012 01:16 PM, Frank Schäfer wrote:
>
> Here is v2 of the patch (attached).
>
> Antti, could you please take a look at the std_map for the tuner ?
> I'm not sure what the correct and complete map is.
>
> For a first test, I've selected the same std_map as used with the KWorld
> A340 (LGDT3304 + TDA18271 C1/C2):
>
> static struct tda18271_std_map kworld_a340_std_map = {
>      .atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 0,
>                .if_lvl = 1, .rfagc_top = 0x37, },
>      .qam_6    = { .if_freq = 4000, .agc_mode = 3, .std = 1,
>                .if_lvl = 1, .rfagc_top = 0x37, },
> };
>
>
> These are the relevant tda18271 register values the taken from Matthews
> USB-log:
>
> EP3 (0x05): 0x1d
> EP4 (0x06): 0x60
> EB22 (0x25): 0x37
>
> The LGDT3305 is configured for QAM and IF=4000kHz, which leads to a
> tda18271_std_map_item with
>
> {
>   .if_freq = 4000,
>   .agc_mode = 3,
>   .std = 5,
>   .fm_rfn = 0,
>   .if_lvl = 0,
>   .rfagc_top = 0x37,
>   }
>
> According to the datasheet and tda18271-maps.c, this should be qam_6,
> qam_7 or qam_8.
>
> Do we need further USB-logs from the Windows driver ?
> And if yes, do you have any advice for Matthew how to create them ?
>
> Regards,
> Frank
>
>
>

What git branch are you writing the patch against?

I had to manually apply the patch by editing each file specified in the 
patch. The patch failed to apply against master (I'm assuming)

I used these commands to check out the code (patched against this code 
base after completing the steps below):
>   git clone git://github.com/torvalds/linux.git v4l-dvb
>   cd v4l-dvb
>   git remote add linuxtv git://linuxtv.org/media_tree.git
>   git remote update

At first I got this error:
> [  709.649264] DVB: Unable to find symbol lgdt3305_attach()
http://pyther.net/a/digivox_atsc/patch2/dmesg_before_lgdt3305.txt

I had to go back into the kernel config uncheck "Autoselect tuners and 
i2c modules to build" and then it included all device drivers under 
"Customise DVB Frontend"

Now the kernel detects the card however, I was unable to successfully 
capture a mpeg2 stream.

> $ dmesg
http://pyther.net/a/digivox_atsc/patch2/dmesg.txt

I attempted to tune to a channel using azap. The channels.conf was 
generated using my pci based tuner card that I have in another system.

> [root@tux ~]# azap -r -c /home/pyther/channels.conf "WATE-DT"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 525000000 Hz
> video pid 0x07c0, audio pid 0x07c1
> status 00 | signal 4b11 | snr 0066 | ber 00000000 | unc 0000ffff |
> status 1f | signal ffff | snr 01d8 | ber 00000000 | unc 0000ffff | FE_HAS_LOCK

http://pyther.net/a/digivox_atsc/patch2/azap_wate-dt.txt
http://pyther.net/a/digivox_atsc/patch2/azap_ionlife.txt

Although, it looked like tuning was semi-successful, I tried the following

   * cat /dev/dvb/adapter0/dvr0 (no output)
   * mplayer /dev/dvb/adapter0/dvr0 (no output)
   * cat /dev/dvb/adapter0/dvr0 > test.mpg (test.mpg was 0 bytes)

I then attempted to do a tv channel scan:
> [root@tux ~]# scan -A 2 -t 1 
> /usr/share/dvb/atsc/us-Cable-Standard-center-frequencies-QAM256 > 
> ~/channels.conf
It got through a few channels before it crashed with this error
> start_filter:1752: ERROR: ioctl DMX_SET_FILTER failed: 71 Protocol error
http://pyther.net/a/digivox_atsc/patch2/dmesg_after_scan.txt
http://pyther.net/a/digivox_atsc/patch2/lspci_after_scan.txt

While tuned into a channel using azap I ran dvbtraffic:
http://pyther.net/a/digivox_atsc/patch2/dvbtraffic.txt

Just let me know what you need me to do next. I really appreciate the 
work and help!

Regards,
Matthew
