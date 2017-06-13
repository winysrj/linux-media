Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:32894 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753112AbdFMNrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 09:47:12 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: broonie@kernel.org, hverkuil@xs4all.nl, mattw@codeaurora.org,
        mitchelh@codeaurora.org, akpm@linux-foundation.org,
        yamada.masahiro@socionext.com
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, chris.paterson2@renesas.com,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v2 0/2] Avoid namespace collision within macros & tidyup
Date: Tue, 13 Jun 2017 14:33:46 +0100
Message-Id: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The readx_poll_timeout & similar macros defines local variable that can
cause name space collision with the caller. Fixed this issue by prefixing
them with underscores. Also tidied couple of instances where the macro
arguments are used in expressions without paranthesis.

This patchset is based on top of today's linux-next repo.
commit bc4c75f41a1c ("Add linux-next specific files for 20170613")

Change history:

v2:
 - iopoll.h:
	- Enclosed timeout_us & sleep_us arguments with paranthesis
 - regmap.h:
	- Enclosed timeout_us & sleep_us arguments with paranthesis
	- Renamed pollret to __ret

Note: timeout_us cause spare check warning as identified here [1].

[1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg15138.html

Thanks,
Ramesh

Ramesh Shanmugasundaram (2):
  iopoll: Avoid namespace collision within macros & tidyup
  regmap: Avoid namespace collision within macro & tidyup

 include/linux/iopoll.h | 12 +++++++-----
 include/linux/regmap.h | 17 +++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.12.2
