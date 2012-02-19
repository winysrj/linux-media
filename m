Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57878 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2BSI5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 03:57:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ryan <ryanphilips19@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap4 v4l media-ctl usage
Date: Sun, 19 Feb 2012 09:57:45 +0100
Message-ID: <2215470.hR2vMaHYCK@avalon>
In-Reply-To: <CANMsd02vLtdmrV-eHuBJ4SAc6PiYG8tw1+OvSXYAJ83zcoe7Hw@mail.gmail.com>
References: <CANMsd02vLtdmrV-eHuBJ4SAc6PiYG8tw1+OvSXYAJ83zcoe7Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ryan,

On Saturday 18 February 2012 20:59:57 Ryan wrote:
> hello,
> I am using media-ctl on the panda board. The sensor gets detected. But
> media-ctl doesnt print anything.
> The kernel is cloned from omap4 v4l git tree: commit id:
> 3bc023462a68f78bb0273848f5ab08a01b434ffa
> 
> what could be wrong in here?
> 
> ~ # ./media-ctl -p
> Opening media device /dev/media0
> Enumerating entities
> Found 0 entities
> Enumerating pads and links
> Device topology
> 
> What steps i need to follow get output from sensor in terms of
> arguments to media-ctl and yavta.

Could you please first make sure that media-ctl has be compiled against header 
files from the kernel running on your board ?

-- 
Regards,

Laurent Pinchart
