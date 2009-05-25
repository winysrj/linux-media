Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:50563 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbZEYWdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 18:33:16 -0400
Subject: Re: Strange PCI IDs
From: hermann pitton <hermann-pitton@arcor.de>
To: Nicolas =?ISO-8859-1?Q?L=E9veill=E9?= <knos@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4A1B0D0C.7040707@free.fr>
References: <4A1B0D0C.7040707@free.fr>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 May 2009 00:21:47 +0200
Message-Id: <1243290107.3744.106.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 25.05.2009, 23:26 +0200 schrieb Nicolas Léveillé:
> Hello,
> 
> While discovering the bttv code (I'd like to add support to a yet 
> unsupported bttv derivative, the PMS PDI Deluxe) I found a strange commit:
> 
> changeset:   10944:6b90215088f0
> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
> date:        Wed Mar 11 08:18:53 2009 -0300
> summary:     Conceptronic CTVFMI2 PCI Id
> 
> within: linux/drivers/media/video/bt8xx/bttv-cards.c
> 
>          { 0x109e036e, BTTV_BOARD_CONCEPTRONIC_CTVFMI2,  "Conceptronic 
> CTVFMi v2"},
> 
> Does the above work at all for autodetecting this card?
> 
> The PCI ID looks suspiciously like a generic PCI ID, especially 
> considering that:
> 
>    109e : vendor id for "Brooktree Corporation"
>    036e : device id for "Bt878 Video Capture"
> 
> So I immediately was surprised to see the above PCI ID constant.
> 
> It does not appear it would cause any problem since the vendor and 
> device ids are reversed anyway, however is this really correct? 
> Shouldn't there be a comment about it?
> 
> Cheers,
> Nicolas Léveillé
> 

on the saa7134 driver we treat these sort of subsystem IDs, lots of
them, as invalid. One patch once made use of them and that part was
removed.

Cheers,
Hermann


