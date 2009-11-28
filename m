Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57877 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZK1Beu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 20:34:50 -0500
Date: Fri, 27 Nov 2009 17:34:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	christoph@bartelmus.de, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR system?
Message-ID: <20091128013443.GL6936@core.coreip.homeip.net>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com> <BDgcsm11qgB@lirc> <9e4733910911270949s3e8b5ba9qfe5025d490ad0cfa@mail.gmail.com> <874oof6b9u.fsf@tac.ki.iif.hu> <9e4733910911271121j452aa796j543f1fc3f6de7028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911271121j452aa796j543f1fc3f6de7028@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2009 at 02:21:13PM -0500, Jon Smirl wrote:
> On Fri, Nov 27, 2009 at 2:03 PM, Ferenc Wagner <wferi@niif.hu> wrote:
> > Admittedly, I don't know why /dev/mouse is evil, maybe I'd understand if
> 
> /dev/mouse is evil because it is possible to read partial mouse
> messages. evdev fixes things so that you only get complete messages.
> 

For me the main evil of /dev/mouse (and other multuiplexing interfaces)
is that it is impossible to remove one of the streams from the
multiplexed stream without affecting other users. And so are born
various "grab" schemes where we declare one application _the
application_ and let it "grab" the device.. which breaks when there are
other applications also interested in the same data stream.

-- 
Dmitry
