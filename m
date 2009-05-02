Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2296 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbZEBP3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 11:29:47 -0400
Received: from tschai.lan ([84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id n42FTg5a071881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 2 May 2009 17:29:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Daily build: updated with new gcc and binutils
Date: Sat, 2 May 2009 17:29:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905021729.42217.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've updated my daily build environment with the latest gcc (4.4.0) and 
binutils (2.19.1). I've already noticed that gcc 4.4.0 produces a bunch of 
new warning. Please take a look at the daily build results when they are 
posted later today and fix any new warnings you see.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
