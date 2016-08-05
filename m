Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39455 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbcHEHjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 03:39:15 -0400
Subject: Re: doc-rst: too much space around ``foo`` text
To: Markus Heiser <markus.heiser@darmarit.de>
References: <cc77239c-7e8f-7c03-bcdd-e19d87998aee@xs4all.nl>
 <DD872694-1DF7-4444-9013-EBCD16801689@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cdd9f195-b304-c814-e967-3f9947a24332@xs4all.nl>
Date: Fri, 5 Aug 2016 09:39:07 +0200
MIME-Version: 1.0
In-Reply-To: <DD872694-1DF7-4444-9013-EBCD16801689@darmarit.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Did you have time to look at this yet? It is for me something that is really
distracting. I tried to track this down myself but I just don't know enough about
html/css.

The text ``V4L2_XFER_FUNC_709`` is translated to:

<code class="docutils literal"><span class="pre">V4L2_XFER_FUNC_709</span></code>.

And it is the <code> part that adds the extra spacing somewhere.

Originally <code> added a rectangle around the text, so I suspect that the extra spacing
for that rectangle is still added somewhere.

Regards.

	Hans

On 07/09/2016 10:40 AM, Markus Heiser wrote:
> Hi Hans,
> 
> Am 08.07.2016 um 22:52 schrieb Hans Verkuil <hverkuil@xs4all.nl>:
> 
>> Hi Markus,
>>
>> First of all a big 'Thank you!' for working on this, very much appreciated.
>> And I also am very grateful that you could convert the CEC docs so quickly for me.
> 
> You are welcome :)
> 
>> That said, can you take a look at this:
>>
>> https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/vidioc-enum-fmt.html
>>
>> As you can see, every text written as ``foo`` in the rst file has a bit too much space
>> around it. It's especially clear in the description of the 'type' field: the commas
>> after each V4L2_BUF_TYPE_ constant should be right after the last character, and now
>> it looks as if there is a space in front.
>>
>> It's jarring when you read it, but it is probably easy to fix for someone who knows
>> this stuff.
> 
> Yes, this is a good point, the layout of inline constant markup bothers me also.
> The Read-The-Doc (RTD) theme we use is IMHO the best on the web, since it is well
> maintained and supports a good layout on various viewports:
> 
>   http://read-the-docs.readthedocs.io/en/latest/theme.html
> 
> Nevertheless I think in some details it is a bit to excessive.
> 
> I will place it on my TODO list .. hopefully I find the time to solve
> it in the next days.
> 
> -- Markus --
> 
>>
>> Thanks!
>>
>> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
