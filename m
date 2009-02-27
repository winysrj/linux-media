Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:52547 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbZB0T3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 14:29:42 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KFQ003HHOSVED00@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2009 14:29:20 -0500 (EST)
Date: Fri, 27 Feb 2009 14:29:18 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [linux-dvb] Fwd: HVR2250 Status - Where am I?
In-reply-to: <412bdbff0902271050r4c53a655na8cd0f404a83895e@mail.gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <49A83F0E.5070402@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <499E381D.4070607@linuxtv.org>
 <387ee2020902200707n185ec344m823a33a8fdce72e3@mail.gmail.com>
 <e816454e0902270833i73cd59f0t1129ab7011b0024c@mail.gmail.com>
 <387ee2020902270845u7700b4feuc2c8d6898947e641@mail.gmail.com>
 <49A81DCE.6060201@linuxtv.org>
 <387ee2020902270918y1f06a54evf4d14f15765e886b@mail.gmail.com>
 <49A820B9.7000004@linuxtv.org>
 <e816454e0902271027k295aa341r384752829687b7e8@mail.gmail.com>
 <412bdbff0902271034qd762d8pc2254ed14e930b72@mail.gmail.com>
 <387ee2020902271038v3ca7434dw25780937e64673e1@mail.gmail.com>
 <412bdbff0902271050r4c53a655na8cd0f404a83895e@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Feb 27, 2009 at 1:38 PM, John Drescher <drescherjm@gmail.com> wrote:
>> So now (with my donation) we have him working at $1/hour assuming that
>> it takes only 100 hours..
> 
> Well, this assumes that it would only take 100 hours, of which given
> the complexity of the device, it will probably take more than twice
> that (since it's a PCI device and the estimates I gave are for USB
> devices).
> 
> If nothing else, it offers some insight as to how valuable the work of
> people like Steven is (he has written a whole bunch of different
> drivers).  It also demonstrates one reason there are so few developers
> willing to do this sort of work.  Getting a developer to donate a
> couple of evening's worth of time is pretty easy.  Getting them to
> make a commitment of every day for the next two to three months is
> quite harder.

It takes a massive amount of time from all of the core developers to keep the 
v4l-dvb tree up to date and to add new functionality.

Adding a new style of board to an existing driver can take a couple of hours 
with testing. It's bread a butter maintenance task.

However, adding a brand new bridge driver to the kernel can take 6 months just 
for the first release, and is then slowly improved over the next 12-24 months.

It's a large task.

- Steve


