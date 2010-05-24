Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39202 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0EXHJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 03:09:34 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2W00653X7VOE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 May 2010 08:09:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2W006VFX7VAV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 May 2010 08:09:31 +0100 (BST)
Date: Mon, 24 May 2010 09:08:51 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Setting up a GIT repository on linuxtv.org
In-reply-to: <1274635044.2275.11.camel@localhost>
To: 'Andy Walls' <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Message-id: <001001cafb0f$f6d95580$e48c0080$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1274635044.2275.11.camel@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Andy Walls wrote:
>Hi,
>
>I'm a GIT idiot, so I need a little help on getting a properly setup
>repo at linuxtv.org.  Can someone tell me if this is the right
>procedure:
>
>$ ssh -t awalls@linuxtv.org git-menu
>        (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)
>$ git clone \
>	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
>        v4l-dvb

If I understand correctly, you won't be working on that repository directly
(i.e. no working directory on the linuxtv server, only push/fetch(pull), and
the actual work on your local machine), you should make it a bare repository
by passing a --bare option to clone. 

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





