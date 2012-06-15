Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3375 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2FOLPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 07:15:31 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id q5FBFTQs033172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 13:15:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.103.215] (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id B1E232B040004
	for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 13:15:27 +0200 (CEST)
Message-ID: <4FDB194F.9060006@xs4all.nl>
Date: Fri, 15 Jun 2012 13:15:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH for 3.6] DocBook fix: wrong type in documentation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a quick one I came across just now.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
index b788c72..2a3c91a 100644
--- a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
@@ -145,7 +145,7 @@ For example, the MSB does not necessarily indicate if the signal is
  signal. Drivers shall not convert the sample format by software.</para></entry>
  	    </row>
  	    <row>
-	      <entry>__u32</entry>
+	      <entry>__s32</entry>
  	      <entry><structfield>start</structfield>[2]</entry>
  	      <entry>This is the scanning system line number
  associated with the first line of the VBI image, of the first and the
