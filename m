Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4560 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2HQMSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:18:41 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id q7HCIcXV060712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 14:18:39 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.186])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 59A2635E00A5
	for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 14:18:37 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [ANN] media_build should work again!
Date: Fri, 17 Aug 2012 14:18:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171418.38108.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've updated the media_build scripts to reflect the new file organization.

Most of the work was actually in dealing with some driver changes that required
compat code and that had nothing to do with the reorganization.

I'll have to wait for the daily build tonight to know for certain whether all
linux kernels are compiling fine, so I might have to do some finetuning this
weekend if there are still some failures.

Regards,

	Hans
