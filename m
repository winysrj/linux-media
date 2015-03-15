Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45140 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbbCOSHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 14:07:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 176272A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 19:07:40 +0100 (CET)
Message-ID: <5505CA6B.7080805@xs4all.nl>
Date: Sun, 15 Mar 2015 19:07:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANN] New v4l2-compliance features
References: <550322BB.6080905@xs4all.nl>
In-Reply-To: <550322BB.6080905@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2015 06:47 PM, Hans Verkuil wrote:
> Hi all,
> 
> I've just updated v4l2-compliance with some important new features.
> 
> First of all v4l2-compliance will store the driver state before it
> starts testing and it will restore it before the streaming tests
> start and when the application exits (including exit due to Ctrl-C).
> 
> This makes it possible to setup the driver for the streaming tests
> by selecting the right input/output, frequency, format, etc. so that
> that will be used by the streaming test.
> 
> The current -i, -o and -f options to set the input/output/frequency
> have been dropped since they are no longer needed.
> 
> Secondly a new option has been added: --stream-all-formats (-f). This
> will iterate over all pixelformats, all frame sizes, all frame intervals
> and all v4l2_field values and tries to stream 1 second worth of video.
> 
> It is normally quite difficult to check if a driver can really handle
> all combinations that it advertises, and this option should help.
> 
> It uses MMAP streaming or read/write if MMAP streaming is not supported.
> 
> Note that only video capture and output devices are supported. No support
> for memory-to-memory devices exists currently.

I've made some more improvements where the selection (crop/compose) API is
also tested in various combinations while streaming.

This covers most of the selection API. The main selection-related thing that
is still missing is testing of the various selection flags.

Regards,

	Hans
