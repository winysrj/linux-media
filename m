Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4528 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3JDLPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 07:15:06 -0400
Message-ID: <524EA330.8010700@xs4all.nl>
Date: Fri, 04 Oct 2013 13:14:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libtool warning in libdvbv5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

When linking libdvbv5.la I get the following warning from libtool:

  CCLD     libdvbv5.la
libtool: link: warning: `-version-info/-version-number' is ignored for convenience libraries

Other libs don't give that warning, but I don't see any obvious differences.

Do you know what might cause this?

Regards,

	Hans
