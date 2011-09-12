Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46694 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1ILRWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 13:22:40 -0400
Received: by ywb5 with SMTP id 5so958004ywb.19
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 10:22:40 -0700 (PDT)
Date: Mon, 12 Sep 2011 12:22:33 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Josh Boyer <jwboyer@redhat.com>, linux-media@vger.kernel.org,
	Dave Jones <davej@redhat.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Message-ID: <20110912172233.GB27651@elie>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201109080938.54655.laurent.pinchart@ideasonboard.com>
 <20110912011614.GA4834@elie.sbx02827.chicail.wayport.net>
 <201109121620.39982.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109121620.39982.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:

> I've just sent a pull request to Mauro.

Thanks!  Looks good to me, for what little that's worth.  My only nits
are that in the future it might be nice to "Cc: stable" and credit
testers so they can grep through commit logs to find out if the kernel
is fixed.
