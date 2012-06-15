Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:36787 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab2FORtE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 13:49:04 -0400
Message-ID: <4FDB7582.6030703@iki.fi>
Date: Fri, 15 Jun 2012 20:48:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl, snjw23@gmail.com,
	t.stanislaws@samsung.com
Subject: Re: [PATCH v4 7/7] v4l: Correct conflicting V4L2 subdev selection
 API documentation
References: <4FDB3C2E.9060502@iki.fi> <1580520.TYuvdPHuRK@avalon> <20120615153150.GJ12505@valkosipuli.retiisi.org.uk> <1969837.7mioik4VZv@avalon>
In-Reply-To: <1969837.7mioik4VZv@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 15 June 2012 18:31:50 Sakari Ailus wrote:
>> On Fri, Jun 15, 2012 at 04:14:21PM +0200, Laurent Pinchart wrote:
>>> On Friday 15 June 2012 16:44:40 Sakari Ailus wrote:
>>>> The API reference documents that the KEEP_CONFIG flag tells the
>>>> configuration should not be propatgated by the driver whereas the
>>>> interface
>>>
>>> s/propatgated/propagated/

Fixed.

>>>> documentation (dev-subdev.xml) categorically prohibited any changes to
>>>> the
>>>> rest of the pipeline. The latter makes no sense, since it would severely
>>>> limit the usefulness of the KEEP_CONFIG flag.
>>>>
>>>> Correct the documentation in dev-subddev.xml.
>>>>
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>> ---
>>>>
>>>>  Documentation/DocBook/media/v4l/dev-subdev.xml |   10 +++++-----
>>>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
>>>> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 8c44b3f..95ebf87
>>>> 100644
>>>> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
>>>> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
>>>> @@ -361,11 +361,11 @@
>>>>
>>>>        performed by the user: the changes made will be propagated to
>>>>        any subsequent stages. If this behaviour is not desired, the
>>>>        user must set
>>>>
>>>> -      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
>>>> -      flag causes no propagation of the changes are allowed in any
>>>> -      circumstances. This may also cause the accessed rectangle to be
>>>> -      adjusted by the driver, depending on the properties of the
>>>> -      underlying hardware.</para>
>>>> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag,
>>>
>>> This should be V4L2_SEL_FLAG_KEEP_CONFIG.

Fixed in patch number 4.

>>>> +      which tells the driver to make minimum changes to the rest of
>>>> +      the subdev's configuration.
>>>
>>> I'm not sure to like this. "minimum changes" is not clearly defined. Isn't
>>> the point of the KEEP_CONFIG flag is to avoid propagating *any* change
>>> down the pipeline inside the subdev ?
>>
>> Yes, but the hardware may have restrictions that essentially makes the
>> configuration static is absolutely no changes are allowed elsewhere. In
>> those cases it should be possible to allow changes elsewhere.
>>
>> Or do you think we should just completely disallow them? Would that work
>> e.g. for the OMAP 3 ISP resizer?
> 
> I think the point of KEEP_CONFIG was to disallow changes completely, to make 
> it possible to change the digital zoom factor during streaming for instance. 
> The OMAP3 ISP resizer should accomodate that. If we allow changes under "some 
> circumstances" applications won't be able to rely on the flag.

Let's do this: I make this change to the patch, i.e. disallow changing
other rectangles or the format. If we feel we need to change that it'll
probably be in 3.6 timeframe. It's also easier to allow doing more
things than less --- the likeliness of any possible regression is
smaller than denying what used to be possible previously.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi


