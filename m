Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55633 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZLCLdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 06:33:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Replace Mercurial with GIT as SCM
Date: Thu, 3 Dec 2009 12:34:19 +0100
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de> <4B177120.6090900@redhat.com>
In-Reply-To: <4B177120.6090900@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031234.19183.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 December 2009 09:04:48 Hans de Goede wrote:
> +1 for git, I really really really miss being able to do
> a simple "git rebase", and no rebase is not evil not as long
> as you don't use it for anything but local patches.

For what it's worth, I second that. "git rebase -i" is one of git's killer 
features (I personally learned about it during Linus' talk at the LPC 2009, so 
if you haven't heard about "git rebase -i" before, take a look at it).

-- 
Regards,

Laurent Pinchart
