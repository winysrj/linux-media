Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:57900 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353Ab3BYB6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 20:58:12 -0500
Message-ID: <512AC532.9000401@pyther.net>
Date: Sun, 24 Feb 2013 20:58:10 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Frank_Sc?= =?ISO-8859-1?Q?h=E4fer?=
	<fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.co m> <50CCAAA4.4030808@iki.fi> <50CE70E0.2070809@pyther.net> <50CE74C7.90809@iki.fi> <50CE7763.3030900@pyther.net> <50CEE6FA.4030901@iki.fi> <50CEFD29.8060009@iki.fi> <50CEFF43.1030704@pyther.net> <50CF44CD.5060707@redhat.com> <50CFDE2B.6040100@pyther.net> <50E49FA6.8010402@iki.fi> <50E4F2BA.7060407@pyther.net> <50FC01DE.3080203@pyther.net> <50FC2D8D.7080205@iki.fi> <51201871.9050501@pyther.net> <512A92C5.9020108@iki.fi>
In-Reply-To: <512A92C5.9020108@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2013 05:23 PM, Antti Palosaari wrote:
>
> I rebased it to the latest LinuxTV 3.9. There is quite a lot of changes
> done for em28xx driver so it could work. Please test.
>
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/HU345-Q
>
> regards
> Antti
>

I checked out the branch and these are my results from some brief testing.

Channel scan: results in INPUT/output error

Tuning and watching a channel. With mplayer when tuning to a specific 
channel it seemed to play without issue. Occasionally when starting 
mplayer, the audio and video was way out of sync. It was if the video 
was only displaying a few frame per second.

Remote: the number keys worked as the inputed their respective value 
into my terminal. I will test the others tomorrow.

http://pyther.net/a/digivox_atsc/feb24/scan.txt
http://pyther.net/a/digivox_atsc/feb24/dmesg.txt

Thanks,
Matthew


