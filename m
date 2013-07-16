Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3GPMBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 08:01:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
Cc: linux-media@vger.kernel.org, hansverk@cisco.com
Subject: Re: [PATCH 4/4] qv4l2: add OpenGL video render
Date: Tue, 16 Jul 2013 14:01:45 +0200
Message-ID: <1609457.OFIJZjqBDN@avalon>
In-Reply-To: <5eb7b2d7de462e820ceb0698f6aa431c3eca414c.1373973770.git.bwinther@cisco.com>
References: <1373973848-4084-1-git-send-email-bwinther@cisco.com> <5eb7b2d7de462e820ceb0698f6aa431c3eca414c.1373973770.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård,

Thank you for the patches.

On Tuesday 16 July 2013 13:24:08 Bård Eirik Winther wrote:
> The qv4l2 test utility now supports OpenGL-accelerated display of video.
> This allows for using the graphics card to render the video content to
> screen and to performing color space conversion.
> 
> Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> ---
>  configure.ac                |   8 +-
>  utils/qv4l2/Makefile.am     |   9 +-
>  utils/qv4l2/capture-win.cpp | 559 +++++++++++++++++++++++++++++++++++++++--
>  utils/qv4l2/capture-win.h   |  81 ++++++-
>  utils/qv4l2/qv4l2.cpp       | 173 +++++++++++---
>  utils/qv4l2/qv4l2.h         |   8 +
>  6 files changed, 782 insertions(+), 56 deletions(-)

Is there a chance you could split the OpenGL code to separate classes, in a 
separate source file ? This would allow implementing other renderers, such as 
KMS planes on embedded devices.

-- 
Regards,

Laurent Pinchart

