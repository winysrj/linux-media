Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55623 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab2ESPEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 11:04:45 -0400
Message-ID: <4FB7B68A.90402@iki.fi>
Date: Sat, 19 May 2012 18:04:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec H7(az6007), CI support and Kaffeine
References: <4F65F5E2.2030302@gmail.com> <4F661336.3060003@iki.fi> <4FB7B209.5070300@gmail.com>
In-Reply-To: <4FB7B209.5070300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19.05.2012 17:45, Roger Mårtensson wrote:
> Antti Palosaari skrev 2012-03-18 17:54:
>  > On 18.03.2012 16:49, Roger Mårtensson wrote:
>  >>
>  >> My problem is as follows:
>  >> When viewing encrypted channels I can watch without problem.
>  >> When I change to another encrypted channel inside kaffeine nothing
>  >> happens. The EPG tells me which program it is but no video is
> displayed.
>  >>
>  > I suspect it is driver problem. I did some time ago Anysee CI support
>  > and tested it using VLC, Kaffeine and IIRC gnutv too. It is even
>  > possible to remove whole CAM and plug it back - still should continue
>  > working. For example view FTA channel, unplug CAM, plug CAM back; and
>  > only small glitches are seen during CAM replug when device routes TS via
>  > CAM / bypass CAM.
>
> I've noticed that there have been some patches for az6007(terratec H7,
> etc) but still the same problem. When tuning to an encrypted channel no
> video is showing. Some EPG-data data is shown that tells me what program
> should be playing.

For me this is indicator saying TS is not routed via CAM as should.

As you has been successfully viewing encrypted channel (TS is routed via 
CAM) and then switching to other encrypted channel and no picture 
anymore but still some other TS data like EPG (TS is not routed via CAM 
anymore). Switching channel changes TS route to bypass CAM.

> Got a guess on #linuxtv that it could be that the routing to the CAM
> isn't set up after a tune. (my interpretation of the comment on IRC)

heh, it was me.

> According to the developer of the CI-integration on az6007 it works for
> him. The difference is that he used DVB-T and I use DVB-C. Is there a
> difference here?

As it is DRX-K demod there should not be difference. It is single demod 
having single TS interface.

> Linux-media, you're my only hope. :)

Test VLC and gnutv too. Any other apps?
Some apps calls slot_reset()/slot_shutdown()/slot_ts_enable() in 
different order which could raise that bug.

Antti
-- 
http://palosaari.fi/
