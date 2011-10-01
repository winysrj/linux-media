Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40424 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1JAKDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 06:03:10 -0400
Received: by eya28 with SMTP id 28so1669162eya.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 03:03:09 -0700 (PDT)
Message-ID: <4E86E554.1040400@gmail.com>
Date: Sat, 01 Oct 2011 12:03:00 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com> <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com> <4E70BA97.1090904@samsung.com> <201109261625.03748.hverkuil@xs4all.nl>
In-Reply-To: <201109261625.03748.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 09/26/2011 04:25 PM, Hans Verkuil wrote:
> On Wednesday, September 14, 2011 16:30:47 Sylwester Nawrocki wrote:
>> On 09/14/2011 09:10 AM, Scott Jiang wrote:
>>>>> +static int bcap_qbuf(struct file *file, void *priv,
>>>>> +                     struct v4l2_buffer *buf)
>>>>> +{
>>>>> +     struct bcap_device *bcap_dev = video_drvdata(file);
>>>>> +     struct v4l2_fh *fh = file->private_data;
>>>>> +     struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
>>>>> +
>>>>> +     if (!bcap_fh->io_allowed)
>>>>> +             return -EACCES;
>>>>
>>>> I suppose -EBUSY would be more appropriate here.
>>>>
>>> no, io_allowed is to control which file instance has the right to do I/O.
>>
>> Looks like you are doing here what the v4l2 priority mechanism is meant for.
>> Have you considered the access priority (VIDIOC_G_PRIORITY/VIDIOC_S_PRIORITY
>> and friends)? Does it have any shortcomings?
> 
> Sylwester, the priority handling doesn't take care of this particular case.
> 
> When it comes to streaming you need to administrate which filehandle started
> the streaming and block any other filehandle from interfering with that.
> 
> This check should really be done in vb2.

True, I've noticed QBUF/DQBUF are not touched by the priority handling.
Perhaps I didn't follow the discussions in this topic carefully enough.

Then we seem to have another feature request for vb2.

--
Thanks,
Sylwester
