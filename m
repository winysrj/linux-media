Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48551 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbcHTMwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 08:52:12 -0400
Date: Sat, 20 Aug 2016 09:51:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160820095157.1464e2cf@vento.lan>
In-Reply-To: <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
        <20160818163514.43539c11@lwn.net>
        <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
        <8737m0udod.fsf@intel.com>
        <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Aug 2016 17:52:07 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 19.08.2016 um 14:49 schrieb Jani Nikula <jani.nikula@intel.com>:
> 
> > On Fri, 19 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:  
> >> Am 19.08.2016 um 00:35 schrieb Jonathan Corbet <corbet@lwn.net>:
> >> * the pdf goes to the "latex" folder .. since this is WIP
> >>  and there are different solutions conceivable ... I left
> >>  it open for the first.  
> > 
> > Mea culpa. As I said, I intended my patches as RFC only.  
> 
> I think this is OK for the first. I thought that we first
> let finish Mauro's task on making the media PDF and after
> this we decide how move from the latex folder to a pdf folder
> (one solution see below).

Finished handling all tables. I'm sending the last 2 patches
right now. Now, all tables fit into the page margins. Yet, I
suspect that flat-table extension causes some troubles when cspan
is used for LaTeX. It would be good if Markus could double check them.

There are just two things that won't fit at the margins of the document:

1) included files with long lines. We might put those includes into
a begingroup and use a smaller font, but IMHO the best is to fix the
few cases on them, as those lines are very likely violating the 80 column
limit;

2) kernel-doc output for big arguments.

We have lots of function argument inside several media structs, like
at:
	struct v4l2_subdev_core_ops.

one of such arguments is this function:

int (* s_io_pin_config) (struct v4l2_subdev *sd, size_t n,struct v4l2_subdev_io_pin_config *pincfg);

When kernel-doc generates the Members description, as the above line is
bigger than 80 columns, it simply truncates its description to:

	Members
	int (*)(struct v4l2_subdev *sd) log_status callback for VIDIOC_LOG_STATUS ioctl handler code.
	int (*)(struct v4l2_subdev *sd,size_t n,struct v4l2_subdev_io_pin_config *pincfg) s_io_pin_con
	...

The LaTeX output for it is:

	\textbf{Members}
	\begin{description}
	\item[{\sphinxcode{int (*)(struct v4l2\_subdev *sd) log\_status}}] \leavevmode
	callback for \sphinxcode{VIDIOC\_LOG\_STATUS} ioctl handler code.

	\item[{\sphinxcode{int (*)(struct v4l2\_subdev *sd, size\_t n,struct v4l2\_subdev\_io\_pin\_config *pincfg) s\_io\_pin\_config}}] \leavevmode
	configure one or more chip I/O pins for chips that
	multiplex different internal signal pads out to IO pins.  This function
	takes a pointer to an array of `n' pin configuration entries, one for
	each pin being configured.  This function could be called at times
	other than just subdevice initialization.

It seems that \sphinxcode{} doesn't allow line breaks. Maybe we can
override it via conf.py. I'll play with it and see if I can find a
solution. Yet, this could have side effects on other places.

Any suggestions about how to fix it?

PS.: if you want to see, it is at:
	https://mchehab.fedorapeople.org/media.pdf

on page 623.

There is one additional issue on LaTeX output: it numbered the
document on a very different way than on html. Also, it has just one
TOC. This is very bad, because, as we had to manually numerate
figures, their number/names look weird on LaTeX output.

Thanks,
Mauro
