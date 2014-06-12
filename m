Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1744 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbaFLMJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 08:09:45 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5CC9fZA084904
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 14:09:43 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 8DBFD2A1FCB
	for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 14:09:34 +0200 (CEST)
Message-ID: <53999849.1090105@xs4all.nl>
Date: Thu, 12 Jun 2014 14:08:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [ATTN] Please review/check the REVIEWv4 compound control patch series
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro & anyone else with an interest,

I'd appreciate it if this patch series was reviewed, in particular
with respect to the handling of multi-dimensional arrays:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg75929.html

This patch series incorporates all comments from the REVIEWv3 series
except for two (see the cover letter of the patch series for details),

If support for arrays with more than 8 dimensions is really needed,
then I would like to know asap so I can implement that in time for
3.17.

Regards,

	Hans
