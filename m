Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:34775 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760765Ab0J1SXJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 14:23:09 -0400
Date: Thu, 28 Oct 2010 12:23:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] cafe_ccic: fix colorspace corruption on resume
Message-ID: <20101028122307.57f1b2e3@bike.lwn.net>
In-Reply-To: <20101027135500.BA4869D401B@zog.reactivated.net>
References: <20101027135500.BA4869D401B@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 27 Oct 2010 14:55:00 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Only power down during resume if the camera is not in use, and correctly
> reconfigure the sensor during resume.

Makes sense to me.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
