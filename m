Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbZK1Cjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 21:39:45 -0500
Date: Sat, 28 Nov 2009 00:39:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091128003918.628d4b84@pedra>
In-Reply-To: <4B0ED19B.9030409@redhat.com>
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com>
	<4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com>
	<m36391tjj3.fsf@intrepid.localdomain>
	<4B0AB60B.2030006@s5r6.in-berlin.de>
	<4B0AC8C9.6080504@redhat.com>
	<m34oolrnwd.fsf@intrepid.localdomain>
	<4B0E71B6.4080808@redhat.com>
	<m3my29up3y.fsf@intrepid.localdomain>
	<4B0ED19B.9030409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 26 Nov 2009 17:06:03 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Krzysztof Halasa wrote:
> > Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> > 
> >> Technically, it is not hard to port this solution to the other
> >> drivers, but the issue is that we don't have all those IR's to know
> >> what is the complete scancode that each key produces. So, the hardest
> >> part is to find a way for doing it without causing regressions, and to
> >> find a group of people that will help testing the new way.
> > 
> > We don't want to "port it" to other drivers. We need to have a common
> > module which does all RCx decoding. The individual drivers should be as
> > simple as possible, something that I outlined in a previous mail.
> 
> With the current 7bits mask applied to almost all devices, it is probably not very
> useful for those who want to use generic IRs. We really need to port the solution
> we've done on dvb-usb to the other drivers, allowing them to have the entire
> scancode at the tables while keep supporting table replacement. 
> 
> The issue is that we currently have only 7bits of the scan codes produced by the IR's.
> So, we need to re-generate the keycode tables for each IR after the changes got applied.

Ok, I got some time to add support for tables with the full scan codes at the V4L drivers.
In order to not break all tables, I've confined the changes to just one device (HVR-950,
at the em28xx driver). The patches were already committed at the -hg development tree.

In order to support tables with the full scan codes, all that is needed is to add the 
RC5 address + RC5 data when calling ir_input_keydown. So, the change is as simple as:

-			ir_input_keydown(ir->input, &ir->ir,
-					 poll_result.rc_data[0]);
+			ir_input_keydown(ir->input, &ir->ir,
+					 poll_result.rc_address << 8 |
+					 poll_result.rc_data[0]);
+		else

An example of such patch can be seen at:
	http://linuxtv.org/hg/v4l-dvb/rev/9c38704cfd56

There are still some work to do, since, currently, the drivers will use a table with a fixed
size. So, you can replace the current values, but it is not possible to add new keys.

The fix for it is simple, but we need to think what would be the better way for it. There are
two alternatives:
	- A table with a fixed size (like 128 or 256 entries - maybe a modprobe parameter
could be used to change its size);
	- some way to increase/reduce the table size. In this case, we'll likely need some
ioctl for it.

-- 

Cheers,
Mauro
