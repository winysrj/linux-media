Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:56226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220AbZJaU14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 16:27:56 -0400
Received: by fg-out-1718.google.com with SMTP id d23so61967fga.1
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 13:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1257020204.3087.18.camel@palomino.walls.org>
References: <1257020204.3087.18.camel@palomino.walls.org>
Date: Sat, 31 Oct 2009 16:28:00 -0400
Message-ID: <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
Subject: Re: cx18: YUV frame alignment improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:
> All,
>
> At
>
> http://linuxtv.org/hg/~awalls/cx18-yuv
>
> I have checked in some improvements to YUV handling in the cx18
> driver.
>
> There was a problem in that a lost/dropped buffer between the cx18
> driver and the CX23418 firmware would cause the video frame alignment to
> be lost with no easy way to recover.
>
> These changes do the following:
>
> 1. Force YUV buffer sizes to be large enough to hold either 1 full 525
> line system frame or 1 full 625 line system frame with new module
> options and defaults.  That makes the YUV buffers quite large, but
> allows for "1 frame per buffer" for full sized video frames.
>
> 2. Not being able to allocate the now large YUV buffers is non-fatal.
> The driver will still load and work for other stream types, even if it
> can't get the YUV buffers.  A warning is blurted out in the log, in case
> YUV buffers can't be allocated.
>
> 3. __GFP_REPEAT has been added when trying to make the initial video
> buffer allocations.  After I added this, I never had the large YUV
> buffers fail to be allocated.
>
> 4. We now lie to the firmware about the actual YUV buffer size, so that
> the firmware always thinks the buffers are exactly large enough to hold
> exactly an integral number of YUV frames based on the image height.
> This means that dropped/lost YUV buffers between the cx18 driver and the
> CX23418 firmware will only drop whole frames and no misalignment should
> occur.
>
>
> # modinfo cx18
> [...]
> parm:           enc_yuv_buffers:Encoder YUV buffer memory (MB). (enc_yuv_bufs can override)
>                        Default: 3 (int)
> parm:           enc_yuv_bufsize:Size of an encoder YUV buffer (kB)
>                        Allowed values:
>                                  0 (do not allocate YUV buffers)
>                                507 (when never capturing 625 line systems)
>                                608 (when capturing 625 and/or 525 line systems)
>                        Default: 608 (int)
> parm:           enc_yuv_bufs:Number of encoder YUV buffers
>                        Default is computed from other enc_yuv_* parameters (int)
> [...]
>
> # modprobe cx18
> # mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc
>
>
> You can add 'debug=264' to the modprobe line to watch the size of the
> payloads coming back from the firmware to make sure they are an integral
> number of frames, but logging stats on every noticably degrades
> performance.
>
> Regards,
> Andy

Hi Andy,

How does this code work if the cx23418 scaler is used (resulting in
the size of the frames to be non-constant)?  Or is the scaler not
currently supported in the driver?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
