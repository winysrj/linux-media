Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:44578 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbcHEIHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2016 04:07:07 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: doc-rst: too much space around ``foo`` text
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <cdd9f195-b304-c814-e967-3f9947a24332@xs4all.nl>
Date: Fri, 5 Aug 2016 10:06:24 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <28CDFC04-E421-4191-AB4C-E6546AAB1909@darmarit.de>
References: <cc77239c-7e8f-7c03-bcdd-e19d87998aee@xs4all.nl> <DD872694-1DF7-4444-9013-EBCD16801689@darmarit.de> <cdd9f195-b304-c814-e967-3f9947a24332@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 05.08.2016 um 09:39 schrieb Hans Verkuil <hverkuil@xs4all.nl>:

> Hi Markus,
> 
> Did you have time to look at this yet? It is for me something that is really
> distracting. I tried to track this down myself but I just don't know enough about
> html/css.
> 
> The text ``V4L2_XFER_FUNC_709`` is translated to:
> 
> <code class="docutils literal"><span class="pre">V4L2_XFER_FUNC_709</span></code>.
> 
> And it is the <code> part that adds the extra spacing somewhere.
> 
> Originally <code> added a rectangle around the text, so I suspect that the extra spacing
> for that rectangle is still added somewhere.
> 
> Regards.
> 
> 	Hans
> 

Hi Hans,

sorry I forgot your requirement ... my TODO list is to long ;-). 

Yes, this is a 5pt padding (left/right) of the <code> tag.

I drop the padding and send a patch ...

-- Markus --


> On 07/09/2016 10:40 AM, Markus Heiser wrote:
>> Hi Hans,
>> 
>> Am 08.07.2016 um 22:52 schrieb Hans Verkuil <hverkuil@xs4all.nl>:
>> 
>>> Hi Markus,
>>> 
>>> First of all a big 'Thank you!' for working on this, very much appreciated.
>>> And I also am very grateful that you could convert the CEC docs so quickly for me.
>> 
>> You are welcome :)
>> 
>>> That said, can you take a look at this:
>>> 
>>> https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/vidioc-enum-fmt.html
>>> 
>>> As you can see, every text written as ``foo`` in the rst file has a bit too much space
>>> around it. It's especially clear in the description of the 'type' field: the commas
>>> after each V4L2_BUF_TYPE_ constant should be right after the last character, and now
>>> it looks as if there is a space in front.
>>> 
>>> It's jarring when you read it, but it is probably easy to fix for someone who knows
>>> this stuff.
>> 
>> Yes, this is a good point, the layout of inline constant markup bothers me also.
>> The Read-The-Doc (RTD) theme we use is IMHO the best on the web, since it is well
>> maintained and supports a good layout on various viewports:
>> 
>>  http://read-the-docs.readthedocs.io/en/latest/theme.html
>> 
>> Nevertheless I think in some details it is a bit to excessive.
>> 
>> I will place it on my TODO list .. hopefully I find the time to solve
>> it in the next days.
>> 
>> -- Markus --
>> 
>>> 
>>> Thanks!
>>> 
>>> 	Hans
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

