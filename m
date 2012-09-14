Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:53535 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab2INU1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 16:27:50 -0400
Received: from leon.localnet (ALille-155-1-154-177.w86-208.abo.wanadoo.fr [86.208.170.177])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id AF47320263
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 22:27:48 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Fri, 14 Sep 2012 23:27:47 +0300
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <573d42b4b775afd8beeadc7a903cc2190a6f430a.1347619766.git.hans.verkuil@cisco.com> <5053929D.4050902@iki.fi>
In-Reply-To: <5053929D.4050902@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209142327.47675@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 14 septembre 2012 23:25:01, Sakari Ailus a écrit :
> I had a quick discussion with Laurent, and what he suggested was to use
> the kernel version to figure out the type of the timestamp. The drivers
> that use the monotonic time right now wouldn't be affected by the new
> flag on older kernels. If we've decided we're going to switch to
> monotonic time anyway, why not just change all the drivers now and
> forget the capability flag.

That does not work In Real Life.

People do port old drivers forward to new kernels.
People do port new drivers back to old kernels

User space needs a flag is needed. Full point.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
