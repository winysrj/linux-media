Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37573 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DEPKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 11:10:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M20008YNI58BP70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 16:10:20 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2000H04I5NMA@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 16:10:36 +0100 (BST)
Date: Thu, 05 Apr 2012 17:10:34 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 02/11] Documentation: media: description of DMABUF
 importing in V4L2
In-reply-to: <201204051758.41552.remi@remlab.net>
To: =?ISO-8859-15?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com
Message-id: <4F7DB5EA.2020506@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
 <1333634408-4960-3-git-send-email-t.stanislaws@samsung.com>
 <201204051758.41552.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
Thank you for review. Please refer to comments below.

On 04/05/2012 04:58 PM, Rémi Denis-Courmont wrote:
> Le jeudi 5 avril 2012 16:59:59 Tomasz Stanislawski, vous avez écrit :
>> This patch adds description and usage examples for importing
>> DMABUF file descriptor in V4L2.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/compat.xml         |    4 +
>>  Documentation/DocBook/media/v4l/io.xml             |  177
>> ++++++++++++++++++++ .../DocBook/media/v4l/vidioc-create-bufs.xml       | 
>>   1 +
>>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 ++
>>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    8 +-
>>  5 files changed, 203 insertions(+), 2 deletions(-)
>>

[snip]

>> +    <example>
>> +      <title>Initiating streaming I/O with DMABUF file descriptors</title>
>> +
>> +      <programlisting>
>> +&v4l2-requestbuffers; reqbuf;
>> +
>> +memset (&amp;reqbuf, 0, sizeof (reqbuf));
>> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +reqbuf.memory = V4L2_MEMORY_DMABUF;
>> +
>> +if (ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf) == -1) {
>> +	if (errno == EINVAL)
>> +		printf ("Video capturing or user pointer streaming is not 
> supported\n");
> 
> User pointer??
> 

Right. I will fix this copy & paste error.

>> +	else
>> +		perror ("VIDIOC_REQBUFS");
>> +
>> +	exit (EXIT_FAILURE);
>> +}
>> +      </programlisting>
>> +    </example>
>> +

[snip]

>> +    <para>To start and stop capturing or output applications call the
>> +&VIDIOC-STREAMON; and &VIDIOC-STREAMOFF; ioctl. Note
>> +<constant>VIDIOC_STREAMOFF</constant> removes all buffers from both queues
>> and +unlocks/unpins all buffers as a side effect. Since there is no notion
>> of doing +anything "now" on a multitasking system, if an application needs
>> to synchronize +with another event it should examine the &v4l2-buffer;
>> +<structfield>timestamp</structfield> of captured buffers, or set the field
>> +before enqueuing buffers for output.</para>
>> +
>> +    <para>Drivers implementing user pointer I/O must support the
> 
> User pointer again??
> 
> 

Yes. Another C&P mistake. Thanks for noticing it.

Regards,
Tomasz Stanislawski

