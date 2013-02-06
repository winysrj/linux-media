Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:54510 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab3BFOmN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 09:42:13 -0500
To: Neuer User <auslands-kv@gmx.de>
Subject: Re: Replacement for =?UTF-8?Q?vloopback=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 06 Feb 2013 15:31:43 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <linux-media@vger.kernel.org>
In-Reply-To: <ketngk$dit$1@ger.gmane.org>
References: <ketngk$dit$1@ger.gmane.org>
Message-ID: <a1d8611ac577065a5433d4ed74c87111@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 06 Feb 2013 14:57:43 +0100, Neuer User <auslands-kv@gmx.de> wrote:

> So, my question ist: Is vloopback the right way to go for this

> requirement? If yes, how to get it working?



No. Video loopback is just a way for an application to expose a virtual

camera, for another application to use. It is not a way to share a camera

within two applications.



Sharing a camera is fundamentally impossible due to the limitation of the

hardware, which cannot capture in two different formats and sets of buffers

simultaneously. Live with it.



-- 

Rémi Denis-Courmont

Sent from my collocated server
