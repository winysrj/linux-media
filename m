Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:47005 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab0DEWpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 18:45:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [RFC] Serialization flag example
Date: Tue, 6 Apr 2010 00:46:11 +0200
Cc: hermann-pitton@arcor.de, awalls@md.metrocast.net,
	mchehab@redhat.com, dheitmueller@kernellabs.com,
	abraham.manu@gmail.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
References: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net> <x2r30353c3d1004032014qc2b31bd5uab4da9a0d364e8ff@mail.gmail.com>
In-Reply-To: <x2r30353c3d1004032014qc2b31bd5uab4da9a0d364e8ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004060046.12997.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 04 April 2010 05:14:17 David Ellingsworth wrote:
> After looking at the proposed solution, I personally find the
> suggestion for a serialization flag to be quite ridiculous. As others
> have mentioned, the mere presence of the flag means that driver
> writers will gloss over any concurrency issues that might exist in
> their driver on the mere assumption that specifying the serialization
> flag will handle it all for them.

I happen to agree with this. Proper locking is difficult, but that's not a 
reason to introduce such a workaround. I'd much rather see proper 
documentation for driver developers on how to implement locking properly.

-- 
Regards,

Laurent Pinchart
