Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52556 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbbDBR4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 13:56:08 -0400
Message-ID: <551D8299.2060400@xs4all.nl>
Date: Thu, 02 Apr 2015 19:55:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2] v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
References: <551D38A5.9020104@xs4all.nl> <CAPybu_0gfixU2fn7LAa3WkCxWoBxS7gmwThVX1M2U0i4XHberQ@mail.gmail.com>
In-Reply-To: <CAPybu_0gfixU2fn7LAa3WkCxWoBxS7gmwThVX1M2U0i4XHberQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/02/2015 07:02 PM, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> On Thu, Apr 2, 2015 at 2:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> +       case V4L2_PIX_FMT_Y16:          descr = "16-bit Greyscale"; break;
> 
> What about  "16-bit Greyscale LE" ?

LE is the default, so that's not mentioned. Only if it is BE will I mention
it in the description. It's the way drivers do this today as well, and I
think it makes sense.

Regards,

	Hans

