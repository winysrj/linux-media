Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:30881 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2F0Jzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 05:55:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: About s_std_output
Date: Wed, 27 Jun 2012 11:55:17 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <CAHG8p1DaJPWwSxmMqk6Jkx8JO8m69OuTYpwHvhsB54e8RAMRVA@mail.gmail.com>
In-Reply-To: <CAHG8p1DaJPWwSxmMqk6Jkx8JO8m69OuTYpwHvhsB54e8RAMRVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206271155.17164.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 27 June 2012 11:37:24 Scott Jiang wrote:
> Hi Hans,
> 
> I noticed there are two s_std ops in core and video for output. And
> some drivers call video->s_std_out and then core->s_std in their S_STD
> iotcl. Could anyone share me the story why we have
> s_std_output/g_std_output/g_tvnorms_output ops in video instead of
> making use of s_std/g_std in core?

The core class is for common, often used ops. Setting the standard for
capture devices is very common, so it is in core. Setting the standard
for output devices is much less common (there aren't that many output
devices in the kernel), so that stayed in the video class.

It is a bit arbitrary and I am not sure whether I would make the same
choice now.

There is no g_tvnorms_output, BTW.

Regards,

	Hans
