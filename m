Return-path: <linux-media-owner@vger.kernel.org>
Received: from sbevan.dsl.xmission.com ([166.70.26.173]:33328 "EHLO
	nebo.bevan.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbZEZT6y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 15:58:54 -0400
Received: from [192.168.0.4] (scottfam.dsl.xmission.com [166.70.240.45])
	by nebo.bevan.us (Postfix) with ESMTP id C9BA6486E23
	for <linux-media@vger.kernel.org>; Tue, 26 May 2009 13:51:14 -0600 (MDT)
Subject: RFC - Locking resources between V4L and DVB interfaces
From: Rusty Scott <rustys@ieee.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 26 May 2009 13:51:15 -0600
Message-Id: <1243367475.15846.19.camel@godzilla>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,
I talked to Mauro offline about this issue and he indicated that it was
an area that could use some attention.  So I have decided to take this
issue on and am looking for comments about how this should work.

Issue: The DVB and V4L interfaces are considered different devices from
a system standpoint.  However they often share a hardware resource, such
as a tuner, on many cards.  There is currently no locking on the shared
resource, so one interface could interfere with the resources already in
use by the other.

My experience in the code tree and API are not very in depth.  I've only
helped maintain some card specific code to this point.  I'm looking for
comments and information on various ways to accomplish this and possible
gotchas to watch out for.  Any pointers, suggestions or other help on
this would be appreciated.

Thanks,

Rusty


