Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55394 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZKZSSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 13:18:06 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com>
	<m34oolrnwd.fsf@intrepid.localdomain> <4B0E71B6.4080808@redhat.com>
Date: Thu, 26 Nov 2009 19:18:09 +0100
In-Reply-To: <4B0E71B6.4080808@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 10:16:54 -0200")
Message-ID: <m3my29up3y.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Technically, it is not hard to port this solution to the other
> drivers, but the issue is that we don't have all those IR's to know
> what is the complete scancode that each key produces. So, the hardest
> part is to find a way for doing it without causing regressions, and to
> find a group of people that will help testing the new way.

We don't want to "port it" to other drivers. We need to have a common
module which does all RCx decoding. The individual drivers should be as
simple as possible, something that I outlined in a previous mail.
-- 
Krzysztof Halasa
