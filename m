Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933767Ab0FCDlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 23:41:05 -0400
Message-ID: <4C072451.7090001@infradead.org>
Date: Thu, 03 Jun 2010 00:41:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 16077] New: Drop is video frame rate in kernel
 .34
References: <bug-16077-10286@https.bugzilla.kernel.org/> <20100602140916.759d7159.akpm@linux-foundation.org>
In-Reply-To: <20100602140916.759d7159.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-06-2010 18:09, Andrew Morton escreveu:
> On Sun, 30 May 2010 14:29:55 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=16077
> 
> 2.6.33 -> 2.6.34 performance regression in dvb webcam frame rates.

I don't think this is a regression. Probably, the new code is allowing a higher
resolution. As the maximum bandwidth from the sensor to the USB bridge doesn't
change, and a change from QVGA to VGA implies on 4x more pixels per frame, as
consequence, the number of frames per second will likely reduce by a factor of 4x.

I've asked the reporter to confirm what resolutions he is setting on 2.6.33
and on 2.6.34, just to double check if my thesis is correct.

Cheers,
Mauro.
