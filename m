Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZBYPuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 10:50:16 -0500
Date: Wed, 25 Feb 2009 09:49:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Markus Rechberger <mrechberger@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory
 together with uvcvideo driver
Message-ID: <20090225094929.09783b83@caramujo.chehab.org>
In-Reply-To: <49A4F6C0.5060503@freemail.hu>
References: <bug-12768-10286@http.bugzilla.kernel.org/>
	<20090224135720.9e752fee.akpm@linux-foundation.org>
	<20090224230200.77469747@pedra.chehab.org>
	<d9def9db0902241815i7e0d8e90k59824c5a83534e2c@mail.gmail.com>
	<20090224192330.338302fa.akpm@linux-foundation.org>
	<d9def9db0902241935h3e9303ebpaa43ec2ae03b4dc2@mail.gmail.com>
	<49A4F6C0.5060503@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Feb 2009 08:44:00 +0100
Németh Márton <nm127@freemail.hu> wrote:

> What I did with the other out-of-tree em28xx-new driver was that
> I printed out the urb->kref.refcount before and after each urb operation.
> 
> The result was that when the urb->complete function is called, the reference
> count was still 2, instead of 1.
> 
> I could imagine three possible errors:
> 1. there is a bug in uvcvideo driver
> 2. there is a bug in v4l framework
> 3. there is a bug in usb subsystem
> 
> It would be good if someone who have a deeper knowledge than me on these fields could
> give some hints or debug patches which would lead us closer to the solution.

Márton,

I did a test yesterday night with 2.6.29-rc6. The em28xx in-kernel still has
same problem we focused a while ago (except that, before, memory were going
exausted on a much higher rate, and we had memory leaks for every close() call).

What happens is that, sometimes, memory are not being freed by
usb_kill_urb()/usb_unlink_urb(). I'm trying to debug it right now, to
understand what's happening.


Cheers,
Mauro
