Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57135 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752436AbcIJK6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 06:58:20 -0400
Date: Sat, 10 Sep 2016 13:58:17 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Oliver Collyer <ovcollyer@mac.com>
Cc: linux-media@vger.kernel.org, Support INOGENI <support@inogeni.com>,
        james.liu@magewell.net
Subject: Re: uvcvideo error on second capture from USB device, leading to
 V4L2_BUF_FLAG_ERROR
Message-ID: <20160910105817.eoyvvy5u5mkkrb5c@zver>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
 <20160905201935.wpgtrtt7e4bjjylo@zver>
 <FE81AFD0-C5F1-4FE7-A282-3294E668066C@mac.com>
 <20160906122823.toxscjyxomrh2col@zver>
 <71006CF0-B710-435A-B5A5-C0D0D20DE34F@mac.com>
 <20160910101440.nlb4sp43u36yj4ql@zver>
 <E8CA02F7-7F3C-4D0A-BAFC-24CAB8A57AEB@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E8CA02F7-7F3C-4D0A-BAFC-24CAB8A57AEB@mac.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 10, 2016 at 01:21:10PM +0300, Oliver Collyer wrote:
> 
> >> I have written a patch for FFmpeg that deals with the problem for both
> >> devices so it’s not really an issue for me anymore, but I’m not sure
> >> if the patch will get accepted in their master git as it’s a little
> >> messy.
> > 
> > Please post this patch here!
> 
> Here you go, Andrey. This patch basically makes it throw away corrupted buffers and then also the first 8 buffers after the last corrupted buffer.

Thanks a lot for sharing.

> It’s not sufficient just to throw away the corrupted buffers as I have noticed that the first few legitimate buffers appear at slightly irregular time intervals leading to FFmpeg spewing out a bunch of warnings for the duration of the capture. In my tests around 3 buffers have to be ignored but I’ve fixed it at 8 to be on the safe side. It’s a bit ugly though, to be honest, I don’t know how the number of buffers that need to be ignored would depend on the framerate, video size etc, but it works for my 1080i test.
> 
> With this patch, you get some warnings at the start, for both devices, as it encounters (and recovers from) the corrupted buffers but after that the captures work just fine.
> 
> 
> diff --git a/libavdevice/v4l2.c b/libavdevice/v4l2.c
> old mode 100644
> new mode 100755
> index ddf331d..7b4a826
> --- a/libavdevice/v4l2.c
> +++ b/libavdevice/v4l2.c
> @@ -79,6 +79,7 @@ struct video_data {
>  
>      int buffers;
>      volatile int buffers_queued;
> +    int buffers_ignore;
>      void **buf_start;
>      unsigned int *buf_len;
>      char *standard;
> @@ -519,7 +520,9 @@ static int mmap_read_frame(AVFormatContext *ctx, AVPacket *pkt)
>          av_log(ctx, AV_LOG_WARNING,
>                 "Dequeued v4l2 buffer contains corrupted data (%d bytes).\n",
>                 buf.bytesused);
> -        buf.bytesused = 0;
> +        s->buffers_ignore = 8;
> +        enqueue_buffer(s, &buf);
> +        return FFERROR_REDO;
>      } else
>  #endif
>      {
> @@ -529,14 +532,28 @@ static int mmap_read_frame(AVFormatContext *ctx, AVPacket *pkt)
>              s->frame_size = buf.bytesused;
>  
>          if (s->frame_size > 0 && buf.bytesused != s->frame_size) {
> -            av_log(ctx, AV_LOG_ERROR,
> +            av_log(ctx, AV_LOG_WARNING,
>                     "Dequeued v4l2 buffer contains %d bytes, but %d were expected. Flags: 0x%08X.\n",
>                     buf.bytesused, s->frame_size, buf.flags);
> +            s->buffers_ignore = 8;
>              enqueue_buffer(s, &buf);
> -            return AVERROR_INVALIDDATA;
> +            return FFERROR_REDO;
>          }
>      }

These two chunks look like legit resilience measure, and maybe could be
even added to upstream ffmpeg, maybe for non-default mode.

>  
> +    
> +    /* if we just encounted some corrupted buffers then we ignore the next few
> +     * legitimate buffers because they can arrive at irregular intervals, causing
> +     * the timestamps of the input and output streams to be out-of-sync and FFmpeg
> +     * to continually emit warnings. */
> +    if (s->buffers_ignore) {
> +        av_log(ctx, AV_LOG_WARNING,
> +               "Ignoring dequeued v4l2 buffer due to earlier corruption.\n");
> +        s->buffers_ignore --;
> +        enqueue_buffer(s, &buf);
> +        return FFERROR_REDO;
> +    }

Not clear exactly happens here so that such workaround is needed...


Congratulations, you've ended up with a workaround which works for you,
for such a mysterious issue :)

I still don't know what exactly causes this error condition on original
layer (I suppose that's some "panic" in the peripheral device), but I
guess that due to rarity of this condition, V4L2 code developers (in
both kernel and ffmpeg) just haven't had an opportunity to debug such
situations and handled this error condition formally, without experience
of running into it, and knowledge why it happens and how it could be
handled in most resilient way. (Maybe this should NOT be handled in
resilient way in theory, but still works for your case.) So you had to
pave your own way here.

Maybe comments from senior V4L2 developers shed more lights on this.
