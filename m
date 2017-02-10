Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34057 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbdBJMK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 07:10:27 -0500
Received: by mail-wr0-f173.google.com with SMTP id o16so106457836wra.1
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2017 04:09:44 -0800 (PST)
Subject: Re: metadata node
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
 <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
 <alpine.DEB.2.00.1702021932150.23282@axis700.grange>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <74450682-4fdc-4561-e853-865bdaa64cfc@linaro.org>
Date: Fri, 10 Feb 2017 14:09:42 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1702021932150.23282@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 02/02/2017 08:35 PM, Guennadi Liakhovetski wrote:
> Hi Stanimir,
> 
> On Mon, 30 Jan 2017, Stanimir Varbanov wrote:
> 
>> Hi Guennadi,
>>
>> On 01/11/2017 11:42 AM, Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>> In any case, _if_ we do keep the current approach of separate /dev/video* 
>>> nodes, we need a way to associate video and metadata nodes. Earlier I 
>>> proposed using media controller links for that. In your implementation of 
>>
>> I don't think that media controller links is a good idea. This metadata
>> api could be used by mem2mem drivers which don't have media controller
>> links so we will need a generic v4l2 way to bound image buffer and its
>> metadata buffer.
> 
> Is there anything, that's preventing mem2mem drivers from using the MC 
> API? Arguably, if you need metadata, you cross the line of becoming a 
> complex enough device to deserve MC support?

Well I don't want to cross that boundary :), and I don't want to use MC
for such simple entity with one input and one output. The only reason to
reply to your email was to provoke your attention to the drivers which
aren't MC based.

On other side I think that sequence field in struct vb2_v4l2_buffer
should be sufficient to bound image buffer with metadata buffer.

-- 
regards,
Stan
