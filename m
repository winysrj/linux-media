Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:45221 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbZDGVYj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Apr 2009 17:24:39 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange>
	<87iqlgkykd.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 07 Apr 2009 23:24:29 +0200
In-Reply-To: <87iqlgkykd.fsf@free.fr> (Robert Jarzmik's message of "Tue\, 07 Apr 2009 22\:18\:10 +0200")
Message-ID: <87skkkdunm.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> I'll test fully this weekend.
I just made a first try, just to prepare my weekend. Even with Ming Lei patch
reverted, and all statically built, I have no camera detected ...

Is there something I need to know before attempting the brute force method
(ie. DEBUG, printks etc ...) ?

Cheers.

--
Robert
