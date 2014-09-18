Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36547 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaIRMPW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:15:22 -0400
Date: Thu, 18 Sep 2014 09:15:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH v2] [media] BZ#84401: Revert "[media] v4l: vb2: Don't
 return POLLERR during transient buffer underruns"
Message-ID: <20140918091516.42dc6bb3@recife.lan>
In-Reply-To: <541ACAF9.4030204@cisco.com>
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
	<20140918070619.32d4e4b1@recife.lan>
	<541AAFA6.6080605@cisco.com>
	<20140918075005.11bd495f@recife.lan>
	<541ACAF9.4030204@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Sep 2014 14:07:21 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> My patch is the *only* fix for that since that's the one that addresses
> the real issue.
> 
> One option is to merge my fix for 3.18 with a CC to stable for 3.16.
> 
> That way it will be in the tree for longer.
> 
> Again, the revert that you did won't solve the regression at all. Please
> revert the revert.

Well, some patch that went between 3.15 and 3.16 broke VBI. If it was
not this patch, what's the patch that broke it?

Regards,
Mauro
