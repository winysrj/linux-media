Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:49417 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752472AbdGCLSJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 07:18:09 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: broonie@kernel.org
Cc: hverkuil@xs4all.nl, akpm@linux-foundation.org,
        yamada.masahiro@socionext.com, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        chris.paterson2@renesas.com,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v3 0/2] Avoid namespace collision within macros & tidy up
Date: Mon,  3 Jul 2017 12:04:19 +0100
Message-Id: <20170703110421.3082-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

The readx_poll_timeout & similar macros defines local variable that can
cause name space collision with the caller. Fixed this issue by prefixing
them with underscores. Also tidied couple of instances where the macro
arguments are used in expressions without parentheses.

This patchset is based on top of today's linux-next repo.
commit b18ea5c46031 ("Add linux-next specific files for 20170703")

Change history:

v3:
 - Rebased
 - Corrected parentheses spelling

v2:
 - iopoll.h:
	- Enclosed timeout_us & sleep_us arguments with parentheses
 - regmap.h:
	- Enclosed timeout_us & sleep_us arguments with parentheses
	- Renamed pollret to __ret

Note: timeout_us causes a spare check warning as identified here [1].

[1] https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg15138.html

Thanks,
Ramesh

Ramesh Shanmugasundaram (2):
  iopoll: Avoid namespace collision within macros & tidy up
  regmap: Avoid namespace collision within macro & tidy up

 include/linux/iopoll.h | 12 +++++++-----
 include/linux/regmap.h | 17 +++++++++--------
 2 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.12.2
