Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe03.c2i.net ([212.247.154.66]:60444 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752722Ab2BOROc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 12:14:32 -0500
Received: from [176.74.208.111] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe03.swip.net (CommuniGate Pro SMTP 5.4.2)
  with ESMTPA id 74051152 for linux-media@vger.kernel.org; Wed, 15 Feb 2012 18:14:30 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Make the USB Video Class debug filesystem support compile  time optional.
Date: Wed, 15 Feb 2012 18:12:39 +0100
References: <201202142215.51388.hselasky@c2i.net>
In-Reply-To: <201202142215.51388.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202151812.39703.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 14 February 2012 22:15:51 Hans Petter Selasky wrote:
> The following patch makes the recently added DEBUGFS for UVC optional.
> 
> --HPS
> 

Please ignore this patch. It appears that the DEBUGFS can be disabled by 
including the correct debugfs.h header file.

--HPS
