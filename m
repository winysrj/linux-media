Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:51076 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab0CCGFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 01:05:52 -0500
Subject: Re: saa7231 is anybody trying
From: hermann pitton <hermann-pitton@arcor.de>
To: Jens Chievitz <jenscz@adslhome.dk>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B7FA312.6090005@adslhome.dk>
References: <4B7FA312.6090005@adslhome.dk>
Content-Type: text/plain
Date: Wed, 03 Mar 2010 07:02:57 +0100
Message-Id: <1267596177.3388.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 20.02.2010, 09:53 +0100 schrieb Jens Chievitz:
> Hi developers
> Is anybody trying to get this device working under linux?
> I have found some code here:
> > http://www.jusst.de/hg/saa7231
> but it it is not finished.
> Regards
>   Jens chievitz

got some such fish on the hook, notoriously buying some latest
Medion/Aldi/Tevion/Creatix stuff. That sort was not exactly wanted, but
it has some big NXP on it and else the fuzzy picture was for nothing
good enough ;)

CTX1924_V2

isl6405ezr.
Most important chip on it ;)

saa7231ne

cx24120-13z

24118a12 clock 40.44

tda18271HDC2 clock 16.00

Looks like Manu has a lot already and also Sergey.

filename:       /lib/modules/2.6.30.1/kernel/drivers/media/dvb/frontends/cx24120.ko
license:        GPL
author:         Sergey Tyurin
description:    DVB Frontend module for Conexant CX24120/CX24118
hardware
srcversion:     C9FCDA7FA6E37AED28B5DD8
depends:        i2c-core
vermagic:       2.6.30.1 SMP preempt mod_unload
parm:           cx24120_debug:Activates frontend debugging (default:0)
(int)

But still seems to be a long road.

BTW, there are lots of complaints about overheating for that card within
short time on the original machine, what I don't see on my old AMD Quad
machine.

DVB-T looks ok on vista, did not test any analog stuff yet, but DVB-S is
very poor. Not even 50% of the usual services. S2 not tested, need to
move the dish.

Looks like we might import a DVB-S bug from initial m$ drivers again?

Cheers,
Hermann






