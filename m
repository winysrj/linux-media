Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2971 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaGYS1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 14:27:22 -0400
Message-ID: <53D2A183.30000@xs4all.nl>
Date: Fri, 25 Jul 2014 20:27:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l2-ctrls: negative integer control values broken
References: <53D2A115.5010209@googlemail.com>
In-Reply-To: <53D2A115.5010209@googlemail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2014 08:25 PM, Frank Schäfer wrote:
> Hans,
> 
> sorry for bothering you with another issue on friday evening. :-/
> But it seems that commit 958c7c7e65 ("[media] v4l2-ctrls: fix corner
> case in round-to-range code") introduced a regression for controls which
> are using a negative integer value range.
> All negative values are mapped to the maximum (positive) value (check
> em28xx brightness, red and blue balance bridge controls for example).
> Reverting this commit makes them working again.
> At a first glance I can't find a mistake...

I'll take a look at this this weekend. Thanks for reporting this!

	Hans

