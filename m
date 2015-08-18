Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56261 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbbHRI4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:56:11 -0400
Message-ID: <55D2F0E0.7080604@xs4all.nl>
Date: Tue, 18 Aug 2015 10:46:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
CC: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org, linux@arm.linux.org.uk
Subject: Re: [PATCHv2 0/4] cec-ctl/compliance: new CEC utilities
References: <cover.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, this cover letter is incomplete, here is the full cover letter:

This patch series adds two new utilities to the v4l-utils git repository
(http://git.linuxtv.org/cgit.cgi/v4l-utils.git/). It assumes that the new
CEC framework (v8) is available in the kernel:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg91285.html

The first patch adds the new cec headers to the 'sync-with-kernel' target,
the second syncs with the kernel and adds the new cec headers to v4l-utils,
the third adds the compliance utility and the last adds the cec-ctl utility.

The cec-compliance utility is by no means 100% coverage, in particular the
event API and non-blocking ioctls are untested. But it is a starting point,
and a complex protocol like CEC really needs a compliance tool.

The cec-ctl utility has almost full CEC message coverage: all generated from
the cec headers, so this is easy to keep up to date.

Regards,

        Hans

Changes since v1:

- cec-ctl: added CEC message logging/monitoring.
- cec-ctl: add support to clear the logical addresses.
- cec-ctl: log events.



On 08/18/15 10:36, Hans Verkuil wrote:
> Hans Verkuil (4):
>   Makefile.am: copy cec headers with make sync-with-kernel
>   sync-with-kernel
>   cec-compliance: add new CEC compliance utility
>   cec-ctl: CEC control utility
> 
>  Makefile.am                                   |    4 +
>  configure.ac                                  |    2 +
>  contrib/freebsd/include/linux/input.h         |   29 +
>  contrib/freebsd/include/linux/v4l2-controls.h |    4 +
>  include/linux/cec-funcs.h                     | 1771 +++++++++++++++++++++++++
>  include/linux/cec.h                           |  781 +++++++++++
>  include/linux/v4l2-controls.h                 |    4 +
>  utils/Makefile.am                             |    2 +
>  utils/cec-compliance/Makefile.am              |    3 +
>  utils/cec-compliance/cec-compliance.cpp       |  926 +++++++++++++
>  utils/cec-compliance/cec-compliance.h         |   87 ++
>  utils/cec-ctl/Makefile.am                     |    8 +
>  utils/cec-ctl/cec-ctl.cpp                     | 1296 ++++++++++++++++++
>  utils/cec-ctl/msg2ctl.pl                      |  430 ++++++
>  utils/keytable/parse.h                        |   18 +
>  utils/keytable/rc_keymaps/lme2510             |  132 +-
>  utils/keytable/rc_maps.cfg                    |    1 +
>  17 files changed, 5432 insertions(+), 66 deletions(-)
>  create mode 100644 include/linux/cec-funcs.h
>  create mode 100644 include/linux/cec.h
>  create mode 100644 utils/cec-compliance/Makefile.am
>  create mode 100644 utils/cec-compliance/cec-compliance.cpp
>  create mode 100644 utils/cec-compliance/cec-compliance.h
>  create mode 100644 utils/cec-ctl/Makefile.am
>  create mode 100644 utils/cec-ctl/cec-ctl.cpp
>  create mode 100644 utils/cec-ctl/msg2ctl.pl
> 
