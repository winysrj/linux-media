Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39303 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbbCJP4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 11:56:46 -0400
Message-ID: <54FF1437.1050206@xs4all.nl>
Date: Tue, 10 Mar 2015 16:56:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 18/18] marvell-ccic: fix Y'CbCr ordering
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl> <1425936143-5658-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-19-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2015 10:22 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Various formats had their byte ordering implemented incorrectly, and
> the V4L2_PIX_FMT_UYVY is actually impossible to create, instead you
> get V4L2_PIX_FMT_YVYU.
> 
> This was working before commit ad6ac452227b7cb93ac79beec092850d178740b1
> ("add new formats support for marvell-ccic driver"). That commit broke
> the original format support and the OLPC XO-1 laptop showed wrong
> colors ever since (if you are crazy enough to attempt to run the latest
> kernel on it, like I did).

I tried to contact the original authors of that commit but I couldn't reach
them. So I've added the following to the commit log of this patch:

"The email addresses of the authors of that patch are no longer valid,
so without a way to reach them and ask them about their test setup
I am going with what I can test on the OLPC laptop.

If this breaks something for someone on their non-OLPC setup, then
contact the linux-media mailinglist. My suspicion however is that
that commit went in untested."

Regards,

	Hans
