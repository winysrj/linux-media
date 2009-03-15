Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3197 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCOQxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 12:53:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Date: Sun, 15 Mar 2009 17:53:52 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200903151324.00784.hverkuil@xs4all.nl> <Pine.LNX.4.58.0903150859300.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903150859300.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151753.52663.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
> On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > Hi Mauro,
> >
> > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
>
> It would be a lot easier if you would provide patch descriptions.

Here it is:

- bttv: convert to v4l2_subdev.

That's all it does. You can't do half a conversion. I'm interested whether I 
got the probing sequence correct. Most of the patch deals with the actual 
conversion of bttv_call_i2c_clients to the equivalent bttv_call_all and 
that is pretty boring.

But it's the changes to bttv-cards.c that need to be reviewed just in case I 
missed something that would break support for some exotic bttv card.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
