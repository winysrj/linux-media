Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:47196 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZEZTGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:06:14 -0400
From: Dominique Dumont <domi.dumont@free.fr>
To: Tomer Barletz <barletz@gmail.com>
Date: Tue, 26 May 2009 21:06:02 +0200
Cc: linux-media@vger.kernel.org
References: <eaf6cbc30905252243m2d6e1537vd255e49f289c0f33@mail.gmail.com>
In-Reply-To: <eaf6cbc30905252243m2d6e1537vd255e49f289c0f33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905262106.03697.domi.dumont@free.fr>
Subject: Re: Problem with SCM/Viaccess CAM
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Tuesday 26 May 2009 07:43:15 Tomer Barletz, vous avez écrit :
> Hi,
> When inserting a SCM/Viaccess CAM, I get the following message:
> dvb_ca adapter 0: DVB CAM did not respond :(
>
> According to this:
> http://linuxtv.org/hg/v4l-dvb/file/142fd6020df3/linux/Documentation/dvb/ci.
>txt this CAM should work.
>
> I'm using kernel 2.6.10.

SCM CAMs are very slow to start up. I've submitted a patch to work-around this 
issue a few years ago. IIRC, this was around 2.6.14.

So you should upgrade your kernel

HTH

