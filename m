Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2800 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaHDIrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 04:47:19 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s748lANL034573
	for <linux-media@vger.kernel.org>; Mon, 4 Aug 2014 10:47:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5AE142A2651
	for <linux-media@vger.kernel.org>; Mon,  4 Aug 2014 10:47:06 +0200 (CEST)
Message-ID: <53DF488A.4080307@xs4all.nl>
Date: Mon, 04 Aug 2014 10:47:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANN] Created a patch to teach valgrind about V4L2 and the media
 API
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See this bugreport for valgrind with the attached patch:

https://bugs.kde.org/show_bug.cgi?id=338023

Regards,

	Hans
