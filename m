Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49918
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932581AbcHWAlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 20:41:07 -0400
Date: Mon, 22 Aug 2016 21:40:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jani Nikula <jani.nikula@intel.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs-rst: kernel-doc: better output struct members
Message-ID: <20160822214055.7c56f06d@vento.lan>
In-Reply-To: <20160822153421.1e334ab0@lwn.net>
References: <45996a8dc149f7de6ed09d703b76cb65e55b7a9a.1471781478.git.mchehab@s-opensource.com>
        <20160822153421.1e334ab0@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Aug 2016 15:34:21 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sun, 21 Aug 2016 09:11:57 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > So, change kernel-doc, for it to produce the output on a different way:
> > 
> > 	**Members**
> > 
> > 	``prios[4]``
> > 	  - **type**: ``atomic_t``
> > 
> > 	  array with elements to store the array priorities
> > 
> > With such change, the name of the member will be the first visible
> > thing, and will be in bold style. The type will still be there, inside
> > a list.  
> 
> OK, I'll confess to not being 100% convinced on this one.  I certainly
> sympathize with the problem that drives this change, but I think the
> result is a bit on the noisy and visually distracting side.  
> 
> I wonder if we might be better off to just leave the "type:" bulleted
> line out entirely?  The type information already appears in the structure
> listing directly above, so it's arguably redundant here.  If formatting
> the type is getting in the way here, perhaps the right answer is just
> "don't do that"?

I almost stripped the type on the first version of this patch, as I had
the same doubt as you ;)

I ended keeping it just because I didn't have a strong argument to
strip it.

There is another reason too... just stripping it will produce a
little difference at the output:

With HTML, the output is:

	*struct v4l2_subdev_tuner_ops*

	    Callbacks used when v4l device was opened in radio mode.

	...

	*Members*

	*s_radio*
	    callback for VIDIOC_S_RADIO ioctl handler code.
	...

On LaTeX/PDF, is displayed as:

	*struct v4l2_subdev_tuner_ops*

	    Callbacks used when v4l device was opened in radio mode.

	...

	*Members*

	*s_radio* callback for VIDIOC_S_RADIO ioctl handler code.


Anyway, I'm OK on just stripping the type. I'm sending a second version
of it.

Thanks!
Mauro
