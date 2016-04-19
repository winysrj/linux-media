Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:33683 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbcDSKKJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 06:10:09 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: Non-coherent (streaming) contig-dma?
References: <m3r3elh6wm.fsf@t19.piap.pl>
	<20160406120853.GM32125@valkosipuli.retiisi.org.uk>
Date: Tue, 19 Apr 2016 12:10:06 +0200
In-Reply-To: <20160406120853.GM32125@valkosipuli.retiisi.org.uk> (Sakari
	Ailus's message of "Wed, 6 Apr 2016 15:08:53 +0300")
Message-ID: <m3bn55gb9d.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus <sakari.ailus@iki.fi> writes:

> I sent the set here under the subject "[RFC RESEND 00/11] vb2: Handle user
> cache hints, allow drivers to choose cache coherency" last September.

Thanks, I will look at this.
Unfortunately, I need CPU access to the buffers, it's just that coherent
RAM is way too slow on ARM.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
