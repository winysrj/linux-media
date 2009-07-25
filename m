Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:62020 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZGYReq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 13:34:46 -0400
Received: by bwz28 with SMTP id 28so1921897bwz.37
        for <linux-media@vger.kernel.org>; Sat, 25 Jul 2009 10:34:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907251844.45017.hverkuil@xs4all.nl>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com>
	 <200907251639.18441.hverkuil@xs4all.nl>
	 <20090725144127.GI10561@esdhcp037198.research.nokia.com>
	 <200907251844.45017.hverkuil@xs4all.nl>
Date: Sat, 25 Jul 2009 20:34:44 +0300
Message-ID: <a0580c510907251034k5ce303f4gd93c8cf66ee4856c@mail.gmail.com>
Subject: Re: Changes to the string control handling
From: Eduardo Valentin <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: eduardo.valentin@nokia.com,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"dougsland@gmail.com" <dougsland@gmail.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Sat, Jul 25, 2009 at 7:44 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> Hi Eduardo,
>
> On Saturday 25 July 2009 16:41:27 Eduardo Valentin wrote:
>> On Sat, Jul 25, 2009 at 04:39:18PM +0200, ext Hans Verkuil wrote:
>> > If the string must be exactly 8 x n long, then I think that it is a good idea
>> > to start using the 'step' value of v4l2_queryctrl: this can be used to tell
>> > the application that string lengths should be a multiple of the step value.
>> > I've toyed with that idea before but I couldn't think of a good use case,
>> > but this might be it.
>>
>> I think that would be good. It is a way to report to user land what can be
>> done in these cases which strings can be chopped in small pieces. Of course,
>> documenting this part it is appreciated.
>
> Ok, I've implemented this. While doing this I realized that I had to change
> a few things:
>
> 1) the 'length' field in v4l2_ext_control has been renamed to 'size'. The
> name 'length' was too easy to confuse with 'string length' while in reality
> it referred to the memory size of the control payload. 'size' is more
> appropriate.
>
> 2) the 'minimum' and 'maximum' fields of v4l2_queryctrl now return the min
> and max string lengths, i.e. *without* terminating zero. I realized that what
> VIDIOC_QUERYCTRL returns has nothing to do with how much memory to reserve
> for the string control. It is about the properties of the string itself
> and it is not normal to include the terminating zero when talking about a
> string length.
>
> I've incorporated everything in my v4l-dvb-strctrl tree. I apologize for the
> fact that you have to make yet another series of patches, but these changes
> are typical when you start implementing and documenting a new feature for
> the first time.

I believe now things about string handling are becoming much clear this way.
No worries about the fact that we need another (or even more) series for si4713.
As it is the first driver using the new API, it is better to forge it
properly, so people
can use it as example.

When I come back to office, I'll have the opportunity to test the new series.
Only after that I can send it again. But I will try to send it as soon
as possible.

>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Eduardo Bezerra Valentin
