Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63347 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031Ab2ASKHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 05:07:31 -0500
Received: by lahc1 with SMTP id c1so2785067lah.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 02:07:29 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/2] [media] dvb_frontend: Require FE_HAS_PARAMETERS for get_frontend()
Date: Thu, 19 Jan 2012 11:07:24 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201201181450.14089.pboettcher@kernellabs.com> <1326909085-14256-1-git-send-email-mchehab@redhat.com> <1326909085-14256-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326909085-14256-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191107.25039.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 18 January 2012 18:51:25 Mauro Carvalho Chehab wrote:
> Calling get_frontend() before having either the frontend locked
> or the network signaling carriers locked won't work. So, block
> it at the DVB core.

I like the idea and also the implementation.

But before merging this needs more comments from other on the list. 

Even though it does not break anything for any current frontend-driver 
it is important to have a wider base agreeing on that. Especially from 
some other frontend-driver-writers.

For example I could imagine that a frontend HAS_LOCK, but is still not 
able to report the parameters (USB-firmware-based frontends might be 
poorly implemented). 

And so on...

regards,

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
