Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:52729 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZK0R4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 12:56:46 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: how to get a registered adapter name
Date: Fri, 27 Nov 2009 18:56:48 +0100
Cc: Brice Dubost <dubost@crans.org>, Benedict bdc091 <bdc091@gmail.com>
References: <746d58780909140842o8952bf1g8f7851eee9ec0093@mail.gmail.com> <4B0FDD66.9090903@crans.org>
In-Reply-To: <4B0FDD66.9090903@crans.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911271856.48877.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 27. November 2009, Brice Dubost wrote:
> Benedict bdc091 wrote:
> > Hi list,
> >
> > I'd like to enumerate connected DVB devices from my softawre, based on
> > DVB API V3.

> > So, I tried to figure out a way to get "ASUS My Cinema U3000 Mini DVBT
> > Tuner" string from adapter, instead of "DiBcom 7000PC" from adapter's
> > frontend...
> > Unsuccefully so far.
> >
> > Any suggestions?
>
> Hello,
>
> I have the same issue, I look a bit to the code of the DVB drivers, it
> seems not obvious to recover this name as it is written now
>
> It is stored in the "struct dvb_adapter". and printed by
> dvb_register_adapter, but doesn't seems to be available by other functions
>

I think putting it somewhere into sysfs is a good idea (along with frontend 
name).
Best is to move all dvb sysfs-devices into a per adapter subdirectory.

Matthias
