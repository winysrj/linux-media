Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m82LuMg4007267
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 17:56:23 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m82LuAbn013544
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 17:56:10 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2363902rvb.51
	for <video4linux-list@redhat.com>; Tue, 02 Sep 2008 14:56:10 -0700 (PDT)
Message-ID: <2df568dc0809021456j3beba9do84c718eb5ffdd99d@mail.gmail.com>
Date: Tue, 2 Sep 2008 15:56:09 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <200808262258.43478.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2df568dc0808261327w4fadadebm37b9516a5c4975b6@mail.gmail.com>
	<200808262258.43478.hverkuil@xs4all.nl>
Subject: Re: saa7134_empress streaming via v4l2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, Aug 26, 2008 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday 26 August 2008 22:27:03 Gordon Smith wrote:
>> Hello -
>>
>> I have a RTD Technologies VFG7350 (saa7134 based, two channel,
> hardware
>> encoder per channel, no tuner).
>>
>> Should v4l2 show MPEG extended controls for a saa7134_empress device?
>
> Not in that kernel. It was broken.
>
>> If so,
>> any hints about how to restore the controls?
>
> I would love it if you could try this development tree:
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-empress/
>
> I literally merged the last change this evening to 'revive' the empress
> driver after it was solidly broken in recent kernels. It should have
> the MPEG controls and I would really like to know whether it is working
> for you.
>
> For my BeholdTV M6 card I see the standard user controls on both
> devices, I get the private controls on the first device and I get the
> MPEG controls on the second device.
>
> Regards,
>
>        Hans
>

An update after private discussion with Hans Verkuil:

Using either a fresh v4l-dvb (as of today) or the codebase listed
above, saa7134 based card now has MPEG controls restored.

Solution was:
 - Update code
 - Remove i2c address parameters (force and ignore) from saa6752hs
module (that were necessary in the past?)

In 2.6.25-gentoo-r7 + v4l-dvb, MPEG controls have returned:
{{{
$ v4l2-apps/util/v4l2-ctl --list-ctrls --device /dev/video2

User Controls

                     brightness (int)  : min=0 max=255 step=1
default=128 value=128
                       contrast (int)  : min=0 max=127 step=1
default=68 value=68
                     saturation (int)  : min=0 max=127 step=1
default=64 value=64
                            hue (int)  : min=-128 max=127 step=1
default=0 value=0
                         volume (int)  : min=-15 max=15 step=1 default=0 value=0
                           mute (bool) : default=0 value=1
                         mirror (bool) : default=0 value=0

MPEG Encoder Controls

                    stream_type (menu) : min=1 max=1 default=1 value=1
flags=update
       audio_sampling_frequency (menu) : min=1 max=1 default=1 value=1
                 audio_encoding (menu) : min=1 max=1 default=1 value=1
flags=update
         audio_layer_ii_bitrate (menu) : min=11 max=13 default=11 value=11
                 video_encoding (menu) : min=1 max=1 default=1 value=1
                   video_aspect (menu) : min=1 max=2 default=1 value=1
             video_bitrate_mode (menu) : min=0 max=1 default=0 value=0
flags=update
                  video_bitrate (int)  : min=0 max=27000000 step=1
default=6000000 value=0
             video_peak_bitrate (int)  : min=0 max=27000000 step=1
default=8000000 value=0

}}}

>>
>> Below is control listing in 2.6.25-gentoo-r7 + v4l-dvb:
>> ----------------------------------------
>> $ v4l2-ctl  --list-ctrls --device=/dev/video2
>>
>> User Controls
>>
>>                      brightness (int)  : min=0 max=255 step=1
> default=128
>> value=128
>>                        contrast (int)  : min=0 max=127 step=1
> default=68
>> value=68
>>                      saturation (int)  : min=0 max=127 step=1
> default=64
>> value=64
>>                             hue (int)  : min=-128 max=127 step=1
> default=0
>> value=0
>>                          volume (int)  : min=-15 max=15 step=1
> default=0
>> value=0
>>                            mute (bool) : default=0 value=1
>>                          mirror (bool) : default=0 value=0
>>
>> MPEG Encoder Controls
>> ----------------------------------------
>>
>> Below is control listing in 2.6.22-gentoo-r10 (also shows "private
>> controls"):
>> ----------------------------------------
>> $ v4l2-ctl  --list-ctrls --device=/dev/video2
>>                      brightness (int)  : min=0 max=255 step=1
> default=128
>> value=128
>>                        contrast (int)  : min=0 max=127 step=1
> default=68
>> value=68
>>                      saturation (int)  : min=0 max=127 step=1
> default=64
>> value=64
>>                             hue (int)  : min=-128 max=127 step=1
> default=0
>> value=0
>>                          volume (int)  : min=-15 max=15 step=1
> default=0
>> value=0
>>                            mute (bool) : default=0 value=1
>>                          mirror (bool) : default=0 value=0
>>                          invert (bool) : default=0 value=0
>>              y_offset_odd_field (int)  : min=0 max=128 step=0
> default=0
>> value=0
>>             y_offset_even_field (int)  : min=0 max=128 step=0
> default=0
>> value=0
>>                        automute (bool) : default=1 value=1
>> ----------------------------------------
>>
>> Any hints also about how to restore the "private controls" (invert -
>> automute)?
>>
>> Thanks.
>> - Gordon
>> --
>> video4linux-list mailing list
>> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
