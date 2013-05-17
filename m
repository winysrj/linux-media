Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3301 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3EQIbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 04:31:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Can you take a look at these dvb-apps warnings/errors?
Date: Fri, 17 May 2013 10:30:57 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201305171030.57794.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you take a look at these? The daily build is failing because of this.

Thanks!

	Hans

test_video.c:322:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘ssize_t’ [-Wformat]
dvbscan.c:128:6: warning: variable ‘output_type’ set but not used [-Wunused-but-set-variable]
dvbscan.c:126:6: warning: variable ‘uk_ordering’ set but not used [-Wunused-but-set-variable]
dvbscan.c:124:32: warning: variable ‘inversion’ set but not used [-Wunused-but-set-variable]
dvbscan_dvb.c:27:44: warning: unused parameter ‘fe’ [-Wunused-parameter]
dvbscan_atsc.c:27:45: warning: unused parameter ‘fe’ [-Wunused-parameter]
util.c:193:7: error: ‘SYS_DVBC_ANNEX_A’ undeclared (first use in this function)
util.c:194:7: error: ‘SYS_DVBC_ANNEX_C’ undeclared (first use in this function)
util.c:262:26: error: ‘DTV_ENUM_DELSYS’ undeclared (first use in this function)
util.c:263:1: warning: control reaches end of non-void function [-Wreturn-type]
make[2]: *** [util.o] Error 1
make[1]: *** [all] Error 2
make: *** [all] Error 2
