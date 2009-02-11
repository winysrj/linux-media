Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:58401 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbZBKBFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 20:05:13 -0500
Subject: Re: Any supported Dual DVB-S cards?
From: hermann pitton <hermann-pitton@arcor.de>
To: Steven Ellis <mail_lists@stevencherie.net>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-media@vger.kernel.org
In-Reply-To: <499154D6.1040108@stevencherie.net>
References: <498EAD1F.8040300@stevencherie.net>
	 <49904330.2070606@pocock.com.au>  <499154D6.1040108@stevencherie.net>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 02:06:00 +0100
Message-Id: <1234314360.4463.48.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve!

Am Dienstag, den 10.02.2009, 23:20 +1300 schrieb Steven Ellis:
> Daniel Pocock wrote:
> > Steven Ellis wrote:
> >> Noticed that Pinnacle now do a dual tuner PCI based DVB-S card
> >>
> >> http://www.pinnaclesys.com/PublicSite/uk/Products/Consumer+Products/PCTV+Tuners/PCTV+Digital+PVR+(DVB-S_DVB-T)/PCTV+Dual+Sat+Pro+PCI.htm
> >>
> >>
> >> And that development is underway. Has anyone found a dual tuner card
> >> that works?
> >>   
> > Is it possible to use multiple USB devices to do the same thing as a
> > dual tuner card?
> The problem is I want to house the tuners inside of a media PC case
> which is harder with USB devices.
> 
> Also I have spare PCIe slots if there was a dual tuner PCIe unit at a
> reasonable price.
> 
> Steve
> 

Same here :)

Just for completeness, we support a device on saa7134 with dual DVB-S
tuners and demods and also with dual DVB-T/analog hybrid tuners and
DVB-T demods and external video inputs. (4 streams at once are always
possible)

It is card=96 Medion8800 Quad(ro), better called Creatix CTX944
(www.creatix.de).

It has also two saa7131e, which causes that it needs at least a blue
multi busmaster capable PCI slot, often found on MSI mobos. Within a
green one it also offers a soft modem ...

Everything works, except the second DVB-S tuner needs the first one
active too at the same time, this is caused by the shared dual isl6405
LNB controller, which has only i2c access from the first PCI bridge.

Long story short, that second LNB supply should be initialized at 13
Volts, the buffers sent are correct, but stays always at 18 Volts.

This is the same for recent Philips/NXP/m$ drivers and ours for my
observations.

OTOH, also tuner RF loopthrough from the first DVB-S tuner to the second
is enabled, which allows also 13 Volts transponder reception on the
second. There is some small signal quality loss then, which is not the
case for routing the DVB-T RF through to the second tda9875ac1 for
DVB-T.

I know Aldi/Medion is/are selling in Australia since years and we had
feed back for the early cardbus devices from there, but don't know about
NZ.

If it should happen that you have such a blue PCI slot and are still
curious enough, I guess I can get one down to you from second hand
markets.

If you still have at least two normal PCI slots free and are thinking
about a linux media machine for distribution currently, two LifeView
Trio or better two Asus 3in1 might do it, but are still rather
expensive.

I can't tell if you can get some supported Creatix CTX948 triple out of
them for better conditions, but maybe worth at try.

Cheers,
Hermann


