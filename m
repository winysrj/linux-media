Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f184.google.com ([209.85.222.184]:60250 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZIOESx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 00:18:53 -0400
Received: by pzk14 with SMTP id 14so3133989pzk.1
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 21:18:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090915140715.2b9ea890@glory.loctelecom.ru>
References: <20090819160700.049985b5@glory.loctelecom.ru>
	 <37219a840908250940m3393f73ftbaa28639ca0f93cd@mail.gmail.com>
	 <20090910152510.6970f8ab@glory.loctelecom.ru>
	 <303a8ee30909140555y32d86999x5b4aaf7417fba293@mail.gmail.com>
	 <20090915140715.2b9ea890@glory.loctelecom.ru>
Date: Tue, 15 Sep 2009 00:18:55 -0400
Message-ID: <303a8ee30909142118h6808a249o2cb22570fca8dfd4@mail.gmail.com>
Subject: Re: tuner, code for discuss
From: Michael Krufky <mkrufky@kernellabs.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 15, 2009 at 12:07 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> On Mon, 14 Sep 2009 08:55:22 -0400
> Michael Krufky <mkrufky@kernellabs.com> wrote:
>
>> On Thu, Sep 10, 2009 at 1:25 AM, Dmitri Belimov <d.belimov@gmail.com>
>> wrote:
>> > Hi All
>> >
>> > This is my next patch.
>> >
>> > Changes:
>> > 1. By default charge pump is ON
>> > 2. For radio mode charge pump set to OFF
>> > 3. Set correct AGC value in radio mode
>> > 4. Add control gain of AGC.
>> > 5. New function simple_get_tv_gain and simple_set_tv_gain for
>> > read/write gain of AGC. 6. Add some code for control gain from
>> > saa7134 part. By default this control is OFF 7. When TV card can
>> > manipulate this control, enable it.
>> >
>> > Main changes is control value of AGC TOP in .initdata =
>> > tua603x_agc112 array. Use this value for set AGC TOP after set freq
>> > of TV.
>> >
>> > I don't understand how to correct call new function for read/write
>> > value of AGC TOP.
>> >
>> > What you think about it??
>> >
>>
>> [patch snipped]
>>
>> >
>> >
>> > With my best regards, Dmitry.
>>
>> Dmitry,
>>
>> The direct usage of .initdata and .sleepdata is probably unnecessary
>> here --  If you trace how the tuner-simple driver works, you'll find
>> that simply having these fields defined will cause these bytes to be
>> written at the appropriate moment.
>>
>> However, for the actual sake of setting this gain value, I'm not sure
>> that initdata / sleep data is the right place for it either.  (I know
>> that I recommended something like this at first, but at the time I
>> didn't realize that there is a range of six acceptable values for this
>> field)
>>
>> What I would still like to understand is:  Who will be changing this
>> value?  I see that you've added a control to the saa7134 driver -- is
>> this to be manipulated from userspace?
>
> Yes
>
>> Under what conditions will somebody want to change this value?
>
> for SECAM with strong signal we have wide white crap on the screen.
> Need reduce value of AGC TOP.
>
> For weak signal need increase value of AGC TOP
> Ajust value of AGC TOP can get more better image quality.
>
>> How will users know that they need to alter this gain value?
>
> By default use value from .initdata
> v4l2-ctl can modify this value or via some plugins for TV wach programm.
>
> End-user programm for watch TV IMHO now is very poor.
>
> With my best regards, Dmitry.
>

I have to admit that I am not familiar enough with SECAM myself to see
this kind of trouble.  For NTSC and PAL, tvtime is a great application
-- the only shortcoming that bothers me about tvtime is lack of audio
support.  One must rely on a separate mechanism to hear audio, whether
it's a patch cable from the tv tuner to the sound board, or a separate
application decoding DMA audio.  ...but that is not what this email
thread is about.

As far as simple tuning and analog television viewing goes, tvtime
rocks.  Is it really that difficult for SECAM users?

In summary, you are telling us that we need to add userspace controls
to handle gain control, for tuning SECAM.  I am going to have to ask
for help on this topic from those cc'd on this email.  (Adding Hans
Verkuil, as I value his opinion for controls and dealing with video
standards in high regard)

Personally, I don't quite understand why we would need to add such
controls NOW, while we've supported this video standard for years
already.  I am not arguing against this in any way, but I dont feel
like I'm qualified to accept this addition without hearing the
opinions of others first.

Can somebody help to shed some light?

Cheers,

Mike
