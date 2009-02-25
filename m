Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52463 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755662AbZBYTKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 14:10:10 -0500
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 25 Feb 2009 20:10:01 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <49A586CE.7030600@gmx.de>
Message-ID: <20090225191001.50400@gmx.net>
MIME-Version: 1.0
References: <200902221115.01464.hverkuil@xs4all.nl> <49A586CE.7030600@gmx.de>
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
To: hverkuil@xs4all.nl
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>
> _: Yes
> _: No
>
>   

YES (but I would go even further)

> 
> Optional question:
>
> Why:
>   

The aim should be to bring improvements to the released Linux kernel.

The *only* point relevant for both development and testing is the current
latest development kernel, currently 2.6.29-rc6.

So I would go further : development should be moved to git and support
for all previous kernels should be dropped allowing concentration of
development resources on making patches which will be applied to the head 
of the git tree.

I think it is completely wrong-headed to have "v4l-dvb" as a thing which 
can be installed on top of old kernels to add new driver support to old
kernels. It is a waste of time to create such a thing, and a drain on 
resources to support.

As for users/testers, the message should be made crystal clear: if you
want to try running bleeding-edge code to get the latest support your
hardware the first thing to do is upgrade to the latest kernel. It will
be easier to communicate with developers who are (or should be!) working
on improving the latest development kernel.

This is better for everyone : time wasted on backporting and talking
about/debugging old kernel issues will be eliminated and drivers will 
released in the mainline kernels faster.

It will also clarify to distros and users where the "coal face" is:
new hardware support comes from new kernels, not v4l-dvb or (usually) 
backports or anything else.

Fixes for bugs in last stable kernel (currently 2.6.28.7) should be
pushed in if known, but never new features.

Distros or those with special commercial reasons can work on backports
if they really feel they can justify the use of their time, money and
other resources. They are also the only ones who can properly take account
of all the userland consequences of making a backport because they see
the whole system.

Regards,
Hans
-- 
Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01
