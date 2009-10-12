Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37311 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZJLUqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 16:46:23 -0400
Received: by bwz6 with SMTP id 6so3423543bwz.37
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 13:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD3946D.8040407@proekspert.ee>
References: <4AD3821C.5050306@proekspert.ee>
	 <829197380910121313s50fe7d34oe3fedbf7a5182a48@mail.gmail.com>
	 <4AD3946D.8040407@proekspert.ee>
Date: Mon, 12 Oct 2009 16:45:10 -0400
Message-ID: <829197380910121345v67a0871v44392780b7fa0c71@mail.gmail.com>
Subject: Re: DVB support for MSI DigiVox A/D II and KWorld 320U
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Lauri Laanmets <lauri.laanmets@proekspert.ee>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 4:41 PM, Lauri Laanmets
<lauri.laanmets@proekspert.ee> wrote:
> Hello
>
> Tried that but the result is basically the same: "zl10353_attach" gives
>
> [  491.490259] zl10353_read_register: readreg error (reg=127, ret==-19)
>
> And it is funny that if I compile the mcentral latest code in the same
> kernel, it works, but I cannot find the difference in the code :)
>
> Lauri

Check the dvb_gpio setting in the board profile.  On some of those
boards you need to take put one of the GPO pins high to take the demod
out of reset.  The KWorld 315u and 330u are both like that.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
