Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:45452 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaDYMsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 08:48:53 -0400
Received: by mail-yh0-f49.google.com with SMTP id z6so3490972yhz.8
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 05:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNWvQ1ZYL-0rK2w7yPwzm9QyyCN8JvRyjGhq5eO6rOH9dw@mail.gmail.com>
References: <5357DAC2.20005@sca-uk.com>
	<535A52CB.7060106@sca-uk.com>
	<CALzAhNWvQ1ZYL-0rK2w7yPwzm9QyyCN8JvRyjGhq5eO6rOH9dw@mail.gmail.com>
Date: Fri, 25 Apr 2014 08:48:52 -0400
Message-ID: <CALzAhNVJkMtnsHaR55C-i+pLY_nZumBsedWT-vuOhWczHd8UFQ@mail.gmail.com>
Subject: Re: Comparisons of images between Dazzle DVC100, EasyCap stk1160 and
 Hauppauge ImapctVCB-e in Linux.
From: Steven Toth <stoth@kernellabs.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Steve Cookson <steve.cookson@sca-uk.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ezequiel.garcia@free-electrons.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Doh, HTML cause vger to drop it. Resending.

On Fri, Apr 25, 2014 at 8:47 AM, Steven Toth <stoth@kernellabs.com> wrote:
> On Fri, Apr 25, 2014 at 8:19 AM, Steve Cookson <it@sca-uk.com> wrote:
>>
>> Hi Guys,
>>
>
> Hello again.
>
>>
>> (I'm copying Ezequial on this because of the work he has done on the
>> stk1160).
>>
>> My colleague (a Doctor) had this to say on the medical images I posted
>> earlier (see below):
>>
>> >  The impactVCB-e image is redder and less clear. The dvc100 and easycap
>> > seem similar to me and both of them are not as good as the original one.
>>
>> So I have to ask how is it that the cheap little EasyCap is performing at
>> the same level as the Dazzle DVC100 and better than the ImpactVCB-e?
>>
>
> Its usually either because the Linux engineers simply aren't focused on
> improving quality for the last 'mile', or that the ADC/Video digitizer
> differers between products. 'Redder' isn't usually a differentiation between
> video digitizer silicon, its miss-configuration - for example.
>
>
>>
>> It seems to me that the more complex and expensive DVC100 and ImpactVCB-e
>> should perform well and that the EasyCap should be the runner up.
>>
>
> Not necessarily, but I can understand why you may think that. The reality is
> - you are measuring the work of individuals who we're not paid to create
> these Linux drivers. They work well enough for their needs, they scratched
> their own itch, then they moved on, more than likely this is the case. So,
> you are seeing a mixture of different silicon, different attention to
> detail, different default values and different levels of commitment in the
> driver developers.
>
>> If the DVC100 and ImpactVCB-e had had the same love and attention that
>> Ezequial has shown the EasyCap would they outperform it?
>>
>
> Hard to say. With my experience working for Hauppauge, directly in their
> engineering team, having worked on literally hundreds of products, lots of
> different video digitizer, they're all fairly close quality wise in general,
> with good signals, with the right drivers.
>
> What makes a good video digitizer stand out from a poor one, it how it
> performs in very poor signal conditions.
>
>
>>
>> The ImpactVCB-e is easier to use internally and the Dazzle is external.
>> Does the fact that the ImpactVCB-e has a PCI-e connector help it at all?
>>
>
>
> Invariably not.
>
>
>>
>> Otherwise I should just focus on EasyCap for my raw SD capture and move
>> on.
>>
>
> You need to make that judgement call. If you are building a business around
> medical imaging and have no engineering capability to improve drivers, go
> with what your gut says and what's available to you today. You shouldn't
> rely on the good will of Linux engineers to fix your business requirements
> in their spare time, in the coming weeks or months.
>
> Or, hire a consultant to improve the drivers for you and the rest of the
> Linux community. This what everyone else does.
>
> - Steve
>
>>
>> Thanks,
>>
>> Steve
>>
>>
>> On 23/04/14 16:22, Steve Cookson wrote:
>>>
>>> Hi Guys,
>>>
>>> I would be interested in your views of the comparisons of these images.
>>> The still is the image of a duodenum taken during an endoscopy and recorded
>>> to a DVD player (via an s-video or composite cable).  Although the endoscope
>>> is an HD endoscope, the DVD recorder isn't and the resulting video is
>>> 720x480i59.94.
>>>
>>> Here are further details of the video:-
>>>
>>> Format : MPEG Video v2
>>> Format profile : Main@Main
>>> Format settings, BVOP : Yes, Matrix : Custom, GOP : M=3, N=15
>>> Bit rate mode : Variable
>>> Bit rate : 4 566 Kbps
>>> Maximum bit rate : 10 000 Kbps
>>> Width : 720 pixels
>>> Height : 480 pixels
>>> Display aspect ratio : 4:3
>>> Frame rate : 29.970 fps
>>> Standard : NTSC
>>> Color space : YUV
>>> Chroma subsampling : 4:2:0
>>> Bit depth : 8 bits
>>> Scan type : Interlaced
>>> Scan order : Top Field First
>>> Compression mode : Lossy
>>> Bits/(Pixel*Frame) : 0.441
>>>
>>> The video was played through Dragon Player and the video signal has
>>> exited through a mini-VGA port defined as 640x480 and passed through a
>>> VGA->S-Video converter to an s-video cable.
>>>
>>> The cable has in turn been connected in turn to a Dazzle DVC100, an
>>> EasyCap stk1160 and a Hauppauge ImapctVCB-e.
>>>
>>> Each setting (eg brightness and contrast etc) has as near as possible to
>>> mid-range and a screengrab taken.
>>>
>>> The results are shown here:
>>>
>>> Original:
>>> http://tinypic.com/usermedia.php?uo=fNkd6hpTbcMrgmD6gSf74Ih4l5k2TGxc
>>>
>>> Dazzle DVC100:
>>> http://tinypic.com/usermedia.php?uo=fNkd6hpTbcMaOf4QTsIefYh4l5k2TGxc
>>>
>>> ImpactVCB-e:
>>> http://tinypic.com/usermedia.php?uo=fNkd6hpTbcM7i72IqGujuIh4l5k2TGxc
>>>
>>> STK1160:
>>> http://tinypic.com/usermedia.php?uo=fNkd6hpTbcPO7kmQk/IS94h4l5k2TGxc
>>>
>>> I would be grateful for your views on the quality of the images.
>>>
>>> Is one of materially higher quality than the others, or can I adjust the
>>> settings to improve the quality of one of them more.
>>>
>>> It seems to me that the Hauppauge is marginally better than the others.
>>> What do you think?
>>>
>>> Can I improve the test?
>>>
>>> Regards
>>>
>>> Steve.
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>



-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
