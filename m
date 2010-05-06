Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:47682 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0EFSbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 14:31:45 -0400
Date: Thu, 6 May 2010 20:32:18 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
Message-ID: <20100506203218.31c62786@tele>
In-Reply-To: <4BE305DD.5020106@redhat.com>
References: <201001090015.31357.jareguero@telefonica.net>
	<201001121557.10312.jareguero@telefonica.net>
	<201001131450.44689.jareguero@telefonica.net>
	<201001141726.52062.jareguero@telefonica.net>
	<4BE305DD.5020106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 06 May 2010 15:09:33 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> > I found the problem. Autogain don't work well if brightness is de
> > default value(128). if brightness is less(64) autogain work well.
> > There is a problem when setting the brightness. It is safe to
> > remove the brightness control? Patch attached.
> > 
> > Jose Alberto  
> 
> This patch doesn't apply anymore. I'm not sure if the issue were
> fixed upstream. If not, please re-base your patch against my git tree
> and send it again.
> 
> patching file drivers/media/video/gspca/zc3xx.c
> Hunk #1 succeeded at 6086 with fuzz 1 (offset 45 lines).
> Hunk #2 FAILED at 6882.
> 1 out of 2 hunks FAILED -- saving rejects to file
> drivers/media/video/gspca/zc3xx.c.rej
> >>> Patch patches/lmml_72895_problem_with_gspca_and_zc3xx.patch
> >>> doesn't apply

Jose's patch is not needed anymore. I completely removed the brightness
control as it was done: it did not work for any zc3xx webcam. The git
change is bdd13e1bf3ada06bb9ccd04f5f65f7912eff72af.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
