Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1ECKe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 06:34:59 -0400
Message-ID: <4DBFDA43.4020005@redhat.com>
Date: Tue, 03 May 2011 07:34:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu, Ondrej Zary <linux@rainbow-software.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Joerg Heckenbach <joerg@heckenbach-aw.de>,
	Dwaine Garden <dwainegarden@rogers.com>,
	linux-media@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usbvision: remove RGB format conversion
References: <201104272241.38457.linux@rainbow-software.org> <17469.1303958880@localhost>
In-Reply-To: <17469.1303958880@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-04-2011 23:48, Valdis.Kletnieks@vt.edu escreveu:
> On Wed, 27 Apr 2011 22:41:32 +0200, Ondrej Zary said:
>> As V4L2 spec says that drivers shouldn't do any in-kernel image format
>> conversion, remove it.
> 
> Does this classify as breaking the API, and thus require a deprecation period?
> Is it likely to break any userspace that wasn't planning on doing its own RGB
> conversions?

Yes, it does. Before we do something like that, we need to write an entry to
Documentation/feature-removal-schedule.txt and wait for at least one kernel
release before actually removing such feature.

It is not that bad, as libv4l is present on almost all modern distros, but still
it is an API breakage and we need to play by the book.

Thanks!
Mauro.

