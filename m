Return-path: <linux-media-owner@vger.kernel.org>
Received: from link-v.kaznejov.cz ([89.235.36.82]:39933 "EHLO
	link-v.kaznejov.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZI2JXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2009 05:23:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by link-v.kaznejov.cz (Postfix) with ESMTP id 2AC3DE63A5
	for <linux-media@vger.kernel.org>; Tue, 29 Sep 2009 11:14:39 +0200 (CEST)
Received: from link-v.kaznejov.cz ([127.0.0.1])
	by localhost (kaznejov.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cwb70PZhV0hD for <linux-media@vger.kernel.org>;
	Tue, 29 Sep 2009 11:14:30 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by link-v.kaznejov.cz (Postfix) with ESMTP id 28E4FE6322
	for <linux-media@vger.kernel.org>; Tue, 29 Sep 2009 11:14:27 +0200 (CEST)
Message-ID: <4AC1CFF1.7050907@kaznejov.cz>
Date: Tue, 29 Sep 2009 11:14:25 +0200
From: Jiri Dobry <jirik@kaznejov.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: record DVB-S2 stream into file
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I would like to record DVB-S2 complete stream into file. For DVB-S I can 
use dvbstream tool.
But on this time it not support DVB_S2.

Do somebody have patch or another tip how to save stream into file.

Jiri

PS: I don't need only one program/service but complete stream with all PIDs.
<http://vger.kernel.org/vger-lists.html#linux-media>
