Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50629 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZCEUAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 15:00:07 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LfJjg-0003Lh-8v
	for linux-media@vger.kernel.org; Thu, 05 Mar 2009 20:00:04 +0000
Received: from 80-229-248-183.plus.com ([80-229-248-183.plus.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 20:00:02 +0000
Received: from utar101 by 80-229-248-183.plus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 20:00:02 +0000
To: linux-media@vger.kernel.org
From: utar <utar101@gmail.com>
Subject: Re: Hauppauge NOVA-T 500 falls over after warm reboot
Date: Thu, 5 Mar 2009 19:57:38 +0000 (UTC)
Message-ID: <loom.20090305T195350-142@post.gmane.org>
References: <49AD88BF.30507@gmail.com>  <617be8890903031229n79f93882k63560cb4d17c6b33@mail.gmail.com>  <49AD9C59.1050803@gmail.com> <617be8890903040026t679991bmf69b0076ff5bb64e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Have you tried rmmoding the module (dvb_usb_dib0700) and reloading it?
> I think that it was in such a case where it then wrongly detected the
> card as 'cold', attempting to reload it, which failed.

No as if I do a cold boot there isn't an issue.  I just thought I would report
this so that the developers were aware.

Many thanks for the suggestion though.

