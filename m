Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:38324 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0CaGIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 02:08:07 -0400
Date: Wed, 31 Mar 2010 08:07:57 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	Krivchikov Sergei <sergei.krivchikov@gmail.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: genius islim 310 webcam test
Message-ID: <20100331080757.40f9c478@tele>
In-Reply-To: <4BB2E42B.4090302@freemail.hu>
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>
	<4BB2E42B.4090302@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Mar 2010 07:56:59 +0200
Németh Márton <nm127@freemail.hu> wrote:

> The next thing is that you need to learn how to compile the Linux
> kernel from source code. There is a description for Ubuntu at
> https://help.ubuntu.com/community/Kernel/Compile . After you are able
> to compile and install your new kernel, you can try to apply the
> patch in this email, recompile the kernel, install the kernel and the
> modules, unload the gspca_pac7302 kernel module ("rmmod
> gspca_pac7302"), and then plug the webcam in order it can load the
> new kernel module. When you were successful with these steps you'll
> see new messages in the output of "dmesg" command. Please send this
> output also.

Hello Németh and Sergei,

I think the patch is not needed because it just gives the vend:prod
which is already known by lsusb.

On the other hand, compiling a full kernel is not needed with a small
tarball distribution as the one I have in my page (actual gspca-2.9.10).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
