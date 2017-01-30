Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f180.google.com ([209.85.210.180]:36017 "EHLO
        mail-wj0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdA3R0e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 12:26:34 -0500
Received: by mail-wj0-f180.google.com with SMTP id n2so8847307wjq.3
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 09:26:21 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: metadata node
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6c8267d-d18d-419e-bb2c-a21cfcbdd5bc@linaro.org>
Date: Mon, 30 Jan 2017 19:26:19 +0200
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 01/11/2017 11:42 AM, Guennadi Liakhovetski wrote:
> Hi Laurent,
> 
> As you know, I'm working on a project, that involves streaming metadata, 
> obtained from UVC payload headers to the userspace. Luckily, you have 
> created "metadata node" patces a while ago. The core patch has also been 
> acked by Hans, so, I decided it would be a safe enough bet to base my work 
> on top of that.
> 
> Your patch makes creating /dev/video* metadata device nodes possible, but 
> it doesn't provide any means to associate metadata nodes to respective 
> video (image) nodes. Another important aspect of using per-frame metadata 
> is synchronisation between metadata and image buffers.  The user is 
> supposed to use buffer sequence numbers for that. That should be possible, 
> but might be difficult if buffers lose synchronisation at some point. As a 
> solution to the latter problem the use of requests with buffers for both 
> nodes has been proposed, which should be possible once the request API is 
> available.
> 
> An alternative approach to metadata support, e.g. heterogeneous 
> multi-plain buffers with one plain carrying image data and another plain 
> carrying metadata would be possible. It could also have other uses. E.g. 
> we have come across cameras, streaming buffers, containing multiple images 
> (e.g. A and B). Possibly both images have supported fourcc format, but 
> they cannot be re-used, because A+B now are transferred in a single 
> buffer. Instead a new fourcc code has to be invented for such cases to 
> describe A+B.
> 
> As an important argument in favour of having a separate video node for 
> metadata you named cases, when metadata has to be obtained before a 
> complete image is available. Do you remember specifically what those cases 
> are? Or have you got a link to that discussion?
> 
> In any case, _if_ we do keep the current approach of separate /dev/video* 
> nodes, we need a way to associate video and metadata nodes. Earlier I 
> proposed using media controller links for that. In your implementation of 

I don't think that media controller links is a good idea. This metadata
api could be used by mem2mem drivers which don't have media controller
links so we will need a generic v4l2 way to bound image buffer and its
metadata buffer.


-- 
regards,
Stan
