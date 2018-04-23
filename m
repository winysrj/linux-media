Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33500 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754855AbeDWMOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:14:21 -0400
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-5-hverkuil@xs4all.nl>
 <CAAFQd5AwZZ3EXbOdpOrVMupDY8ZvzL0j0sPYxgFCicAY3tn9mA@mail.gmail.com>
 <6e932c81-200e-378b-4822-6995516c13be@xs4all.nl>
Message-ID: <ecc9827a-5e49-8f3e-71de-a2ebb5cc19bb@xs4all.nl>
Date: Mon, 23 Apr 2018 14:14:16 +0200
MIME-Version: 1.0
In-Reply-To: <6e932c81-200e-378b-4822-6995516c13be@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/23/2018 01:24 PM, Hans Verkuil wrote:
>>> +/**
>>> + * struct media_request - Media device request
>>> + * @mdev: Media device this request belongs to
>>> + * @kref: Reference count
>>> + * @debug_prefix: Prefix for debug messages (process name:fd)
>>
>> debug_str?
> 
> Hmm, I prefer debug_prefix.

Apologies, I misunderstood this.

Indeed, it should be debug_str.

Regards,

	Hans
