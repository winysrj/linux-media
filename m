Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42912 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaGIUOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 16:14:37 -0400
Received: by mail-vc0-f181.google.com with SMTP id il7so8355099vcb.12
        for <linux-media@vger.kernel.org>; Wed, 09 Jul 2014 13:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvcAg4c9Z-pt3EquwA98d5dUW20dD20y9VXH=5i8MjHA5iHYQ@mail.gmail.com>
References: <CAFvcAg4c9Z-pt3EquwA98d5dUW20dD20y9VXH=5i8MjHA5iHYQ@mail.gmail.com>
Date: Wed, 9 Jul 2014 22:14:37 +0200
Message-ID: <CAFvcAg49VwGS9CadmeR5AR1q4Q0mNssHeCYAt-saV5mYTNjFAw@mail.gmail.com>
Subject: Re: DVB-T be-all: tuning failed for 754mhz
From: Quentin Denis <quentin.denis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the same issue with w_scan: http://pastebin.com/vCFD2972

On Wed, Jul 9, 2014 at 12:28 PM, Quentin Denis <quentin.denis@gmail.com> wrote:
> Hi all,
>
> I am running a Terratec DVB Cinergy T stick MKII under openSUSE and cannot find
> all the channels available in my region (Brussels). I have all the channels
> from on 482Mhz but none on 754mh, whereas on Windows I receive both.
>
> How can it be that it does not fully work under linux? Is there an
> issue with the
> driver? Neither kaffeine nor 'scan' will find it. The latter outputs a
> tuning failure:
>
> quentin@linux-v3k0:~> scan be-All.txt > channels.conf
> scanning be-All.txt
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 754000000 0 3 9 1 1 3 0
> initial transponder 482000000 0 1 9 3 1 3 0
> initial transponder 506000000 0 1 9 3 1 3 0
> initial transponder 666000000 0 3 9 1 1 3 0
> initial transponder 834000000 0 3 9 1 1 3 0
>>>> tune to:
> 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> Network Name 'VRTmux1'
> 0x0001 0x1010: pmt_pid 0x1010 VRT -- EEN (running)
> 0x0001 0x1020: pmt_pid 0x1020 VRT -- Canvas (running)
> 0x0001 0x1030: pmt_pid 0x1030 VRT -- Ketnet op 12 (running)
> 0x0001 0x1040: pmt_pid 0x1040 VRT -- Radio 1 (running)
> 0x0001 0x1050: pmt_pid 0x1050 VRT -- Radio 2 (running)
> 0x0001 0x1060: pmt_pid 0x1060 VRT -- Klara (running)
> 0x0001 0x1070: pmt_pid 0x1070 VRT -- Studio Brussel (running)
> 0x0001 0x1080: pmt_pid 0x1080 VRT -- MNM (running)
> 0x0001 0x1090: pmt_pid 0x1090 VRT -- Klara Continuo (running)
> 0x0001 0x10a0: pmt_pid 0x10a0 VRT -- Sporza (running)
> 0x0001 0x10c0: pmt_pid 0x10c0 VRT -- Nieuws+ (running)
> 0x0001 0x10d0: pmt_pid 0x10d0 VRT -- MNM Hits (running)
>>>> tune to:
> 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
> 834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> (tuning failed)
> WARNING: >>> tuning failed!!!
> dumping lists (12 services)
> Done.
>
> Best regards,
> Quentin
