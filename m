Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56023 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390932AbeHPNNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:13:50 -0400
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
 <20180814142047.93856-2-hverkuil@xs4all.nl> <2183957.pVXMYXPWuc@avalon>
 <2eb63571-dd07-b00e-4e42-38fc2f42530b@xs4all.nl>
Message-ID: <74db3b1f-168e-3577-9fea-778d84b3d2a3@xs4all.nl>
Date: Thu, 16 Aug 2018 12:16:15 +0200
MIME-Version: 1.0
In-Reply-To: <2eb63571-dd07-b00e-4e42-38fc2f42530b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/08/18 11:58, Hans Verkuil wrote:
>>> +On success :c:func:`poll() <request-func-poll>` returns the number of file
>>> +descriptors that have been selected (that is, file descriptors for which
>>> the +``revents`` field of the respective struct :c:type:`pollfd`
>>> +is non-zero). Request file descriptor set the ``POLLPRI`` flag in
>>> ``revents`` +when the request was completed.  When the function times out
>>> it returns +a value of zero, on failure it returns -1 and the ``errno``
>>> variable is +set appropriately.
>>> +
>>> +Attempting to poll for a request that is completed or not yet queued will
>>> +set the ``POLLERR`` flag in ``revents``.
>>
>> Why should a completed request set POLLERR, given that the purpose of poll() 
>> is to poll for completion ?
> 
> I think you are right. We should just always set POLLPRI for completed requests.
> I'll change that.

I checked the code, and this is actually what happens already. So the text should
read:

"Attempting to poll for a request that is not yet queued will set the ``POLLERR``
flag in ``revents``."

I'll update this.

Regards,

	Hans
