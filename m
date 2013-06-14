Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34954 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3FNJxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 05:53:35 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOD00900NGWSIC0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Jun 2013 10:53:33 +0100 (BST)
Message-id: <51BAE81B.4050008@samsung.com>
Date: Fri, 14 Jun 2013 11:53:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	avnd.kiran@samsung.com
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
 <1370870586-24141-6-git-send-email-arun.kk@samsung.com>
 <51B5D876.2000704@samsung.com>
 <CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
In-reply-to: <CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 06/14/2013 11:26 AM, Arun Kumar K wrote:
> Hi Sylwester,
> 
>>> +     static const char * const vpx_num_partitions[] = {
>>> +             "1 partition",
>>> +             "2 partitions",
>>> +             "4 partitions",
>>> +             "8 partitions",
>>> +             NULL,
>>> +     };
>>> +     static const char * const vpx_num_ref_frames[] = {
>>> +             "1 reference frame",
>>> +             "2 reference frame",
>>> +             NULL,
>>> +     };
>>
>> Have you considered using V4L2_CTRL_TYPE_INTEGER_MENU control type for this ?
>> One example is V4L2_CID_ISO_SENSITIVITY control.
>>
> 
> If I understand correctly, V4L2_CTRL_TYPE_INTEGER_MENU is used for
> controls where
> the driver / IP can support different values depending on its capabilities.

No, not really, it just happens there is no INTEGER_MENU control with standard
values yet. I think there are some (minor) changes needed in the v4l2-ctrls
code to support INTEGER_MENU control with standard menu items.

> But here VP8 standard supports only 4 options for no. of partitions
> that is 1, 2, 4 and 8.

I think such a standard menu list should be defined in v4l2-ctrls.c then.

> Also for number of ref frames, the standard allows only the options 1,
> 2 and 3 which
> cannot be extended more. So is it correct to use INTEGER_MENU control here and
> let the driver define the values?

If this is standard then the core should define available menu items. But
it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
opinions though.

Regards,
Sylwester
