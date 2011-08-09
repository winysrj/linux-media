Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1HIHfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 03:35:17 -0400
Message-ID: <4E40E3A6.2080508@redhat.com>
Date: Tue, 09 Aug 2011 09:37:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Adam Baker <linux@baker-net.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <201108082133.00340.linux@baker-net.org.uk> <alpine.LNX.2.00.1108081543490.21785@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108081543490.21785@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

<snip>

> OK, another example. The cameras supported in camlibs/jl2005c do not have
> webcam ability, but someone could at any time design and market a dualmode
> which has in stillcam mode the same severe limitation. What limitation?
> Well, the entire memory of the camera must be dumped, or else the camera
> jams itself. You can stop dumping in the middle of the operation, but you
> must continue after that. Suppose that you had ten pictures on the camera
> and you only wanted to download the first one. Then you can do that and
> temporarily stop downloading the rest. But while exiting you have to check
> whether the rest are downloaded or not. And if they are not, then it has
> to be done, with the data simply thrown in the trash, and then the
> camera's memory pointer reset before the camera is released. How, one
> might ask, did anyone produce something so primitive? Well, it is done.
> Perhaps the money saved thereby was at least in part devoted to producing
> better optics for the camera. At least, one can hope so. But people did
> produce those cameras, and people have bought them. But does anyone want
> to reproduce the code to support this kind of crap in the kernel? And go
> through all of the hoops required in order to fake the behavior which one
> woulld "expect" from a "real" still camera? It has already been done in
> camlibs/jl2005c and isn't that enough?

This actually is an example where doing a kernel driver would be easier,
a kernel driver never exits. So it can simply remember where it was
reading (and cache the data it has read sofar). If an app requests picture
10, we read 1-10, cache them and return picture 10 to the app, then the same
or another app asks for picture 4, get it from cache, asks for picture 20
read 11-20, etc.

Having written code for various small digital picture frames (the keychain
models) I know where you are coming from. Trust me I do. Recently I had
an interesting bug report, with a corrupt PAT (picture allocation table)
turns out that when deleting a picture through the menu inside the frame
a different marker gets written to the PAT then when deleting it with the
windows software, Fun huh?

So yeah duplicating this code is no fun, but it is the only realistic
solution which will get us a 100% reliable and robust user experience.

Regards,

Hans
