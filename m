Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33957 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaFAMrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jun 2014 08:47:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 11/18] v4l: vsp1: wpf: Simplify cast to pipeline structure
Date: Sun, 01 Jun 2014 14:47:55 +0200
Message-ID: <20315353.bdlSXH88Rv@avalon>
In-Reply-To: <CAMuHMdUCT1rSQWn+B9zQ3a-BPJsBePK9K5NszR==AriaRm8BjQ@mail.gmail.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1401593977-30660-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdUCT1rSQWn+B9zQ3a-BPJsBePK9K5NszR==AriaRm8BjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Sunday 01 June 2014 10:50:20 Geert Uytterhoeven wrote:
> On Sun, Jun 1, 2014 at 5:39 AM, Laurent Pinchart wrote:
> > USe the subdev pointer directly to_vsp1_pipeline() macro instead of
> 
> Use

Thank you. I'll fix that for the next version. I would be happy this typo was 
the biggest issue with the patch set :-)

-- 
Regards,

Laurent Pinchart

