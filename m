Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1102 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1EWOcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:32:21 -0400
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4NEWJeF009633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 23 May 2011 16:32:19 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [ANN] IRC meeting May 31st, 10:00 CET (UTC+2): Cropping and Composing
Date: Mon, 23 May 2011 16:32:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231632.14148.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

Just a short announcement that we will have a meeting on the #v4l IRC channel
regarding the Samsung proposals for cropping and composing.

See:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32152

We need to figure out how these proposals interact with the existing VIDIOC_S_FMT
and how to handle any ordering dependencies (i.e. do we have to set the crop,
s_fmt and composition in a particular order or not?)

Since all developers that work on this are all in Europe this meeting is scheduled
in the morning for the CET timezone. If people from outside Europe want to join,
then please let us know soon. We can probably reschedule it if there are good
reasons.

Regards,

	Hans
