Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:18837 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdC0QxB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 12:53:01 -0400
From: =?iso-8859-1?Q?Br=FCns=2C_Stefan?= <Stefan.Bruens@rwth-aachen.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Antti Palosaari <crope@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>
Subject: Re: [PATCH v3 0/3] Add support for MyGica T230C DVB-T2 stick
Date: Mon, 27 Mar 2017 16:52:58 +0000
Message-ID: <1853859.nLLveUtAEZ@sbruens-linux>
References: <20170217005533.22424-1-stefan.bruens@rwth-aachen.de>
 <2b3bb92a-4024-7a82-c86d-2e5893786daf@iki.fi>
 <20170306083408.5abb44b5@vento.lan>
In-Reply-To: <20170306083408.5abb44b5@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <209651FD3663EC4F99793922C1780EAD@rwth-ad.de>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Montag, 6. März 2017 12:34:13 CEST Mauro Carvalho Chehab wrote:
> Em Sat, 4 Mar 2017 03:23:42 +0200
> 
> Antti Palosaari <crope@iki.fi> escreveu:
> > On 03/03/2017 08:35 PM, Brüns, Stefan wrote:
> > > On Fr, 2017-02-17 at 01:55 +0100, Stefan Brüns wrote:
> > >> The required command sequence for the new tuner (Si2141) was traced
> > >> from the
> > >> current Windows driver and verified with a small python
> > >> script/libusb.
> > >> The changes to the Si2168 and dvbsky driver are mostly additions of
> > >> the
> > >> required IDs and some glue code.
> > >> 
> > >> Stefan Brüns (3):
> > >>   [media] si2157: Add support for Si2141-A10
> > >>   [media] si2168: add support for Si2168-D60
> > >>   [media] dvbsky: MyGica T230C support
> > >>  
> > >>  drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
> > >>  drivers/media/dvb-frontends/si2168.c      |  4 ++
> > >>  drivers/media/dvb-frontends/si2168_priv.h |  2 +
> > >>  drivers/media/tuners/si2157.c             | 23 +++++++-
> > >>  drivers/media/tuners/si2157_priv.h        |  2 +
> > >>  drivers/media/usb/dvb-usb-v2/dvbsky.c     | 88
> > >> 
> > >> +++++++++++++++++++++++++++++++
> > >> 
> > >>  6 files changed, 118 insertions(+), 2 deletions(-)
> > > 
> > > Instead of this series, a different patchset was accepted, although
> > > Antti raised concerns about at least 2 of the 3 patches accpeted, more
> > > specifically the si2157 patch contains some bogus initialization code,
> 
> Sorry, I likely missed those comments when reviewed the patch series.
> 
> As the applied series won't cause regressions, as all init code seem
> specific to the new tuner, I won't be reverting the patchsets, but
> wait for Antti to be able to do a deeper look on it.
> 
> Please submit a patch removing the bogus init code, for Antti's
> review.
> 
> > > and the T230C support were better added to the dvbsky driver instead of
> > > 
> > >  cxusb.
> 
> IMHO, the better here would be to merge both drivers into one, as they
> seem to be doing very similar stuff. So, I can't find a good reason
> why we should keep both drivers upstream. As dvbsky uses dvb-usb-v2,
> the best would be to move the board-specific code from cxusb into
> the dvbsky driver, and drop the cxusb driver.
> 
> Feel free to submit such patch too.

"Merging" the drivers comes down to reverting the patch to cxusb, and instead 
applying Patch 3 from my series. I won't port support for any other stick, as 
I lack the hardware for testing.
 
> > Patch set looks good. I ordered that device and it arrived yesterday. I
> > will handle that during 2 weeks - it is now skiing holiday and I am at
> > France alps whole next week. So just wait :)

@Annti - hope you enjoyed skiing, did you have time for looking into the 
issue?

Kind regards,

Stefan
