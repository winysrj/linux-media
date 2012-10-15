Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:41199 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab2JOUKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:07 -0400
Received: from leon.localnet (cs27062151.pp.htv.fi [89.27.62.151])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id 5A1F02009B
	for <linux-media@vger.kernel.org>; Mon, 15 Oct 2012 22:10:04 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] Timestamps and V4L2
Date: Mon, 15 Oct 2012 23:10:03 +0300
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <507C5BC4.7060700@cybermato.com> <20121015195906.GG21261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121015195906.GG21261@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210152310.03123@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 15 octobre 2012 22:59:06, Sakari Ailus a écrit :
> For the latter the realtime clock fits poorly to begin with: it jumps
> around e.g. when the daylight saving time changes.

Wrong. The real time clock is always UTC. It is not subject to time zone 
offsets. It only jumps when the clock is manually adjusted.

(That is not to deny that clock warping is a problem. All serious multimedia 
frameworks and network protocol stacks use the monotonic clock nowadays.)

-- 
Rémi Denis-Courmont
http://www.remlab.net/
