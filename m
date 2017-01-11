Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55476 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdAKJms (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 04:42:48 -0500
Date: Wed, 11 Jan 2017 10:42:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Subject: metadata node
Message-ID: <Pine.LNX.4.64.1701111007540.761@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

As you know, I'm working on a project, that involves streaming metadata, 
obtained from UVC payload headers to the userspace. Luckily, you have 
created "metadata node" patces a while ago. The core patch has also been 
acked by Hans, so, I decided it would be a safe enough bet to base my work 
on top of that.

Your patch makes creating /dev/video* metadata device nodes possible, but 
it doesn't provide any means to associate metadata nodes to respective 
video (image) nodes. Another important aspect of using per-frame metadata 
is synchronisation between metadata and image buffers.  The user is 
supposed to use buffer sequence numbers for that. That should be possible, 
but might be difficult if buffers lose synchronisation at some point. As a 
solution to the latter problem the use of requests with buffers for both 
nodes has been proposed, which should be possible once the request API is 
available.

An alternative approach to metadata support, e.g. heterogeneous 
multi-plain buffers with one plain carrying image data and another plain 
carrying metadata would be possible. It could also have other uses. E.g. 
we have come across cameras, streaming buffers, containing multiple images 
(e.g. A and B). Possibly both images have supported fourcc format, but 
they cannot be re-used, because A+B now are transferred in a single 
buffer. Instead a new fourcc code has to be invented for such cases to 
describe A+B.

As an important argument in favour of having a separate video node for 
metadata you named cases, when metadata has to be obtained before a 
complete image is available. Do you remember specifically what those cases 
are? Or have you got a link to that discussion?

In any case, _if_ we do keep the current approach of separate /dev/video* 
nodes, we need a way to associate video and metadata nodes. Earlier I 
proposed using media controller links for that. In your implementation of 
the R-Car VSP1 1-D histogram engine metadata node, where did you link it 
in the media controller topology? Could you provide a (snippet of a) 
graph?

Thanks
Guennadi
