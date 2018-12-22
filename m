Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F54CC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 16:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48BE821983
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 16:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5y6boCq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbeLVQv1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 11:51:27 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:45793 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbeLVQv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 11:51:27 -0500
Received: by mail-ua1-f65.google.com with SMTP id e16so2746842uam.12
        for <linux-media@vger.kernel.org>; Sat, 22 Dec 2018 08:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kyWsiu3PrtfGhYvxIVVnDgJkrPXwHyiySWKAwN0krw=;
        b=j5y6boCq9mkPQlPDzASWTwAV8nlBEjaA279GQ/btY/eiXolpdcTTesXECJf7bXm/Jc
         R5N+Igwr33I9kOJGZ7hCRfw7SDvvaO1pdJbbwJE+OvfcNZb3+sBAOJDq68+FEuHGEP0z
         i1l6KNv+HZZzCeKuFIqj2ugMGEJ0JIwRFvLIaTJEfN8PQgcvkdtJxRLdM2wFlShaHmJa
         pMIM++JEfqOcgkJI61G4FlPw16L1s8JnL7uMAABbpur5TZkli1MiKpua5q23rdKSpaTc
         +gPnz9vFwOwzqHTCtFLtE8lWGLI872XbOjOciNC8WJsD7H4Yu1rEY5ICqyqXzLlXTH1p
         PVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kyWsiu3PrtfGhYvxIVVnDgJkrPXwHyiySWKAwN0krw=;
        b=NSoD/Decft0lv7snYKPftNjj0C1HjwPLggWj5pCwK/ibv1PWjDJn0ngFaBKCkTEBjB
         ma7cl/wjfpXnTCvXgDNUCQIo3OOzy5GqLbmws/kTvWzGJ8Og+n5TRRGpEPEsRmJyNOGY
         I55KIMHk/rpsZC3y5JMGK1KZaZ4ra5gV8s1F1TdBF6HUSZx7HCfddXiuP5r3tE8yirLP
         6laoJYRJPLTNQy0FH2v/U+ABqcK3/xwOoPPmRRQ6U/6+WBNeascGu9vyk2MEBva4JWLs
         KubOWUYOdN5pN6It/l+/ADwshgStaGf3yq5gqCd79en+SVdwuXoVJPkRG/gce7ztUWYr
         Uw2Q==
X-Gm-Message-State: AJcUukc1OHInYs3lfSuErwTJ4C32z5q/gjconJi1WRPqc/LcGWzPBjkg
        Ac1+6FTvy8R5rT7rFw7aCunib4kKS8HQNuGzIVGxRtIp
X-Google-Smtp-Source: ALg8bN5gxGqQ/Gc2pZ+jr3ngq0/epONwvop7d8pElV2HZc9/nEXphTMWjNQALWLW8FaG3XV9JxZ7Dw0f6u/4mXUJpUI=
X-Received: by 2002:ab0:48cd:: with SMTP id y13mr2249244uac.49.1545469432364;
 Sat, 22 Dec 2018 01:03:52 -0800 (PST)
MIME-Version: 1.0
References: <20181218111140.90645-1-dafna3@gmail.com> <603cad44-4a52-73d1-3ad5-5474ee549977@xs4all.nl>
 <CAJ1myNRieZveHD95YBXiLx6Ka6pDBrW8Cvmh0Nvxt1f=YDDUyg@mail.gmail.com> <a0e7ade6-d3e4-132a-0629-4fb6a4b664b2@xs4all.nl>
In-Reply-To: <a0e7ade6-d3e4-132a-0629-4fb6a4b664b2@xs4all.nl>
From:   Dafna Hirschfeld <dafna3@gmail.com>
Date:   Sat, 22 Dec 2018 11:03:41 +0200
Message-ID: <CAJ1myNT_8mrQOE+o7auzAibG+Tn_zjUobMtMUtBFW55yF72zcA@mail.gmail.com>
Subject: Re: [PATCH v4l-utils] v4l2-ctl: Add support for CROP selection in m2m streaming
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        helen.koike@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 19, 2018 at 12:03 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 12/19/18 9:34 AM, Dafna Hirschfeld wrote:
> >>> +bool is_m2m_enc = false;
> >>
> >> This should be static.
> >>
> >> I'm assuming that in a future patch we'll get a is_m2m_dec as well?
> >
> > I forgot that there can be more options other than m2m_enc/_dec.
> > So actually adding is_m2m_dec is needed. Or I can define an enum with
> > 3 possible values
> > IS_M2M_ENC, IS_M2M_DEC, NOT_M2M_DEV
>
> I think using bools will make the code easier.
>
> >
> >>
> >>> +
> >>>  #define TS_WINDOW 241
> >>>  #define FILE_HDR_ID                  v4l2_fourcc('V', 'h', 'd', 'r')
> >>>
> >>> @@ -108,6 +114,84 @@ public:
> >>>       unsigned dropped();
> >>>  };
> >>>
> >>> +static int get_codec_type(int fd, bool &is_enc) {
> >>
> >> { on the next line.
> >>
> >>> +     struct v4l2_capability vcap;
> >>> +
> >>> +     memset(&vcap,0,sizeof(vcap));
> >>
> >> Space after ,
> >>
> >> Please use the kernel coding style for these v4l utilities.
> >>
> > I ran the checkpatch script on this file and it didn't catch theses things.
> > Do you use checkpatch for v4l-utils ?
>
> No. As far as I can tell checkpatch skips cpp files so it can't be used for C++ files.
>
> >
> >>> +
> >>> +     int ret = ioctl(fd, VIDIOC_QUERYCAP, &vcap);
> >>
> >> Please use the cv4l_fd class. It comes with lots of helpers for all these ioctls
> >> and it already used in v4l2-ctl-streaming.cpp.
> >>
> >> In this function you can just do:
> >>
> >>         if (!fd.has_vid_m2m())
> >>                 return -1;
> >>
> >>> +     if(ret) {
> >>> +             fprintf(stderr, "get_codec_type: VIDIOC_QUERYCAP failed: %d\n", ret);
> >>> +             return ret;
> >>> +     }
> >>> +     unsigned int caps = vcap.capabilities;
> >>> +     if (caps & V4L2_CAP_DEVICE_CAPS)
> >>> +             caps = vcap.device_caps;
> >>> +     if(!(caps & V4L2_CAP_VIDEO_M2M) && !(caps & V4L2_CAP_VIDEO_M2M_MPLANE)) {
> >>> +             is_enc = false;
> >>> +             fprintf(stderr,"get_codec_type: not an M2M device\n");
> >>> +             return -1;
> >>> +     }
> >>> +
> >>> +     struct v4l2_fmtdesc fmt;
> >>> +     memset(&fmt,0,sizeof(fmt));
> >>> +     fmt.index = 0;
> >>> +     fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >>> +
> >>> +     while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
> >>> +             if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
> >>> +                     break;
> >>> +             fmt.index++;
> >>> +     }
> >>
> >> These tests aren't good enough. You need to enumerate over all formats.
> >> Easiest is to keep a tally of the total number of formats and how many
> >> are compressed.
> >>
> >> An encoder is a device where all output formats are uncompressed and
> >> all capture formats are compressed. It's the reverse for a decoder.
> >>
> >> If you get a mix on either side, or both sides are raw or both sides
> >> are compressed, then it isn't a codec.
> >>
> >>> +     if (ret) {
> >>> +             is_enc = true;
> >>> +             return 0;
> >>> +     }
> >>> +     memset(&fmt,0,sizeof(fmt));
> >>> +     fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> >>> +     while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
> >>> +             if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
> >>> +                     break;
> >>> +             fmt.index++;
> >>> +     }
> >>> +     if (ret) {
> >>> +             is_enc = false;
> >>> +             return 0;
> >>> +     }
> >>> +     fprintf(stderr, "get_codec_type: could no determine codec type\n");
> >>> +     return -1;
> >>> +}
> >>> +
> >>> +static void get_frame_dims(unsigned int &frame_width, unsigned int &frame_height) {
> >>> +
> >>> +     if(is_m2m_enc)
> >>> +             vidout_get_orig_from_set(frame_width, frame_height);
> >>> +     else
> >>> +             vidcap_get_orig_from_set(frame_width, frame_height);
> >>> +}
> >>> +
> >>> +static int get_visible_format(int fd, unsigned int &width, unsigned int &height) {
> >>> +     int ret = 0;
> >>> +     if(is_m2m_enc) {
> >>> +             struct v4l2_selection in_selection;
> >>> +
> >>> +             in_selection.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> >>> +             in_selection.target = V4L2_SEL_TGT_CROP;
> >>> +
> >>> +             if ( (ret = ioctl(fd, VIDIOC_G_SELECTION, &in_selection)) != 0) {
> >>> +                     fprintf(stderr,"get_visible_format: error in g_selection ioctl: %d\n",ret);
> >>> +                     return ret;
> >>> +             }
> >>> +             width = in_selection.r.width;
> >>> +             height = in_selection.r.height;
> >>> +     }
> >>> +     else { //TODO - g_selection with COMPOSE should be used here when implemented in driver
> >>> +             vidcap_get_orig_from_set(width, height);
> >>> +     }
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +
> >>>  void fps_timestamps::determine_field(int fd, unsigned type)
> >>>  {
> >>>       struct v4l2_format fmt = { };
> >>> @@ -419,7 +503,6 @@ static void print_buffer(FILE *f, struct v4l2_buffer &buf)
> >>>                       fprintf(f, "\t\tData Offset: %u\n", p->data_offset);
> >>>               }
> >>>       }
> >>> -
> >>>       fprintf(f, "\n");
> >>>  }
> >>>
> >>> @@ -657,7 +740,131 @@ void streaming_cmd(int ch, char *optarg)
> >>>       }
> >>>  }
> >>>
> >>> -static bool fill_buffer_from_file(cv4l_queue &q, cv4l_buffer &b, FILE *fin)
> >>> +bool padding(cv4l_fd &fd, cv4l_queue &q, unsigned char* buf, FILE *fpointer, unsigned &sz, unsigned &len, bool is_read)
> >>
> >> This should definitely be a static function. Also, this is not a very good name.
> >>
> >> Why not call it fill_padded_buffer_from_file()?
> >
> > This function is used both for reading from file for the encoder and
> > writing to file for the decoder.
> > Maybe it can be called read_write_padded_frame ?
>
> That would work.
>
> >
> >>
> >>> +{
> >>> +     cv4l_fmt fmt(q.g_type());
> >>
> >> No need to use q.g_type(). 'cv4l_fmt fmt;' is sufficient.
> >>
> >>> +     fd.g_fmt(fmt, q.g_type());
> >>
> >> After all, it's filled here.
> >>
> >>> +     const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
> >>
> >> This test should be moved to fill_buffer_from_file. If it is not an encoder and
> >> the pixelformat is not known (v4l2_fwht_find_pixfmt() returns NULL), then it should
> >> fallback to the old behavior. So this function should only be called when you have
> >> all the information about the pixelformat.
> >>
> >
> > This function is supposed to be called only for m2m encoder on the
> > output buffer and m2m decoder on the capture buffer
> > so vic_format is not NULL in those case.
>
> Actually, handling padding is not specific to codecs. Any video device can have
> cropping or composing.
>
> The generic rules are:
>
> 1) if a video output device supports TGT_CROP, then use that rectangle when reading
>    from a file.
>
> 2) if a video capture device supports TGT_COMPOSE, then use that rectangle when
>    writing to a file.
>
> The problem with this is that doing this requires v4l2-ctl to understand all the pixelformats.
> That's a lot more work so for now just use v4l2_fwht_find_pixfmt() which has the information
> needed for the most common formats.
>
> Anything not known by v4l2_fwht_find_pixfmt() can just fall back to the old behavior.
>
> >
> >>> +     unsigned coded_width = fmt.g_width();
> >>> +     unsigned coded_height = fmt.g_height();
> >>> +     unsigned real_width;
> >>> +     unsigned real_height;
> >>> +     unsigned char *buf_p = (unsigned char*) buf;
> >>> +
> >>> +     if(is_read) {
> >>> +             real_width  = frame_width;
> >>> +             real_height = frame_height;
> >>> +     }
> >>> +     else {
> >>> +             real_width  = visible_width;
> >>> +             real_height = visible_height;
> >>> +     }
> >>> +     sz = 0;
> >>> +     len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
> >>> +     switch(vic_fmt->id) {
> >>> +     case V4L2_PIX_FMT_YUYV:
> >>> +     case V4L2_PIX_FMT_YVYU:
> >>> +     case V4L2_PIX_FMT_UYVY:
> >>> +     case V4L2_PIX_FMT_VYUY:
> >>> +     case V4L2_PIX_FMT_RGB24:
> >>> +     case V4L2_PIX_FMT_HSV24:
> >>> +     case V4L2_PIX_FMT_BGR24:
> >>> +     case V4L2_PIX_FMT_RGB32:
> >>> +     case V4L2_PIX_FMT_XRGB32:
> >>> +     case V4L2_PIX_FMT_HSV32:
> >>> +     case V4L2_PIX_FMT_BGR32:
> >>> +     case V4L2_PIX_FMT_XBGR32:
> >>> +     case V4L2_PIX_FMT_ARGB32:
> >>> +     case V4L2_PIX_FMT_ABGR32:
> >>
> >> I'd put this all under a 'default' case. I think GREY can also be added here.
> >>
> >> What I would really like to see is that only the information from v4l2_fwht_pixfmt_info
> >> can be used here without requiring a switch.
> >>
> >> I think all that is needed to do that is that struct v4l2_fwht_pixfmt_info is extended
> >> with a 'planes_num' field, which is 1 for interleaved formats, 2 for luma/interleaved chroma
> >> planar formats and 3 for luma/cr/cb planar formats.
> >>
> > So I should send a patch to the kernel code, adding this field ?
>
> Yes.
>
> >
> >>> +             for(unsigned i=0; i < real_height; i++) {
> >>> +                     unsigned int consume_sz = vic_fmt->bytesperline_mult*real_width;
> >>> +                     unsigned int wsz = 0;
> >>> +                     if(is_read)
> >>> +                             wsz = fread(buf_p, 1, consume_sz, fpointer);
> >>> +                     else
> >>> +                             wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> >>> +                     sz += wsz;
> >>> +                     if(wsz == 0 && i == 0)
> >>> +                             break;
> >>> +                     if(wsz != consume_sz) {
> >>> +                             fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> >>> +                             return false;
> >>> +                     }
> >>> +                     buf_p += vic_fmt->chroma_step*coded_width;
> >>> +             }
> >>> +     break;
> >>> +
> >>> +     case V4L2_PIX_FMT_NV12:
> >>> +     case V4L2_PIX_FMT_NV16:
> >>> +     case V4L2_PIX_FMT_NV24:
> >>> +     case V4L2_PIX_FMT_NV21:
> >>> +     case V4L2_PIX_FMT_NV61:
> >>> +     case V4L2_PIX_FMT_NV42:
> >>> +             for(unsigned plane_idx = 0; plane_idx < 2; plane_idx++) {
> >>> +                     unsigned h_div = (plane_idx == 0) ? 1 : vic_fmt->height_div;
> >>> +                     unsigned w_div = (plane_idx == 0) ? 1 : vic_fmt->width_div;
> >>> +                     unsigned step  =  (plane_idx == 0) ? vic_fmt->luma_alpha_step : vic_fmt->chroma_step;
> >>> +
> >>> +                     for(unsigned i=0; i <  real_height/h_div; i++) {
> >>> +                             unsigned int wsz = 0;
> >>> +                             unsigned int consume_sz = step * real_width / w_div;
> >>> +                             if(is_read)
> >>> +                                     wsz = fread(buf_p, 1,  consume_sz, fpointer);
> >>> +                             else
> >>> +                                     wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> >>> +                             if(wsz == 0 && i == 0 && plane_idx == 0)
> >>> +                                     break;
> >>> +                             if(wsz != consume_sz) {
> >>> +                                     fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> >>> +                                     return true;
> >>> +                             }
> >>> +                             sz += wsz;
> >>> +                             buf_p += step*coded_width/w_div;
> >>> +                     }
> >>> +                     buf_p += (coded_width / w_div) * (coded_height - real_height) / h_div;
> >>> +
> >>> +                     if(sz == 0)
> >>> +                             break;
> >>> +             }
> >>> +     break;
> >>> +     case V4L2_PIX_FMT_YUV420:
> >>> +     case V4L2_PIX_FMT_YUV422P:
> >>> +     case V4L2_PIX_FMT_YVU420:
> >>> +     case V4L2_PIX_FMT_GREY:
> >>> +             for(unsigned comp_idx = 0; comp_idx < vic_fmt->components_num; comp_idx++) {
> >>> +                     unsigned h_div = (comp_idx == 0) ? 1 : vic_fmt->height_div;
> >>> +                     unsigned w_div = (comp_idx == 0) ? 1 : vic_fmt->width_div;
> >>> +
> >>> +                     for(unsigned i=0; i < real_height/h_div; i++) {
> >>> +                             unsigned int wsz = 0;
> >>> +                             unsigned int consume_sz = real_width/w_div;
> >>> +                             if(is_read)
> >>> +                                     wsz = fread(buf_p, 1, consume_sz, fpointer);
> >>> +                             else
> >>> +                                     wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> >>> +                             if(wsz == 0 && i == 0 && comp_idx == 0)
> >>> +                                     break;
> >>> +                             if(wsz != consume_sz) {
> >>> +                                     fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> >>> +                                     return true;
> >>> +                             }
> >>> +                             sz += wsz;
> >>> +                             buf_p += coded_width/w_div;
> >>> +                     }
> >>> +                     buf_p += (coded_width / w_div) * (coded_height - real_height) / h_div;
> >>> +
> >>> +                     if(sz == 0)
> >>> +                             break;
> >>> +             }
> >>> +             break;
> >>> +     default:
> >>> +             fprintf(stderr,"the format is not supported yet\n");
> >>> +             return false;
> >>> +     }
> >>> +     return true;
> >>> +}
> >>> +
> >>> +static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b, FILE *fin)
> >>>  {
> >>>       static bool first = true;
> >>>       static bool is_fwht = false;
> >>> @@ -785,7 +992,15 @@ restart:
> >>>                               return false;
> >>>                       }
> >>>               }
> >>> -             sz = fread(buf, 1, len, fin);
> >>> +
> >>> +             if(is_m2m_enc) {
> >>> +                     if(!padding(fd, q, (unsigned char*) buf, fin, sz, len, true))
> >>> +                             return false;
> >>> +             }
> >>> +             else {
> >>> +                     sz = fread(buf, 1, len, fin);
> >>> +             }
> >>> +
> >>>               if (first && sz != len) {
> >>>                       fprintf(stderr, "Insufficient data\n");
> >>>                       return false;
> >>> @@ -908,7 +1123,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
> >>>                                       tpg_fillbuffer(&tpg, stream_out_std, j, (u8 *)q.g_dataptr(i, j));
> >>>                       }
> >>>               }
> >>> -             if (fin && !fill_buffer_from_file(q, buf, fin))
> >>> +             if (fin && !fill_buffer_from_file(fd, q, buf, fin))
> >>>                       return -2;
> >>>
> >>>               if (qbuf) {
> >>> @@ -960,7 +1175,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
> >>>               if (fd.qbuf(buf))
> >>>                       return -1;
> >>>       }
> >>> -
> >>> +
> >>
> >> Seems to be a whitespace only change, just drop this change.
> >>
> >>>       double ts_secs = buf.g_timestamp().tv_sec + buf.g_timestamp().tv_usec / 1000000.0;
> >>>       fps_ts.add_ts(ts_secs, buf.g_sequence(), buf.g_field());
> >>>
> >>> @@ -1023,8 +1238,15 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
> >>>                       }
> >>>                       if (host_fd_to >= 0)
> >>>                               sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
> >>> -                     else
> >>> -                             sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
> >>> +                     else {
> >>> +                             if(!is_m2m_enc) {
> >>> +                                     if(!padding(fd, q, (u8 *)q.g_dataptr(buf.g_index(), j) + offset, fout, sz, used, false))
> >>> +                                             return false;
> >>> +                             }
> >>> +                             else {
> >>> +                                     sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
> >>> +                             }
> >>> +                     }
> >>
> >> This doesn't feel right.
> >>
> >> I think a write_buffer_to_file() function should be introduced that deals with these
> >> variations.
> >
> > Not sure what you meant, should I implement this if-else in another function ?
> > The "padding" function is used both for reading and writing to/from
> > padded buffer.
> > The condition for calling it here should be changed to
> > "if(is_m2m_dec)" in which case "padding" will
> > write a raw frame to a file from the padded capture buffer.
>
> static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &b, FILE *fout)
> {
> #ifndef NO_STREAM_TO
>         // code
> #endif
> }
>
> And in do_handle_cap() drop the NO_STREAM_TO and replace it with a call
> to the new function:
>
>         if (fout && (!stream_skip || ignore_count_skip) &&
>             buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR))
>                 write_buffer_to_file(q, buf, fout);
>
> This can be done in a separate patch: first refactor the code, introducing the
> new function, then add support for handling padding.
>
> >
> >>
> >>>
> >>>                       if (sz != used)
> >>>                               fprintf(stderr, "%u != %u\n", sz, used);
> >>> @@ -1130,7 +1352,7 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
> >>>                       output_field = V4L2_FIELD_TOP;
> >>>       }
> >>>
> >>> -     if (fin && !fill_buffer_from_file(q, buf, fin))
> >>> +     if (fin && !fill_buffer_from_file(fd, q, buf, fin))
> >>>               return -2;
> >>>
> >>>       if (!fin && stream_out_refresh) {
> >>> @@ -1227,7 +1449,7 @@ static void streaming_set_cap(cv4l_fd &fd)
> >>>               }
> >>>               break;
> >>>       }
> >>> -
> >>> +
> >>>       memset(&sub, 0, sizeof(sub));
> >>>       sub.type = V4L2_EVENT_EOS;
> >>>       fd.subscribe_event(sub);
> >>> @@ -2031,6 +2253,21 @@ void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
> >>>       int do_cap = options[OptStreamMmap] + options[OptStreamUser] + options[OptStreamDmaBuf];
> >>>       int do_out = options[OptStreamOutMmap] + options[OptStreamOutUser] + options[OptStreamOutDmaBuf];
> >>>
> >>> +     int r = get_codec_type(fd.g_fd(), is_m2m_enc);
> >>> +     if(r) {
> >>> +             fprintf(stderr, "error checking codec type\n");
> >>> +             return;
> >>> +     }
> >>> +
> >>> +     r = get_visible_format(fd.g_fd(), visible_width, visible_height);
> >>> +
> >>> +     if(r) {
> >>> +             fprintf(stderr, "error getting the visible width\n");
> >>> +             return;
> >>> +     }
> >>> +
> >>> +     get_frame_dims(frame_width, frame_height);
> >>> +
> >>>       if (out_fd.g_fd() < 0) {
> >>>               out_capabilities = capabilities;
> >>>               out_priv_magic = priv_magic;
> >>> diff --git a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> >>> index dc17a868..932f1fd2 100644
> >>> --- a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> >>> +++ b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> >>> @@ -244,6 +244,12 @@ void vidcap_get(cv4l_fd &fd)
> >>>       }
> >>>  }
> >>>
> >>> +void vidcap_get_orig_from_set(unsigned int &r_width, unsigned int &r_height) {
> >>> +     r_height = height;
> >>> +     r_width = width;
> >>> +}
> >>> +
> >>> +
> >>>  void vidcap_list(cv4l_fd &fd)
> >>>  {
> >>>       if (options[OptListFormats]) {
> >>> diff --git a/utils/v4l2-ctl/v4l2-ctl-vidout.cpp b/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> >>> index 5823df9c..05bd43ed 100644
> >>> --- a/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> >>> +++ b/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> >>> @@ -208,6 +208,11 @@ void vidout_get(cv4l_fd &fd)
> >>>       }
> >>>  }
> >>>
> >>> +void vidout_get_orig_from_set(unsigned int &r_width, unsigned int &r_height) {
> >>> +     r_height = height;
> >>> +     r_width = width;
> >>> +}
> >>
> >> Don't do this (same for vidcap_get_orig_from_set).
> >>
> >> I think you just want to get the width and height from VIDIOC_G_FMT here,
> >> so why not just call that?
> >>
> > Those width/height are the values that are given by the user command.
>
> Yes, but those values are used in ioctl calls to the driver, so rather
> than using those values you query the driver.
>
> > They are needed in order to
> > read raw frames line by line for the encoder.
>
> Why not call G_FMT and G_SELECTION(TGT_CROP) to obtain that information?
>
The way vicodec is now implemented is that it does not hold the
original width/height given in S_FMT but the coded once.
But the userspace still needs these values in order to read raw frames
from the file.
Not sure how to solve it.
Why does the userspace encoder need to query this values from the
driver ? Since these are raw frames the userspace
should already know the dimensions.

Dafna

> Please note that all the set and get options are all processed before the
> streaming options. So when you start streaming the driver is fully configured.
>
> > Maybe I can implement it by calling 'parse_fmt' in 'stream_cmd'
> > function similar to how 'vidout_cmd' do it.
> >
> > https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-ctl/v4l2-ctl-vidout.cpp#n90
> >
> >
> >> Remember that you can call v4l2-ctl without setting the output width and height
> >> if the defaults that the driver sets are already fine. In that case the width and height
> >> variables in this source are just 0.
> >>
> >>> +
> >>>  void vidout_list(cv4l_fd &fd)
> >>>  {
> >>>       if (options[OptListOutFormats]) {
> >>> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> >>> index 5a52a0a4..ab2994b2 100644
> >>> --- a/utils/v4l2-ctl/v4l2-ctl.h
> >>> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> >>> @@ -357,6 +357,8 @@ void vidout_cmd(int ch, char *optarg);
> >>>  void vidout_set(cv4l_fd &fd);
> >>>  void vidout_get(cv4l_fd &fd);
> >>>  void vidout_list(cv4l_fd &fd);
> >>> +void vidcap_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
> >>> +void vidout_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
> >>>
> >>>  // v4l2-ctl-overlay.cpp
> >>>  void overlay_usage(void);
> >>>
> >>
> >> This patch needs more work (not surprisingly, since it takes a bit of time to
> >> understand the v4l2-ctl source code).
> >>
> >> Please stick to the kernel coding style! Using a different style makes it harder
> >> for me to review since my pattern matches routines in my brain no longer work
> >> optimally. It's like reading text with spelling mistakes, you cn stil undrstant iT,
> >> but it tekes moore teem. :-)
> >>
> > okei :)
> >
> >> Regards,
> >>
> >>         Hans
>
> Regards,
>
>         Hans
