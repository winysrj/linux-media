Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4488 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbZAVHOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 02:14:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Need help building spec to review...
Date: Thu, 22 Jan 2009 08:14:45 +0100
Cc: linux-media@vger.kernel.org
References: <1232589404.19974.4.camel@palomino.walls.org>
In-Reply-To: <1232589404.19974.4.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901220814.45151.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 22 January 2009 02:56:44 Andy Walls wrote:
> I'm not quite sure how to make the V4L2 spec to review the latest
> changes
>
> $ cd v4l-dvb-spec/v4l2-spec
> $ make
> [...]
> echo "</index>" >>indices.sgml
> echo "<programlisting>" > videodev2.h.sgml
> expand --tabs=8 < ../linux/include/linux/videodev2.h | \
> 	  sed -e "s/&/\\&amp;/g" -e "s/</\\&lt;/g" -e "s/>/\\&gt;/g" -e
> "s/\(enum *\)v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type
> \)/\1<link linkend=\"\2\">v4l2_mpeg_cx2341x_video_\2<\/link>/g" -e
> "s/\(\(enum\|struct\) *\)\(v4l2_[a-zA-Z0-9_]*\)/\1<link linkend=\"\3
> \">\3<\/link>/g" -e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1
> \">\1<\/link> /g" -e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" | \
> 	  sed 's/i\.e\./&ie;/' >> videodev2.h.sgml
> echo "</programlisting>" >> videodev2.h.sgml
> make: *** No rule to make target `vidioc-cropcap.sgml', needed by
> `html-single-build.stamp'.  Stop.
> $
>
>
> Please advise...

Try again. This file was missing from the repo so I've added it. I've 
absolutely no idea why that file wasn't in the repo, that was really weird.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
