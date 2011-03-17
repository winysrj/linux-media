Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45536 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1CQLHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 07:07:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] ignore Documentation/DocBook/media/
Date: Thu, 17 Mar 2011 12:07:35 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D80C7BD.3030704@matrix-vision.de>
In-Reply-To: <4D80C7BD.3030704@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171207.35492.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Wednesday 16 March 2011 15:22:53 Michael Jones wrote:
> From 81a09633855b88d19f013d7e559e0c4f602ba711 Mon Sep 17 00:00:00 2001
> From: Michael Jones <michael.jones@matrix-vision.de>
> Date: Thu, 10 Mar 2011 16:16:38 +0100
> Subject: [PATCH] ignore Documentation/DocBook/media/
> 
> It is created and populated by 'make htmldocs'
> 
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/.gitignore
> b/Documentation/DocBook/.gitignore index c6def35..679034c 100644
> --- a/Documentation/DocBook/.gitignore
> +++ b/Documentation/DocBook/.gitignore
> @@ -8,3 +8,4 @@
>  *.dvi
>  *.log
>  *.out
> +media/

-- 
Regards,

Laurent Pinchart
