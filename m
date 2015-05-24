Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.openmailbox.org ([62.4.1.38]:46005 "EHLO
	smtp4.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbEXXb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 19:31:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail2.openmailbox.org (Postfix) with ESMTP id 17EB32027D0
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 01:25:55 +0200 (CEST)
Received: from mail2.openmailbox.org ([62.4.1.33])
	by localhost (mail.openmailbox.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hS_M1nyIlW6d for <linux-media@vger.kernel.org>;
	Mon, 25 May 2015 01:25:50 +0200 (CEST)
Received: from www.openmailbox.org (mail2.openmailbox.org [62.4.1.33])
	by mail2.openmailbox.org (Postfix) with ESMTP id 3B57A200683
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 01:25:50 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2015 01:25:50 +0200
From: tomsmith7899@openmailbox.org
To: linux-media@vger.kernel.org
Subject: Access to =?UTF-8?Q?MPEG-TS=3F?=
Message-ID: <2b345f147f4d4bdbaf2ac15e1a78aff0@openmailbox.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm working on an application that - among other things - should be able 
to identify the programs in a MPEG transport stream broadcasted via 
DVB-C. This is what I have figured out so far:

1. Open the DVB frontend.
2. Fill struct dvb_frontend_parameters with transponder frequency etc.
3. Apply struct dvb_frontend_parameters with FE_SET_FRONTEND ioctl call.

After performing these steps, I call the FE_READ_STATUS ioctl and the 
status is FE_HAS_LOCK.

I should then parse the MPEG transport stream to identify the programs, 
pids etc. but my problem is that I don't know how to access the 
transport stream? I have tried to read the file descriptor returned from 
opening the frontend, but no MPEG data is found there.

Can anyone point me in the right direction?
