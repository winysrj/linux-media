Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:45172 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1KYPot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 10:44:49 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id pAPFaBmt018848
	for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 16:36:11 +0100
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id pAPFZxoF011732
	for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 16:36:01 +0100
Message-ID: <4ECFB5DF.1040806@tvdr.de>
Date: Fri, 25 Nov 2011 16:35:59 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 10/12] av7110: replace audio.h, video.h and osd.h
 by av7110.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <5276295e57ca56ed2a27148d918b63b00dd05b34.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <5276295e57ca56ed2a27148d918b63b00dd05b34.1322141686.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.11.2011 14:39, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Create a new public header, av7110.h, that contains all the av7110
> specific audio, video and osd APIs that used to be defined in dvb/audio.h,
> dvb/video.h and dvb/osd.h. These APIs are no longer part of DVBv5 but are
> now av7110-specific.
>
> This decision was taken during the 2011 Prague V4L-DVB workshop.
>
> Ideally av7110 would be converted to use the replacement V4L2 MPEG
> decoder API, but that's a huge job for such an old driver.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

This would break applications, especially VDR.
I therefore strongly oppose this!
You may introduce new APIs as you like, but don't break the
existing ones that have worked for many years.

Nacked-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>

Klaus
