Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb01fl.versatel.de ([89.246.255.251]:55849 "EHLO
	mxweblb01fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZBYTqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 14:46:53 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb01fl.versatel.de (8.13.1/8.13.1) with ESMTP id n1PJWxJE024107
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 20:32:59 +0100
Received: from cinnamon-sage.de (i577A2196.versanet.de [87.122.33.150])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id n1PJWxnv001286
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2009 20:32:59 +0100
Received: from 192.168.23.2:50880 by cinnamon-sage.de for <hverkuil@xs4all.nl>,<linux-media@vger.kernel.org> ; 25.02.2009 20:32:59
Message-ID: <49A59CCF.1050301@cinnamon-sage.de>
Date: Wed, 25 Feb 2009 20:32:31 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> 
> _: Yes
> _: No

  Yes.

> Why:

  I'm a v4l-user, I use my VDR for a couple of years now. These were the 
steps I took, before I assembled my box:

- I have analog cable, so what hardware does exist, that is capable to 
record video on an old PC (even my desktop had only a 400MHz Celeron)?
- Which of these pieces are supported by Linux?

  For me it ended up with a PVR150 and an DXR3, later replaced by a 
PVR350. I started with kernel 2.6.9, that time ivtv wasn't part of the 
kernel, it was even outside v4l-dvb (am I correct?). Without a large 
amount of help from the ivtv-lists and VDR forum, that would have been a 
disaster for me. I can't say how glad I was, when I read the news, that 
ivtv was integrated in the kernel.
  What I'm trying to say is: when you need support for hardware, you 
have to upgrade your kernel and there are many other people beside the 
main driver developer which can help you. In the "hot" time of 
integrating ivtv in the kernel, I back off asking Hans for supporting an 
older kernel, since all I wanted was a working driver. And if that means 
I have to upgrade the kernel, I just have to do it.

  I get paid for developing and maintaining some specialized desktop 
applications since ~15 years now (~200 users), and from that point of 
view, sometimes you have to drop support for older installations 
respectively have to upgrade those to some level, because it's just a 
pain. I can remember what a relief it was, to be able to drop support 
for Windows 98 and base my company's (rather complex and large) ERP-app 
on some "real" Windows (>= 2000). (right now we're right in the middle 
of porting from Win32/C++ to .Net3.5/C#, guess who will make a jig when 
it's done...)

  Reading the diverse postings and from my point of knowledge and 
experience, I think it's best to swap the development model to an "in 
kernel"-tree, that feeds a compat-tree, which supports kernel-versions 
that are reasonable. And if someone has fun backporting (i2c-related) 
drivers below 2.6.22, than let him do it. But let the main developer do 
their work in keeping uptodate with new hardware and new kernels. They 
get old soon enough. (the kernel, not the developers...) ;-)

Lars.
