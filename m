Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:56919 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab3GRM4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 08:56:00 -0400
Date: Thu, 18 Jul 2013 09:55:59 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sergey 'Jin' Bostandzhyan <jin@mediatomb.cc>,
	linux-media@vger.kernel.org
Subject: Re: Possible problem with stk1160 driver
Message-ID: <20130718125557.GB2307@localhost>
References: <20130716220418.GC10973@deadlock.dhs.org>
 <20130717084428.GA2334@localhost>
 <20130717213139.GA14370@deadlock.dhs.org>
 <20130718001752.GA2318@localhost>
 <51E78BB1.4020108@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51E78BB1.4020108@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for jumping in.

On Thu, Jul 18, 2013 at 08:31:13AM +0200, Hans Verkuil wrote:
> On 07/18/2013 02:17 AM, Ezequiel Garcia wrote:
> > 
> > Ah... forgot to mention about that. I haven't included the fix for standard
> > setting, because either the stk1160 chip or the userspace application didn't
> > seem to behave properly: I got wrongly coloured frames when trying to
> > change the standard while streaming.
> 
> You generally can't switch standards while streaming. That said, it is OK
> to accept the same standard, i.e. return 0 if the standard is unchanged and
> EBUSY otherwise.
> 

Ok, I'll add a check for unchanged standards to overcome this situation.

> In the end it is an application bug, though. It shouldn't try to change the
> standard while streaming has started.
> 

Ok, so that confirms we should not allow it.

Sergey: Hopefully, with these two patches you won't need any further
patching on your side.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
