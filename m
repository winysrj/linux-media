Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36092 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752486AbeBSLBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 06:01:20 -0500
Subject: Re: [PATCHv2 3/9] staging: atomisp: Kill subdev s_parm abuse
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
 <20180122123125.24709-4-hverkuil@xs4all.nl>
 <20180214141430.1866afeb@vento.lan>
 <20180216090436.muvu3acgz7444vdf@valkosipuli.retiisi.org.uk>
 <20180216095826.569575d9@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1f778157-ee8c-9157-641f-cdb77f205746@xs4all.nl>
Date: Mon, 19 Feb 2018 12:01:08 +0100
MIME-Version: 1.0
In-Reply-To: <20180216095826.569575d9@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2018 12:58 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Feb 2018 11:04:36 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> On Wed, Feb 14, 2018 at 02:14:30PM -0200, Mauro Carvalho Chehab wrote:
>>> Sakari,
>>>
>>> Em Mon, 22 Jan 2018 13:31:19 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>   
>>>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>
>>>> Remove sensor driver's interface that made use of use case specific
>>>> knowledge of platform capabilities.  
>>>
>>> Could you better describe it? What s_param abuse?
>>> What happens after this patch? It seems that atomISP relies on  
>>
>> I'd like to remind you this is a staging driver that got where it is
>> without any review.
> 
> Ok, but this is not an excuse to not properly document any further
> patches to it.
> 
>> If you insist on improving the commit message, then
>> this is what I propose:
>>
>> Remove sensor driver's interface for setting the use case specific mode
>> list as well as the mode lists that are related to other than
>> CI_MODE_PREVIEW. This removes s_parm abuse in using driver specific values
>> in v4l2_streamparm.capture.capturemode. The drivers already support
>> [gs]_frame_interval so removing support for [gs]_parm is enough.
> 
> Works for me.

I'll update the commit message for this patch.

Regards,

	Hans
