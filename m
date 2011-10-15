Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:40436 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1JOAZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 20:25:12 -0400
Message-ID: <4E98D2E5.4070805@mlbassoc.com>
Date: Fri, 14 Oct 2011 18:25:09 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OMAP3 ISP - interlaced data incorrect
References: <4E98C09B.2060800@mlbassoc.com> <CA+2YH7uo-CqvW9ez9xtQ-7pTB_nnemL_7hsOAQ6vX-S-wju9dA@mail.gmail.com>
In-Reply-To: <CA+2YH7uo-CqvW9ez9xtQ-7pTB_nnemL_7hsOAQ6vX-S-wju9dA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-14 17:43, Enrico wrote:
> On Sat, Oct 15, 2011 at 1:07 AM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> For days, I've been chasing ghosts :-)  I know they are still there,
>> but I think they are more a function of the source than the ISP setup.
>> So, I went looking for a better source, NTSC in my case.  My choice is
>> is a DVD player with known good video (I'm convinced that my cheap NTSC
>> camera produces crap, especially when there is a lot of motion in the
>> frames).  Looking at this on an analogue TV (yes, they still exist!),
>> the picture is not bad, so I think it's a good choice, at least when
>> trying to understand what's happening with the OMAP3 ISP.
>>
>> Look at these two pictures:
>>   http://www.mlbassoc.com/misc/nemo-00001.png
>>   http://www.mlbassoc.com/misc/nemo-swapped-00001.png
>>
>> These represent one frame of data captured via my OMAP3 ISP + TVP5150
>> from a DVD (sorry, Disney).  The first is a raw conversion of the
>> frame using ffmpeg.  As you can see, there seem to be lines swapped,
>> so I wrote a little program to swap the lines even/odd.  The second
>> (nemo-swapped) shows what this looks like.  Obviously, the data is
>> not being stored in memory correctly.  Does anyone know how to adjust
>> the ISP to make this work the right way around?  Currently in ispccdc.c, we
>> have:
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN,
>> 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD,
>> 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN,
>> 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>>
>> I tried this:
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN,
>> 2);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD,
>> 0);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN,
>> 2);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 0);
>> but this lead to a kernel panic :-(
>>
>> Somehow, we need to be storing the data something like this:
>>    EE EE EE EE ...
>>    EO EO EO EO ...
>>    OE OE OE OE ...
>>    OO OO OO OO ...
>> but the current layout is               ccdc_config_outlineoffset(ccdc,
>> pix.bytesperline, EVENEVEN, 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD,
>> 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN,
>> 1);
>>                 ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>>
>>    EO EO EO EO ...
>>    EE EE EE EE ...
>>    OO OO OO OO ...
>>    OE OE OE OE ...
>>
>> First, I need to get the data into memory in the correct order :-)
>>
>> Note: these results are consistent, i.e. if I stop things and do another
>> grab, they are incorrect in the same [wrong] order.
>
>
> Just set the FINV bit (search for it in ispccdc.c), i tested it before
> and i had the opposite result (from a good looking nemo-swapped-like
> picture to a bad one).

That works great, thanks.  Maybe we need another user flag, like fldmode,
for this?

>
>
>>     I've not done any recent tests with the gstreamer modules and the TI DSP
>> code,
>>     but I will shortly.  We'll see how well that does.
>
> I've tested it with the dsp and nothing changes, same problems. But i
> will be happy if proven wrong!

I'll play with this a bit more tomorrow.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
