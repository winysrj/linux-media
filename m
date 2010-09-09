Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab0IIPMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 11:12:15 -0400
Message-ID: <4C88DE80.1050207@redhat.com>
Date: Thu, 09 Sep 2010 15:17:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <e3kwq01m3v9rvkx9fdhst6mo.1284042856851@email.android.com>
In-Reply-To: <e3kwq01m3v9rvkx9fdhst6mo.1284042856851@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/09/2010 04:41 PM, Andy Walls wrote:
> Hans de Goede,
>
> The uvc API that creates v4l2 ctrls on behalf of userspace could intercept those calls and create an LED interface instead of, or in addition to, the v4l2 ctrl.

That would mean special casing certain extension controls which I don't think is something which we want to do.

Regards,

Hans
