Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:43849 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZK0ATl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 19:19:41 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
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
	<4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>
	<4B0E765C.2080806@redhat.com> <m3iqcxuotd.fsf@intrepid.localdomain>
	<4B0ED238.6060306@redhat.com> <m3pr75rpqa.fsf@intrepid.localdomain>
	<4B0EED7D.90204@redhat.com> <m3ljhtrn83.fsf@intrepid.localdomain>
	<4B0EFC30.80208@redhat.com>
Date: Fri, 27 Nov 2009 01:19:44 +0100
In-Reply-To: <4B0EFC30.80208@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 26 Nov 2009 20:07:44 -0200")
Message-ID: <m38wdsstsv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Why do you want to replace everything into a single shot?

Why not? It seems simpler to me. We need to change this anyway.

If we change the whole table in a single ioctl, we can easily enumerate
protocols requested and enable then selectively.
But I think it's a minor implementation decision and we don't need to
look at it at this time.
-- 
Krzysztof Halasa
