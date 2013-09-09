Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:43702 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab3IILtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 07:49:55 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net
References: <m3d2oifezy.fsf@t19.piap.pl> <522DAFC6.9020608@xs4all.nl>
Date: Mon, 09 Sep 2013 13:49:53 +0200
In-Reply-To: <522DAFC6.9020608@xs4all.nl> (Hans Verkuil's message of "Mon, 09
	Sep 2013 13:23:50 +0200")
MIME-Version: 1.0
Message-ID: <m3ob82fc4e.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: SOLO6x10 MPEG4/H.264 encoder driver
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> I took the latest bluecherry code as the basis for the changes, merging what
> I could from the kernel code. Unfortunately this was very hard to do backport,
> so I decided to take bluecherry's code.

I see, thanks for speedy explanation.

If I may suggest something (especially to Ismael), perhaps we do the
further development here, I mean based on git.kernel.org sources, and
not on (unsynced) bluecherry's.

I will fix this stuff again.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
