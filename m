Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:42867 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZDYRxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 13:53:07 -0400
Date: Sat, 25 Apr 2009 10:53:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill the unused fields with zeros in case of
 VIDIOC_S_FMT
In-Reply-To: <49F2C59A.9010703@freemail.hu>
Message-ID: <Pine.LNX.4.58.0904251045070.3753@shell2.speakeasy.net>
References: <49F2C59A.9010703@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Apr 2009, [UTF-8] Németh Márton wrote:
> The VIDIOC_S_FMT is a write-read ioctl: it sets the format and returns
> the current format in case of success. The parameter of VIDIOC_S_FMT
> ioctl is a pointer to struct v4l2_format. [1] This structure contains some
> fields which are not used depending on the .type value. These unused
> fields are filled with zeros with this patch.

It's a union, so it's not really the case the the fields are unused.  If
it's a non-private format, the structure will have some empty padding space
at the end of the structure after the last field for the format's type.
Since it's just padding space and there are no fields defined, I don't
think we have to clear it.

>  		struct v4l2_format *f = (struct v4l2_format *)arg;
>
> +#define CLEAR_UNUSED_FIELDS(data, last_member) \
> +	memset(((u8 *)f)+ \
> +		offsetof(struct v4l2_format, fmt)+ \
> +		sizeof(struct v4l2_ ## last_member), \
> +		0, \
> +		sizeof(*f)- \
> +		offsetof(struct v4l2_format, fmt)+ \
> +		sizeof(struct v4l2_ ## last_member))
> +

What is "data" used for?  The length in your memset is wrong.  You didn't
run this through "make patch" did you?  Because there are spacing/formatting
errors that that would have caught.
