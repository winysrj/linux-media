Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38106 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932162Ab0A0SWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 13:22:38 -0500
Date: Wed, 27 Jan 2010 19:22:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
In-Reply-To: <4B6081D4.5070501@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
 <4B6081D4.5070501@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Jan 2010, Németh Márton wrote:

> Guennadi Liakhovetski wrote:

[snip]

> > And these:
> > 
> > 	if (output_w > max(512U, input_w / 2)) {
> > 	if (output_h > max(384U, input_h / 2)) {
> > 
> > would now produce compiler warnings... Have you actually tried to compile 
> > your patch? You'll also have to change formats in dev_dbg() calls here...
> 
> Interesting to hear about compiler warnings. I don't get them if I apply the patch
> on top of version 14064:31eaa9423f98 of http://linuxtv.org/hg/v4l-dvb/  . What
> is your compiler version?

Well, it's my built-in mental compiler, I haven't started versioning it 
yet;) Strange, that (your) compiler doesn't complain - max() does 
type-checking and now it's signed against unsigned, hm... In any case, 
that one is easy to fix - just remove the "U"s, but I'm wondering why the 
compiler didn't shout and whether there can be other similar mismatches...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
