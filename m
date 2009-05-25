Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:53672 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZEYV3Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 17:29:24 -0400
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 4E4CCD48127
	for <linux-media@vger.kernel.org>; Mon, 25 May 2009 23:29:19 +0200 (CEST)
Received: from localhost.localdomain (bob75-6-82-238-74-76.fbx.proxad.net [82.238.74.76])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 6F64CD48002
	for <linux-media@vger.kernel.org>; Mon, 25 May 2009 23:29:17 +0200 (CEST)
Message-ID: <4A1B0D0C.7040707@free.fr>
Date: Mon, 25 May 2009 23:26:36 +0200
From: =?ISO-8859-1?Q?Nicolas_L=E9veill=E9?= <knos@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Strange PCI IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

While discovering the bttv code (I'd like to add support to a yet 
unsupported bttv derivative, the PMS PDI Deluxe) I found a strange commit:

changeset:   10944:6b90215088f0
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Wed Mar 11 08:18:53 2009 -0300
summary:     Conceptronic CTVFMI2 PCI Id

within: linux/drivers/media/video/bt8xx/bttv-cards.c

         { 0x109e036e, BTTV_BOARD_CONCEPTRONIC_CTVFMI2,  "Conceptronic 
CTVFMi v2"},

Does the above work at all for autodetecting this card?

The PCI ID looks suspiciously like a generic PCI ID, especially 
considering that:

   109e : vendor id for "Brooktree Corporation"
   036e : device id for "Bt878 Video Capture"

So I immediately was surprised to see the above PCI ID constant.

It does not appear it would cause any problem since the vendor and 
device ids are reversed anyway, however is this really correct? 
Shouldn't there be a comment about it?

Cheers,
Nicolas Léveillé


