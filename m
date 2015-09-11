Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44369 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbbIKOAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:00:00 -0400
Message-ID: <55F2DE18.3020201@xs4all.nl>
Date: Fri, 11 Sep 2015 15:58:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: linux-api@vger.kernel.org
Subject: Re: [PATCH v8 44/55] [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY
 ioctl
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <297afcfe4c9c5ebc074f92d1badd34b94e8b28f9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <297afcfe4c9c5ebc074f92d1badd34b94e8b28f9.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Add a new ioctl that will report the entire topology on
> one go.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I do have one suggestion: media_v2_interface, media_v2_pad and media_v2_link all
have a 'flags' field, but it is not clear from the code in the header which flag
#defines are used for which struct. Perhaps a few comments would help with that.

> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index a1bd7afba110..b17f6763aff4 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h

<snip>

> +
> +struct media_v2_pad {
> +	__u32 id;
> +	__u32 entity_id;
> +	__u32 flags;
> +	__u16 reserved[9];

Strange odd number here for no clear reason. Perhaps use 8 or 10 instead?

Anyway, you have my Ack.

Regards,

	Hans
