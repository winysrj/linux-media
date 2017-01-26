Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753126AbdAZLMO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 06:12:14 -0500
Date: Thu, 26 Jan 2017 12:11:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Metadata node IRC discussion on 19.01.2017
Message-ID: <Pine.LNX.4.64.1701261049260.5285@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

A discussion of per-frame metadata took place on 19.01 on IRC. 
Participants: everybody in CC and myself. An earlier email on this mailing 
list 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg107013.html 
served as a basis. The current state of the patches is:

[v2.2,1/4] v4l: Add metadata buffer type and format
https://patchwork.linuxtv.org/patch/36810/ 
[v3,4/4] uvcvideo: add a metadata device node
https://patchwork.linuxtv.org/patch/38581/

1. are separate metadata nodes really the best approach?

One of the main reasons to use a separate /dev/video* node for per-frame 
metadata is to achieve maximum flexibility. In some cases metadata is 
produced and sent by the hardware before the complete video frame has been 
captured. E.g. image statistics, which is often calculated only over a 
part of the image to make it available as soon as possible. There are also 
use-cases, which can benefit from metadata being available before the 
frame has been transferred completely.

The concern, that has been raised, is the difficulty to match metadata and 
image buffers. As a solution, the matching should be done, based on buffer 
sequence numbers. The drivers must make sure to always use matching 
sequence numbers. If any of the buffers got lost, the respective number 
will be skipped. To enable this a requirement for the first buffer on a 
video device node to have sequence number 0 should be removed.

Further the request API can be used to match image and metadata buffers, 
once that API is available.

2. how should the image and metadata device nodes be associated?

The Media Controller API should be used for this. E.g. on UVC both the 
image and the metadata video device nodes should have links from the same 
pad on the last entity in the video chain. It should be noted though, that 
linking one (source) pad to two (sink) pads isn't always possible. It 
would be impossible, if respective subdevices were creating device nodes 
themselves, thus providing a user API to them. The UVC driver doesn't do 
that, so, such linking should be possible.

[remaining question] It should be possible to write a generic user-space 
application, that is be able to match image and metadata device nodes. On 
UVC this matching will be done by checking links to the same source pad. 
On other camera configurations this would be impossible, so, a different 
matching approach would be used. How can a generic application be written 
then?

3. how to handle isochronous video streaming interfaces on UVC cameras?

As proposed in the above mentioned email, contents of payload headers 
should be exported via metadata nodes on UVC cameras. Those headers 
contain (currently, as of UVC standard 1.5) up to 12 bytes of standard 
data, but the size field of the header is 1 byte, therefore up to 255 
bytes can be transferred in each payload header. Importantly, the standard 
UVC payload headers can include timestampe in the camera and the USB time 
bases, which can be required in the user-space.

UVC video streaming interfaces can use isochronous or bulk endpoints. On 
bulk endpoints each frame is transferred as one payload. That limits the 
metadata amount to 255 bytes per frame.

The problem with isochronous UVC interfaces is, that the frame can be 
transferred over USB in arbitrary many payloads. Some of them can even 
only consist of the minimal 2-byte header. Ideally all headers, belonging 
to a single video frame, should be transferred to the user in a single 
metadata buffer. This is problematic, because the maximum size of the 
metadata is unknown.

No decision has been made on this topic.

[proposal] to support isochronous endpoints, a decision has to be made to 
use a certain buffer size. The easiest way to handle excessive data would 
be to drop it. Alternatively a ring-buffer approach could be used to drop 
earlier headers and keep the later ones. Simultaneously statistics can be 
collected about the number and the size of acquired headers. That 
statistics can be made available to the user in a UVC-specific control. 
That way after an initial streaming session, an application could 
re-adjust its buffer size for the following sessions. Additionally entries 
can be added to the internal uvcvideo device table with maximum metadata 
size. That way the control could return one field for cameras in the 
device table, which would be 0 for unknown cameras, and further fields for 
any dynamically calculated information.

Thanks
Guennadi
