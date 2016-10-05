Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:34452 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752784AbcJEUZw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 16:25:52 -0400
Date: Wed, 5 Oct 2016 22:25:35 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Jani Nikula <jani.nikula@linux.intel.com>
cc: Daniel Vetter <daniel@ffwll.ch>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Linux PM list <linux-pm@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-clk@vger.kernel.org,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        linux-mtd@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        drbd-dev@lists.linbit.com, linux-metag@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: kernel-doc-rst-lint (was: Re: [PATCH 00/15] improve function-level
 documentation)
In-Reply-To: <87h98quc1w.fsf@intel.com>
Message-ID: <alpine.DEB.2.10.1610052224240.3130@hadrien>
References: <1475351192-27079-1-git-send-email-Julia.Lawall@lip6.fr> <CAKMK7uHT3FutHQuQQ3iwXmYbidB3AOs7AxnpaJD4MTqy0-QehQ@mail.gmail.com> <87h98quc1w.fsf@intel.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1882111399-1475699148=:3130"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1882111399-1475699148=:3130
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Wed, 5 Oct 2016, Jani Nikula wrote:

> On Wed, 05 Oct 2016, Daniel Vetter <daniel@ffwll.ch> wrote:
> > Jani Nikula has a patch with a scrip to make the one kernel-doc parser
> > into a lint/checker pass over the entire kernel. I think that'd would
> > be more robust instead of trying to approximate the real kerneldoc
> > parser. Otoh that parser is a horror show of a perl/regex driven state
> > machine ;-)
> >
> > Jani, can you pls digg out these patches? Can't find them right now ...
>
> Expanding the massive Cc: with linux-doc list...
>
> Here goes. It's a quick hack from months ago, but still seems to
> somewhat work. At least for the kernel-doc parts. The reStructuredText
> lint part isn't all that great, and doesn't have mapping to line numbers
> like the Sphinx kernel-doc extension does. Anyway I'm happy how this
> integrates with kernel build CHECK and C=1/C=2.
>
> I guess Julia's goal is to automate the *fixing* of some of the error
> classes from kernel-doc. Not sure how well this could be made to
> integrate with any of that.

No, my work doesn't fix anything.  Coccinelle can't actually process
comments.  I just correlated the parsed comment with the function header.

julia

>
> BR,
> Jani.
>
>
> From 1244efa0f63a7b13795e8c37f81733a3c8bfc56a Mon Sep 17 00:00:00 2001
> From: Jani Nikula <jani.nikula@intel.com>
> Date: Tue, 31 May 2016 18:11:33 +0300
> Subject: [PATCH] kernel-doc-rst-lint: add tool to check kernel-doc and rst
>  correctness
> Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
> Cc: Jani Nikula <jani.nikula@intel.com>
>
> Simple kernel-doc and reStructuredText lint tool that can be used
> independently and as a kernel build CHECK tool to validate kernel-doc
> comments.
>
> Independent usage:
> $ kernel-doc-rst-lint FILE
>
> Kernel CHECK usage:
> $ make CHECK=scripts/kernel-doc-rst-lint C=1		# (or C=2)
>
> Depends on docutils and the rst-lint package
> https://pypi.python.org/pypi/restructuredtext_lint
>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  scripts/kernel-doc-rst-lint | 106 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 106 insertions(+)
>  create mode 100755 scripts/kernel-doc-rst-lint
>
> diff --git a/scripts/kernel-doc-rst-lint b/scripts/kernel-doc-rst-lint
> new file mode 100755
> index 000000000000..7e0157679f83
> --- /dev/null
> +++ b/scripts/kernel-doc-rst-lint
> @@ -0,0 +1,106 @@
> +#!/usr/bin/env python
> +# coding=utf-8
> +#
> +# Copyright © 2016 Intel Corporation
> +#
> +# Permission is hereby granted, free of charge, to any person obtaining a
> +# copy of this software and associated documentation files (the "Software"),
> +# to deal in the Software without restriction, including without limitation
> +# the rights to use, copy, modify, merge, publish, distribute, sublicense,
> +# and/or sell copies of the Software, and to permit persons to whom the
> +# Software is furnished to do so, subject to the following conditions:
> +#
> +# The above copyright notice and this permission notice (including the next
> +# paragraph) shall be included in all copies or substantial portions of the
> +# Software.
> +#
> +# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> +# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> +# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> +# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> +# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> +# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> +# IN THE SOFTWARE.
> +#
> +# Authors:
> +#    Jani Nikula <jani.nikula@intel.com>
> +#
> +# Simple kernel-doc and reStructuredText lint tool that can be used
> +# independently and as a kernel build CHECK tool to validate kernel-doc
> +# comments.
> +#
> +# Independent usage:
> +# $ kernel-doc-rst-lint FILE
> +#
> +# Kernel CHECK usage:
> +# $ make CHECK=scripts/kernel-doc-rst-lint C=1		# (or C=2)
> +#
> +# Depends on docutils and the rst-lint package
> +# https://pypi.python.org/pypi/restructuredtext_lint
> +#
> +
> +import os
> +import subprocess
> +import sys
> +
> +from docutils.parsers.rst import directives
> +from docutils.parsers.rst import Directive
> +from docutils.parsers.rst import roles
> +from docutils import nodes, statemachine
> +import restructuredtext_lint
> +
> +class DummyDirective(Directive):
> +    required_argument = 1
> +    optional_arguments = 0
> +    option_spec = { }
> +    has_content = True
> +
> +    def run(self):
> +        return []
> +
> +# Fake the Sphinx C Domain directives and roles
> +directives.register_directive('c:function', DummyDirective)
> +directives.register_directive('c:type', DummyDirective)
> +roles.register_generic_role('c:func', nodes.emphasis)
> +roles.register_generic_role('c:type', nodes.emphasis)
> +
> +# We accept but ignore parameters to be compatible with how the kernel build
> +# invokes CHECK.
> +if len(sys.argv) < 2:
> +    sys.stderr.write('usage: kernel-doc-rst-lint [IGNORED OPTIONS] FILE\n');
> +    sys.exit(1)
> +
> +infile = sys.argv[len(sys.argv) - 1]
> +cmd = ['scripts/kernel-doc', '-rst', infile]
> +
> +try:
> +    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
> +    out, err = p.communicate()
> +
> +    # python2 needs conversion to unicode.
> +    # python3 with universal_newlines=True returns strings.
> +    if sys.version_info.major < 3:
> +        out, err = unicode(out, 'utf-8'), unicode(err, 'utf-8')
> +
> +    # kernel-doc errors
> +    sys.stderr.write(err)
> +    if p.returncode != 0:
> +        sys.exit(p.returncode)
> +
> +    # restructured text errors
> +    lines = statemachine.string2lines(out, 8, convert_whitespace=True)
> +    lint_errors = restructuredtext_lint.lint(out, infile)
> +    for error in lint_errors:
> +        # Ignore INFO
> +        if error.level <= 1:
> +            continue
> +
> +        print(error.source + ': ' + error.type + ': ' + error.full_message)
> +        if error.line is not None:
> +            print('Context:')
> +            print('\t' + lines[error.line - 1])
> +            print('\t' + lines[error.line])
> +
> +except Exception as e:
> +    sys.stderr.write(str(e) + '\n')
> +    sys.exit(1)
> --
> 2.1.4
>
>
> --
> Jani Nikula, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--8323329-1882111399-1475699148=:3130--
