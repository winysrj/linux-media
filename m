Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54416 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1LaPbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 10:31:51 -0500
Date: Sat, 31 Dec 2011 16:31:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
Message-ID: <20111231163145.251d526e@stein>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 30 Mauro Carvalho Chehab wrote:
> Basically, changes all DVB frontend drivers to work directly with
> the DVBv5 structure.
[...]
> Test reports are welcome.
[...]
>   [media] firedtv: convert set_fontend to use DVBv5 parameters
[...]
>  drivers/media/dvb/firewire/firedtv-avc.c     |   95 ++++++++--------
>  drivers/media/dvb/firewire/firedtv-fe.c      |   31 ++----
>  drivers/media/dvb/firewire/firedtv.h         |    4 +-

I briefly tested git://linuxtv.org/media_tree.gitstaging/for_v3.3
7c61d80a9bcf on top of v3.2-rc7 on a FireDTV-T/CI with kaffeine and on a
FireDTV-C/CI with kaffeine and smplayer and didn't notice any runtime problem.

Building fs/compat_ioctl.c failed for me though:
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’ 
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
etc. pp.
-- 
Stefan Richter
-=====-==-== ==-- =====
http://arcgraph.de/sr/
