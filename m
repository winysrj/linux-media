Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44891 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZAVB4B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 20:56:01 -0500
Subject: Need help building spec to review...
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Content-Type: text/plain
Date: Wed, 21 Jan 2009 20:56:44 -0500
Message-Id: <1232589404.19974.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm not quite sure how to make the V4L2 spec to review the latest
changes

$ cd v4l-dvb-spec/v4l2-spec
$ make
[...]
echo "</index>" >>indices.sgml
echo "<programlisting>" > videodev2.h.sgml
expand --tabs=8 < ../linux/include/linux/videodev2.h | \
	  sed -e "s/&/\\&amp;/g" -e "s/</\\&lt;/g" -e "s/>/\\&gt;/g" -e
"s/\(enum *\)v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type
\)/\1<link linkend=\"\2\">v4l2_mpeg_cx2341x_video_\2<\/link>/g" -e
"s/\(\(enum\|struct\) *\)\(v4l2_[a-zA-Z0-9_]*\)/\1<link linkend=\"\3
\">\3<\/link>/g" -e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1
\">\1<\/link> /g" -e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" | \
	  sed 's/i\.e\./&ie;/' >> videodev2.h.sgml
echo "</programlisting>" >> videodev2.h.sgml
make: *** No rule to make target `vidioc-cropcap.sgml', needed by
`html-single-build.stamp'.  Stop.
$ 


Please advise...

Regards,
Andy

