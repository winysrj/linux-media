Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31991 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1K2RTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 12:19:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Tue, 29 Nov 2011 18:19:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/3] v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42
 formats
In-reply-to: <1322562419-9934-3-git-send-email-laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Message-id: <4ED5140D.4080200@samsung.com>
References: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1322562419-9934-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/29/2011 11:26 AM, Laurent Pinchart wrote:
> NV24 and NV42 are planar YCbCr 4:4:4 and YCrCb 4:4:4 formats with a
> luma plane followed by an interleaved chroma plane.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
...
> +	</example>
> +      </refsect1>
> +    </refentry>
> +

> +  <!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "pixfmt.sgml"
> +indent-tabs-mode: nil
> +End:
> +  -->

I think this comment chunk is redundant, it's just for emacs configuration.
Every time I open the file containing litter like this I get a not-so-useful
message, asking if I want to load the variables defined there or not.

I'm considering a patch cleaning up the Docbook from this emacs stuff, as I
also made a mistake copying this comment when adding NV12M, NV12MT formats.

Looks like most of people are doing that, e.g. see

http://www.mail-archive.com/linux-media@vger.kernel.org/msg38637.html

;)

--

Regards,
Sylwester
