Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60289 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab0AAQ7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jan 2010 11:59:24 -0500
Subject: Re: TV tunes ok but my DVB cards won't tune
From: Andy Walls <awalls@radix.net>
To: Matthew Smith <yo.checkit@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <a556718c1001010407j4b94af6sff50d00909fc2211@mail.gmail.com>
References: <a556718c1001010407j4b94af6sff50d00909fc2211@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jan 2010 11:58:55 -0500
Message-Id: <1262365135.17968.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-01 at 23:07 +1100, Matthew Smith wrote:
> Hi all,
> 
> I hope this is the right place to try and troubleshoot my DVB setup. I
> have a Conexant based tuner that used to work with the cx88 driver and
> an Avermedia USB tuner. I have moved house and can't get either of
> these cards to tune using the scan or dvbscan utilities.
> 
> Mythtv is able to pick up the channels when it scans but it can't tune
> to them later when I try to watch live tv.  As it tunes, I briefly see
> mythtv reporting signal strengths around 40%

You can use femon to see if you even get a lock on the channels.

> My TV is using the same antenna (with a splitter) and it picks up the
> channels and reports 30-33% signal strength and 100% signal quality.
> 
> Also, I'm not sure I have the right channel file as I live in country
> Victoria and the closest city is Melbourne so I'm using that file.  I
> would expect to at least tune the major channels.
> 
> Is this just a case of needing a better antenna or is there something
> else I can try? (I am already using a signal amplifier at the wall
> socket.)


An amplifier at the wall socket is suboptimal.  For weak OTA signals,
you want a low noise figure ( < 3 dB ) pre-amplifier located as close to
the antenna as possible - before the splitters, long cable runs, and
wall plates - so you can maintain as much of your received SNR as
possible.  (In the US Winegard make some good units.)

Also be aware that over-amplification can overdrive the tuner front ends
causing intermodulation products that show up as noise and degrade the
SNR.

You may find the information here useful:

http://ivtvdriver.org/index.php/Howto:Improve_signal_quality

once ivtvdriver.org comes back up.  It seems to be down right now.

Regards,
Andy
 


> Regards
> 
> Matt
> 
> $ scan /usr/share/dvb/dvb-t/au-Melbourne
> scanning /usr/share/dvb/dvb-t/au-Melbourne
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 226500000 1 3 9 3 1 1 0
> initial transponder 177500000 1 3 9 3 1 1 0
> initial transponder 191625000 1 3 9 3 1 1 0
> initial transponder 219500000 1 3 9 3 1 1 0
> initial transponder 536625000 1 2 9 3 1 2 0
> >>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
> >>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


