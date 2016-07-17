Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46829
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcGQNCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 09:02:01 -0400
Date: Sun, 17 Jul 2016 10:01:54 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
Subject: Troubles with kernel-doc and RST files
Message-ID: <20160717100154.64823d99@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm now converting the kAPI media doc to RST file, and I'm seeing several
issues with kernel-doc conversion:

1) We now need to include each header file with documentation twice,
one to get the enums, structs, typedefs, ... and another one for the
functions:

	.. kernel-doc:: include/media/media-device.h

	.. kernel-doc:: include/media/media-entity.h
	   :export: drivers/media/media-entity.c

2) For functions, kernel-doc is now an all or nothing. If not all
functions are declared, it outputs this warning:

	./include/media/media-devnode.h:1: warning: no structured comments

And give up. No functions are exported, nor it points where it bailed.
So, we need to manually look into all exported symbols to identify
what's missing

3) When there's an asterisk inside the source code, for example, to
document a pointer, or when something else fails when parsing a
header file, kernel-doc handler just outputs:
	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:137: WARNING: Inline emphasis start-string without end-string.
	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:470: WARNING: Explicit markup ends without a blank line; unexpected unindent.

pointing to a fake line at the rst file, instead of pointing to the
line inside the parsed header where the issue was detected, making
really hard to identify what's the error.

In this specific case, mc-core.rst has only 260 lines at the time I got
such error.

4) There are now several errors when parsing functions. Those seems to
happen when an argument is a function pointer, like:

/devel/v4l/patchwork/Documentation/media/kapi/v4l2-core.rst:757: WARNING: Error when parsing function declaration.
If the function has no return type:
  Error in declarator or parameters and qualifiers
  Invalid definition: Expected identifier in nested name, got keyword: int [error at 3]
    int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
    ---^
If the function has a return type:
  Error in declarator or parameters and qualifiers
  If pointer to member declarator:
    Invalid definition: Expected '::' in pointer to member (function). [error at 26]
      int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
      --------------------------^
  If declarator-id:
    Invalid definition: Expecting "," or ")" in parameters_and_qualifiers, got "EOF". [error at 136]
      int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
      ----------------------------------------------------------------------------------------------------------------------------------------^

The same happens for function typedefs:

/devel/v4l/patchwork/Documentation/media/kapi/v4l2-core.rst:16: WARNING: Error when parsing function declaration.
If the function has no return type:
  Error in declarator or parameters and qualifiers
  Invalid definition: Expected identifier in nested name, got keyword: typedef [error at 7]
    typedef bool v4l2_check_dv_timings_fnc (const struct v4l2_dv_timings * t, void * handle)
    -------^
If the function has a return type:
  Invalid definition: Expected identifier in nested name, got keyword: typedef [error at 7]
    typedef bool v4l2_check_dv_timings_fnc (const struct v4l2_dv_timings * t, void * handle)
    -------^
/devel/v4l/patchwork/Documentation/media/kapi/v4l2-core.rst:298: WARNING: Error when parsing function declaration.
If the function has no return type:
  Error in declarator or parameters and qualifiers
  Invalid definition: Expected identifier in nested name, got keyword: int [error at 3]
    int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
    ---^
If the function has a return type:
  Error in declarator or parameters and qualifiers
  If pointer to member declarator:
    Invalid definition: Expected '::' in pointer to member (function). [error at 26]
      int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
      --------------------------^
  If declarator-id:
    Invalid definition: Expecting "," or ")" in parameters_and_qualifiers, got "EOF". [error at 136]
      int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
      ----------------------------------------------------------------------------------------------------------------------------------------^

Could someone more familiar to Sphinx kernel-doc take a look on the
above?

Thanks,
Mauro
