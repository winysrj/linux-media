Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbZKZRvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 12:51:08 -0500
Message-ID: <4B0EC003.8090208@redhat.com>
Date: Thu, 26 Nov 2009 15:50:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<20091123173726.GE17813@core.coreip.homeip.net>	<m3r5rpq818.fsf@intrepid.localdomain>	<20091126052155.GD23244@core.coreip.homeip.net> <m31vjlw54x.fsf@intrepid.localdomain>
In-Reply-To: <m31vjlw54x.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
>> In what way the key interface is unsufficient for delivering button
>> events?
> 
> At present: 128 different keys only (RC5: one group). One remote per
> device only.
> 
> The protocol itself doesn't have the above limitations, but has others,
> with are acceptable for key input.

This is not a limit at the input subsystem. It were a design decision for
some drivers at the V4L subsystem that we need to change.

Cheers,
Mauro.
