Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44089
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933922AbcKVS1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 13:27:35 -0500
Date: Tue, 22 Nov 2016 16:27:29 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] doc-rst: Specify raw bayer format variant used in
 the examples
Message-ID: <20161122162729.22e4721a@vento.lan>
In-Reply-To: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Nov 2016 23:49:43 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The documentation simply mentioned that one of the four pixel orders was
> used in the example. Now specify the exact pixelformat instead.
> 
> for i in pixfmt-s*.rst; do i=$i perl -i -pe '
> 	my $foo=$ENV{i};
> 	$foo =~ s/pixfmt-[a-z]+([0-9].*).rst/$1/;
> 	$foo = uc $foo;
> 	s/one of these formats/a small V4L2_PIX_FMT_SBGGR$foo image/' $i;
> done

Patch is nice, except that it doesn't apply :-)

If it depends on some other patch, please send it together with
its dependency or at least mention it at the patch, after the 
-- line.

Thanks,
Mauro




$ quilt push -f --merge
Applying patch patches/lmml_38129_1_1_doc_rst_specify_raw_bayer_format_variant_used_in_the_examples.patch
patching file Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
patching file Documentation/media/uapi/v4l/pixfmt-srggb12.rst
can't find file to patch at input line 62
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
|index 06facc9..d407b2b 100644
|--- a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
|+++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
patching file Documentation/media/uapi/v4l/pixfmt-srggb8.rst


Regards,
Mauro
Thanks,
Mauro
