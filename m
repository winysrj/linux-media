Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36292 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbcAXKZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 05:25:03 -0500
Received: by mail-wm0-f47.google.com with SMTP id l65so32202186wmf.1
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2016 02:25:01 -0800 (PST)
Subject: Re: dvbv5-zap: getting pmt-pid
To: Russel Winder <russel@winder.org.uk>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1453612624.2497.15.camel@winder.org.uk>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <56A4A665.6030504@gmail.com>
Date: Sun, 24 Jan 2016 10:24:37 +0000
MIME-Version: 1.0
In-Reply-To: <1453612624.2497.15.camel@winder.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russel Winder wrote:
> In the middle of last year, there was an email exchange about dvbv5-zap
> and the -p option not working. As far as I can tell this is still a
> problem for Debian Sid and Fedora Rawhide with PCTV 292e, PCTV 282e,
> and Terratec XXS. Is there a fix pending?
>
> Debian Sid: kernel 4.3, libdvbv5 and dvb-tools 1.8.0
> Fedora Rawhide: kernel 4.4 and 4.5, libdvbv5 1.8.1
>
> (Fedora appears not to package dvb-tools :-(, but compiling the source
> of dvbv5-zap from a clone of the repository behaves in the same way as
> the version distributed on Debian Sid.)
>
> For example on Debian Sid with PCTV 282e:
>
> |> dvbv5-zap -p -r -c ~/.local/share/me-tv/virtual_channels.conf "BBC NEWS"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/users/russel/.local/share/me-tv/virtual_channels.conf'
> service has pid type 05:  7270
> tuning to 490000000 Hz
> read_sections: read error: Resource temporarily unavailable
> couldn't find pmt-pid for sid 1100

FWIW recording with dvbv5-zap is sub-optimal anyway as you won't get 
subs/ad.
