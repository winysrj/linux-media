Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:36072 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbZLKPCz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 10:02:55 -0500
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 3BC44E0809B
	for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 16:02:57 +0100 (CET)
Received: from UNKNOWN (imp2-g19.priv.proxad.net [172.20.243.132])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 66B92E08162
	for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 16:02:55 +0100 (CET)
Message-ID: <1260543775.4b225f1f4cec9@imp.free.fr>
Date: Fri, 11 Dec 2009 16:02:55 +0100
From: dvblinux@free.fr
To: linux-media@vger.kernel.org
Subject: New ASUS P3-100 DVB-T/DVB-S device (1043:48cd)
References: <200912111456.45947.amlopezalonso@gmail.com>
In-Reply-To: <200912111456.45947.amlopezalonso@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, I'm new on this list.

I modified on my own the SAA driver to manage an ASUS PS3-100 combo card not
supported yet in current version.

It features two DVB-S and DVB-T receivers packed on the same PCI card.

The DVB-T part is identical to ASUS P7131 Hybrid and therefore is managed thru
the existing driver after a light patch in the driver source (and card.c):
copying relevant stuff from (1043:4876) to (1043:48cd).

I'm not a developper, how to share my successfull experiments ?

Regards.

