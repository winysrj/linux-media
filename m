Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42271 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753086AbcHUMCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 08:02:55 -0400
Date: Sun, 21 Aug 2016 09:02:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160821090247.04b8c36d@vento.lan>
In-Reply-To: <20160820095157.1464e2cf@vento.lan>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
        <20160818163514.43539c11@lwn.net>
        <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
        <8737m0udod.fsf@intel.com>
        <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
        <20160820095157.1464e2cf@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 20 Aug 2016 09:51:57 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Fri, 19 Aug 2016 17:52:07 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
> > Am 19.08.2016 um 14:49 schrieb Jani Nikula <jani.nikula@intel.com>:
> >   
> > > On Fri, 19 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:    
> > >> Am 19.08.2016 um 00:35 schrieb Jonathan Corbet <corbet@lwn.net>:
> > >> * the pdf goes to the "latex" folder .. since this is WIP
> > >>  and there are different solutions conceivable ... I left
> > >>  it open for the first.    
> > > 
> > > Mea culpa. As I said, I intended my patches as RFC only.    
> > 
> > I think this is OK for the first. I thought that we first
> > let finish Mauro's task on making the media PDF and after
> > this we decide how move from the latex folder to a pdf folder
> > (one solution see below).  
> 
> Finished handling all tables. I'm sending the last 2 patches
> right now. Now, all tables fit into the page margins. Yet, I
> suspect that flat-table extension causes some troubles when cspan
> is used for LaTeX. It would be good if Markus could double check them.
> 
> There are just two things that won't fit at the margins of the document:
> 
> 1) included files with long lines. We might put those includes into
> a begingroup and use a smaller font, but IMHO the best is to fix the
> few cases on them, as those lines are very likely violating the 80 column
> limit;
> 
> 2) kernel-doc output for big arguments.
> 
> We have lots of function argument inside several media structs, like
> at:
> 	struct v4l2_subdev_core_ops.
> 
> one of such arguments is this function:
> 
> int (* s_io_pin_config) (struct v4l2_subdev *sd, size_t n,struct v4l2_subdev_io_pin_config *pincfg);
> 
> When kernel-doc generates the Members description, as the above line is
> bigger than 80 columns, it simply truncates its description to:
> 
> 	Members
> 	int (*)(struct v4l2_subdev *sd) log_status callback for VIDIOC_LOG_STATUS ioctl handler code.
> 	int (*)(struct v4l2_subdev *sd,size_t n,struct v4l2_subdev_io_pin_config *pincfg) s_io_pin_con
> 	...
> 
> The LaTeX output for it is:
> 
> 	\textbf{Members}
> 	\begin{description}
> 	\item[{\sphinxcode{int (*)(struct v4l2\_subdev *sd) log\_status}}] \leavevmode
> 	callback for \sphinxcode{VIDIOC\_LOG\_STATUS} ioctl handler code.
> 
> 	\item[{\sphinxcode{int (*)(struct v4l2\_subdev *sd, size\_t n,struct v4l2\_subdev\_io\_pin\_config *pincfg) s\_io\_pin\_config}}] \leavevmode
> 	configure one or more chip I/O pins for chips that
> 	multiplex different internal signal pads out to IO pins.  This function
> 	takes a pointer to an array of `n' pin configuration entries, one for
> 	each pin being configured.  This function could be called at times
> 	other than just subdevice initialization.
> 
> It seems that \sphinxcode{} doesn't allow line breaks. Maybe we can
> override it via conf.py. I'll play with it and see if I can find a
> solution. Yet, this could have side effects on other places.
> 
> Any suggestions about how to fix it?

The problem is actually because Sphinx uses item[], with doesn't split
into multiple lines. Doing something like:
	\\DeclareRobustCommand{\\sphinxcode}[1]{\\begin{minipage}{\\columnwidth}\\texttt{#1}\\end{minipage}}

Could fix, but, after sleeping into it, I think that the problem is actually
at the way the kernel-doc is output.

Right now, for a struct, it produces the following output:

	.. c:type:: struct v4l2_prio_state

	   stores the priority states

	**Definition**

	::

	  struct v4l2_prio_state {
	    atomic_t prios[4];
	  };

	**Members**

	``atomic_t prios[4]``
	  array with elements to store the array priorities

Putting everything inside `` is the culprit for having a very big line
there.

Also, IMHO, the best would be to output it on a different way, like:

**Members**

``prios[4]``
  type: ``atomic_t``

  array with elements to store the array priorities

In order to highlight what really matters: the member name. The type
is a secondary information. Also, it is "hidden" in the middle of a
long string in the case of function parameters. The order for function
parameters is also counter-intuitive, as struct member like:

        int (* rx_read) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num);

Is currently shown as:

        int (*) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num) read

With sounds weird, at least to my eyes. Also, if the line is too big,
on PDF output, the member name will be missed, with is very bad.

So, I think that the best solution here is to actually patch
kernel-doc, for it to produce the output on a different way:

	**Members**

	``prios[4]``
	  - **type**: ``atomic_t``

	  array with elements to store the array priorities

With such change, the name of the member will be the first visible
thing, and will be in **bold** style. The type will still be there.
Also, as the type is not part of LaTeX "item[]", LaTeX will split it into
multiple lines, if needed.

So, both LaTeX/PDF and HTML outputs will look good.

It should be noticed, however, that the way Sphinx LaTeX output handles 
things like:

	Foo
	   bar

is different than the HTML output. On HTML, it will produce something
like:

	**Foo**
	   bar


While, on LaTeX, it puts both foo and bar at the same line, like:

	**Foo** bar


By starting the second line with a dash, both HTML and LaTeX output
will do the same thing.

I'm sending the patch for kernel-doc script in a few.

Thanks,
Mauro
