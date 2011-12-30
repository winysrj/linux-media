Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42568 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1L3LYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 06:24:36 -0500
Date: Fri, 30 Dec 2011 12:26:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: [GIT PATCHES FOR 3.3] gspca patches and new jl2005bcd driver
Message-ID: <20111230122608.7f08efe7@tele>
In-Reply-To: <4EFD98E6.6010107@redhat.com>
References: <4EFD8494.4050506@redhat.com>
	<20111230112411.3089e281@tele>
	<4EFD98E6.6010107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Dec 2011 11:56:38 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> I took it as is from Theodore, I guess we should do a separate cleanup
> patch on top to preserve the history / authorship. Since I'm busy testing
> the new isoc bandwidth stuff today, could you perhaps do a cleanup patch for this?

Yes, but the first step is to remove this patch from the pull request, and only you may do it (it is only 3 git commands and an email - otherwise, it has no sense to add two empty lines in a patch and to remove them in an other one!).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
