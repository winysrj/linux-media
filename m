Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48632 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZH3VaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 17:30:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-2?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] libv4l: add NULL pointer check
Date: Sun, 30 Aug 2009 23:33:20 +0200
Cc: V4L Mailing List <linux-media@vger.kernel.org>
References: <4A9A3EB0.8060304@freemail.hu>
In-Reply-To: <4A9A3EB0.8060304@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908302333.20933.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 30 August 2009 10:56:16 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> Add NULL pointer check before the pointers are dereferenced.

Applications are not supposed to pass NULL pointers to those functions. It 
would be an API violation. Instead of silently failing a segfault is better.

> The patch was tested with v4l-test 0.19 [1] together with
> "Trust 610 LCD Powerc@m Zoom" in webcam mode.
>
> Reference:
> [1] v4l-test: Test environment for Video For Linux Two API
>     http://v4l-test.sourceforge.net/
>
> Priority: normal
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

-- 
Regards,

Laurent Pinchart
