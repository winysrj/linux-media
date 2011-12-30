Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53432 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1L3KTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:19:49 -0500
Date: Fri, 30 Dec 2011 11:21:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for 3.2 URGENT] gspca: Fix bulk mode cameras no longer
 working (regression fix)
Message-ID: <20111230112121.03e8b59b@tele>
In-Reply-To: <1325191002-25074-2-git-send-email-hdegoede@redhat.com>
References: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
	<1325191002-25074-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Dec 2011 21:36:42 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> The new iso bandwidth calculation code accidentally has broken support
> for bulk mode cameras. This has broken the following drivers:
> finepix, jeilinj, ovfx2, ov534, ov534_9, se401, sq905, sq905c, sq930x,
> stv0680, vicam.
> 
> Thix patch fixes this. Fix tested with: se401, sq905, sq905c, stv0680 & vicam
> cams.

Hi Hans,

Sorry for I should not be fully awoken yet, but I don't understand the
problem from your fix.

The patch just sets the altsetting to the highest one for bulk
transfer. Does this mean that, in this case, the altsetting table
created by build_ep_tb is wrong and the highest altsetting cannot
selected?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
