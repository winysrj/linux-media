Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52718 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbbLRAEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 19:04:37 -0500
Subject: Re: VIVID bug in BGRA and ARGB
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
References: <1450393444.28544.3.camel@collabora.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56734D8F.2030209@xs4all.nl>
Date: Fri, 18 Dec 2015 01:04:31 +0100
MIME-Version: 1.0
In-Reply-To: <1450393444.28544.3.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/18/2015 12:04 AM, Nicolas Dufresne wrote:
> Hi Hans,
> 
> while testing over color formats VIVID produce, I found that BGRA and
> ARGB the alpha component is always 0, which leads to black frames when
> composed (when the background is black of course). Is that a bug, or
> intended ?

Depends who you ask, I guess.

Anyway, the alpha value can be set through a user control (Alpha Component),
which is indeed by default 0. I wonder if I should set it to 0x7f by default.

This still maps to 0 for 1-5-5-5 ARGB formats, though.

Suggestions are welcome.

Regards,

	Hans
