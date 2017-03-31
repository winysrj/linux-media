Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50788 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932993AbdCaMMl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:12:41 -0400
Subject: Re: [PATCH] vidioc-enumin/output.rst: improve documentation
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <dfd64830-b66d-044d-2a40-82210a32c18a@xs4all.nl>
 <20170331070508.7a8eae16@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7e294a12-b8a9-a09f-c2d0-bf2e2ddcbf8b@xs4all.nl>
Date: Fri, 31 Mar 2017 14:12:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170331070508.7a8eae16@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 12:05, Mauro Carvalho Chehab wrote:
> Em Fri, 31 Mar 2017 10:58:39 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> The V4L2_INPUT_TYPE_CAMERA and V4L2_OUTPUT_TYPE_ANALOG descriptions were
>> hopelessly out of date. Fix this, and also fix a few style issues in these
>> documents. Finally add the missing documentation for V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY
>> (only used by the zoran driver).
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
> 
> Patch looks OK to me, but see below.
> 
>> Question: should we perhaps add _TYPE_VIDEO aliases?
> 
> IMHO, let's rename it to _TYPE_VIDEO (or STREAM, or V_STREAM), and make 
> _TYPE_CAMERA an alias, e. g.:
> 
> #define V4L2_INPUT_TYPE_VIDEO 2
> 
> #define V4L2_INPUT_TYPE_CAMERA V4L2_INPUT_TYPE_VIDEO
> 
> This way, we'll let clearer what's currently preferred. We should also
> change it at the documentation, mentioning that V4L2_INPUT_TYPE_CAMERA
> is an alias, due to historical reasons.

Does this really make sense to do this now? Everyone is used to the old defines,
wouldn't changing this just increase confusion?

Sorry, playing devil's advocate here.

I'm a bit hesitant of doing this. We've done this in the past for APIs that
were very new or rarely used, but this is everywhere.

I feel fixing the spec is sufficient.

If more people think that adding this aliases is a good idea, then I can do that.

Regards,

	Hans
