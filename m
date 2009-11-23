Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:43564 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbZKWUv2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:51:28 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<20091123173726.GE17813@core.coreip.homeip.net>
Date: Mon, 23 Nov 2009 21:51:31 +0100
In-Reply-To: <20091123173726.GE17813@core.coreip.homeip.net> (Dmitry
	Torokhov's message of "Mon, 23 Nov 2009 09:37:27 -0800")
Message-ID: <m3r5rpq818.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> Curreently the "scan" codes in the input layer serve just to help users
> to map whatever the device emits into a proper input event code so that
> the rest of userspace would not have to care and would work with all
> types of devices (USB, PS/2, etc).
>
> I would not want to get to the point where the raw codes are used as a
> primary data source.

The "key" interface is not flexible enough at present.

> Again, I would prefer to keep EV_KEY/KEY_* as the primary event type for
> keys and buttons on all devices.

Primary, I think so.
-- 
Krzysztof Halasa
