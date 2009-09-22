Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64051 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZIVDbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 23:31:15 -0400
Received: by bwz6 with SMTP id 6so2369028bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 20:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253584852.3279.11.camel@pc07.localdom.local>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
	 <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
	 <1253506233.3255.6.camel@pc07.localdom.local>
	 <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
	 <1253508863.3255.10.camel@pc07.localdom.local>
	 <d9def9db0909210302m44f8ed77wfca6be3693491233@mail.gmail.com>
	 <1253584852.3279.11.camel@pc07.localdom.local>
Date: Tue, 22 Sep 2009 05:31:17 +0200
Message-ID: <d9def9db0909212031q67e12ba7j9030063baf19a98@mail.gmail.com>
Subject: Re: Bug in S2 API...
From: Markus Rechberger <mrechberger@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 4:00 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hi Markus,
>
> Am Montag, den 21.09.2009, 12:02 +0200 schrieb Markus Rechberger:
>> ----
>> in dvb-frontend.c:
>>  ----
>>          if(cmd == FE_GET_PROPERTY) {
>>
>>                  tvps = (struct dtv_properties __user *)parg;
>>                  dprintk("%s() properties.num = %d\n", __func__, tvps->num);
>>                  dprintk("%s() properties.props = %p\n", __func__, tvps->props);
>>                  ...
>>                  if (copy_from_user(tvp, tvps->props, tvps->num *
>>  sizeof(struct dtv_property)))
>>  ----
>>
>>
>> > OK,
>> >
>> > thought I'll have never to care for it again.
>> >
>> > ENUM calls should never be W.
>> >
>> > Hit me for all I missed.
>> >
>> > Cheers,
>> > Hermann
>>
>> you are not seeing the point of it it seems
>
> you are right, I do not see your point at all, but I was wrong for the
> get calls.
>
> We had such discussions on v4l ioctls previously.
>
> The result was to keep them as is and not to change IOR to IOWR to keep
> compatibility.
>
> This is six years back.
>

I think they all have got fixed up for v4l2 back then

#ifdef __OLD_VIDIOC_
/* for compatibility, will go away some day */
#define VIDIOC_OVERLAY_OLD      _IOWR('V', 14, int)
#define VIDIOC_S_PARM_OLD        _IOW('V', 22, struct v4l2_streamparm)
#define VIDIOC_S_CTRL_OLD        _IOW('V', 28, struct v4l2_control)
#define VIDIOC_G_AUDIO_OLD      _IOWR('V', 33, struct v4l2_audio)
#define VIDIOC_G_AUDOUT_OLD     _IOWR('V', 49, struct v4l2_audioout)
#define VIDIOC_CROPCAP_OLD       _IOR('V', 58, struct v4l2_cropcap)
#endif

to eg:
#define VIDIOC_OVERLAY           _IOW('V', 14, int)
#define VIDIOC_S_PARM           _IOWR('V', 22, struct v4l2_streamparm)
#define VIDIOC_S_CTRL           _IOWR('V', 28, struct v4l2_control)
#define VIDIOC_G_AUDIO           _IOR('V', 33, struct v4l2_audio)
#define VIDIOC_G_AUDOUT          _IOR('V', 49, struct v4l2_audioout)
#define VIDIOC_CROPCAP          _IOWR('V', 58, struct v4l2_cropcap)

so only the DVB-API remains bugged now.

Markus
