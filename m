Return-path: <linux-media-owner@vger.kernel.org>
Received: from postfix2-g20.free.fr ([212.27.60.43]:44612 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZALABL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 19:01:11 -0500
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by postfix2-g20.free.fr (Postfix) with ESMTP id 5A2F22EE091B
	for <linux-media@vger.kernel.org>; Sun, 11 Jan 2009 23:00:57 +0100 (CET)
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] soc-camera: fix S_CROP breakage on PXA and SuperH
References: <Pine.LNX.4.64.0901110148360.22041@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 12 Jan 2009 00:59:50 +0100
In-Reply-To: <Pine.LNX.4.64.0901110148360.22041@axis700.grange> (Guennadi Liakhovetski's message of "Sun\, 11 Jan 2009 01\:53\:05 +0100 \(CET\)")
Message-ID: <87d4etpf61.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Recent format-negotiation patches caused S_CROP breakage in pxa_camera.c 
> and sh_mobile_ceu_camera.c drivers, fix it.

> Tested on PXA, Magnus, please test on sh, Robert, any objections?
No objection, that seems very sensible, and it was a regression introduced by
the format negotiation, no doubt about it, sorry :(

It's fine by me, and tested (also I don't work with S_CROP so I can only testify
non-regression of my tests).

Cheers.

--
Robert
