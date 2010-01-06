Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53434 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab0AFQxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 11:53:36 -0500
Message-ID: <4B44C00A.4080603@gmail.com>
Date: Wed, 06 Jan 2010 17:53:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: video/tuner-core, fix memory leak
References: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1262796476-17737-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2010 05:47 PM, Jiri Slaby wrote:
> Stanse found a memory leak in tuner_probe. t is not
> freed/assigned on all paths. Fix that.

Oops. I generated two patches here, only the second is for PCI.

Sorry Mauro, you got this one twice.

-- 
js
