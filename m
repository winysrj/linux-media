Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:45507 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZCBMjv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 07:39:51 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1Le8Uv-0004dC-3i
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 02 Mar 2009 14:47:57 +0100
Date: Mon, 2 Mar 2009 13:39:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
Message-ID: <20090302133936.00899692@hyperion.delvare>
In-Reply-To: <20090215214108.34f31c39@hyperion.delvare>
References: <20090215214108.34f31c39@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009 21:41:08 +0100, Jean Delvare wrote:
> Hi all,
> 
> Today I have hit the following general protection fault when removing
> module cx8800:

This has just happened to me again today, with kernel 2.6.28.7. I have
opened a bug in bugzilla:

http://bugzilla.kernel.org/show_bug.cgi?id=12802

-- 
Jean Delvare
