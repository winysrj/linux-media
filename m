Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0KIPgN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 10:36:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH 2/2] v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions
Date: Tue, 9 Nov 2010 16:36:11 +0100
Cc: linux-media@vger.kernel.org
References: <1289316628-9394-1-git-send-email-laurent.pinchart@ideasonboard.com> <1289316628-9394-3-git-send-email-laurent.pinchart@ideasonboard.com> <20101109163325.3b706714.ospite@studenti.unina.it>
In-Reply-To: <20101109163325.3b706714.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091636.11737.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Antonio,

On Tuesday 09 November 2010 16:33:25 Antonio Ospite wrote:
> On Tue,  9 Nov 2010 16:30:28 +0100
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > The argument isn't used anymore by the functions, remote it.
> 
> s/remote/remove/

Oops :-)

Thanks, I'll fix that when sending the pull request.

-- 
Regards,

Laurent Pinchart
