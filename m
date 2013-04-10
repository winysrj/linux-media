Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:10675 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3DJJRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 05:17:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: [PATCH 2/2] v4l2-ctl: initial attempt to support M2M device streaming
Date: Wed, 10 Apr 2013 11:16:47 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>,
	"Tzu-Jung Lee" <tjlee@ambarella.com>
References: <1365572135-2311-1-git-send-email-tjlee@ambarella.com> <201304100848.30682.hverkuil@xs4all.nl> <CAEvN+1gmv9N9e897NvqCQ2o2LCqMUDfob2T_DQ_ehZLWkjAZEA@mail.gmail.com>
In-Reply-To: <CAEvN+1gmv9N9e897NvqCQ2o2LCqMUDfob2T_DQ_ehZLWkjAZEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304101116.47872.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 10 April 2013 10:38:13 Tzu-Jung Lee wrote:
> On Wed, Apr 10, 2013 at 2:48 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> +             if (!eos[OUT]) {
> >> +                     if (FD_ISSET(fd, &write_fds)) {
> >> +                             r  = do_handle_out(fd, &reqbufs[OUT], is_mplane, num_planes,
> >> +                                                buffers[OUT], buffer_lengths[OUT], file[OUT],
> >> +                                                &count[OUT], &last[OUT], &tv_last[OUT]);
> >> +                             if (r < 0)  {
> >> +                                     eos[OUT] = true;
> >> +
> >> +                                     if (options[OptDecoderCmd]) {
> >> +                                             doioctl(fd, VIDIOC_DECODER_CMD, &dec_cmd);
> >> +                                             options[OptDecoderCmd] = false;
> >> +                                     }
> >> +
> >> +                                     doioctl(fd, VIDIOC_STREAMOFF, &type[OUT]);
> >> +
> >
> > Rather than using eos[OUT], just 'break' out of the loop here.
> 
> If we break out here, the unfinished captured stream will also be left
> out, isn't it?

That's a good point. So it's OK to keep the eos[2] array. However, to make
this work correctly the while loop should use '&&' instead of '||'. I.e.,
only break out when both sides have eos set.

In addition, once eos is set for one of the two sides, make sure that you
no longer attempt to select on that fd for read+exception (capture) or
write (output).

You may also have to modify the way stream_count and skip are handled in
an m2m case: those should only apply to the output side of things, it
makes no sense to apply them to the capture side.

Regards,

	Hans
 
> Oh, I'm working on a M2M device, which works with bitstreams only, and
> no frames on Linux.
> So we keep feeding input streams via the OUTPUT path, and get
> transcoded bitstream from
> CAPTURE path. In this case, we need to keep pulling out the transcoded
> bitstreams in the loop.
> I think this is also only relevant to compressed formats again.
> 
> >> +                             }
> >> +                     }
> >> +
> >> +             }
> >> +     }
> >> +
> >> +     fcntl(fd, F_SETFL, fd_flags);
> >> +     fprintf(stderr, "\n");
> >> +
> >> +     do_release_buffers(&reqbufs[CAP], num_planes, is_mmap,
> >> +                        buffers[CAP], buffer_lengths[CAP]);
> >> +
> >> +     do_release_buffers(&reqbufs[OUT], num_planes, is_mmap,
> >> +                        buffers[OUT], buffer_lengths[OUT]);
> >> +
> >> +     if (file[CAP] && file[CAP] != stdout)
> >> +             fclose(file[CAP]);
> >> +
> >> +     if (file[OUT] && file[OUT] != stdin)
> >> +             fclose(file[OUT]);
> >> +}
> >> +
> >>  void streaming_set(int fd)
> >>  {
> >>       bool do_cap = options[OptStreamMmap] || options[OptStreamUser];
> >>       bool do_out = options[OptStreamOutMmap] || options[OptStreamOutUser];
> >>
> >> -     if (do_cap)
> >> +     if (do_cap && do_out)
> >> +             streaming_set_m2m(fd);
> >> +     else if (do_cap)
> >>               streaming_set_cap(fd);
> >>       else if (do_out)
> >>               streaming_set_out(fd);
> >>
> >
> > Regards,
> >
> >         Hans
> 
