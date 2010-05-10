Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48839 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab0EJLUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 07:20:11 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 10 May 2010 16:50:06 +0530
Subject: RE: [PATCH 0/6] [RFC] tvp514x fixes
Message-ID: <19F8576C6E063C45BE387C64729E7394044E4048E4@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 0/6] [RFC] tvp514x fixes
> 
> Hi Vaibhav,
> 
> While working on the *_fmt to *_mbus_fmt video op conversion I noticed that
> tvp514x is confusing the current select TV standard with the detected TV
> standard leading to horrible side-effects where called TRY_FMT can actually
> magically change the TV standard.
> 
> I fixed this and I also simplified the format handling in general. Basically
> removing the format list table and realizing that since there is only one
> supported format, you can just return that format directly.
> 
> This will also make the next step much easier where enum/try/s/g_fmt is
> replaced by enum/try/s/g_mbus_fmt.
> 
> However, I have no way of testing this. Can you review this code and let
> me know if it is OK?
> 
[Hiremath, Vaibhav] Sorry Hans for delayed response on this, actually today almost whole day I had to spend collecting docs for VISA application and stuff.

Thanks for working on this and changing the driver, I will take a look at it (Also I will validate it here at my end) and update you on this.

Thanks,
Vaibhav

> Regards,
> 
> 	Hans
> 
> Hans Verkuil (6):
>   tvp514x: do NOT change the std as a side effect
>   tvp514x: make std_list const
>   tvp514x: there is only one supported format, so simplify the code
>   tvp514x: add missing newlines
>   tvp514x: remove obsolete fmt_list
>   tvp514x: simplify try/g/s_fmt handling
> 
>  drivers/media/video/tvp514x.c |  223 ++++++++------------------------------
> ---
>  1 files changed, 40 insertions(+), 183 deletions(-)

