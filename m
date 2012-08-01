Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:44634 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2HAUlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 16:41:19 -0400
Received: from basile.localnet (ip6-localhost [IPv6:::1])
	by oyp.chewa.net (Postfix) with ESMTP id 70A59200ED
	for <linux-media@vger.kernel.org>; Wed,  1 Aug 2012 22:41:17 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.6] VIDIOC_ENUM_FREQ_BANDS fix
Date: Wed, 1 Aug 2012 23:41:16 +0300
References: <201208012152.46310.hverkuil@xs4all.nl>
In-Reply-To: <201208012152.46310.hverkuil@xs4all.nl>
MIME-Version: 1.0
Message-Id: <201208012341.16986.remi@remlab.net>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 1 août 2012 22:52:46 Hans Verkuil, vous avez écrit :
> When VIDIOC_ENUM_FREQ_BANDS is called for a driver that doesn't supply an
> enum_freq_bands op, then it will fall back to reporting a single freq band
> based on information from g_tuner or g_modulator.

By the way...

Isn't V4L2_TUNER_CAP_FREQ_BANDS expected to tell whether the driver can 
enumerate bands? Why is there a need for fallback implementation?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
