Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:33441 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbaLGIPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 03:15:48 -0500
Message-ID: <1417940144.2720.1.camel@xs4all.nl>
Subject: Re: DVBSky T980C: Si2168 fw load failed
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Sun, 07 Dec 2014 09:15:44 +0100
In-Reply-To: <54834B0D.6070502@iki.fi>
References: <2eea6b3b11e395b7fb238f350a804dc9.squirrel@webmail.xs4all.nl>
	 <54834B0D.6070502@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2014-12-06 at 20:29 +0200, Antti Palosaari wrote:
> On 12/06/2014 06:48 PM, Jurgen Kramer wrote:
> > On my new DVBSky T980C the tuner firmware failes to load:
> > [   51.326525] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
> > [   51.356233] si2168 2-0064: downloading firmware from file
> > 'dvb-demod-si2168-a30-01.fw'
> > [   51.408166] si2168 2-0064: firmware download failed=-110
> > [   51.415457] si2157 4-0060: found a 'Silicon Labs Si2146/2147/2148/2157/2158'
> > in cold state
> > [   51.521714] si2157 4-0060: downloading firmware from file
> > 'dvb-tuner-si2158-a20-01.fw'
> > [   52.330605] si2168 2-0064: found a 'Silicon Labs Si2168' in cold state
> > [   52.330784] si2168 2-0064: downloading firmware from file
> > 'dvb-demod-si2168-a30-01.fw'
> > [   52.382145] si2168 2-0064: firmware download failed=-110
> >
> > 110 seems to mean connection timeout. Any pointers how to debug this further?
> >
> > This is with the latest media_build from linuxtv.org on 3.17.4.
> 
> Looks like si2168 firmware failed to download, but si2157 succeeded. 
> Could you add some more time for driver timeout? Current timeout is 
> selected by trial and error, lets say it takes always max 43ms for my 
> device I coded it 50ms.
> 
> 
> drivers/media/dvb-frontends/si2168.c
> /* wait cmd execution terminate */
> #define TIMEOUT 50
> 
> change it to
> #define TIMEOUT 500

Thanks, with the larger timeout the fw load works:

[   56.960982] si2168 4-0064: found a 'Silicon Labs Si2168' in cold
state
[   56.972650] si2168 4-0064: downloading firmware from file
'dvb-demod-si2168-a30-01.fw'
[   60.103509] si2168 4-0064: found a 'Silicon Labs Si2168' in warm
state
[   60.110739] si2157 6-0060: found a 'Silicon Labs
Si2146/2147/2148/2157/2158' in cold state
[   60.123720] si2157 6-0060: downloading firmware from file
'dvb-tuner-si2158-a20-01.fw'

BTW Is there a way to switch between T/T2 and DVB-C mode? 

Regards,
Jurgen

