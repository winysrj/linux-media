Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36078 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab2HXPoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 11:44:25 -0400
From: Detlev Zundel <dzu@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other register settings
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241227140.20710@axis700.grange>
	<m2pq6g5tm3.fsf@lamuella.denx.de>
	<Pine.LNX.4.64.1208241527370.20710@axis700.grange>
Date: Fri, 24 Aug 2012 17:44:08 +0200
In-Reply-To: <Pine.LNX.4.64.1208241527370.20710@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri, 24 Aug 2012 15:35:59 +0200 (CEST)")
Message-ID: <m2fw7c47nb.fsf@lamuella.denx.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> Hi Detlev
>
> On Fri, 24 Aug 2012, Detlev Zundel wrote:
>
>> Hello Guennadi,
>> 
>> > Hi Anatolij
>> >
>> > On Fri, 24 Aug 2012, Anatolij Gustschin wrote:
>> >
>> >> Add controls for horizontal and vertical blanking, analog control
>> >> and control for undocumented register 32.
>> >
>> > Sorry, I don't think this is a good idea to export an undocumented 
>> > register as a control.
>> 
>> Why exactly is that?  Even though it is not documented, we need to
>> fiddle with it to make our application work at all.  So we tend to
>> believe that other users of the chip will want to use it also.
>
> Below I asked to provide details about how you have to change this 
> register value: toggle dynamically at run-time or just set once at 
> initialisation? Even if toggle: are this certain moments, related to 
> standard camera activities (e.g., starting and stopping streaming, 
> changing geometry etc.) or you have to set this absolutely asynchronously 
> at moments of time, that only your application knows about?

Anatolij can answer those detail questions, all I know is that without
fiddling with the register we do not receive valid pictures at all.

>> Furthermore I don't see that we fundamentally reject patches for other
>> parts in the Linux kernel where people found out things not in the
>> official datasheets.
>
> The problem is not, that this register is undocumented, the problem rather 
> is, that IMHO exporting an API to user-space, setting an undocumented 
> register to arbitrary values is, hm, at least pretty dubious.

As I wrote above, without fiddling with the register, we do _not_
receive correct pictures at all.  So this is not dubious but shown by
experiment to be needed (at least in our setup).

Best wishes
  Detlev

-- 
A language that doesn't affect the way you think about programming, is
not worth knowing.             -- Alan Perlis, Epigrams on Programming
