Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42577 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbbDDOzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2015 10:55:16 -0400
Message-ID: <551FFB32.2020309@xs4all.nl>
Date: Sat, 04 Apr 2015 16:54:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: corbet@lwn.net
Subject: Re: [PATCHv3 00/22] marvell-ccic: drop and fix formats
References: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426333621-21474-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2015 12:46 PM, Hans Verkuil wrote:
> This v3 patch series replaces patch 18 from the first series.
> 
> Patch 18 and 19 are unchanged from patches 18 and 21 from the
> second series.
> 
> Patches 20-21 replace the RGB444 format by the newly defined XBGR444
> format (X means that the 'alpha' channel should be ignored and is not
> filled in). The actual layout in memory remains unchanged.
> 
> Patch 22 fixes the Bayer format.
> 
> All tested on my OLPC XO-1 laptop.

Jon, ping!

Patch 18 is merged and I have your Ack for patch 19, but I'd like your Ack
as well for patches 20-22, if possible.

Regards,

	Hans
