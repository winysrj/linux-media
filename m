Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63559 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZHYKAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 06:00:39 -0400
Received: by fxm17 with SMTP id 17so1952813fxm.37
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 03:00:40 -0700 (PDT)
Message-ID: <4A93B640.5080004@googlemail.com>
Date: Tue, 25 Aug 2009 11:00:32 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Feature request: Kernel config option to enable/disable IR interface
 per adapter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

When dealing with multiple different adapters, it does not make sense to have 
the IR interfaces of all adapters active.
Like a DVB-T and a DVB sat adapter in one system.

It would not solve the issue when having multiple of the same adapters by that 
is may be a next step to think about.

Regards
Peter

BTW: Is the following IR port patch for a Tevi S460 going to make it in the main 
stream code base?
http://patchwork.kernel.org/patch/14888/
