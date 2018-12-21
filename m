Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3625EC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 12:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E805B21908
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 12:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390315AbeLUMbS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 07:31:18 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54002 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732614AbeLUMbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 07:31:17 -0500
Received: from [IPv6:2001:983:e9a7:1:a083:659e:88da:d180] ([IPv6:2001:983:e9a7:1:a083:659e:88da:d180])
        by smtp-cloud7.xs4all.net with ESMTPA
        id aJxKg0zfsdllcaJxLgrtbz; Fri, 21 Dec 2018 13:31:16 +0100
Subject: Re: [PATCH v4l-utils] v4l2-ctl: Add support for CROP selection in m2m
 streaming
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        helen.koike@collabora.com
References: <20181218111140.90645-1-dafna3@gmail.com>
 <603cad44-4a52-73d1-3ad5-5474ee549977@xs4all.nl>
 <CAJ1myNRieZveHD95YBXiLx6Ka6pDBrW8Cvmh0Nvxt1f=YDDUyg@mail.gmail.com>
 <a0e7ade6-d3e4-132a-0629-4fb6a4b664b2@xs4all.nl>
 <CAJ1myNR8JVggC-24y3+mhreM0PoZ82EdG1BBo3OFzisR+hogig@mail.gmail.com>
 <26d97ba9-d387-d3e8-3d09-eb6c96fd62dd@xs4all.nl>
 <CAJ1myNSeybTSGQo9wc9FnJsYqVOdTxwtaxK4tFZrc41A4NiTjw@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4a58e87f-baf9-8b70-112c-16a2ad742922@xs4all.nl>
Date:   Fri, 21 Dec 2018 13:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAJ1myNSeybTSGQo9wc9FnJsYqVOdTxwtaxK4tFZrc41A4NiTjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHqZGe2u++zZk29XnfjwXP1qvrGHV+75tuLMJYTBtNvDGrbewsf9pB/m6nnf+RXsAw5kXYLLaVndS8tsYgum8HFujpVl4IMGrXxjr9FYkm/jC9ytuDLU
 FzTXOD9aIH48tFGoWgzpN4N63+nhn4scygPXqW+t+9TRAF4xuddrfT5b6KrIY+mX1/FxWaP6Kxgj6ELe337JvpHIj+NNdu6EZbucUKdeyA26+zVbmd8+FA6v
 uYyjRI/UF0cooM3zwmcHJaHMu9y5jmfA7nEBV8+YA2IPF1u+pg2XmQ9TrAsgte7zfyyZLFTOrAEgYtSq9d0coYi8ojz7MoQTdZagE28l7fU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/21/18 1:21 PM, Dafna Hirschfeld wrote:
> 
> 
> On Thu, Dec 20, 2018 at 11:45 AM Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>> wrote:
> 
>     On 12/19/18 2:32 PM, Dafna Hirschfeld wrote:
>     > On Wed, Dec 19, 2018 at 12:03 PM Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>> wrote:
>     >>
>     >> On 12/19/18 9:34 AM, Dafna Hirschfeld wrote:
>     >>>>> +bool is_m2m_enc = false;
>     >>>>
>     >>>> This should be static.
>     >>>>
>     >>>> I'm assuming that in a future patch we'll get a is_m2m_dec as well?
>     >>>
>     >>> I forgot that there can be more options other than m2m_enc/_dec.
>     >>> So actually adding is_m2m_dec is needed. Or I can define an enum with
>     >>> 3 possible values
>     >>> IS_M2M_ENC, IS_M2M_DEC, NOT_M2M_DEV
>     >>
>     >> I think using bools will make the code easier.
>     >>
>     >>>
>     >>>>
>     >>>>> +
>     >>>>>  #define TS_WINDOW 241
>     >>>>>  #define FILE_HDR_ID                  v4l2_fourcc('V', 'h', 'd', 'r')
>     >>>>>
>     >>>>> @@ -108,6 +114,84 @@ public:
>     >>>>>       unsigned dropped();
>     >>>>>  };
>     >>>>>
>     >>>>> +static int get_codec_type(int fd, bool &is_enc) {
>     >>>>
>     >>>> { on the next line.
>     >>>>
>     >>>>> +     struct v4l2_capability vcap;
>     >>>>> +
>     >>>>> +     memset(&vcap,0,sizeof(vcap));
>     >>>>
>     >>>> Space after ,
>     >>>>
>     >>>> Please use the kernel coding style for these v4l utilities.
>     >>>>
>     >>> I ran the checkpatch script on this file and it didn't catch theses things.
>     >>> Do you use checkpatch for v4l-utils ?
>     >>
>     >> No. As far as I can tell checkpatch skips cpp files so it can't be used for C++ files.
>     >>
>     >>>
>     >>>>> +
>     >>>>> +     int ret = ioctl(fd, VIDIOC_QUERYCAP, &vcap);
>     >>>>
>     >>>> Please use the cv4l_fd class. It comes with lots of helpers for all these ioctls
>     >>>> and it already used in v4l2-ctl-streaming.cpp.
>     >>>>
>     >>>> In this function you can just do:
>     >>>>
>     >>>>         if (!fd.has_vid_m2m())
>     >>>>                 return -1;
>     >>>>
>     >>>>> +     if(ret) {
>     >>>>> +             fprintf(stderr, "get_codec_type: VIDIOC_QUERYCAP failed: %d\n", ret);
>     >>>>> +             return ret;
>     >>>>> +     }
>     >>>>> +     unsigned int caps = vcap.capabilities;
>     >>>>> +     if (caps & V4L2_CAP_DEVICE_CAPS)
>     >>>>> +             caps = vcap.device_caps;
>     >>>>> +     if(!(caps & V4L2_CAP_VIDEO_M2M) && !(caps & V4L2_CAP_VIDEO_M2M_MPLANE)) {
>     >>>>> +             is_enc = false;
>     >>>>> +             fprintf(stderr,"get_codec_type: not an M2M device\n");
>     >>>>> +             return -1;
>     >>>>> +     }
>     >>>>> +
>     >>>>> +     struct v4l2_fmtdesc fmt;
>     >>>>> +     memset(&fmt,0,sizeof(fmt));
>     >>>>> +     fmt.index = 0;
>     >>>>> +     fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>     >>>>> +
>     >>>>> +     while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
>     >>>>> +             if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
>     >>>>> +                     break;
>     >>>>> +             fmt.index++;
>     >>>>> +     }
>     >>>>
>     >>>> These tests aren't good enough. You need to enumerate over all formats.
>     >>>> Easiest is to keep a tally of the total number of formats and how many
>     >>>> are compressed.
>     >>>>
>     >>>> An encoder is a device where all output formats are uncompressed and
>     >>>> all capture formats are compressed. It's the reverse for a decoder.
>     >>>>
>     >>>> If you get a mix on either side, or both sides are raw or both sides
>     >>>> are compressed, then it isn't a codec.
>     >>>>
>     >>>>> +     if (ret) {
>     >>>>> +             is_enc = true;
>     >>>>> +             return 0;
>     >>>>> +     }
>     >>>>> +     memset(&fmt,0,sizeof(fmt));
>     >>>>> +     fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>     >>>>> +     while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
>     >>>>> +             if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
>     >>>>> +                     break;
>     >>>>> +             fmt.index++;
>     >>>>> +     }
>     >>>>> +     if (ret) {
>     >>>>> +             is_enc = false;
>     >>>>> +             return 0;
>     >>>>> +     }
>     >>>>> +     fprintf(stderr, "get_codec_type: could no determine codec type\n");
>     >>>>> +     return -1;
>     >>>>> +}
>     >>>>> +
>     >>>>> +static void get_frame_dims(unsigned int &frame_width, unsigned int &frame_height) {
>     >>>>> +
>     >>>>> +     if(is_m2m_enc)
>     >>>>> +             vidout_get_orig_from_set(frame_width, frame_height);
>     >>>>> +     else
>     >>>>> +             vidcap_get_orig_from_set(frame_width, frame_height);
>     >>>>> +}
>     >>>>> +
>     >>>>> +static int get_visible_format(int fd, unsigned int &width, unsigned int &height) {
>     >>>>> +     int ret = 0;
>     >>>>> +     if(is_m2m_enc) {
>     >>>>> +             struct v4l2_selection in_selection;
>     >>>>> +
>     >>>>> +             in_selection.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>     >>>>> +             in_selection.target = V4L2_SEL_TGT_CROP;
>     >>>>> +
>     >>>>> +             if ( (ret = ioctl(fd, VIDIOC_G_SELECTION, &in_selection)) != 0) {
>     >>>>> +                     fprintf(stderr,"get_visible_format: error in g_selection ioctl: %d\n",ret);
>     >>>>> +                     return ret;
>     >>>>> +             }
>     >>>>> +             width = in_selection.r.width;
>     >>>>> +             height = in_selection.r.height;
>     >>>>> +     }
>     >>>>> +     else { //TODO - g_selection with COMPOSE should be used here when implemented in driver
>     >>>>> +             vidcap_get_orig_from_set(width, height);
>     >>>>> +     }
>     >>>>> +     return 0;
>     >>>>> +}
>     >>>>> +
>     >>>>> +
>     >>>>>  void fps_timestamps::determine_field(int fd, unsigned type)
>     >>>>>  {
>     >>>>>       struct v4l2_format fmt = { };
>     >>>>> @@ -419,7 +503,6 @@ static void print_buffer(FILE *f, struct v4l2_buffer &buf)
>     >>>>>                       fprintf(f, "\t\tData Offset: %u\n", p->data_offset);
>     >>>>>               }
>     >>>>>       }
>     >>>>> -
>     >>>>>       fprintf(f, "\n");
>     >>>>>  }
>     >>>>>
>     >>>>> @@ -657,7 +740,131 @@ void streaming_cmd(int ch, char *optarg)
>     >>>>>       }
>     >>>>>  }
>     >>>>>
>     >>>>> -static bool fill_buffer_from_file(cv4l_queue &q, cv4l_buffer &b, FILE *fin)
>     >>>>> +bool padding(cv4l_fd &fd, cv4l_queue &q, unsigned char* buf, FILE *fpointer, unsigned &sz, unsigned &len, bool is_read)
>     >>>>
>     >>>> This should definitely be a static function. Also, this is not a very good name.
>     >>>>
>     >>>> Why not call it fill_padded_buffer_from_file()?
>     >>>
>     >>> This function is used both for reading from file for the encoder and
>     >>> writing to file for the decoder.
>     >>> Maybe it can be called read_write_padded_frame ?
>     >>
>     >> That would work.
>     >>
>     >>>
>     >>>>
>     >>>>> +{
>     >>>>> +     cv4l_fmt fmt(q.g_type());
>     >>>>
>     >>>> No need to use q.g_type(). 'cv4l_fmt fmt;' is sufficient.
>     >>>>
>     >>>>> +     fd.g_fmt(fmt, q.g_type());
>     >>>>
>     >>>> After all, it's filled here.
>     >>>>
>     >>>>> +     const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
>     >>>>
>     >>>> This test should be moved to fill_buffer_from_file. If it is not an encoder and
>     >>>> the pixelformat is not known (v4l2_fwht_find_pixfmt() returns NULL), then it should
>     >>>> fallback to the old behavior. So this function should only be called when you have
>     >>>> all the information about the pixelformat.
>     >>>>
>     >>>
>     >>> This function is supposed to be called only for m2m encoder on the
>     >>> output buffer and m2m decoder on the capture buffer
>     >>> so vic_format is not NULL in those case.
>     >>
>     >> Actually, handling padding is not specific to codecs. Any video device can have
>     >> cropping or composing.
>     >>
>     >> The generic rules are:
>     >>
>     >> 1) if a video output device supports TGT_CROP, then use that rectangle when reading
>     >>    from a file.
>     >>
>     >> 2) if a video capture device supports TGT_COMPOSE, then use that rectangle when
>     >>    writing to a file.
>     >>
>     >> The problem with this is that doing this requires v4l2-ctl to understand all the pixelformats.
>     >> That's a lot more work so for now just use v4l2_fwht_find_pixfmt() which has the information
>     >> needed for the most common formats.
>     >>
>     >> Anything not known by v4l2_fwht_find_pixfmt() can just fall back to the old behavior.
>     >>
>     > So I'm not sure what is the correct implementation here,
>     > Currently this function suppose to be used only by m2m_enc/dec, I
>     > actually have no idea
>     > how other types of drivers work. What exactly should be the conditions
>     > for calling this function ?
> 
>     Any driver that supports TGT_CROP for video output or TGT_COMPOSE for video capture
>     should use that information when reading from a file or writing to a file in v4l2-ctl.
> 
> There is the field "have_selection" in v4l_fd, which is update here https://git.linuxtv.org/hverkuil/v4l-utils.git/tree/utils/common/v4l-helpers.h#n476
> The selection target is set to crop for capture buffer and compose for output buffer, this is the opposite
> from what you wrote and what I implemented in vicodec.
> Also, why is the returned value compared to ENOTTY ? according to the docs, if the operation is not
> supported it should return EINVAL.

No, EINVAL is returned if the ioctl is supported but the given values are
invalid.

If an ioctl is not supported at all by a driver, then ENOTTY is returned.

I know, it's a weird error code, but this is historical UNIX error code:
https://en.wikipedia.org/wiki/Not_a_typewriter

The 'have_selection' test is still valid for codecs since it doesn't test if the
target is correct, but it tests if the ioctl is implemented.

I could have just set sel.target to any target in that test, it's a bit overkill
what happens there. The test assumes that the device is either a pure capture
(i.e. webcam like) device or a pure video output device, and for such devices the
target is valid. For M2M devices the targets are opposite from what non-M2M
devices would implement. I.e. for webcams the cropping takes place in the hardware,
and they typically do not support composing into a capture buffer.

Regards,

	Hans
