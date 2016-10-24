Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38998 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938541AbcJXJEg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:04:36 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Documentation/media/uapi/cec/ sporadically unnecessarily rebuilding
Date: Mon, 24 Oct 2016 12:04:31 +0300
Message-ID: <871sz6p17k.fsf@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain


I think I saw some of this in the past [1], but then couldn't reproduce
it after all. Now I'm seeing it again. Sporadically
Documentation/media/uapi/cec/ gets rebuilt on successive runs of make
htmldocs, even when nothing has changed.

Output of 'make SPHINXOPTS="-v -v" htmldocs' attached for both cases.

Using Sphinx (sphinx-build) 1.4.6


BR,
Jani.


[1] id:8760rbp8zh.fsf@intel.com

-- 
Jani Nikula, Intel Open Source Technology Center

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=build-ok.txt

  SPHINX  htmldocs --> file:///home/jani/src/linux/Documentation/output;
make[2]: Nothing to be done for 'all'.
Running Sphinx v1.4.6
[app] setting up extension: 'kernel-doc'
[app] adding config value: ('kerneldoc_bin', None, 'env')
[app] adding config value: ('kerneldoc_srctree', None, 'env')
[app] adding config value: ('kerneldoc_verbosity', 1, 'env')
[app] adding directive: ('kernel-doc', <class 'kernel-doc.KernelDocDirective'>, None, None, {})
[app] setting up extension: 'rstFlatTable'
[app] adding directive: ('flat-table', <class 'rstFlatTable.FlatTable'>, None, None, {})
[app] setting up extension: 'kernel_include'
[app] adding directive: ('kernel-include', <class 'kernel_include.KernelInclude'>, None, None, {})
[app] setting up extension: 'cdomain'
[app] overriding domain: <class 'cdomain.CDomain'>
[app] setting up extension: 'sphinx.ext.imgmath'
[app] adding config value: ('math_number_all', False, 'html')
[app] adding node: (<class 'sphinx.ext.mathbase.math'>, {'latex': (<function latex_visit_math at 0x7f27758aea60>, None), 'man': (<function man_visit_math at 0x7f27758aee18>, None), 'text': (<function text_visit_math at 0x7f27758aec80>, None), 'override': True, 'html': (<function html_visit_math at 0x7f27758ba6a8>, None), 'texinfo': (<function texinfo_visit_math at 0x7f27758ba0d0>, None)})
[app] adding node: (<class 'sphinx.ext.mathbase.displaymath'>, {'latex': (<function latex_visit_displaymath at 0x7f27758aeb70>, None), 'man': (<function man_visit_displaymath at 0x7f27758aeea0>, <function man_depart_displaymath at 0x7f27758aef28>), 'text': (<function text_visit_displaymath at 0x7f27758aed08>, None), 'html': (<function html_visit_displaymath at 0x7f27758ba730>, None), 'texinfo': (<function texinfo_visit_displaymath at 0x7f27758ba158>, <function texinfo_depart_displaymath at 0x7f27758ba1e0>)})
[app] adding node: (<class 'sphinx.ext.mathbase.eqref'>, {'latex': (<function latex_visit_eqref at 0x7f27758aebf8>, None), 'man': (<function man_visit_eqref at 0x7f27758ba048>, None), 'text': (<function text_visit_eqref at 0x7f27758aed90>, None), 'html': (<function html_visit_eqref at 0x7f27758ba2f0>, <function html_depart_eqref at 0x7f27758ba378>), 'texinfo': (<function texinfo_visit_eqref at 0x7f27758ba268>, None)})
[app] adding role: ('math', <function math_role at 0x7f27758ae8c8>)
[app] adding role: ('eq', <function eq_role at 0x7f27758ae950>)
[app] adding directive: ('math', <class 'sphinx.ext.mathbase.MathDirective'>, None, None, {})
[app] connecting event 'doctree-resolved': <function number_equations at 0x7f27758ba400> [id=0]
[app] adding config value: ('imgmath_image_format', 'png', 'html')
[app] adding config value: ('imgmath_dvipng', 'dvipng', 'html')
[app] adding config value: ('imgmath_dvisvgm', 'dvisvgm', 'html')
[app] adding config value: ('imgmath_latex', 'latex', 'html')
[app] adding config value: ('imgmath_use_preview', False, 'html')
[app] adding config value: ('imgmath_dvipng_args', ['-gamma', '1.5', '-D', '110', '-bg', 'Transparent'], 'html')
[app] adding config value: ('imgmath_dvisvgm_args', ['--no-fonts'], 'html')
[app] adding config value: ('imgmath_latex_args', [], 'html')
[app] adding config value: ('imgmath_latex_preamble', '', 'html')
[app] adding config value: ('imgmath_add_tooltips', True, 'html')
[app] adding config value: ('imgmath_font_size', 12, 'html')
[app] connecting event 'build-finished': <function cleanup_tempdir at 0x7f27758ba598> [id=1]
[app] setting up extension: 'alabaster'
[app] connecting event 'html-page-context': <function update_context at 0x7f27751f1ea0> [id=2]
loading pickled environment... done
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 0 source files that are out of date
updating environment: 0 added, 0 changed, 0 removed
looking for now-outdated files... 12 found
pickling environment... done
checking consistency... done
docnames to write: media/uapi/cec/cec-func-close, media/uapi/cec/cec-func-ioctl, media/uapi/cec/cec-func-open, media/uapi/cec/cec-func-poll, media/uapi/cec/cec-funcs, media/uapi/cec/cec-header, media/uapi/cec/cec-ioc-adap-g-caps, media/uapi/cec/cec-ioc-adap-g-log-addrs, media/uapi/cec/cec-ioc-adap-g-phys-addr, media/uapi/cec/cec-ioc-dqevent, media/uapi/cec/cec-ioc-g-mode, media/uapi/cec/cec-ioc-receive
preparing documents... WARNING: search index couldn't be loaded, but not all documents will be built: the index will be incomplete.
done
writing output... [  7%] index
writing output... [ 14%] media/uapi/cec/cec-api
writing output... [ 21%] media/uapi/cec/cec-func-close
writing output... [ 28%] media/uapi/cec/cec-func-ioctl
writing output... [ 35%] media/uapi/cec/cec-func-open
writing output... [ 42%] media/uapi/cec/cec-func-poll
writing output... [ 50%] media/uapi/cec/cec-funcs
writing output... [ 57%] media/uapi/cec/cec-header
writing output... [ 64%] media/uapi/cec/cec-ioc-adap-g-caps
writing output... [ 71%] media/uapi/cec/cec-ioc-adap-g-log-addrs
writing output... [ 78%] media/uapi/cec/cec-ioc-adap-g-phys-addr
writing output... [ 85%] media/uapi/cec/cec-ioc-dqevent
writing output... [ 92%] media/uapi/cec/cec-ioc-g-mode
writing output... [100%] media/uapi/cec/cec-ioc-receive

generating indices... genindex
writing additional pages... search
copying static files... done
copying extra files... done
dumping search index in English (code: en) ... done
dumping object inventory... done
build succeeded, 1 warning.
  HTML    Documentation/DocBook/index.html

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=build-cec-rebuilding.txt

  SPHINX  htmldocs --> file:///home/jani/src/linux/Documentation/output;
make[2]: Nothing to be done for 'all'.
Running Sphinx v1.4.6
[app] setting up extension: 'kernel-doc'
[app] adding config value: ('kerneldoc_bin', None, 'env')
[app] adding config value: ('kerneldoc_srctree', None, 'env')
[app] adding config value: ('kerneldoc_verbosity', 1, 'env')
[app] adding directive: ('kernel-doc', <class 'kernel-doc.KernelDocDirective'>, None, None, {})
[app] setting up extension: 'rstFlatTable'
[app] adding directive: ('flat-table', <class 'rstFlatTable.FlatTable'>, None, None, {})
[app] setting up extension: 'kernel_include'
[app] adding directive: ('kernel-include', <class 'kernel_include.KernelInclude'>, None, None, {})
[app] setting up extension: 'cdomain'
[app] overriding domain: <class 'cdomain.CDomain'>
[app] setting up extension: 'sphinx.ext.imgmath'
[app] adding config value: ('math_number_all', False, 'html')
[app] adding node: (<class 'sphinx.ext.mathbase.math'>, {'override': True, 'html': (<function html_visit_math at 0x7f365c4fe6a8>, None), 'man': (<function man_visit_math at 0x7f365c4f2e18>, None), 'text': (<function text_visit_math at 0x7f365c4f2c80>, None), 'texinfo': (<function texinfo_visit_math at 0x7f365c4fe0d0>, None), 'latex': (<function latex_visit_math at 0x7f365c4f2a60>, None)})
[app] adding node: (<class 'sphinx.ext.mathbase.displaymath'>, {'text': (<function text_visit_displaymath at 0x7f365c4f2d08>, None), 'texinfo': (<function texinfo_visit_displaymath at 0x7f365c4fe158>, <function texinfo_depart_displaymath at 0x7f365c4fe1e0>), 'latex': (<function latex_visit_displaymath at 0x7f365c4f2b70>, None), 'html': (<function html_visit_displaymath at 0x7f365c4fe730>, None), 'man': (<function man_visit_displaymath at 0x7f365c4f2ea0>, <function man_depart_displaymath at 0x7f365c4f2f28>)})
[app] adding node: (<class 'sphinx.ext.mathbase.eqref'>, {'text': (<function text_visit_eqref at 0x7f365c4f2d90>, None), 'texinfo': (<function texinfo_visit_eqref at 0x7f365c4fe268>, None), 'latex': (<function latex_visit_eqref at 0x7f365c4f2bf8>, None), 'html': (<function html_visit_eqref at 0x7f365c4fe2f0>, <function html_depart_eqref at 0x7f365c4fe378>), 'man': (<function man_visit_eqref at 0x7f365c4fe048>, None)})
[app] adding role: ('math', <function math_role at 0x7f365c4f28c8>)
[app] adding role: ('eq', <function eq_role at 0x7f365c4f2950>)
[app] adding directive: ('math', <class 'sphinx.ext.mathbase.MathDirective'>, None, None, {})
[app] connecting event 'doctree-resolved': <function number_equations at 0x7f365c4fe400> [id=0]
[app] adding config value: ('imgmath_image_format', 'png', 'html')
[app] adding config value: ('imgmath_dvipng', 'dvipng', 'html')
[app] adding config value: ('imgmath_dvisvgm', 'dvisvgm', 'html')
[app] adding config value: ('imgmath_latex', 'latex', 'html')
[app] adding config value: ('imgmath_use_preview', False, 'html')
[app] adding config value: ('imgmath_dvipng_args', ['-gamma', '1.5', '-D', '110', '-bg', 'Transparent'], 'html')
[app] adding config value: ('imgmath_dvisvgm_args', ['--no-fonts'], 'html')
[app] adding config value: ('imgmath_latex_args', [], 'html')
[app] adding config value: ('imgmath_latex_preamble', '', 'html')
[app] adding config value: ('imgmath_add_tooltips', True, 'html')
[app] adding config value: ('imgmath_font_size', 12, 'html')
[app] connecting event 'build-finished': <function cleanup_tempdir at 0x7f365c4fe598> [id=1]
[app] setting up extension: 'alabaster'
[app] connecting event 'html-page-context': <function update_context at 0x7f365bddd8c8> [id=2]
loading pickled environment... done
building [mo]: targets for 0 po files that are out of date
building [html]: targets for 0 source files that are out of date
updating environment: 0 added, 0 changed, 0 removed
looking for now-outdated files... none found
no targets are out of date.
build succeeded.
  HTML    Documentation/DocBook/index.html

--=-=-=--
