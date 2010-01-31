Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:35574 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0AaMpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 07:45:25 -0500
Subject: Re: CAM appears to introduce packet loss
From: Abylai Ospan <aospan@netup.ru>
To: Marc Schmitt <marc.schmitt@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 15:43:47 +0300
Message-ID: <1264941827.28401.3.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Try to check raw speed coming from demod:

echo 1 > /sys/module/dvb_core/parameters/dvb_demux_speedcheck

and then:

tail -f /var/log/messages  |  grep -i speed

or 

dmesg  | grep -i speed

what values do you see ?
this TS going through CAM. CAM has a bitrate limitation which they can
pass (this depends on CAM model).

On Sun, 2010-01-31 at 13:12 +0100, Marc Schmitt wrote:
> Hi all,
> 
> For quite some time now, I'm fighting with my DVB-C setup and I think
> I've eliminated any hardware issues that could be the origin of the
> issue I'm seeing. Here is my setup:
> 
> Hardware:
> * KNC1 TV-Station DVB-C with KNC1 CineView CI (I also tried the
> SATELCO EasyWatch PCI (DVB-C) with SATELCO EasyWatch CI which is
> exactly the same hardware, just different brand)
> * Conax 4.00e CAM (tested in a DVB-C capable TV, works fine)
> * Smartcard from the DVB provider (http://www.sasag.ch, tested and
> properly accessible through `gnutv -cammenu`)
> * Dell PE700, P4 2.80GHz, 4GB RAM
> 
> Software:
> * Mythbuntu 9.10 (karmic)
> * kernel 2.6.31-17-generic #54-Ubuntu SMP Thu Dec 10 16:20:31 UTC 2009
> i686 GNU/Linux
> 
> My DVB provider uses the free-to-view system for all channels except
> the local TV channel which is transmitted unencrypted. When the CAM is
> not inserted in the CI, I'm getting a perfect video stream ([PS/PES:
> ITU-T Rec. H.262 | ISO/IEC 13818-2 or ISO/IEC 11172-2 video stream])
> for that unencrypted channel. dvbsnoop tells me that the stream is
> coming in at a fairly constant bandwidth of 4852 kbit/s. The moment I
> insert the CAM into the CI, the bandwidth drops to an average of 4070
> kbit/s. I did analyze both streams with Peter Daniel's MPEG-2
> Transport Stream packet analyser. As expected, the former stream has
> no continuity issues whereas the latter does. I see the continuity
> counter jump from 12 to 15 for example. The resulting video stream is
> visually distorted, I've uploaded an example at
> https://sites.google.com/site/msslinux/linuxmce/SFInfo.mpeg?attredirects=0&d=1
> to give you an idea. I get exactly the same result for any
> free-to-view channel which makes me suspect that the CAM/Smartcard
> does properly decrypt the stream. However, something appears not to be
> able to keep up. My DVB provider used QAM_256 which makes the
> bandwidth susceptible to the signal to noise ratio. The S/N ratio is
> at f5f5 without the CAM inserted and drops to f4f4 with the CAM
> inserted. I don't think that's the issue. I saw a few postings on the
> net about performance issues of budget cards with QAM_256 when using
> CI/CAM. Is that really the problem? How can I find out, i.e. further
> narrow down the problem?
> 
> Any pointers will be appreciated.
> 
> Thanks,
>     Marc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


