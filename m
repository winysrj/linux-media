Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:31389 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZEBVgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 17:36:24 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1448602fkq.5
        for <linux-media@vger.kernel.org>; Sat, 02 May 2009 14:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905021302.03415.hverkuil@xs4all.nl>
References: <200905021302.03415.hverkuil@xs4all.nl>
Date: Sun, 3 May 2009 01:36:22 +0400
Message-ID: <1a297b360905021436j21ec4cdyb9ee8f3aff3a38ce@mail.gmail.com>
Subject: Re: stv090x.c compile warning
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, May 2, 2009 at 3:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Manu,
>
> Compiling stv090x.c against 2.6.30-rc4 gives me this compile warning:
>
> /home/hans/work/src/v4l/v4l-dvb/v4l/stv090x.c: In
> function 'stv090x_chk_tmg':
> /home/hans/work/src/v4l/v4l-dvb/v4l/stv090x.c:2544: warning: 'tmg_cpt' may
> be used uninitialized in this function
>
> Looking at the code this variable is indeed uninitialized. I'm pretty sure
> it should be initialized to 0, can you confirm this?
>


Thanks for looking at it. I do have fixed it along with some other changes
that i had.

The fix is there at http://jusst.de/hg/v4l-dvb

Hope i have not broken something else in that large change to support
the newer silicon cut.

Regards,
Manu
