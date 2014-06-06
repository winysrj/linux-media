Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3410 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaFFNpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 09:45:35 -0400
Message-ID: <5391C5E5.2040100@xs4all.nl>
Date: Fri, 06 Jun 2014 15:45:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Pawel Osciak <pawel@osciak.com>,
	LMML <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 2/2] v4l: vb2: Add fatal error condition flag
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <1435470.qABIAKhMXR@avalon> <53919025.1060407@xs4all.nl> <1984998.tr3slfZQtz@avalon>
In-Reply-To: <1984998.tr3slfZQtz@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2014 03:42 PM, Laurent Pinchart wrote:
> On Friday 06 June 2014 11:55:49 Hans Verkuil wrote:
>> On 06/06/2014 11:46 AM, Laurent Pinchart wrote:
>>> On Friday 06 June 2014 11:31:55 Hans Verkuil wrote:
>>>> On 06/06/2014 11:19 AM, Laurent Pinchart wrote:
>>>>> On Friday 06 June 2014 14:31:15 Pawel Osciak wrote:
>>>>>> Hi Laurent,
>>>>>> Thanks for the patch. Did you test this to work in fileio mode? Looks
>>>>>> like it should, but would like to make sure.
>>>>>
>>>>> No, I haven't tested it. The OMAP4 ISS driver, which is my test target
>>>>> for this patch, doesn't support fileio mode. Adding VB2_READ would be
>>>>> easy, but the driver requires configuring the format on the file handle
>>>>> used for streaming, so I can't just run cat /dev/video*.
>>>>
>>>> Just test with vivi.
>>>
>>> But vivi doesn't call the new vb2_queue_error() function. I understand
>>> that your vivi rework would make that easier as you now have an error
>>> control. Should I hack something similar in the existing vivi driver ? Any
>>> pointer ?
>>
>> Just hack it in for testing. E.g. call it when the button control is pressed
>> (see vivi_s_ctrl).
> 
> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> "cat /dev/video0" outputs data until vivi calls vb2_queue_error(), at which 
> points cat prints
> 
> cat: /dev/video0: Input/output error
> 
> Restarting capture works as expected.
> 

Nice.

Once this is merged I plan on adding support for this to my vivi rewrite.

Finishing the vivi rewrite (mostly cleaning things up and documentation
where appropriate) is a high-prio for me. I'd like to get this in for
3.17.

Regards,

	Hans
