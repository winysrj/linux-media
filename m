Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:44468 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932189AbcITS4w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 14:56:52 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the c-domain
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160919120030.4e390e9a@vento.lan>
Date: Tue, 20 Sep 2016 20:56:35 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de> <20160909090832.35c2d982@vento.lan> <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de> <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de> <20160919120030.4e390e9a@vento.lan>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 19.09.2016 um 17:00 schrieb Mauro Carvalho Chehab <mchehab@infradead.org>:

>> Hmm, as far as I see, the output is not correct ... The output of
>> functions with a function pointer argument are missing the 
>> leading parenthesis in the function definition:
>> 
>>  .. c:function:: struct v4l2_m2m_ctx * v4l2_m2m_ctx_init (struct v4l2_m2m_dev * m2m_dev, void * drv_priv, int (*queue_init) (void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
>> 
>> The missing parenthesis cause the error message. 
> 
> 
> Ah, OK! I'll kernel-doc and see what's happening here.
> 
>> 
>> The output of the parameter description is:
>> 
>>  ``int (*)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq) queue_init``
>>    a callback for queue type-specific initialization function
>>    to be used for initializing videobuf_queues
>> 
>> Correct (and IMO better to read) is:
>> 
>>  .. c:function:: struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev, void *drv_priv, int (*queue_init)(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq))
>> 
>> and the parameter description should be something like ...
>> 
>>   :param int (\*queue_init)(void \*priv, struct vb2_queue \*src_vq, struct vb2_queue \*dst_vq):
>>        a callback for queue type-specific initialization function
>>        to be used for initializing videobuf_queues
> 
> I guess the better would be to strip the parameter type and output
> it as:
> 	queue_init
> 		a callback for queue type-specific initialization function
> 		to be used for initializing videobuf_queues

Good point!

> As I pointed before, the point is that such argument can easily have
> more than 80 columns, with would cause troubles with LaTeX output,
> as LaTeX doesn't break long verbatim text on multiple lines.
> 
> I submitted one patch fixing it. Not sure if it got merged by Jon
> or not.

Ups, I might have overseen this patch .. as Jon said, its hard to
follow you ;)

I tested the above with Jon's docs-next, so it seems your patch is
not yet applied. Could you send me a link for this patch? (sorry,
I can't find it).


>> I tested this with my linuxdoc tools (parser) with I get no
>> error messages from the sphinx c-domain.
>> 
>> BTW: 
>> 
>> The parser of my linuxdoc project is more strict and spit out some 
>> warnings, which are not detected by the kernel-doc parser from the
>> kernel source tree.
>> 
>> For your rework on kernel-doc comments, it might be helpful to see
>> those messages, so I recommend to install the linuxdoc package and
>> do some lint.
>> 
>> install: https://return42.github.io/linuxdoc/install.html
>> lint:    https://return42.github.io/linuxdoc/cmd-line.html#kernel-lintdoc
> 
> Interesting! Yeah, it caught a lot more errors ;)
> 
> If I understood it right, I could do something like:
> 
> diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
> index 480d548af670..2de603871536 100644
> --- a/Documentation/media/conf_nitpick.py
> +++ b/Documentation/media/conf_nitpick.py
> @@ -107,3 +107,9 @@ nitpick_ignore = [
> 
>     ("c:type", "v4l2_m2m_dev"),
> ]
> +
> +
> +extensions.append("linuxdoc.rstKernelDoc")
> +extensions.append("linuxdoc.rstFlatTable")
> +extensions.append("linuxdoc.kernel_include")
> +extensions.append("linuxdoc.manKernelDoc")
> 
> Right?

No ;)

> It would be good to do some sort of logic on the
> above for it to automatically include it, if linuxdoc is
> present, otherwise print a warning and do "just" the normal
> Sphinx tests.

The intention is; with installing the linuxdoc project you get
some nice command line tools, like lint for free and if you want
to see how the linuxdoc project compiles your kernel documentation
and how e.g. man pages are build or what warnings are spit, you
have to **replace** the extensions from the kernel's source with
the one from the linuxdoc project.

This is done by patching the build scripts as described in:

  https://return42.github.io/linuxdoc/linux.html

FYI: I updated the documentation of the linuxdoc project.

In this project I develop and maintain "future" concepts like
man-page builder and the py-version of the kernel-doc parser. 
Vice versa, every improvement I see on kernel's source tree is
merged into this project.

This project is also used by my POC at:

* http://return42.github.io/sphkerneldoc/

E.g. it builds the documentation of the complete kernel sources

* http://return42.github.io/sphkerneldoc/linux_src_doc/index.html

the last one is also my test-case to find regression when I change
something / running against the whole source tree and compare the
result to the versioned reST files at 

* https://github.com/return42/sphkerneldoc/tree/master/doc/linux_src_doc

-- Markus --

>> E.g. if you want to lint your whole include/media tree type:
>> 
>>  kernel-lintdoc [--sloppy] include/media
> 
> Yeah, running it manually is another way, although I prefer to have
> it done via a Makefile target, and doing only for the files that
> are currently inside a Sphinx rst file (at least on a first moment).
> 
> Thanks,
> Mauro

