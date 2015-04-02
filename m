Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34978 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbDBRCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 13:02:33 -0400
Received: by lahf3 with SMTP id f3so63997504lah.2
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2015 10:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551D38A5.9020104@xs4all.nl>
References: <551D38A5.9020104@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 2 Apr 2015 19:02:11 +0200
Message-ID: <CAPybu_0gfixU2fn7LAa3WkCxWoBxS7gmwThVX1M2U0i4XHberQ@mail.gmail.com>
Subject: Re: [PATCHv2] v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

On Thu, Apr 2, 2015 at 2:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> +       case V4L2_PIX_FMT_Y16:          descr = "16-bit Greyscale"; break;

What about  "16-bit Greyscale LE" ?


Regards!


-- 
Ricardo Ribalda
