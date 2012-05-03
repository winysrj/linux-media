Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab2ECKjY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 06:39:24 -0400
Message-ID: <4FA26047.2090004@redhat.com>
Date: Thu, 03 May 2012 07:39:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain>  <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>  <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com> <1336005780.24477.7.camel@palomino.walls.org>
In-Reply-To: <1336005780.24477.7.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-05-2012 21:42, Andy Walls escreveu:
> On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:
> 
>> We can speed-up the conversions, with something like:
>>
>> enum foo {
>> 	BAR
>> };
>>
>> if (sizeof(foo) != sizeof(u32))
>> 	call_compat_logic().
>>
>> I suspect that sizeof() won't work inside a macro. 
> 
> sizeof() is evaluated at compile time, after preprocessing. 
> It should work inside of a macro.

According with Dennis Ritchie, testing for sizeof on a macro never worked:
	http://groups.google.com/group/comp.std.c/msg/4852afc61a060d89?dmode=source&pli=1

Regards,
Mauro
