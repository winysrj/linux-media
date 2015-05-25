Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56336 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbbEYLWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 07:22:52 -0400
Message-ID: <55630606.8020104@xs4all.nl>
Date: Mon, 25 May 2015 13:22:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>, hans.verkuil@cisco.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
CC: modin@yuri.at
Subject: Re: [PATCH 0/4] [sur40] minor fixes & performance improvements
References: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 05/21/2015 02:29 PM, Florian Echtler wrote:
> This patch series adds several small fixes, features & performance
> improvements. Many thanks to Martin Kaltenbrunner for testing the
> original driver & submitting the patches. 
> 
> Martin Kaltenbrunner (4):
>   reduce poll interval to allow full 60 FPS framerate
>   add frame size/frame rate query functions
>   add extra debug output, remove noisy warning
>   return BUF_STATE_ERROR if streaming stopped during acquisition
> 
>  drivers/input/touchscreen/sur40.c | 46 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 

The patches look good, but can you repost with better commit logs (i.e. not
just a subject line). Maintainers have become picky about that and without logs
Mauro most likely will not accept it. Actually, I'm not even going to try :-)

Regards,

	Hans
