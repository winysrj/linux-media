Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:53512 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZJXToR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 15:44:17 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Fix missing include for wake_up
References: <1256398701-7369-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0910242134240.14133@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 24 Oct 2009 21:44:13 +0200
In-Reply-To: <Pine.LNX.4.64.0910242134240.14133@axis700.grange> (Guennadi Liakhovetski's message of "Sat\, 24 Oct 2009 21\:35\:00 +0200 \(CEST\)")
Message-ID: <87d44cy3ua.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert
> Thanks, but I'm afraid you're a bit late:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10947/focus=10949
Ouch, missed this one on the mailing list.
You can drop that patch then, Jonathan's patch is exactly the same.

BTW, it was not included in -rc5 (which I'm based on) as you wished for.

Cheers.

--
Robert
