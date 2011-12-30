Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33034 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1L3KWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:22:37 -0500
Date: Fri, 30 Dec 2011 11:24:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.3] gspca patches and new jl2005bcd driver
Message-ID: <20111230112411.3089e281@tele>
In-Reply-To: <4EFD8494.4050506@redhat.com>
References: <4EFD8494.4050506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Dec 2011 10:29:56 +0100
Hans de Goede <hdegoede@redhat.com> wrote:
	[snip]
> The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:
> 
>    [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)
> 
> are available in the git repository at:
>    git://linuxtv.org/hgoede/gspca.git media-for_v3.3
	[snip]
> Theodore Kilgore (1):
>        gspca: add jl2005bcd sub driver
	[snip]

I have noticed some problems with the patch 2346c78dff71b003f:

- there should be no change in gspca.h (addition of two empty lines)

- there is no documentation about the new pixel format 'JL20'

- in jl2005bcd.c, the macro 'err' is used instead of 'pr_err'
  (there are also spaces at end of line, but this is less important..)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
